//
//  DeckAddCardsViewController.m
//  StoneNamuMac
//
//  Created by Jinwoo Kim on 11/28/21.
//

#import "DeckAddCardsViewController.h"
#import "NSWindow+presentErrorAlert.h"
#import "DeckAddCardsViewModel.h"
#import "DeckAddCardCollectionViewItem.h"
#import "NSViewController+SpinnerView.h"
#import "DeckAddCardOptionsMenu.h"
#import "DeckAddCardOptionsToolbar.h"
#import "DeckAddCardOptionsTouchBar.h"
#import "WindowsService.h"
#import "HSCardPromiseProvider.h"
#import "PhotosService.h"
#import "ClickableCollectionView.h"
#import "NSViewController+loadViewIfNeeded.h"
#import "NSPasteboardNameStoneNamuPasteboard.h"
#import <StoneNamuCore/StoneNamuCore.h>
#import <StoneNamuResources/StoneNamuResources.h>

static NSUserInterfaceItemIdentifier const NSUserInterfaceItemIdentifierDeckAddCardsViewController = @"NSUserInterfaceItemIdentifierDeckAddCardsViewController";

@interface DeckAddCardsViewController () <NSCollectionViewDelegate, NSMenuDelegate, DeckAddCardOptionsMenuDelegate, DeckAddCardOptionsToolbarDelegate, DeckAddCardOptionsTouchBarDelegate, DeckAddCardCollectionViewItemDelegate>
@property (retain) NSScrollView *scrollView;
@property (retain) ClickableCollectionView *collectionView;
@property (retain) NSMenu *collectionViewMenu;
@property (retain) DeckAddCardsViewModel *viewModel;
@property (retain) DeckAddCardOptionsMenu *deckAddCardOptionsMenu;
@property (retain) DeckAddCardOptionsToolbar *deckAddCardOptionsToolbar;
@property (retain) DeckAddCardOptionsTouchBar *deckAddCardOptionsTouchBar;
@end

@implementation DeckAddCardsViewController

- (instancetype)initWithLocalDeck:(LocalDeck *)localDeck {
    self = [self init];
    
    if (self) {
        [self loadViewIfNeeded];
        self.viewModel.localDeck = localDeck;
        
        if (localDeck != nil) {
            [self requestDataSourceWithOptions:nil reset:YES];
            [self updateOptionsUsingLocalDeck:localDeck];
        }
    }
    
    return self;
}

- (void)dealloc {
    [self removeObserver:self forKeyPath:@"self.view.window"];
    [_scrollView release];
    [_collectionView release];
    [_collectionViewMenu release];
    [_viewModel release];
    [_deckAddCardOptionsMenu release];
    [_deckAddCardOptionsToolbar release];
    [_deckAddCardOptionsTouchBar release];
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
    [self configureDeckAddCardOptionsMenu];
    [self configureDeckAddCardOptionsToolbar];
    [self configureDeckAddCardOptionsTouchBar];
    [self configureViewModel];
    [self bind];
}

- (NSTouchBar *)makeTouchBar {
    return self.deckAddCardOptionsTouchBar;
}

- (void)encodeRestorableStateWithCoder:(NSCoder *)coder backgroundQueue:(nonnull NSOperationQueue *)queue {
    [super encodeRestorableStateWithCoder:coder];
    
    NSDictionary<NSString *, NSSet<NSString *> *> * _Nullable options = self.viewModel.options;
    NSURL * _Nullable uri = self.viewModel.localDeck.objectID.URIRepresentation;
    
    [queue addOperationWithBlock:^{
        if (options != nil) {
            [coder encodeObject:options forKey:[NSString stringWithFormat:@"%@_options", NSStringFromClass(self.class)]];
        }
        
        if (uri != nil) {
            [coder encodeObject:uri forKey:[NSString stringWithFormat:@"%@_URIRepresentation", NSStringFromClass(self.class)]];
        }
    }];
}

