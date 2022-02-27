//
//  DeckDetailsViewController.m
//  StoneNamuMac
//
//  Created by Jinwoo Kim on 11/28/21.
//

#import "DeckDetailsViewController.h"
#import "HSCardPromiseProvider.h"
#import "DeckDetailsCardCollectionViewItem.h"
#import "DeckDetailsViewModel.h"
#import "NSViewController+loadViewIfNeeded.h"
#import "NSWindow+topBarHeight.h"
#import "DeckDetailsCollectionViewLayout.h"
#import "DeckDetailsManaCostGraphView.h"
#import "ClickableCollectionView.h"
#import "WindowsService.h"
#import "NSViewController+SpinnerView.h"
#import "NSWindow+presentErrorAlert.h"
#import "DeckImageRenderService.h"
#import "PhotosService.h"
#import "HSCardDroppableView.h"
#import "DeckDetailsSeparatorBox.h"
#import "NSPasteboardNameStoneNamuPasteboard.h"
#import "NSAlert+presentTextFieldAlert.h"
#import <StoneNamuCore/StoneNamuCore.h>
#import <StoneNamuResources/StoneNamuResources.h>

@interface DeckDetailsViewController () <NSCollectionViewDelegate, NSMenuDelegate, DeckDetailsCardCollectionViewItemDelegate, HSCardDroppableViewDelegate>
@property (readonly, nonatomic) NSArray<NSMenuItem *> *menuItemsForSingleItem;
@property (readonly, nonatomic) NSArray<NSMenuItem *> *menuItemsForMultipleItems;
@property (retain) NSScrollView *scrollView;
@property (retain) ClickableCollectionView *collectionView;
@property (retain) NSMenu *collectionViewMenu;
@property (retain) DeckDetailsManaCostGraphView *manaCostGraphView;
@property (retain) HSCardDroppableView *hsCardDroppableView;
@property (assign) NSTextField *deckNameTextField;
@property (assign) NSTextView *deckCodeTextView;
@property (retain) DeckDetailsViewModel *viewModel;
@end

@implementation DeckDetailsViewController

- (instancetype)initWithLocalDeck:(LocalDeck *)localDeck {
    self = [self init];
    
    if (self) {
        [self loadViewIfNeeded];
        [self.viewModel requestDataSourceFromLocalDeck:localDeck];
    }
    
    return self;
}

- (void)dealloc {
    [self removeObserver:self forKeyPath:@"self.view.window"];
    [_scrollView release];
    [_collectionView release];
    [_collectionViewMenu release];
    [_manaCostGraphView release];
    [_hsCardDroppableView release];
    [_viewModel release];
    [super dealloc];
}

