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
#import "AppDelegate.h"
#import "NSViewController+SpinnerView.h"
#import <StoneNamuCore/StoneNamuCore.h>
#import <StoneNamuResources/StoneNamuResources.h>

static NSUserInterfaceItemIdentifier const NSUserInterfaceItemIdentifierDeckDetailsCardCollectionViewItem = @"NSUserInterfaceItemIdentifierDeckDetailsCardCollectionViewItem";

@interface DeckDetailsViewController () <NSCollectionViewDelegate, NSMenuDelegate, DeckDetailsCardCollectionViewItemDelegate>
@property (retain) NSScrollView *scrollView;
@property (retain) ClickableCollectionView *collectionView;
@property (retain) NSMenu *collectionViewMenu;
@property (retain) DeckDetailsManaCostGraphView *manaCostGraphView;
@property (retain) NSMenu *moreMenu;
@property (retain) NSButton *moreMenuButton;
@property (assign) NSTextField *deckNameTextField;
@property (assign) NSTextView *deckCodeTextView;
@property (retain) DeckDetailsViewModel *viewModel;
@end

@implementation DeckDetailsViewController

- (instancetype)initWithLocalDeck:(LocalDeck *)localDeck {
    self = [self init];
    
    if (self) {
        [self loadViewIfNeeded];
        [self.viewModel requestDataSourceWithLocalDeck:localDeck];
    }
    
    return self;
}