- (void)restoreStateWithCoder:(NSCoder *)coder {
    [super restoreStateWithCoder:coder];
    
    NSDictionary<NSString *, NSSet<NSString *> *> *options = [coder decodeObjectOfClasses:[NSSet setWithArray:@[NSDictionary.class, NSSet.class, NSString.class]] forKey:[NSString stringWithFormat:@"%@_options", NSStringFromClass(self.class)]];
    
    NSURL * _Nullable URIRepresentation = [coder decodeObjectOfClass:[NSURL class] forKey:[NSString stringWithFormat:@"%@_URIRepresentation", NSStringFromClass(self.class)]];
    
    if (URIRepresentation != nil) {
        [self.viewModel loadLocalDeckFromURIRepresentation:URIRepresentation completion:^(BOOL result) {
            if (result) {
                [NSOperationQueue.mainQueue addOperationWithBlock:^{
                    [self requestDataSourceWithOptions:options reset:YES];
                    [self updateOptionsUsingLocalDeck:self.viewModel.localDeck];
                }];
            }
        }];
    }
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if (([object isEqual:self]) && ([keyPath isEqualToString:@"self.view.window"])) {
        [NSNotificationCenter.defaultCenter removeObserver:self name:NSWindowDidBecomeMainNotification object:nil];
        
        [NSOperationQueue.mainQueue addOperationWithBlock:^{
            if (self.view.window.isMainWindow) {
                [self windowDidBecomeMainReceived:nil];
            } else {
                [self setDeckAddCardOptionsToolbarToWindow];
            }
        }];
        
        if (self.view.window != nil) {
            [NSNotificationCenter.defaultCenter addObserver:self
                                                   selector:@selector(windowDidBecomeMainReceived:)
                                                       name:NSWindowDidBecomeMainNotification
                                                     object:self.view.window];
        }
    } else {
        return [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

- (void)updateOptionInterfaceWithOptions:(NSDictionary<NSString *, NSSet<NSString *> *> * _Nullable)options {
    [self.deckAddCardOptionsMenu updateItemsWithOptions:options];
    [self.deckAddCardOptionsToolbar updateItemsWithOptions:options];
    [self.deckAddCardOptionsTouchBar updateItemsWithOptions:options];
}

- (BOOL)requestDataSourceWithOptions:(NSDictionary<NSString *, NSSet<NSString *> *> * _Nullable)options reset:(BOOL)reset {
    BOOL requested = [self.viewModel requestDataSourceWithOptions:options reset:reset];
    
    if (requested) {
        if (reset) {
            [self.undoManager registerUndoWithTarget:self
                                            selector:@selector(undoOptions:)
                                              object:self.viewModel.options];
        }
    }
    
    return requested;
}

- (void)undoOptions:(NSDictionary<NSString *, NSSet<NSString *> *> *)options {
    [self updateOptionInterfaceWithOptions:options];
    [self.viewModel requestDataSourceWithOptions:options reset:YES];
}

- (void)setAttributes {
    self.identifier = NSUserInterfaceItemIdentifierDeckAddCardsViewController;
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
    
    NSNib *nib = [[NSNib alloc] initWithNibNamed:NSStringFromClass([DeckAddCardCollectionViewItem class]) bundle:NSBundle.mainBundle];
    [collectionView registerNib:nib forItemWithIdentifier:NSUserInterfaceItemIdentifierDeckAddCardCollectionViewItem];
    [nib release];
    
    collectionView.selectable = YES;
    collectionView.allowsMultipleSelection = NO;
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
            PhotosService *service = [[PhotosService alloc] initWithHSCards:hsCards hsGameModeSlugType:HSCardGameModeSlugTypeConstructed isGold:NO];
            
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
            
            PhotosService *service = [[PhotosService alloc] initWithHSCards:hsCards hsGameModeSlugType:HSCardGameModeSlugTypeConstructed isGold:NO];
            [service beginSharingServiceOfView:fromView];
            [service release];
        }];
    }];
}

- (void)copyItemTriggered:(NSMenuItem *)sender {
    NSArray<HSCard *> *hsCards = [self.viewModel hsCardsFromIndexPaths:self.collectionView.interactingIndexPaths].allObjects;
    [self copyHSCards:hsCards];
}

- (void)configureViewModel {
    DeckAddCardsViewModel *viewModel = [[DeckAddCardsViewModel alloc] initWithDataSource:[self makeDataSource]];
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
                                               name:NSNotificationNameDeckAddCardsViewModelError
                                             object:self.viewModel];
    
    [NSNotificationCenter.defaultCenter addObserver:self
                                           selector:@selector(startedLoadingDataSourceReceived:)
                                               name:NSNotificationNameDeckAddCardsViewModelStartedLoadingDataSource
                                             object:self.viewModel];
    
    [NSNotificationCenter.defaultCenter addObserver:self
                                           selector:@selector(endedLoadingDataSourceReceived:)
                                               name:NSNotificationNameDeckAddCardsViewModelEndedLoadingDataSource
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
    NSError * _Nullable error = notification.userInfo[DeckAddCardsViewModelErrorNotificationErrorKey];
    
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
    NSDictionary<NSString *, NSSet<NSString *> *> * _Nullable options = notification.userInfo[NSNotificationNameDeckAddCardsViewModelStartedLoadingDataSourceOptionsKey];
    
    [NSOperationQueue.mainQueue addOperationWithBlock:^{
        [self addSpinnerView];
        
        if (options != nil) {
            [self updateOptionInterfaceWithOptions:options];
        }
    }];
}

