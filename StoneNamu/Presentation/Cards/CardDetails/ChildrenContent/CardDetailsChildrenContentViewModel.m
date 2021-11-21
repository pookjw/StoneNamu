//
//  CardDetailsChildrenContentViewModel.m
//  CardDetailsChildrenContentViewModel
//
//  Created by Jinwoo Kim on 8/9/21.
//

#import "CardDetailsChildrenContentViewModel.h"
#import "UICollectionViewDiffableDataSource+applySnapshotAndWait.h"
#import "DragItemService.h"
#import "NSDiffableDataSourceSnapshot+sort.h"

@interface CardDetailsChildrenContentViewModel ()
@property (retain) NSOperationQueue *queue;
@end

@implementation CardDetailsChildrenContentViewModel

- (instancetype)initWithDataSource:(CardDetailsChildrenContentDataSource *)dataSource {
    self = [self init];
    
    if (self) {
        [self->_dataSource release];
        self->_dataSource = [dataSource retain];
        
        NSOperationQueue *queue = [NSOperationQueue new];
        queue.qualityOfService = NSQualityOfServiceUserInitiated;
        self.queue = queue;
        [queue release];
    }
    
    return self;
}

- (void)dealloc {
    [_contextMenuIndexPath release];
    [_dataSource release];
    [_queue release];
    [super dealloc];
}

- (NSArray<UIDragItem *> *)makeDragItemFromIndexPath:(NSIndexPath *)indexPath image:(UIImage *)image {
    CardDetailsChildrenContentItemModel * _Nullable itemModel = [self.dataSource itemIdentifierForIndexPath:indexPath];
    
    if (itemModel == nil) return @[];
    
    UIDragItem *dragItem = [DragItemService.sharedInstance makeDragItemsFromHSCard:itemModel.hsCard image:image];
    
    return @[dragItem];
}

- (void)requestChildCards:(NSArray<HSCard *> *)childCards {
    [self.queue addBarrierBlock:^{
        NSDiffableDataSourceSnapshot *snapshot = [self.dataSource.snapshot copy];
        
        [snapshot deleteAllItems];
        
        CardDetailsChildrenContentSectionModel *sectionModel = [CardDetailsChildrenContentSectionModel new];
        
        [snapshot appendSectionsWithIdentifiers:@[sectionModel]];
        
        NSMutableArray<CardDetailsChildrenContentItemModel *> *itemModels = [@[] mutableCopy];
        
        for (HSCard *childCard in childCards) {
            CardDetailsChildrenContentItemModel *itemModel = [[CardDetailsChildrenContentItemModel alloc] initWithHSCard:childCard];
            [itemModels addObject:itemModel];
            [itemModel release];
        }
        
        [snapshot appendItemsWithIdentifiers:itemModels intoSectionWithIdentifier:sectionModel];
        
        [sectionModel release];
        [itemModels release];
        
        [self sortSnapshot:snapshot];
        
        [self.dataSource applySnapshotAndWait:snapshot animatingDifferences:YES completion:^{
            [snapshot release];
        }];
    }];
}

- (void)sortSnapshot:(NSDiffableDataSourceSnapshot *)snapshot {
    [snapshot sortItemsWithSectionIdentifiers:snapshot.sectionIdentifiers usingComparator:^NSComparisonResult(CardDetailsChildrenContentItemModel * _Nonnull obj1, CardDetailsChildrenContentItemModel * _Nonnull obj2) {
        return [obj1.hsCard compare:obj2.hsCard];
    }];
}

@end
