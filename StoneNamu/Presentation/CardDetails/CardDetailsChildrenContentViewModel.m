//
//  CardDetailsChildrenContentViewModel.m
//  CardDetailsChildrenContentViewModel
//
//  Created by Jinwoo Kim on 8/9/21.
//

#import "CardDetailsChildrenContentViewModel.h"

@interface CardDetailsChildrenContentViewModel ()
@property (retain) NSOperationQueue *queue;
@end

@implementation CardDetailsChildrenContentViewModel

- (instancetype)initWithDataSource:(CardDetailsChildrenContentDataSource *)dataSource {
    self = [self init];
    
    if (self) {
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
        NSDiffableDataSourceSnapshot *snapshot = self.dataSource.snapshot;
        
        [snapshot deleteAllItems];
        
        CardDetailsChildrenContentSectionModel *sectionModel = [CardDetailsChildrenContentSectionModel new];
        
        [snapshot appendSectionsWithIdentifiers:@[sectionModel]];
        
        NSMutableArray<CardDetailsChildrenContentItemModel *> *tmp = [@[] mutableCopy];
        
        for (HSCard *childCard in childCards) {
            CardDetailsChildrenContentItemModel *itemModel = [[CardDetailsChildrenContentItemModel alloc] initWithHSCard:childCard];
            [tmp addObject:itemModel];
            [itemModel release];
        }
        
        NSArray *itemModels = [tmp copy];
        [tmp release];
        
        [snapshot appendItemsWithIdentifiers:itemModels intoSectionWithIdentifier:sectionModel];
        
        [sectionModel release];
        [itemModels release];
        
        [self.dataSource applySnapshot:snapshot animatingDifferences:YES];
    }];
}

- (CardDetailsChildrenContentItemModel * _Nullable)itemModelOfIndexPath:(NSIndexPath *)indexPath {
    return [self.dataSource itemIdentifierForIndexPath:indexPath];
}

@end