- (void)endedLoadingDataSourceReceived:(NSNotification *)notification {
    [NSOperationQueue.mainQueue addOperationWithBlock:^{
        [self removeAllSpinnerview];
        [self updateOptionInterfaceWithOptions:self.viewModel.options];
    }];
}

- (void)windowDidBecomeMainReceived:(NSNotification *)notification {
    [NSOperationQueue.mainQueue addOperationWithBlock:^{
        [self setDeckAddCardOptionsMenuToApp];
        [self setDeckAddCardOptionsToolbarToWindow];
        [self setDeckAddCardOptionsTouchBarToWindow];
    }];
}

- (DeckAddCardsDataSource *)makeDataSource {
    DeckAddCardsViewController * __block unretainedSelf = self;
    
    DeckAddCardsDataSource *dataSource = [[DeckAddCardsDataSource alloc] initWithCollectionView:self.collectionView
                                                                                   itemProvider:^NSCollectionViewItem * _Nullable(NSCollectionView * _Nonnull collectionView, NSIndexPath * _Nonnull indexPath, DeckAddCardItemModel * _Nonnull itemModel) {
        
        DeckAddCardCollectionViewItem *item = (DeckAddCardCollectionViewItem *)[collectionView makeItemWithIdentifier:NSUserInterfaceItemIdentifierDeckAddCardCollectionViewItem forIndexPath:indexPath];
        [item configureWithHSCard:itemModel.hsCard count:itemModel.count isLegendary:itemModel.isLegendary delegate:unretainedSelf];
        
        return item;
    }];
    
    return [dataSource autorelease];
}

- (void)configureDeckAddCardOptionsMenu {
    DeckAddCardOptionsMenu *deckAddCardOptionsMenu = [[DeckAddCardOptionsMenu alloc] initWithOptions:self.viewModel.options localDeck:self.viewModel.localDeck deckAddCardOptionsMenuDelegate:self];
    self.deckAddCardOptionsMenu = deckAddCardOptionsMenu;
    [deckAddCardOptionsMenu release];
}

- (void)configureDeckAddCardOptionsToolbar {
    DeckAddCardOptionsToolbar *deckAddCardOptionsToolbar = [[DeckAddCardOptionsToolbar alloc] initWithIdentifier:NSToolbarIdentifierDeckAddCardOptionsToolbar options:self.viewModel.options localDeck:self.viewModel.localDeck deckAddCardOptionsToolbarDelegate:self];
    self.deckAddCardOptionsToolbar = deckAddCardOptionsToolbar;
    [deckAddCardOptionsToolbar release];
}

- (void)configureDeckAddCardOptionsTouchBar {
    DeckAddCardOptionsTouchBar *deckAddCardOptionsTouchBar = [[DeckAddCardOptionsTouchBar alloc] initWithOptions:self.viewModel.options localDeck:self.viewModel.localDeck deckAddCardOptionsTouchBarDelegate:self];
    self.deckAddCardOptionsTouchBar = deckAddCardOptionsTouchBar;
    [deckAddCardOptionsTouchBar release];
}

- (void)setDeckAddCardOptionsMenuToApp {
    NSApp.mainMenu = self.deckAddCardOptionsMenu;
}

- (void)setDeckAddCardOptionsToolbarToWindow {
    self.view.window.toolbar = self.deckAddCardOptionsToolbar;
}

- (void)setDeckAddCardOptionsTouchBarToWindow {
    self.view.window.touchBar = self.deckAddCardOptionsTouchBar;
}

- (void)clearMenuFromApp {
    NSApp.mainMenu = nil;
}

- (void)clearToolbarFromWindow {
    self.view.window.toolbar = nil;
}

- (void)clearTouchBarFromWindow {
    self.view.window.touchBar = nil;
}

- (void)updateOptionsUsingLocalDeck:(LocalDeck *)localDeck {
    [self.deckAddCardOptionsMenu setLocalDeck:localDeck];
    [self.deckAddCardOptionsToolbar setLocalDeck:localDeck];
    [self.deckAddCardOptionsTouchBar setLocalDeck:localDeck];
}

- (void)presentCardDetailsViewControllerWithIndexPaths:(NSSet<NSIndexPath *> *)indexPaths {
    [indexPaths enumerateObjectsUsingBlock:^(NSIndexPath * _Nonnull obj, BOOL * _Nonnull stop) {
        HSCard * _Nullable hsCard = [self.viewModel.dataSource itemIdentifierForIndexPath:obj].hsCard;
        
        if (hsCard == nil) return;
        
        [WindowsService.sharedInstance presentCardDetailsWindowWithHSCard:hsCard hsGameModeSlugType:HSCardGameModeSlugTypeConstructed isGold:NO];
    }];
}

