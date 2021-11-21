//
//  CardDetailsChildrenContentCollectionViewItemModel.m
//  StoneNamuMac
//
//  Created by Jinwoo Kim on 11/22/21.
//

#import "CardDetailsChildrenContentCollectionViewItemModel.h"
#import "NSCollectionViewDiffableDataSource+applySnapshotAndWait.h"
#import "NSDiffableDataSourceSnapshot+sort.h"

@interface CardDetailsChildrenContentCollectionViewItemModel ()
@property (retain) NSOperationQueue *queue;
@end

@implementation CardDetailsChildrenContentCollectionViewItemModel

- (instancetype)initWithDataSource:(CardDetailsChildrenContentCollectionViewItemDataSource *)dataSource {
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
    [_dataSource release];
    [_queue release];
    [super dealloc];
}

- (void)requestChildCards:(NSArray<HSCard *> *)childCards {
    [self.queue addBarrierBlock:^{
        NSDiffableDataSourceSnapshot *snapshot = [self.dataSource.snapshot copy];
        
        [snapshot deleteAllItems];
        
        CardDetailsChildrenContentCollectionViewItemSectionModel *sectionModel = [CardDetailsChildrenContentCollectionViewItemSectionModel new];
        
        [snapshot appendSectionsWithIdentifiers:@[sectionModel]];
        
        NSMutableArray<CardDetailsChildrenContentCollectionViewItemItemModel *> *itemModels = [@[] mutableCopy];
        
        for (HSCard *childCard in childCards) {
            CardDetailsChildrenContentCollectionViewItemItemModel *itemModel = [[CardDetailsChildrenContentCollectionViewItemItemModel alloc] initWithHSCard:childCard];
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
    [snapshot sortItemsWithSectionIdentifiers:snapshot.sectionIdentifiers usingComparator:^NSComparisonResult(CardDetailsChildrenContentCollectionViewItemItemModel * _Nonnull obj1, CardDetailsChildrenContentCollectionViewItemItemModel * _Nonnull obj2) {
        return [obj1.hsCard compare:obj2.hsCard];
    }];
}

@end
