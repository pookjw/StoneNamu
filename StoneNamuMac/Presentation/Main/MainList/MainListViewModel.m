//
//  MainListViewModel.m
//  StoneNamuMac
//
//  Created by Jinwoo Kim on 11/16/21.
//

#import "MainListViewModel.h"
#import "NSTableViewDiffableDataSource+applySnapshotAndWait.h"

@interface MainListViewModel ()
@end

@implementation MainListViewModel

- (instancetype)initWithDataSource:(MainListDataSource *)dataSource {
    self = [self init];
    
    if (self) {
        [self->_dataSource release];
        self->_dataSource = [dataSource retain];
        
        NSOperationQueue *queue = [NSOperationQueue new];
        queue.qualityOfService = NSQualityOfServiceUserInitiated;
        [self->_queue release];
        self->_queue = queue;
        
        [self request];
    }
    
    return self;
}

- (void)dealloc {
    [_dataSource release];
    [_queue release];
    [super dealloc];
}

- (void)request {
    [self.queue addBarrierBlock:^{
        NSDiffableDataSourceSnapshot *snapshot = [self.dataSource.snapshot copy];
        
        [snapshot deleteAllItems];
        
        //
        
        MainListSectionModel *cardsSectionModel = [[MainListSectionModel alloc] initWithType:MainListSectionModelTypeCards];
        MainListSectionModel *decksSectionModel = [[MainListSectionModel alloc] initWithType:MainListSectionModelTypeDecks];
        
        [snapshot appendSectionsWithIdentifiers:@[cardsSectionModel, decksSectionModel]];
        
        //
        
        MainListItemModel *cardsItemModel = [[MainListItemModel alloc] initWithType:MainListItemModelTypeCards];
        MainListItemModel *decksItemModel = [[MainListItemModel alloc] initWithType:MainListItemModelTypeDecks];
        
        [snapshot appendItemsWithIdentifiers:@[cardsItemModel] intoSectionWithIdentifier:cardsSectionModel];
        [snapshot appendItemsWithIdentifiers:@[decksItemModel] intoSectionWithIdentifier:decksSectionModel];
        
        [cardsSectionModel release];
        [decksSectionModel release];
        
        [cardsItemModel release];
        [decksItemModel release];
        
        [self.dataSource applySnapshotAndWait:snapshot animatingDifferences:NO completion:^{}];
        [snapshot release];
    }];
}

- (void)rowForItemModelType:(MainListItemModelType)type completion:(MainListViewModelRowForItemModelTypeCompletion)completion {
    [self.queue addBarrierBlock:^{
        MainListItemModel * _Nullable __block itemModel = nil;
        
        [self.dataSource.snapshot.itemIdentifiers enumerateObjectsUsingBlock:^(MainListItemModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if (obj.type == type) {
                itemModel = obj;
                *stop = YES;
            }
        }];
        
        if (itemModel == nil) {
            completion(-1);
            return;
        }
        
        completion([self.dataSource rowForItemIdentifier:itemModel]);
    }];
}

@end
