//
//  DeckDetailsViewController.m
//  StoneNamuMac
//
//  Created by Jinwoo Kim on 11/28/21.
//

#import "DeckDetailsViewController.h"
#import "HSCardPromiseProvider.h"
#import "DeckDetailsCardCollectionViewItem.h"
#import "DeckDetailsManaCostGraphCollectionViewItem.h"
#import "DeckDetailsViewModel.h"
#import "NSViewController+loadViewIfNeeded.h"
#import "DeckDetailsCollectionViewLayout.h"
#import <StoneNamuCore/StoneNamuCore.h>
#import <StoneNamuResources/StoneNamuResources.h>

static NSUserInterfaceItemIdentifier const NSUserInterfaceItemIdentifierDeckDetailsCardCollectionViewItem = @"NSUserInterfaceItemIdentifierDeckDetailsCardCollectionViewItem";
static NSUserInterfaceItemIdentifier const NSUserInterfaceItemIdentifierDeckDetailsManaCostGraphCollectionViewItem = @"NSUserInterfaceItemIdentifierDeckDetailsManaCostGraphCollectionViewItem";

@interface DeckDetailsViewController () <NSCollectionViewDelegate>
@property (retain) NSScrollView *scrollView;
@property (retain) NSCollectionView *collectionView;
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
    [_scrollView release];
    [_collectionView release];
    [_viewModel release];
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
    [self configureViewModel];
    [self bind];
}

- (void)setAttributes {
    NSLayoutConstraint *widthLayout = [self.view.widthAnchor constraintEqualToConstant:300];
    [NSLayoutConstraint activateConstraints:@[
        widthLayout
    ]];
}

- (void)configureCollectionView {
    NSScrollView *scrollView = [NSScrollView new];
    NSCollectionView *collectionView = [NSCollectionView new];
    
    self.scrollView = scrollView;
    self.collectionView = collectionView;
    
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
    
    NSNib *manaCostGraphNib = [[NSNib alloc] initWithNibNamed:NSStringFromClass([DeckDetailsManaCostGraphCollectionViewItem class]) bundle:NSBundle.mainBundle];
    [collectionView registerNib:manaCostGraphNib forItemWithIdentifier:NSUserInterfaceItemIdentifierDeckDetailsManaCostGraphCollectionViewItem];
    [manaCostGraphNib release];

    collectionView.selectable = YES;
    collectionView.allowsMultipleSelection = YES;
    collectionView.allowsEmptySelection = YES;
    collectionView.delegate = self;
    
    [collectionView registerForDraggedTypes:HSCardPromiseProvider.pasteboardTypes];
    [collectionView setDraggingSourceOperationMask:NSDragOperationCopy forLocal:NO];
    
    [scrollView release];
    [collectionView release];
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
            case DeckDetailsItemModelTypeManaCostGraph: {
                DeckDetailsManaCostGraphCollectionViewItem *item = (DeckDetailsManaCostGraphCollectionViewItem *)[collectionView makeItemWithIdentifier:NSUserInterfaceItemIdentifierDeckDetailsManaCostGraphCollectionViewItem forIndexPath:indexPath];
                
                [item configureWithManaCost:itemModel.graphManaCost.unsignedIntegerValue
                                 percentage:itemModel.graphPercentage.floatValue
                                  cardCount:itemModel.graphCount.unsignedIntegerValue];
                
                return item;
            }
            default:
                return nil;
        }
    }];
    
    return [dataSource autorelease];
}

- (void)bind {
    [NSNotificationCenter.defaultCenter addObserver:self
                                           selector:@selector(applyingSnapshotToDataSourceWasDoneReceived:)
                                               name:NSNotificationNameDeckDetailsViewModelApplyingSnapshotToDataSourceWasDone
                                             object:self.viewModel];
}

- (void)applyingSnapshotToDataSourceWasDoneReceived:(NSNotification *)notification {
    [NSOperationQueue.mainQueue addOperationWithBlock:^{
//        [self.collectionView.collectionViewLayout invalidateLayout];
    }];
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

@end
