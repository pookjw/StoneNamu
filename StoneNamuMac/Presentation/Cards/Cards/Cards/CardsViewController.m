//
//  CardsViewController.m
//  CardsViewController
//
//  Created by Jinwoo Kim on 9/26/21.
//

#import "CardsViewController.h"
#import "NSWindow+presentErrorAlert.h"
#import "CardsViewModel.h"
#import "CardContentView.h"
#import "NSViewController+SpinnerView.h"
#import "CardOptionsToolbar.h"
#import "CardOptionsTouchBar.h"

@interface CardsViewController () <CardOptionsToolbarDelegate, CardOptionsTouchBarDelegate>
@property (retain) NSScrollView *scrollView;
@property (retain) NSClipView *clipView;
@property (retain) NSCollectionView *collectionView;
@property (retain) CardsViewModel *viewModel;
@property (retain) CardOptionsToolbar *cardOptionsToolbar;
@property (retain) CardOptionsTouchBar *cardOptionsTouchBar;
@end

@implementation CardsViewController

- (void)dealloc {
    [_scrollView release];
    [_clipView release];
    [_collectionView release];
    [_viewModel release];
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
    [self configureCollectionView];
    [self configureCardOptionsToolbar];
    [self configureCardOptionsTouchBar];
    [self configureViewModel];
    [self bind];
    [self addSpinnerView];
    [self.viewModel requestDataSourceWithOptions:nil reset:NO];
}

- (void)viewWillAppear {
    [super viewWillAppear];
    [self setCardOptionsToolbarToWindow];
    [self setCardOptionsTouchBarToWindow];
}

- (void)viewWillDisappear {
    [super viewWillDisappear];
    [self clearCardOptionsToolbarFromWindow];
    [self clearCardOptionsTouchBarFromWindow];
}

- (NSTouchBar *)makeTouchBar {
    return self.cardOptionsTouchBar;
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
    
    NSNib *contentViewNib = [[NSNib alloc] initWithNibNamed:NSStringFromClass([CardContentView class]) bundle:NSBundle.mainBundle];
    [collectionView registerNib:contentViewNib forItemWithIdentifier:NSStringFromClass([CardContentView class])];
    [contentViewNib release];
    
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
                                               name:CardsViewModelErrorNotificationName
                                             object:self.viewModel];
    
    [NSNotificationCenter.defaultCenter addObserver:self
                                           selector:@selector(applyingSnapshotWasDoneReceived:)
                                               name:CardsViewModelApplyingSnapshotToDataSourceWasDoneNotificationName
                                             object:self.viewModel];
}

- (void)scrollViewDidEndLiveScrollReceived:(NSNotification *)notification {
    [NSOperationQueue.mainQueue addOperationWithBlock:^{
        if ((self.clipView.bounds.origin.y + self.clipView.bounds.size.height) >= self.collectionView.collectionViewLayout.collectionViewContentSize.height) {
            BOOL requested = [self.viewModel requestDataSourceWithOptions:self.viewModel.options reset:NO];
            
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
        [self.cardOptionsToolbar updateItemsWithOptions:self.viewModel.options];
        [self.cardOptionsTouchBar updateItemsWithOptions:self.viewModel.options];
    }];
}

- (CardsDataSource *)makeDataSource {
    CardsDataSource *dataSource = [[CardsDataSource alloc] initWithCollectionView:self.collectionView
                                                                     itemProvider:^NSCollectionViewItem * _Nullable(NSCollectionView * _Nonnull collectionView, NSIndexPath * _Nonnull indexPath, CardItemModel * _Nonnull itemModel) {
        
        CardContentView *cell = (CardContentView *)[collectionView makeItemWithIdentifier:NSStringFromClass([CardContentView class]) forIndexPath:indexPath];
        [cell configureWithHSCard:itemModel.hsCard];
        
        return cell;
    }];
    
    return [dataSource autorelease];
}

- (void)configureCardOptionsToolbar {
    CardOptionsToolbar *cardOptionsToolbar = [[CardOptionsToolbar alloc] initWithOptions:self.viewModel.options cardOptionsToolbarDelegate:self];
    self.cardOptionsToolbar = cardOptionsToolbar;
    [cardOptionsToolbar release];
}

- (void)configureCardOptionsTouchBar {
    CardOptionsTouchBar *cardOptionsTouchBar = [[CardOptionsTouchBar alloc] initWithOptions:self.viewModel.options cardOptionsTouchBarDelegate:self];
    self.cardOptionsTouchBar = cardOptionsTouchBar;
    [cardOptionsTouchBar release];
}

- (void)setCardOptionsTouchBarToWindow {
    self.view.window.touchBar = self.touchBar;
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

#pragma mark - CardOptionsToolbarDelegate

- (void)cardOptionsToolbar:(CardOptionsToolbar *)toolbar changedOption:(NSDictionary<NSString *,NSString *> *)options {
    [self addSpinnerView];
    [self.cardOptionsTouchBar updateItemsWithOptions:options];
    [self.viewModel requestDataSourceWithOptions:options reset:YES];
}

#pragma mark - CardOptionsTouchBarDelegate

- (void)cardOptionsTouchBar:(CardOptionsTouchBar *)touchBar changedOption:(NSDictionary<NSString *,NSString *> *)options {
    [self addSpinnerView];
    [self.cardOptionsToolbar updateItemsWithOptions:options];
    [self.viewModel requestDataSourceWithOptions:options reset:YES];
}

@end
