//
//  CardsViewController.m
//  CardsViewController
//
//  Created by Jinwoo Kim on 9/26/21.
//

#import "CardsViewController.h"
#import "NSWindow+presentErrorAlert.h"
#import "CardsViewModel.h"
#import "CardCollectionViewItem.h"
#import "NSViewController+SpinnerView.h"
#import "CardOptionsMenu.h"
#import "CardOptionsToolbar.h"
#import "CardOptionsTouchBar.h"
#import "WindowsService.h"
#import "HSCardPromiseProvider.h"
#import "ClickableCollectionView.h"
#import "PhotosService.h"
#import <StoneNamuCore/StoneNamuCore.h>
#import <StoneNamuResources/StoneNamuResources.h>

static NSUserInterfaceItemIdentifier const NSUserInterfaceItemIdentifierCardsViewController = @"NSUserInterfaceItemIdentifierCardsViewController";
static NSUserInterfaceItemIdentifier const NSUserInterfaceItemIdentifierCardCollectionViewItem = @"NSUserInterfaceItemIdentifierCardCollectionViewItem";

@interface CardsViewController () <NSCollectionViewDelegate, NSMenuDelegate, CardOptionsMenuDelegate, CardOptionsToolbarDelegate, CardOptionsTouchBarDelegate, CardCollectionViewItemDelegate>
@property (retain) NSScrollView *scrollView;
@property (retain) ClickableCollectionView *collectionView;
@property (retain) NSMenu *collectionViewMenu;
@property (retain) CardsViewModel *viewModel;
@property (retain) CardOptionsMenu *cardOptionsMenu;
@property (retain) CardOptionsToolbar *cardOptionsToolbar;
@property (retain) CardOptionsTouchBar *cardOptionsTouchBar;
@end

@implementation CardsViewController

- (void)dealloc {
    [self removeObserver:self forKeyPath:@"self.view.window"];
    [_scrollView release];
    [_collectionView release];
    [_collectionViewMenu release];
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
    [self configureCollectionViewMenu];
    [self configureCardOptionsMenu];
    [self configureCardOptionsToolbar];
    [self configureCardOptionsTouchBar];
    [self configureViewModel];
    [self bind];
    [self requestDataSourceWithOptions:nil reset:NO];
}

- (NSTouchBar *)makeTouchBar {
    return self.cardOptionsTouchBar;
}

- (void)encodeRestorableStateWithCoder:(NSCoder *)coder backgroundQueue:(NSOperationQueue *)queue {
    [super encodeRestorableStateWithCoder:coder backgroundQueue:queue];
    
    [queue addOperationWithBlock:^{
        [coder encodeObject:self.viewModel.options forKey:@"options"];
    }];
}

