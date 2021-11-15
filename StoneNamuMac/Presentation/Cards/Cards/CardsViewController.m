//
//  CardsViewController.m
//  CardsViewController
//
//  Created by Jinwoo Kim on 9/26/21.
//

#import "CardsViewController.h"
#import "NSWindow+presentErrorAlert.h"
#import "CardsViewModel.h"
#import "CardCollectionViewCell.h"
#import "NSViewController+SpinnerView.h"
#import "CardOptionsMenu.h"
#import "CardOptionsToolbar.h"
#import "CardOptionsTouchBar.h"
#import <StoneNamuResources/StoneNamuResources.h>

static NSUserInterfaceItemIdentifier const NSUserInterfaceItemIdentifierCardsViewController = @"NSUserInterfaceItemIdentifierCardsViewController";

@interface CardsViewController () <CardOptionsMenuDelegate, CardOptionsToolbarDelegate, CardOptionsTouchBarDelegate>
@property (retain) NSScrollView *scrollView;
@property (retain) NSClipView *clipView;
@property (retain) NSCollectionView *collectionView;
@property (retain) CardsViewModel *viewModel;
@property (retain) CardOptionsMenu *cardOptionsMenu;
@property (retain) CardOptionsToolbar *cardOptionsToolbar;
@property (retain) CardOptionsTouchBar *cardOptionsTouchBar;
@end

@implementation CardsViewController

- (void)dealloc {
    [_scrollView release];
    [_clipView release];
    [_collectionView release];
    [_viewModel release];
    [_cardOptionsMenu release];
    [_cardOptionsToolbar release];
    [_cardOptionsTouchBar release];
    [super dealloc];
}

- (void)loadView {
    NSView *view = [NSView new];
    self.view = view;
    [view release];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setAttributes];
    [self configureCollectionView];
    [self configureCardOptionsMenu];
    [self configureCardOptionsToolbar];
    [self configureCardOptionsTouchBar];
    [self configureViewModel];
    [self bind];
    [self requestDataSourceWithOptions:nil reset:NO];
}

- (void)viewWillAppear {
    [super viewWillAppear];
    [self setCardsMenuToWindow];
    [self setCardOptionsToolbarToWindow];
    [self setCardOptionsTouchBarToWindow];
}

- (void)viewWillDisappear {
    [super viewWillDisappear];
    [self clearCardsMenuFromWindow];
    [self clearCardOptionsToolbarFromWindow];
    [self clearCardOptionsTouchBarFromWindow];
}

- (NSTouchBar *)makeTouchBar {
    return self.cardOptionsTouchBar;
}

- (void)encodeRestorableStateWithCoder:(NSCoder *)coder {
    [super encodeRestorableStateWithCoder:coder];
    
    [coder encodeObject:self.viewModel.options forKey:@"options"];
}

- (void)restoreStateWithCoder:(NSCoder *)coder {
    [super restoreStateWithCoder:coder];
    
    NSDictionary<NSString *, NSString *> *options = [coder decodeObjectOfClass:[NSDictionary<NSString *, NSString *> class] forKey:@"options"];
    [self requestDataSourceWithOptions:options reset:YES];
}

- (void)updateOptionInterfaceWithOptions:(NSDictionary<NSString *, NSString *> * _Nullable)options {
    [self.cardOptionsMenu updateItemsWithOptions:options];
    [self.cardOptionsToolbar updateItemsWithOptions:options];
    [self.cardOptionsTouchBar updateItemsWithOptions:options];
}

- (BOOL)requestDataSourceWithOptions:(NSDictionary<NSString *, NSString *> * _Nullable)options reset:(BOOL)reset {
    [self updateOptionInterfaceWithOptions:options];
    
    BOOL requested = [self.viewModel requestDataSourceWithOptions:options reset:reset];
    
    if (requested) {
        [self addSpinnerView];
        
        if (reset) {
            [self.undoManager registerUndoWithTarget:self
                                            selector:@selector(undoOptions:)
                                              object:self.viewModel.options];
        }
        
        [self invalidateRestorableState];
    }
    
    return requested;
}

- (void)undoOptions:(NSDictionary<NSString *, NSString *> *)options {
    [self updateOptionInterfaceWithOptions:options];
    [self.viewModel requestDataSourceWithOptions:options reset:YES];
}

- (void)setAttributes {
    self.identifier = NSUserInterfaceItemIdentifierCardsViewController;
}

- (void)configureCollectionView {
    NSScrollView *scrollView = [NSScrollView new];
    NSClipView *clipView = [NSClipView new];
    NSCollectionView *collectionView = [NSCollectionView new];
    
    self.scrollView = scrollView;
    self.clipView = clipView;
    self.collectionView = collectionView;
    
    scrollView.contentView = clipView;
    clipView.documentView = collectionView;
    clipView.postsBoundsChangedNotifications = YES;

    [self.view addSubview:scrollView];
    scrollView.translatesAutoresizingMaskIntoConstraints = NO;
    [NSLayoutConstraint activateConstraints:@[
        [scrollView.topAnchor constraintEqualToAnchor:self.view.topAnchor],
        [scrollView.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor],
        [scrollView.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor],
        [scrollView.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor]
    ]];
    
    NSCollectionViewFlowLayout *flowLayout = [NSCollectionViewFlowLayout new];
    flowLayout.itemSize = NSMakeSize(200, 300);
    flowLayout.minimumLineSpacing = 0.0f;
    collectionView.collectionViewLayout = flowLayout;
    [flowLayout release];
    
    NSNib *nib = [[NSNib alloc] initWithNibNamed:NSStringFromClass([CardCollectionViewCell class]) bundle:NSBundle.mainBundle];
    [collectionView registerNib:nib forItemWithIdentifier:NSStringFromClass([CardCollectionViewCell class])];
    [nib release];
    
    [scrollView release];
    [clipView release];
    [collectionView release];
}