- (void)dealloc {
    [self removeObserver:self forKeyPath:@"self.view.window"];
    [_scrollView release];
    [_collectionView release];
    [_collectionViewMenu release];
    [_manaCostGraphView release];
    [_moreMenu release];
    [_moreMenuButton release];
    [_viewModel release];
    [super dealloc];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if (([object isEqual:self]) && ([keyPath isEqualToString:@"self.view.window"])) {
        if (self.view.window != nil) {
            [NSOperationQueue.mainQueue addOperationWithBlock:^{
                self.view.window.title = self.viewModel.localDeck.name;
                [self updateScrollViewContentInsets];
            }];
        }
    } else {
        return [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
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
    [self configureMoreMenu];
    [self configureMoreMenuButton];
    [self configureViewModel];
    [self bind];
}

- (void)viewDidLayout {
    [super viewDidLayout];
    [self updateScrollViewContentInsets];
}

- (void)setAttributes {
    NSLayoutConstraint *widthLayout = [self.view.widthAnchor constraintEqualToConstant:400.0f];
    [NSLayoutConstraint activateConstraints:@[
        widthLayout
    ]];
}

- (void)configureCollectionView {
    NSScrollView *scrollView = [NSScrollView new];
    ClickableCollectionView *collectionView = [ClickableCollectionView new];
    
    self.scrollView = scrollView;
    self.collectionView = collectionView;
    
    scrollView.automaticallyAdjustsContentInsets = NO;
    scrollView.documentView = collectionView;
    
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
    
    collectionView.selectable = YES;
    collectionView.allowsMultipleSelection = YES;
    collectionView.allowsEmptySelection = YES;
    collectionView.delegate = self;
    
    [collectionView registerForDraggedTypes:HSCardPromiseProvider.pasteboardTypes];
    [collectionView setDraggingSourceOperationMask:NSDragOperationCopy forLocal:NO];
    
    [scrollView release];
    [collectionView release];
}

- (void)configureCollectionViewMenu {
    NSMenu *menu = [NSMenu new];
    self.collectionView.menu = menu;
    
    menu.delegate = self;
    
    [menu release];
}

- (void)configureManaCostGraphView {
    DeckDetailsManaCostGraphView *manaCostGraphView = [DeckDetailsManaCostGraphView new];
    self.manaCostGraphView = manaCostGraphView;
    
    [self.view addSubview:manaCostGraphView];
    manaCostGraphView.translatesAutoresizingMaskIntoConstraints = NO;
    
    [NSLayoutConstraint activateConstraints:@[
        [manaCostGraphView.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor],
        [manaCostGraphView.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor],
        [manaCostGraphView.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor],
    ]];
    
    [manaCostGraphView release];
}

- (void)configureMoreMenu {
    NSMenu *moreMenu = [NSMenu new];
    self.moreMenu = moreMenu;
    
    NSMenuItem *editDeckNameItem = [[NSMenuItem alloc] initWithTitle:[ResourcesService localizationForKey:LocalizableKeyEditDeckName]
                                                              action:@selector(editDeckNameItemTriggered:)
                                                       keyEquivalent:@""];
    editDeckNameItem.image = [NSImage imageWithSystemSymbolName:@"pencil" accessibilityDescription:nil];
    
    NSMenuItem *saveAsImageItem = [[NSMenuItem alloc] initWithTitle:[ResourcesService localizationForKey:LocalizableKeySaveAsImage]
                                                             action:@selector(saveAsImageItemTriggered:)
                                                      keyEquivalent:@""];
    saveAsImageItem.image = [NSImage imageWithSystemSymbolName:@"photo" accessibilityDescription:nil];
    
    NSMenuItem *exportDeckCodeItem = [[NSMenuItem alloc] initWithTitle:[ResourcesService localizationForKey:LocalizableKeyExportDeckCode]
                                                                action:@selector(exportDeckCodeItemTriggered:)
                                                         keyEquivalent:@""];
    exportDeckCodeItem.image = [NSImage imageWithSystemSymbolName:@"square.and.arrow.up" accessibilityDescription:nil];
    
    moreMenu.itemArray = @[editDeckNameItem, saveAsImageItem, exportDeckCodeItem];
    
    [editDeckNameItem release];
    [saveAsImageItem release];
    [exportDeckCodeItem release];
    
    [moreMenu release];
}

- (void)editDeckNameItemTriggered:(NSMenuItem *)sender {
    NSAlert *alert = [NSAlert new];
    NSButton *doneButton = [alert addButtonWithTitle:[ResourcesService localizationForKey:LocalizableKeyDone]];
    NSButton *cancelButton = [alert addButtonWithTitle:[ResourcesService localizationForKey:LocalizableKeyCancel]];
    NSTextField *deckNameTextField = [[NSTextField alloc] initWithFrame:NSMakeRect(0.0f, 0.0f, 300.0f, 20.0f)];
    
    self.deckNameTextField = deckNameTextField;
    
    //
    
    doneButton.target = self;
    doneButton.action = @selector(editDeckNameItemDoneButtonTriggered:);
    
    //
    
    NSString * _Nullable text = self.viewModel.localDeck.name;
    
    if (text == nil) {
        deckNameTextField.stringValue = @"";
    } else {
        deckNameTextField.stringValue = text;
    }
    
    //
    
    alert.messageText = [ResourcesService localizationForKey:LocalizableKeyEditDeckNameTitle];
    alert.showsSuppressionButton = NO;
    alert.accessoryView = deckNameTextField;
    
    //
    
    [alert beginSheetModalForWindow:self.view.window completionHandler:^(NSModalResponse returnCode) {
        
    }];
    
    [alert release];
    [deckNameTextField release];
}

- (void)editDeckNameItemDoneButtonTriggered:(NSButton *)sender {
    [self.viewModel updateDeckName:self.deckNameTextField.stringValue];
    [self.view.window endSheet:self.view.window.attachedSheet];
}

- (void)saveAsImageItemTriggered:(NSMenuItem *)sender {
    NSAlert *alert = [NSAlert new];
    
    alert.messageText = @"TODO";
    
    [alert beginSheetModalForWindow:self.view.window completionHandler:^(NSModalResponse returnCode) {
        
    }];
    
    [alert release];
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
            NSButton *cancelButton = [alert addButtonWithTitle:[ResourcesService localizationForKey:LocalizableKeyCancel]];
            NSScrollView *scrollView = [[NSScrollView alloc] initWithFrame:NSMakeRect(0.0f, 0.0f, 300.0f, 200.0f)];
            NSTextView *deckCodeTextView = [[NSTextView alloc] initWithFrame:scrollView.bounds];
            
            self.deckCodeTextView = deckCodeTextView;
            
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

- (void)configureMoreMenuButton {
    NSButton *moreMenuButton = [NSButton new];
    self.moreMenuButton = moreMenuButton;
    
    moreMenuButton.image = [NSImage imageWithSystemSymbolName:@"ellipsis" accessibilityDescription:nil];
    moreMenuButton.bezelStyle = NSBezelStyleCircular;
    moreMenuButton.target = self;
    moreMenuButton.action = @selector(moreMenuButtonTriggered:);
    moreMenuButton.translatesAutoresizingMaskIntoConstraints = NO;
    
    [self.view addSubview:moreMenuButton];
    [NSLayoutConstraint activateConstraints:@[
        [moreMenuButton.trailingAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.trailingAnchor],
        [moreMenuButton.bottomAnchor constraintEqualToAnchor:self.manaCostGraphView.topAnchor]
    ]];
    
    [moreMenuButton release];
}

- (void)moreMenuButtonTriggered:(NSButton *)sender {
    NSEvent * _Nullable currentEvent = NSApp.currentEvent;
    
    if (currentEvent != nil) {
        [NSMenu popUpContextMenu:self.moreMenu withEvent:currentEvent forView:sender];
    }
}

- (void)configureViewModel {
    DeckDetailsViewModel *viewModel = [[DeckDetailsViewModel alloc] initWithDataSource:[self makeDataSource]];
    self.viewModel = viewModel;
    [viewModel release];
}

- (DeckDetailsDataSource *)makeDataSource {
    DeckDetailsDataSource *dataSource = [[DeckDetailsDataSource alloc] initWithCollectionView:self.collectionView
                                                                                 itemProvider:^NSCollectionViewItem * _Nullable(NSCollectionView * _Nonnull collectionView, NSIndexPath * _Nonnull indexPath, DeckDetailsItemModel * _Nonnull itemModel) {
        
        switch (itemModel.type) {
            case DeckDetailsItemModelTypeCard: {
                DeckDetailsCardCollectionViewItem *item = (DeckDetailsCardCollectionViewItem *)[collectionView makeItemWithIdentifier:NSUserInterfaceItemIdentifierDeckDetailsCardCollectionViewItem forIndexPath:indexPath];
                
                [item configureWithHSCard:itemModel.hsCard
                              hsCardCount:itemModel.hsCardCount.unsignedIntegerValue
                                 delegate:self];
                
                return item;
            }
            default:
                return nil;
        }
    }];
    
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
                                           selector:@selector(applyingSnapshotToDataSourceWasDoneReceived:)
                                               name:NSNotificationNameDeckDetailsViewModelApplyingSnapshotToDataSourceWasDone
                                             object:self.viewModel];
}

- (void)applyingSnapshotToDataSourceWasDoneReceived:(NSNotification *)notification {
    NSArray<DeckDetailsManaCostGraphData *> *manaCostGraphDatas = notification.userInfo[DeckDetailsViewModelApplyingSnapshotToDataSourceWasDoneManaGraphDatasKey];
    
    [NSOperationQueue.mainQueue addOperationWithBlock:^{
        self.view.window.title = self.viewModel.localDeck.name;
        [self.manaCostGraphView configureWithDatas:manaCostGraphDatas];
    }];
}

- (void)increaseCardCount:(NSMenuItem *)sender {
    [self.collectionView.selectionIndexPaths enumerateObjectsUsingBlock:^(NSIndexPath * _Nonnull obj, BOOL * _Nonnull stop) {
        [self.viewModel increaseAtIndexPath:obj];
    }];
}

- (void)decreaseCardCount:(NSMenuItem *)sender {
    [self.collectionView.selectionIndexPaths enumerateObjectsUsingBlock:^(NSIndexPath * _Nonnull obj, BOOL * _Nonnull stop) {
        [self.viewModel decreaseAtIndexPath:obj];
    }];
}

- (void)deleteCards:(NSMenuItem *)sender {
    [self.viewModel deleteAtIndexPathes:self.collectionView.selectionIndexPaths];
}

#pragma mark - NSCollectionViewDelegate

- (void)collectionView:(NSCollectionView *)collectionView didSelectItemsAtIndexPaths:(NSSet<NSIndexPath *> *)indexPaths {

}

- (NSDragOperation)collectionView:(NSCollectionView *)collectionView validateDrop:(id<NSDraggingInfo>)draggingInfo proposedIndexPath:(NSIndexPath * _Nonnull *)proposedDropIndexPath dropOperation:(NSCollectionViewDropOperation *)proposedDropOperation {
    return NSDragOperationCopy;
}

- (BOOL)collectionView:(NSCollectionView *)collectionView acceptDrop:(id<NSDraggingInfo>)draggingInfo indexPath:(NSIndexPath *)indexPath dropOperation:(NSCollectionViewDropOperation)dropOperation {
    
    NSPasteboard *pasteboard = draggingInfo.draggingPasteboard;
    NSArray<NSPasteboardItem *> *items = pasteboard.pasteboardItems;
    NSMutableArray<NSData *> *datas = [@[] mutableCopy];
    
    [items enumerateObjectsUsingBlock:^(NSPasteboardItem * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSData *data = [obj dataForType:NSPasteboardTypeHSCard];
        [datas addObject:data];
    }];
    
    [self.viewModel addHSCardsWithDatas:datas];
    [datas release];
    
    return YES;
}

#pragma mark - NSMenuDelegate

- (void)menuWillOpen:(NSMenu *)menu {
    NSMutableArray<NSMenuItem *> *itemArray = [@[] mutableCopy];
    
    NSUInteger count = self.collectionView.selectionIndexPaths.count;
    
    switch (count) {
        case 0: {
            break;
        }
        case 1: {
            NSMenuItem *increaseItem = [[NSMenuItem alloc] initWithTitle:[ResourcesService localizationForKey:LocalizableKeyIncreaseCardCount]
                                                                  action:@selector(increaseCardCount:)
                                                           keyEquivalent:@""];
            increaseItem.image = [NSImage imageWithSystemSymbolName:@"plus" accessibilityDescription:nil];
            
            NSMenuItem *decreaseItem = [[NSMenuItem alloc] initWithTitle:[ResourcesService localizationForKey:LocalizableKeyDecreaseCardCount]
                                                                  action:@selector(decreaseCardCount:)
                                                           keyEquivalent:@""];
            decreaseItem.image = [NSImage imageWithSystemSymbolName:@"minus" accessibilityDescription:nil];
            
            NSMenuItem *deleteItem = [[NSMenuItem alloc] initWithTitle:[ResourcesService localizationForKey:LocalizableKeyDelete]
                                                                action:@selector(deleteCards:)
                                                         keyEquivalent:@""];
            deleteItem.image = [NSImage imageWithSystemSymbolName:@"trash" accessibilityDescription:nil];
            
            [itemArray addObjectsFromArray:@[increaseItem, decreaseItem, deleteItem]];
            
            [increaseItem release];
            [decreaseItem release];
            [deleteItem release];
            
            break;
        }
        default: {
            NSMenuItem *deleteItem = [[NSMenuItem alloc] initWithTitle:[ResourcesService localizationForKey:LocalizableKeyDelete]
                                                                action:@selector(deleteCards:)
                                                         keyEquivalent:@""];
            deleteItem.image = [NSImage imageWithSystemSymbolName:@"trash" accessibilityDescription:nil];
            
            [itemArray addObject:deleteItem];
            
            [deleteItem release];
            break;
        }
    }
    
    menu.itemArray = itemArray;
    [itemArray release];
}

#pragma mark - DeckDetailsCardCollectionViewItemDelegate

- (void)deckDetailsCardCollectionViewItem:(DeckDetailsCardCollectionViewItem *)deckDetailsCardCollectionViewItem didDoubleClickWithRecognizer:(NSClickGestureRecognizer *)recognizer {
    [self.collectionView.selectionIndexPaths enumerateObjectsUsingBlock:^(NSIndexPath * _Nonnull obj, BOOL * _Nonnull stop) {
        HSCard * _Nullable hsCard = [self.viewModel.dataSource itemIdentifierForIndexPath:obj].hsCard;
        
        if (hsCard != nil) {
            [(AppDelegate *)NSApp.delegate presentCardDetailsWindowWithHSCard:hsCard];
        }
    }];
}

@end
