//
//  CardDetailsChildrenContentViewModel.m
//  CardDetailsChildrenContentViewModel
//
//  Created by Jinwoo Kim on 8/9/21.
//

#import "CardDetailsChildrenContentViewModel.h"
#import "NSSemaphoreCondition.h"

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
    [_contextMenuIndexPath release];
    [_dataSource release];
    [_queue release];
    [super dealloc];
}

- (NSArray<UIDragItem *> *)makeDragItemFromIndexPath:(NSIndexPath *)indexPath image:(UIImage *)image {
    CardDetailsChildrenContentItemModel * _Nullable itemModel = [self.dataSource itemIdentifierForIndexPath:indexPath];
    
    if (itemModel == nil) return @[];
    
    NSItemProvider *itemProvider;
    
    if (image) {
        itemProvider = [[NSItemProvider alloc] initWithObject:image];
    } else {
        itemProvider = [NSItemProvider new];
    }
    
    UIDragItem *dragItem = [[UIDragItem alloc] initWithItemProvider:itemProvider];
    [itemProvider release];
    
    dragItem.localObject = itemModel.hsCard;
    
    return @[[dragItem autorelease]];
}

- (void)requestChildCards:(NSArray<HSCard *> *)childCards {
    [self.queue addBarrierBlock:^{
        NSDiffableDataSourceSnapshot *snapshot = [self.dataSource.snapshot copy];
        
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
        
        NSSemaphoreCondition *semaphore = [NSSemaphoreCondition new];
        [NSOperationQueue.mainQueue addOperationWithBlock:^{
            [self.dataSource applySnapshot:snapshot animatingDifferences:YES completion:^{
                [semaphore signal];
                [snapshot release];
            }];
        }];
        
        [semaphore wait];
        [semaphore release];
    }];
}

@end