- (void)restoreStateWithCoder:(NSCoder *)coder {
    [super restoreStateWithCoder:coder];
    
    NSDictionary<NSString *, id> *options = [coder decodeObjectOfClass:[NSDictionary<NSString *, id> class] forKey:@"options"];
    [self requestDataSourceWithOptions:options reset:YES];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if (([object isEqual:self]) && ([keyPath isEqualToString:@"self.view.window"])) {
        if (self.view.window != nil) {
            [NSOperationQueue.mainQueue addOperationWithBlock:^{
                [self setCardsMenuToWindow];
                [self setCardOptionsToolbarToWindow];
                [self setCardOptionsTouchBarToWindow];
            }];
        }
    } else {
        return [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
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
    ClickableCollectionView *collectionView = [ClickableCollectionView new];

    [self.view addSubview:scrollView];
    scrollView.translatesAutoresizingMaskIntoConstraints = NO;
    [NSLayoutConstraint activateConstraints:@[
        [scrollView.topAnchor constraintEqualToAnchor:self.view.topAnchor],
        [scrollView.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor],
        [scrollView.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor],
        [scrollView.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor]
    ]];
    
    NSCollectionViewFlowLayout *flowLayout = [NSCollectionViewFlowLayout new];
    flowLayout.itemSize = NSMakeSize(200, 270);
    flowLayout.minimumLineSpacing = 0.0f;
    collectionView.collectionViewLayout = flowLayout;
    [flowLayout release];
    
    NSNib *nib = [[NSNib alloc] initWithNibNamed:NSStringFromClass([CardCollectionViewItem class]) bundle:NSBundle.mainBundle];
    [collectionView registerNib:nib forItemWithIdentifier:NSUserInterfaceItemIdentifierCardCollectionViewItem];
    [nib release];

    collectionView.selectable = YES;
    collectionView.allowsMultipleSelection = YES;
    collectionView.allowsEmptySelection = YES;
    collectionView.delegate = self;
    
    [collectionView registerForDraggedTypes:HSCardPromiseProvider.pasteboardTypes];
    [collectionView setDraggingSourceOperationMask:NSDragOperationCopy forLocal:NO];
    
    scrollView.documentView = collectionView;
    scrollView.contentView.postsBoundsChangedNotifications = YES;
    
    self.scrollView = scrollView;
    self.collectionView = collectionView;
    [scrollView release];
    [collectionView release];
}

- (void)configureCollectionViewMenu {
    NSMenu *collectionViewMenu = [NSMenu new];
    
    collectionViewMenu.delegate = self;
    self.collectionView.menu = collectionViewMenu;
    
    self.collectionViewMenu = collectionViewMenu;
    [collectionViewMenu release];
}

- (void)showDetailItemTriggered:(NSMenuItem *)sender {
    [self presentCardDetailsViewControllerWithIndexPaths:self.collectionView.interactingIndexPaths];
}

- (void)saveImageItemTriggered:(NSMenuItem *)sender {
    [self.viewModel hsCardsFromIndexPathsWithCompletion:self.collectionView.interactingIndexPaths completion:^(NSSet<HSCard *> * _Nonnull hsCards) {
        if (hsCards.count == 0) return;
        
        [NSOperationQueue.mainQueue addOperationWithBlock:^{
            PhotosService *service = [[PhotosService alloc] initWithHSCards:hsCards];
            
            [service beginSheetModalForWindow:self.view.window completion:^(BOOL success, NSError * _Nullable error) {
                if (error != nil) {
                    [NSOperationQueue.mainQueue addOperationWithBlock:^{
                        [self.view.window presentErrorAlertWithError:error];
                    }];
                }
            }];
            
            [service release];
        }];
    }];
}

- (void)shareImageItemTriggered:(NSMenuItem *)sender {
    NSSet<NSIndexPath *> *interactingIndexPaths = self.collectionView.interactingIndexPaths;
    
    [self.viewModel hsCardsFromIndexPathsWithCompletion:interactingIndexPaths completion:^(NSSet<HSCard *> * _Nonnull hsCards) {
        if (hsCards.count == 0) return;
        
        [NSOperationQueue.mainQueue addOperationWithBlock:^{
            NSView * _Nullable fromView = [self.collectionView itemAtIndexPath:interactingIndexPaths.allObjects.lastObject].view;
            
            if (fromView == nil) {
                fromView = self.view;
            }
            
            PhotosService *service = [[PhotosService alloc] initWithHSCards:hsCards];
            [service beginSharingServiceOfView:fromView];
            [service release];
        }];
    }];
}

- (void)configureViewModel {
    CardsViewModel *viewModel = [[CardsViewModel alloc] initWithDataSource:[self makeDataSource]];
    self.viewModel = viewModel;
    [viewModel release];
}

- (void)bind {
    [self addObserver:self forKeyPath:@"self.view.window" options:NSKeyValueObservingOptionInitial | NSKeyValueObservingOptionNew context:nil];
    
    [NSNotificationCenter.defaultCenter addObserver:self
                                           selector:@selector(scrollViewDidEndLiveScrollReceived:)
                                               name:NSScrollViewDidEndLiveScrollNotification
                                             object:self.scrollView];
    
    [NSNotificationCenter.defaultCenter addObserver:self
                                           selector:@selector(errorEventReceived:)
                                               name:NSNotificationNameCardsViewModelError
                                             object:self.viewModel];
    
    [NSNotificationCenter.defaultCenter addObserver:self
                                           selector:@selector(startedLoadingDataSourceReceived:)
                                               name:NSNotificationNameCardsViewModelStartedLoadingDataSource
                                             object:self.viewModel];
    
    [NSNotificationCenter.defaultCenter addObserver:self
                                           selector:@selector(endedLoadingDataSourceReceived:)
                                               name:NSNotificationNameCardsViewModelEndedLoadingDataSource
                                             object:self.viewModel];
}

- (void)scrollViewDidEndLiveScrollReceived:(NSNotification *)notification {
    [NSOperationQueue.mainQueue addOperationWithBlock:^{
        NSRect bounds = self.scrollView.contentView.bounds;
        if ((bounds.origin.y + bounds.size.height) >= self.collectionView.collectionViewLayout.collectionViewContentSize.height) {
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

- (void)startedLoadingDataSourceReceived:(NSNotification *)notification {
    [NSOperationQueue.mainQueue addOperationWithBlock:^{
        [self addSpinnerView];
    }];
}

- (void)endedLoadingDataSourceReceived:(NSNotification *)notification {
    [NSOperationQueue.mainQueue addOperationWithBlock:^{
        [self removeAllSpinnerview];
//        [self updateOptionInterfaceWithOptions:self.viewModel.options];
    }];
}

- (CardsDataSource *)makeDataSource {
    CardsViewController * __block unretainedSelf = self;
    
    CardsDataSource *dataSource = [[CardsDataSource alloc] initWithCollectionView:self.collectionView
                                                                     itemProvider:^NSCollectionViewItem * _Nullable(NSCollectionView * _Nonnull collectionView, NSIndexPath * _Nonnull indexPath, CardItemModel * _Nonnull itemModel) {
        
        CardCollectionViewItem *item = (CardCollectionViewItem *)[collectionView makeItemWithIdentifier:NSUserInterfaceItemIdentifierCardCollectionViewItem forIndexPath:indexPath];
        [item configureWithHSCard:itemModel.hsCard delegate:unretainedSelf];
        
        return item;
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

- (void)presentCardDetailsViewControllerWithIndexPaths:(NSSet<NSIndexPath *> *)indexPaths {
    [indexPaths enumerateObjectsUsingBlock:^(NSIndexPath * _Nonnull obj, BOOL * _Nonnull stop) {
        HSCard * _Nullable hsCard = [self.viewModel.dataSource itemIdentifierForIndexPath:obj].hsCard;
        
        if (hsCard == nil) return;
        
        [WindowsService presentCardDetailsWindowWithHSCard:hsCard];
    }];
}

#pragma mark - NSCollectionViewDelegate

- (BOOL)collectionView:(NSCollectionView *)collectionView canDragItemsAtIndexPaths:(NSSet<NSIndexPath *> *)indexPaths withEvent:(NSEvent *)event {
    BOOL result __block = YES;

    [indexPaths enumerateObjectsUsingBlock:^(NSIndexPath * _Nonnull obj, BOOL * _Nonnull stop) {
        CardItemModel * _Nullable itemModel = [self.viewModel.dataSource itemIdentifierForIndexPath:obj];

        if (itemModel == nil) {
            result = NO;
            *stop = YES;
            return;
        }
    }];

    return result;
}

- (id<NSPasteboardWriting>)collectionView:(NSCollectionView *)collectionView pasteboardWriterForItemAtIndexPath:(NSIndexPath *)indexPath {
    CardCollectionViewItem * _Nullable item = (CardCollectionViewItem *)[collectionView itemAtIndexPath:indexPath];
    
    if (item == nil) return nil;
    
    CardItemModel * _Nullable itemModel = [self.viewModel.dataSource itemIdentifierForIndexPath:indexPath];
    
    if (itemModel == nil) return nil;
    
    HSCardPromiseProvider *provider = [[HSCardPromiseProvider alloc] initWithHSCard:itemModel.hsCard image:item.imageView.image];
    
    return [provider autorelease];
}

#pragma mark - NSMenuDelegate

- (void)menuWillOpen:(NSMenu *)menu {
    if ([menu isEqual:self.collectionViewMenu]) {
        NSSet<NSIndexPath *> *interactingIndexPaths = self.collectionView.interactingIndexPaths;
        
        if (interactingIndexPaths.count > 0) {
            NSMenuItem *showDetailItem = [[NSMenuItem alloc] initWithTitle:[ResourcesService localizationForKey:LocalizableKeyShowDetails]
                                                                    action:@selector(showDetailItemTriggered:)
                                                             keyEquivalent:@""];
            showDetailItem.image = [NSImage imageWithSystemSymbolName:@"list.bullet" accessibilityDescription:nil];
            showDetailItem.target = self;
            
            NSMenuItem *saveImageItem = [[NSMenuItem alloc] initWithTitle:[ResourcesService localizationForKey:LocalizableKeySave]
                                                                   action:@selector(saveImageItemTriggered:)
                                                            keyEquivalent:@""];
            saveImageItem.image = [NSImage imageWithSystemSymbolName:@"square.and.arrow.down" accessibilityDescription:nil];
            saveImageItem.target = self;
            
            NSMenuItem *shareImageItem = [[NSMenuItem alloc] initWithTitle:[ResourcesService localizationForKey:LocalizableKeyShare]
                                                                    action:@selector(shareImageItemTriggered:)
                                                             keyEquivalent:@""];
            shareImageItem.image = [NSImage imageWithSystemSymbolName:@"square.and.arrow.up" accessibilityDescription:nil];
            shareImageItem.target = self;
            
            menu.itemArray = @[showDetailItem, saveImageItem, shareImageItem];
            
            [showDetailItem release];
            [saveImageItem release];
        } else {
            menu.itemArray = @[];
        }
    }
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

#pragma mark - CardCollectionViewItemDelegate

- (void)cardCollectionViewItem:(CardCollectionViewItem *)cardCollectionViewItem didDoubleClickWithRecognizer:(NSClickGestureRecognizer *)recognizer {
    [self presentCardDetailsViewControllerWithIndexPaths:self.collectionView.selectionIndexPaths];
}

@end