- (void)copyHSCards:(NSArray<HSCard *> *)hsCards {
    NSPasteboard *pb = [NSPasteboard pasteboardWithName:NSPasteboardNameStoneNamuPasteboard];
    [pb clearContents];
    [pb writeObjects:hsCards];
}

#pragma mark - NSCollectionViewDelegate

- (void)collectionView:(NSCollectionView *)collectionView didSelectItemsAtIndexPaths:(NSSet<NSIndexPath *> *)indexPaths {
    [collectionView deselectItemsAtIndexPaths:indexPaths];
    //    [self.viewModel addHSCardsFromIndexPathes:indexPaths];
}

- (BOOL)collectionView:(NSCollectionView *)collectionView canDragItemsAtIndexPaths:(NSSet<NSIndexPath *> *)indexPaths withEvent:(NSEvent *)event {
    BOOL __block result = YES;
    
    [indexPaths enumerateObjectsUsingBlock:^(NSIndexPath * _Nonnull obj, BOOL * _Nonnull stop) {
        DeckAddCardItemModel * _Nullable itemModel = [self.viewModel.dataSource itemIdentifierForIndexPath:obj];
        
        if (itemModel == nil) {
            result = NO;
            *stop = YES;
            return;
        }
    }];
    
    return result;
}

- (id<NSPasteboardWriting>)collectionView:(NSCollectionView *)collectionView pasteboardWriterForItemAtIndexPath:(NSIndexPath *)indexPath {
    DeckAddCardCollectionViewItem * _Nullable item = (DeckAddCardCollectionViewItem *)[collectionView itemAtIndexPath:indexPath];
    
    if (item == nil) return nil;
    
    DeckAddCardItemModel * _Nullable itemModel = [self.viewModel.dataSource itemIdentifierForIndexPath:indexPath];
    
    if (itemModel == nil) return nil;
    
    HSCardPromiseProvider *provider = [[HSCardPromiseProvider alloc] initWithHSCard:itemModel.hsCard image:item.cardImage];
    
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
            
            NSMenuItem *copyItem = [[NSMenuItem alloc] initWithTitle:[ResourcesService localizationForKey:LocalizableKeyCopy]
                                                              action:@selector(copyItemTriggered:)
                                                       keyEquivalent:@""];
            copyItem.image = [NSImage imageWithSystemSymbolName:@"doc.on.doc" accessibilityDescription:nil];
            copyItem.target = self;
            
            menu.itemArray = @[showDetailItem,
                               [NSMenuItem separatorItem],
                               saveImageItem,
                               shareImageItem,
                               copyItem];
            
            [showDetailItem release];
            [saveImageItem release];
            [shareImageItem release];
            [copyItem release];
        } else {
            menu.itemArray = @[];
        }
    }
}

#pragma mark - DeckAddCardOptionsMenuDelegate

- (void)deckAddCardOptionsMenu:(DeckAddCardOptionsMenu *)menu changedOption:(NSDictionary<NSString *,NSSet<NSString *> *> *)options {
    [NSOperationQueue.mainQueue addOperationWithBlock:^{
        [self requestDataSourceWithOptions:options reset:YES];
    }];
}

- (void)deckAddCardOptionsMenu:(DeckAddCardOptionsMenu *)menu defaultOptionsAreNeedWithSender:(NSMenuItem *)sender {
    [NSOperationQueue.mainQueue addOperationWithBlock:^{
        [self requestDataSourceWithOptions:nil reset:YES];
    }];
}

#pragma mark - DeckAddCardOptionsToolbarDelegate

- (void)deckAddCardOptionsToolbar:(DeckAddCardOptionsToolbar *)toolbar changedOption:(NSDictionary<NSString *,NSSet<NSString *> *> *)options {
    [NSOperationQueue.mainQueue addOperationWithBlock:^{
        [self requestDataSourceWithOptions:options reset:YES];
    }];
}

#pragma mark - DeckAddCardOptionsTouchBarDelegate

- (void)deckAddCardOptionsTouchBar:(DeckAddCardOptionsTouchBar *)touchBar changedOption:(NSDictionary<NSString *,NSSet<NSString *> *> *)options {
    [NSOperationQueue.mainQueue addOperationWithBlock:^{
        [self requestDataSourceWithOptions:options reset:YES];
    }];
}

#pragma mark - DeckAddCardCollectionViewItemDelegate

- (void)deckAddCardCollectionViewItem:(DeckAddCardCollectionViewItem *)deckAddCardCollectionViewItem didClickWithRecognizer:(NSClickGestureRecognizer *)recognizer {
    HSCard * _Nullable hsCard = deckAddCardCollectionViewItem.hsCard;
    
    if (hsCard == nil) return;
    
    [self.viewModel addHSCards:[NSSet setWithObject:hsCard]];
}

@end
