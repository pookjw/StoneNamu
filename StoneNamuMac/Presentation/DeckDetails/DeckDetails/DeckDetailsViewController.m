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
#import <StoneNamuCore/StoneNamuCore.h>
#import <StoneNamuResources/StoneNamuResources.h>

static NSUserInterfaceItemIdentifier const NSUserInterfaceItemIdentifierDeckDetailsCardCollectionViewItem = @"NSUserInterfaceItemIdentifierDeckDetailsCardCollectionViewItem";

@interface DeckDetailsViewController () <NSCollectionViewDelegate, NSMenuDelegate>
@property (retain) NSScrollView *scrollView;
@property (retain) ClickableCollectionView *collectionView;
@property (retain) NSMenu *collectionViewMenu;
@property (retain) DeckDetailsManaCostGraphView *manaCostGraphView;
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
    [_viewModel release];
    [super dealloc];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if (([object isEqual:self]) && ([keyPath isEqualToString:@"self.view.window"])) {
        if (self.view.window != nil) {
            [NSOperationQueue.mainQueue addOperationWithBlock:^{
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
                              hsCardCount:itemModel.hsCardCount.unsignedIntegerValue];
                
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
    NSLog(@"%@", indexPaths);
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
            
            NSMenuItem *decreaseItem = [[NSMenuItem alloc] initWithTitle:[ResourcesService localizationForKey:LocalizableKeyDecreaseCardCount]
                                                                  action:@selector(decreaseCardCount:)
                                                           keyEquivalent:@""];
            
            NSMenuItem *deleteItem = [[NSMenuItem alloc] initWithTitle:[ResourcesService localizationForKey:LocalizableKeyDelete]
                                                                action:@selector(deleteCards:)
                                                         keyEquivalent:@""];
            
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
            
            [itemArray addObject:deleteItem];
            
            [deleteItem release];
            break;
        }
    }
    
    menu.itemArray = itemArray;
    [itemArray release];
}

@end