- (void)configureViewModel {
    CardsViewModel *viewModel = [[CardsViewModel alloc] initWithDataSource:[self makeDataSource]];
    self.viewModel = viewModel;
    [viewModel release];
}

- (void)bind {
    [NSNotificationCenter.defaultCenter addObserver:self
                                           selector:@selector(scrollViewDidEndLiveScrollReceived:)
                                               name:NSScrollViewDidEndLiveScrollNotification
                                             object:self.scrollView];
    
    [NSNotificationCenter.defaultCenter addObserver:self
                                           selector:@selector(errorEventReceived:)
                                               name:NSNotificationNameCardsViewModelError
                                             object:self.viewModel];
    
    [NSNotificationCenter.defaultCenter addObserver:self
                                           selector:@selector(applyingSnapshotWasDoneReceived:)
                                               name:NSNotificationNameCardsViewModelApplyingSnapshotToDataSourceWasDone
                                             object:self.viewModel];
}

- (void)scrollViewDidEndLiveScrollReceived:(NSNotification *)notification {
    [NSOperationQueue.mainQueue addOperationWithBlock:^{
        if ((self.clipView.bounds.origin.y + self.clipView.bounds.size.height) >= self.collectionView.collectionViewLayout.collectionViewContentSize.height) {
            BOOL requested = [self requestDataSourceWithOptions:self.viewModel.options reset:NO];
            
            if (requested) {
                [self addSpinnerView];
            }
        }
    }];
}

- (void)errorEventReceived:(NSNotification *)notification {
    NSError * _Nullable error = notification.userInfo[CardsViewModelErrorNotificationErrorKey];
    
    [NSOperationQueue.mainQueue addOperationWithBlock:^{
        [self removeAllSpinnerview];
        
        if (error) {
            [self.view.window presentErrorAlertWithError:error];
        } else {
            NSLog(@"No error found but the notification was posted: %@", notification.userInfo);
        }
    }];
}

- (void)applyingSnapshotWasDoneReceived:(NSNotification *)notification {
    [NSOperationQueue.mainQueue addOperationWithBlock:^{
        [self removeAllSpinnerview];
        [self updateOptionInterfaceWithOptions:self.viewModel.options];
    }];
}

- (CardsDataSource *)makeDataSource {
    CardsDataSource *dataSource = [[CardsDataSource alloc] initWithCollectionView:self.collectionView
                                                                     itemProvider:^NSCollectionViewItem * _Nullable(NSCollectionView * _Nonnull collectionView, NSIndexPath * _Nonnull indexPath, CardItemModel * _Nonnull itemModel) {
        
        CardCollectionViewCell *cell = (CardCollectionViewCell *)[collectionView makeItemWithIdentifier:NSStringFromClass([CardCollectionViewCell class]) forIndexPath:indexPath];
        [cell configureWithHSCard:itemModel.hsCard];
        
        return cell;
    }];
    
    return [dataSource autorelease];
}

- (void)configureCardOptionsMenu {
    CardOptionsMenu *cardOptionsMenu = [[CardOptionsMenu alloc] initWithOptions:self.viewModel.options cardOptionsMenuDelegate:self];
    self.cardOptionsMenu = cardOptionsMenu;
    [cardOptionsMenu release];
}

- (void)configureCardOptionsToolbar {
    CardOptionsToolbar *cardOptionsToolbar = [[CardOptionsToolbar alloc] initWithIdentifier:NSToolbarIdentifierCardOptionsToolbar options:self.viewModel.options cardOptionsToolbarDelegate:self];
    self.cardOptionsToolbar = cardOptionsToolbar;
    [cardOptionsToolbar release];
}

- (void)configureCardOptionsTouchBar {
    CardOptionsTouchBar *cardOptionsTouchBar = [[CardOptionsTouchBar alloc] initWithOptions:self.viewModel.options cardOptionsTouchBarDelegate:self];
    self.cardOptionsTouchBar = cardOptionsTouchBar;
    [cardOptionsTouchBar release];
}

- (void)setCardsMenuToWindow {
    NSApp.mainMenu = self.cardOptionsMenu;
}

- (void)clearCardsMenuFromWindow {
    self.view.window.menu = nil;
}

- (void)setCardOptionsTouchBarToWindow {
    self.view.window.touchBar = self.cardOptionsTouchBar;
}

- (void)clearCardOptionsTouchBarFromWindow {
    self.view.window.touchBar = nil;
}

- (void)setCardOptionsToolbarToWindow {
    self.view.window.toolbar = self.cardOptionsToolbar;
    [self.cardOptionsToolbar validateVisibleItems];
}

- (void)clearCardOptionsToolbarFromWindow {
    self.view.window.toolbar = nil;
}

#pragma mark - CardOptionsMenuDelegate

- (void)cardOptionsMenu:(CardOptionsMenu *)menu changedOption:(NSDictionary<NSString *,NSString *> *)options {
    [self requestDataSourceWithOptions:options reset:YES];
}

#pragma mark - CardOptionsToolbarDelegate

- (void)cardOptionsToolbar:(CardOptionsToolbar *)toolbar changedOption:(NSDictionary<NSString *,NSString *> *)options {
    [self requestDataSourceWithOptions:options reset:YES];
}

#pragma mark - CardOptionsTouchBarDelegate

- (void)cardOptionsTouchBar:(CardOptionsTouchBar *)touchBar changedOption:(NSDictionary<NSString *,NSString *> *)options {
    [self requestDataSourceWithOptions:options reset:YES];
}

@end