- (void)paste:(id)sender {
    NSPasteboard *pb = [NSPasteboard pasteboardWithName:NSPasteboardNameStoneNamuPasteboard];
    NSArray<HSCard *> * _Nullable hsCards = [pb readObjectsForClasses:@[[HSCard class]] options:nil];
    if (hsCards == nil) return;
    [self.viewModel addHSCards:hsCards];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if (([object isEqual:self]) && ([keyPath isEqualToString:@"self.view.window"])) {
        if (self.view.window != nil) {
            [NSOperationQueue.mainQueue addOperationWithBlock:^{
                if (self.viewModel.localDeck != nil) {
                    NSString * _Nullable title = self.viewModel.localDeck.name;
                    NSString * _Nullable subtitle = self.viewModel.windowSubtitle;
                    
                    if (title != nil) {
                        self.view.window.title = title;
                    } else {
                        self.view.window.title = @"";
                    }
                    
                    if (subtitle != nil) {
                        self.view.window.subtitle = subtitle;
                    } else {
                        self.view.window.subtitle = @"";
                    }
                }
                [self updateScrollViewContentInsets];
            }];
        }
    } else {
        return [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

- (void)saveAsImageItemTriggered:(NSMenuItem *)sender {
    DeckImageRenderService *renderService = [DeckImageRenderService new];
    
    [renderService imageFromLocalDeck:self.viewModel.localDeck fromWindow:self.view.window completion:^(NSImage * _Nonnull image) {
        [NSOperationQueue.mainQueue addOperationWithBlock:^{
            PhotosService *photoService = [[PhotosService alloc] initWithImages:@{self.viewModel.localDeck.name: image}];
            
            [photoService beginSheetModalForWindow:self.view.window completion:^(BOOL success, NSError * _Nullable error) {
                if (error != nil) {
                    [NSOperationQueue.mainQueue addOperationWithBlock:^{
                        [self.view.window presentErrorAlertWithError:error];
                    }];
                }
            }];
            
            return;
        }];
    }];
    
    [renderService release];
}

- (void)exportDeckCodeItemTriggered:(NSMenuItem *)sender {
    [self addSpinnerView];
    
    [self.viewModel exportLocalizedDeckCodeWithCompletion:^(NSString * _Nullable string) {
        [NSOperationQueue.mainQueue addOperationWithBlock:^{
            [self removeAllSpinnerview];
            
            if (string == nil) return;
            
            //
            
            NSAlert *alert = [NSAlert new];
            NSButton *shareButton = [alert addButtonWithTitle:[ResourcesService localizationForKey:LocalizableKeyShare]];
            NSButton *copyButton = [alert addButtonWithTitle:[ResourcesService localizationForKey:LocalizableKeyCopy]];
            [alert addButtonWithTitle:[ResourcesService localizationForKey:LocalizableKeyCancel]];
            NSScrollView *scrollView = [[NSScrollView alloc] initWithFrame:NSMakeRect(0.0f, 0.0f, 300.0f, 200.0f)];
            NSTextView *deckCodeTextView = [[NSTextView alloc] initWithFrame:scrollView.bounds];
            
            //
            
            shareButton.target = self;
            shareButton.action = @selector(exportDeckCodeItemShareButtonTriggered:);
            
            copyButton.target = self;
            copyButton.action = @selector(exportDeckCodeItemCopyButtonTriggered:);
            
            //
            
            
            scrollView.documentView = deckCodeTextView;
            deckCodeTextView.string = string;
            
            //
            
            alert.messageText = [ResourcesService localizationForKey:LocalizableKeyResult];
            alert.showsSuppressionButton = NO;
            alert.accessoryView = scrollView;
            
            //
            
            [alert beginSheetModalForWindow:self.view.window completionHandler:^(NSModalResponse returnCode) {
                
            }];
            
            [alert release];
            [scrollView release];
            
            self.deckCodeTextView = deckCodeTextView;
            [deckCodeTextView release];
        }];
    }];
}

- (void)exportDeckCodeItemShareButtonTriggered:(NSButton *)sender {
    NSSharingServicePicker *picker = [[NSSharingServicePicker alloc] initWithItems:@[self.deckCodeTextView.string]];
    
    [picker showRelativeToRect:CGRectZero ofView:sender preferredEdge:NSRectEdgeMinY];
    
    [picker release];
}

- (void)exportDeckCodeItemCopyButtonTriggered:(NSButton *)sender {
    [NSPasteboard.generalPasteboard clearContents];
    [NSPasteboard.generalPasteboard setString:self.deckCodeTextView.string forType:NSPasteboardTypeString];
}

- (void)editDeckNameItemTriggered:(NSMenuItem *)sender {
    NSTextField *deckNameTextField = [NSAlert presentTextFieldAlertWithMessageText:[ResourcesService localizationForKey:LocalizableKeyEditDeckNameTitle]
                                                                   informativeText:nil
                                                                     textFieldText:self.viewModel.localDeck.name
                                                                            target:self
                                                                            action:@selector(editDeckNameItemDoneButtonTriggered:)
                                                                            window:self.view.window
                                                                 completionHandler:^(NSModalResponse returnCode) {}];
    self.deckNameTextField = deckNameTextField;
}

- (void)editDeckNameItemDoneButtonTriggered:(NSButton *)sender {
    [self.viewModel updateDeckName:self.deckNameTextField.stringValue];
    [self.view.window endSheet:self.view.window.attachedSheet];
}

- (void)deleteItemTriggered:(NSMenuItem *)sender {
    [self.viewModel deleteLocalDeck];
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
    [self configureManaCostGraphView];
    [self configureHSCardDroppableView];
    [self configureViewModel];
    [self bind];
}

- (void)encodeRestorableStateWithCoder:(NSCoder *)coder backgroundQueue:(NSOperationQueue *)queue {
    [super encodeRestorableStateWithCoder:coder backgroundQueue:queue];
    
    [queue addOperationWithBlock:^{
        [coder encodeObject:self.viewModel.localDeck.objectID.URIRepresentation forKey:[NSString stringWithFormat:@"%@_URIRepresentation", NSStringFromClass(self.class)]];
    }];
}

- (void)restoreStateWithCoder:(NSCoder *)coder {
    [super restoreStateWithCoder:coder];
    
    NSURL * _Nullable URIRepresentation = [coder decodeObjectOfClass:[NSURL class] forKey:[NSString stringWithFormat:@"%@_URIRepresentation", NSStringFromClass(self.class)]];
    
    if (URIRepresentation != nil) {
        [self.viewModel requestDataSourceFromURIRepresentation:URIRepresentation completion:^(BOOL result) {}];
    }
}

- (void)setAttributes {
    [NSLayoutConstraint activateConstraints:@[
        [self.view.widthAnchor constraintGreaterThanOrEqualToConstant:300.0f]
    ]];
    
    self.view.postsFrameChangedNotifications = YES;
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
    
    DeckDetailsCollectionViewLayout *layout = [DeckDetailsCollectionViewLayout new];
    collectionView.collectionViewLayout = layout;
    [layout release];
    
    NSNib *cardsNib = [[NSNib alloc] initWithNibNamed:NSStringFromClass([DeckDetailsCardCollectionViewItem class]) bundle:NSBundle.mainBundle];
    [collectionView registerNib:cardsNib forItemWithIdentifier:NSUserInterfaceItemIdentifierDeckDetailsCardCollectionViewItem];
    [cardsNib release];
    
    NSNib *separatorNib = [[NSNib alloc] initWithNibNamed:NSStringFromClass([DeckDetailsSeparatorBox class]) bundle:NSBundle.mainBundle];
    [collectionView registerNib:separatorNib forSupplementaryViewOfKind:NSStringFromClass([DeckDetailsSeparatorBox class]) withIdentifier:NSUserInterfaceItemIdentifierDeckDetailsSeparatorBox];
    [separatorNib release];
    
    collectionView.selectable = YES;
    collectionView.allowsMultipleSelection = YES;
    collectionView.allowsEmptySelection = YES;
    collectionView.delegate = self;
    
    [collectionView registerForDraggedTypes:HSCardPromiseProvider.pasteboardTypes];
    [collectionView setDraggingSourceOperationMask:NSDragOperationCopy forLocal:NO];
    
    scrollView.automaticallyAdjustsContentInsets = NO;
    scrollView.documentView = collectionView;
    
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

- (void)configureManaCostGraphView {
    DeckDetailsManaCostGraphView *manaCostGraphView = [DeckDetailsManaCostGraphView new];
    
    [self.view addSubview:manaCostGraphView];
    manaCostGraphView.translatesAutoresizingMaskIntoConstraints = NO;
    
    [NSLayoutConstraint activateConstraints:@[
        [manaCostGraphView.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor],
        [manaCostGraphView.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor],
        [manaCostGraphView.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor],
    ]];
    
    self.manaCostGraphView = manaCostGraphView;
    [manaCostGraphView release];
}

- (void)configureHSCardDroppableView {
    HSCardDroppableView *hsCardDroppableView = [[HSCardDroppableView alloc] initWithDelegate:self asynchronous:YES];
    [self.view addSubview:hsCardDroppableView];
    
    hsCardDroppableView.translatesAutoresizingMaskIntoConstraints = NO;
    [NSLayoutConstraint activateConstraints:@[
        [hsCardDroppableView.topAnchor constraintEqualToAnchor:self.view.topAnchor],
        [hsCardDroppableView.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor],
        [hsCardDroppableView.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor],
        [hsCardDroppableView.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor]
    ]];
    
    self.hsCardDroppableView = hsCardDroppableView;
    [hsCardDroppableView release];
}

- (void)configureViewModel {
    DeckDetailsViewModel *viewModel = [[DeckDetailsViewModel alloc] initWithDataSource:[self makeDataSource]];
    self.viewModel = viewModel;
    [viewModel release];
}

- (DeckDetailsDataSource *)makeDataSource {
    DeckDetailsViewController * __block unretainedSelf = self;
    
    DeckDetailsDataSource *dataSource = [[DeckDetailsDataSource alloc] initWithCollectionView:self.collectionView
                                                                                 itemProvider:^NSCollectionViewItem * _Nullable(NSCollectionView * _Nonnull collectionView, NSIndexPath * _Nonnull indexPath, DeckDetailsItemModel * _Nonnull itemModel) {
        
        DeckDetailsCardCollectionViewItem *item = (DeckDetailsCardCollectionViewItem *)[collectionView makeItemWithIdentifier:NSUserInterfaceItemIdentifierDeckDetailsCardCollectionViewItem forIndexPath:indexPath];
        
        [item configureWithHSCard:itemModel.hsCard
                   raritySlugType:itemModel.raritySlugType
                      hsCardCount:itemModel.hsCardCount.unsignedIntegerValue
                         delegate:unretainedSelf];
        
        return item;
    }];
    
    dataSource.supplementaryViewProvider = ^NSView * _Nullable(NSCollectionView * _Nonnull collectionView, NSString * _Nonnull elementKind, NSIndexPath * _Nonnull indexPath) {
        if ([elementKind isEqualToString:NSStringFromClass([DeckDetailsSeparatorBox class])]) {
            DeckDetailsSeparatorBox *view = (DeckDetailsSeparatorBox *)[collectionView makeSupplementaryViewOfKind:elementKind withIdentifier:NSUserInterfaceItemIdentifierDeckDetailsSeparatorBox forIndexPath:indexPath];
            return view;
        } else {
            return nil;
        }
    };
    
    return [dataSource autorelease];
}

- (void)updateScrollViewContentInsets {
    self.scrollView.contentInsets = NSEdgeInsetsMake(self.view.window.topBarHeight,
                                                     0.0f,
                                                     self.manaCostGraphView.frame.size.height,
                                                     0.0f);
}

- (void)bind {
    [self addObserver:self forKeyPath:@"self.view.window" options:NSKeyValueObservingOptionInitial | NSKeyValueObservingOptionNew context:nil];
    
    [NSNotificationCenter.defaultCenter addObserver:self
                                           selector:@selector(shouldDismissReceived:)
                                               name:NSNotificationNameDeckDetailsViewModelShouldDismiss
                                             object:self.viewModel];
    
    [NSNotificationCenter.defaultCenter addObserver:self
                                           selector:@selector(didChangeLocalDeckReceived:)
                                               name:NSNotificationNameDeckDetailsViewModelDidChangeLocalDeck
                                             object:self.viewModel];
    
    [NSNotificationCenter.defaultCenter addObserver:self
                                           selector:@selector(errorOccurredReceived:)
                                               name:NSNotificationNameDeckDetailsViewModelErrorOccurred
                                             object:self.viewModel];
    
    [NSNotificationCenter.defaultCenter addObserver:self
                                           selector:@selector(applyingSnapshotToDataSourceWasDoneReceived:)
                                               name:NSNotificationNameDeckDetailsViewModelApplyingSnapshotToDataSourceWasDone
                                             object:self.viewModel];
    
    [NSNotificationCenter.defaultCenter addObserver:self
                                           selector:@selector(shouldChangeWindowSubtitleReceived:)
                                               name:NSNotificationNameDeckDetailsViewModelShouldChangeWindowSubtitle
                                             object:self.viewModel];
    
    [NSNotificationCenter.defaultCenter addObserver:self
                                           selector:@selector(viewDidChangeFrame:)
                                               name:NSViewFrameDidChangeNotification
                                             object:self.view];
}

- (void)shouldDismissReceived:(NSNotification *)notification {
    [NSOperationQueue.mainQueue addOperationWithBlock:^{
        [self.view.window close];
    }];
}

- (void)didChangeLocalDeckReceived:(NSNotification *)notification {
    NSString *name = notification.userInfo[DeckDetailsViewModelDidChangeLocalDeckNameItemKey];
    
    if (name != nil) {
        [NSOperationQueue.mainQueue addOperationWithBlock:^{
            self.view.window.title = name;
        }];
    }
}

- (void)errorOccurredReceived:(NSNotification *)notification {
    NSError * _Nullable error = notification.userInfo[DeckDetailsViewModelErrorOccurredItemKey];
    
    if (error != nil) {
        [NSOperationQueue.mainQueue addOperationWithBlock:^{
            [self.view.window presentErrorAlertWithError:error];
        }];
    }
}

- (void)applyingSnapshotToDataSourceWasDoneReceived:(NSNotification *)notification {
    NSArray<DeckDetailsManaCostGraphData *> *manaCostGraphDatas = notification.userInfo[DeckDetailsViewModelApplyingSnapshotToDataSourceWasDoneManaGraphDatasKey];
    
    [NSOperationQueue.mainQueue addOperationWithBlock:^{
        [self.manaCostGraphView configureWithDatas:manaCostGraphDatas];
    }];
}

- (void)shouldChangeWindowSubtitleReceived:(NSNotification *)notification {
    NSString * _Nullable text = notification.userInfo[DeckDetailsViewModelShouldChangeWindowSubtitleTextKey];
    
    [NSOperationQueue.mainQueue addOperationWithBlock:^{
        if (text != nil) {
            self.view.window.subtitle = text;
        } else {
            self.view.window.subtitle = @"";
        }
    }];
}

- (void)viewDidChangeFrame:(NSNotification *)notification {
    [NSOperationQueue.mainQueue addOperationWithBlock:^{
        [self updateScrollViewContentInsets];
    }];
}

- (NSArray<NSMenuItem *> *)menuItemsForSingleItem {
    NSMenuItem *showDetailItem = [[NSMenuItem alloc] initWithTitle:[ResourcesService localizationForKey:LocalizableKeyShowDetails]
                                                            action:@selector(showDetailItemTriggered:)
                                                     keyEquivalent:@""];
    showDetailItem.image = [NSImage imageWithSystemSymbolName:@"list.bullet" accessibilityDescription:nil];
    showDetailItem.target = self;
    
    NSMenuItem *increaseCardItem = [[NSMenuItem alloc] initWithTitle:[ResourcesService localizationForKey:LocalizableKeyIncreaseCardCount]
                                                              action:@selector(increaseCardItemTriggered:)
                                                       keyEquivalent:@""];
    increaseCardItem.image = [NSImage imageWithSystemSymbolName:@"plus" accessibilityDescription:nil];
    increaseCardItem.target = self;
    
    NSMenuItem *decreaseCardItem = [[NSMenuItem alloc] initWithTitle:[ResourcesService localizationForKey:LocalizableKeyDecreaseCardCount]
                                                              action:@selector(decreaseCardItemTriggered:)
                                                       keyEquivalent:@""];
    decreaseCardItem.image = [NSImage imageWithSystemSymbolName:@"minus" accessibilityDescription:nil];
    decreaseCardItem.target = self;
    
    NSMenuItem *deleteCardItem = [[NSMenuItem alloc] initWithTitle:[ResourcesService localizationForKey:LocalizableKeyDelete]
                                                            action:@selector(deleteCardItemTriggered:)
                                                     keyEquivalent:@""];
    deleteCardItem.image = [NSImage imageWithSystemSymbolName:@"trash" accessibilityDescription:nil];
    deleteCardItem.target = self;
    
    NSArray<NSMenuItem *> *result = @[showDetailItem, [NSMenuItem separatorItem], increaseCardItem, decreaseCardItem, deleteCardItem];
    
    [showDetailItem release];
    [increaseCardItem release];
    [decreaseCardItem release];
    [deleteCardItem release];
    
    return result;
}

- (NSArray<NSMenuItem *> *)menuItemsForMultipleItems {
    NSMenuItem *showDetailItem = [[NSMenuItem alloc] initWithTitle:[ResourcesService localizationForKey:LocalizableKeyShowDetails]
                                                            action:@selector(showDetailItemTriggered:)
                                                     keyEquivalent:@""];
    showDetailItem.image = [NSImage imageWithSystemSymbolName:@"list.bullet" accessibilityDescription:nil];
    showDetailItem.target = self;
    
    NSMenuItem *deleteItem = [[NSMenuItem alloc] initWithTitle:[ResourcesService localizationForKey:LocalizableKeyDelete]
                                                        action:@selector(deleteCardItemTriggered:)
                                                 keyEquivalent:@""];
    deleteItem.image = [NSImage imageWithSystemSymbolName:@"trash" accessibilityDescription:nil];
    
    NSArray<NSMenuItem *> *result = @[showDetailItem, [NSMenuItem separatorItem], deleteItem];
    
    [showDetailItem release];
    [deleteItem release];
    
    return result;
}

- (void)showDetailItemTriggered:(NSMenuItem *)sender {
    NSSet<NSIndexPath *> *interactingIndexPaths = self.collectionView.interactingIndexPaths;
    
    [self.viewModel hsCardsFromIndexPaths:interactingIndexPaths completion:^(NSSet<HSCard *> * _Nonnull hsCards) {
        [hsCards enumerateObjectsUsingBlock:^(HSCard * _Nonnull obj, BOOL * _Nonnull stop) {
            [NSOperationQueue.mainQueue addOperationWithBlock:^{
                [WindowsService.sharedInstance presentCardDetailsWindowWithHSCard:obj];
            }];
        }];
    }];
}

- (void)increaseCardItemTriggered:(NSMenuItem *)sender {
    [self.collectionView.interactingIndexPaths enumerateObjectsUsingBlock:^(NSIndexPath * _Nonnull obj, BOOL * _Nonnull stop) {
        [self.viewModel increaseAtIndexPath:obj];
    }];
}

- (void)decreaseCardItemTriggered:(NSMenuItem *)sender {
    [self.collectionView.interactingIndexPaths enumerateObjectsUsingBlock:^(NSIndexPath * _Nonnull obj, BOOL * _Nonnull stop) {
        [self.viewModel decreaseAtIndexPath:obj];
    }];
}

- (void)deleteCardItemTriggered:(NSMenuItem *)sender {
    [self.viewModel deleteAtIndexPathes:self.collectionView.interactingIndexPaths];
}

#pragma mark - NSCollectionViewDelegate

- (void)collectionView:(NSCollectionView *)collectionView didSelectItemsAtIndexPaths:(NSSet<NSIndexPath *> *)indexPaths {
    
}

- (BOOL)collectionView:(NSCollectionView *)collectionView canDragItemsAtIndexPaths:(NSSet<NSIndexPath *> *)indexPaths withEvent:(NSEvent *)event {
    BOOL __block result = YES;
    
    [indexPaths enumerateObjectsUsingBlock:^(NSIndexPath * _Nonnull obj, BOOL * _Nonnull stop) {
        DeckDetailsItemModel * _Nullable itemModel = [self.viewModel.dataSource itemIdentifierForIndexPath:obj];
        
        if (itemModel == nil) {
            result = NO;
            *stop = YES;
            return;
        }
    }];
    
    return result;
}

- (id<NSPasteboardWriting>)collectionView:(NSCollectionView *)collectionView pasteboardWriterForItemAtIndexPath:(NSIndexPath *)indexPath {
    DeckDetailsItemModel * _Nullable itemModel = (DeckDetailsItemModel *)[self.viewModel.dataSource itemIdentifierForIndexPath:indexPath];
    
    if (itemModel == nil) return nil;
    
    HSCardPromiseProvider *provider = [[HSCardPromiseProvider alloc] initWithHSCard:itemModel.hsCard image:nil];
    
    return [provider autorelease];
}

#pragma mark - NSMenuDelegate

- (void)menuWillOpen:(NSMenu *)menu {
    if ([menu isEqual:self.collectionViewMenu]) {
        NSSet<NSIndexPath *> *selectionIndexPaths = self.collectionView.interactingIndexPaths;
        
        if (selectionIndexPaths.count == 1) {
            menu.itemArray = self.menuItemsForSingleItem;
        } else if (selectionIndexPaths.count > 1) {
            menu.itemArray = self.menuItemsForMultipleItems;
        } else {
            menu.itemArray = @[];
        }
    }
}

#pragma mark - DeckDetailsCardCollectionViewItemDelegate

- (void)deckDetailsCardCollectionViewItem:(DeckDetailsCardCollectionViewItem *)deckDetailsCardCollectionViewItem didDoubleClickWithRecognizer:(NSClickGestureRecognizer *)recognizer {
    [self.viewModel hsCardsFromIndexPaths:self.collectionView.selectionIndexPaths completion:^(NSSet<HSCard *> * _Nonnull hsCards) {
        [hsCards enumerateObjectsUsingBlock:^(HSCard * _Nonnull obj, BOOL * _Nonnull stop) {
            [NSOperationQueue.mainQueue addOperationWithBlock:^{
                [WindowsService.sharedInstance presentCardDetailsWindowWithHSCard:obj];
            }];
        }];
    }];
}

#pragma mark - HSCardDroppableViewDelegate

- (void)hsCardDroppableView:(HSCardDroppableView *)view didAcceptDropWithHSCards:(NSArray<HSCard *> *)hsCards {
    [self.viewModel addHSCards:hsCards];
}

@end
