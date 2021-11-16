//
//  MainListViewModel.m
//  StoneNamuMac
//
//  Created by Jinwoo Kim on 11/16/21.
//

#import "MainListViewModel.h"
#import "NSCollectionViewDiffableDataSource+applySnapshotAndWait.h"

@interface MainListViewModel ()
@property (retain) NSOperationQueue *queue;
@end

@implementation MainListViewModel

- (instancetype)initWithDataSource:(MainListDataSource *)dataSource {
    self = [self init];
    
    if (self) {
        [self->_dataSource release];
        self->_dataSource = [dataSource retain];
        
        NSOperationQueue *queue = [NSOperationQueue new];
        queue.qualityOfService = NSQualityOfServiceUserInitiated;
        queue.maxConcurrentOperationCount = 1;
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

- (void)request {
    [self.queue addOperationWithBlock:^{
        NSDiffableDataSourceSnapshot *snapshot = [self.dataSource.snapshot copy];
        
        [snapshot deleteAllItems];
        
        //
        
        MainListSectionModel *cardsSectionModel = [[MainListSectionModel alloc] initWithType:MainListSectionModelTypeCards];
        MainListSectionModel *decksSectionModel = [[MainListSectionModel alloc] initWithType:MainListSectionModelTypeDecks];
        
        [snapshot appendSectionsWithIdentifiers:@[cardsSectionModel, decksSectionModel]];
        
        //
        
        [snapshot appendItemsWithIdentifiers:@[
            [[[MainListItemModel alloc] initWithType:MainListItemModelTypeCards] autorelease]
        ] intoSectionWithIdentifier:cardsSectionModel];
        
        [snapshot appendItemsWithIdentifiers:@[
            [[[MainListItemModel alloc] initWithType:MainListItemModelTypeDecks] autorelease]
        ] intoSectionWithIdentifier:decksSectionModel];
        
        [cardsSectionModel release];
        [decksSectionModel release];
        
        [self.dataSource applySnapshotAndWait:snapshot animatingDifferences:NO completion:^{
            [snapshot release];
        }];
    }];
}

- (void)indexPathForItemModelType:(MainListItemModelType)type completion:(MainListViewModelIndexPathForItemModelTypeCompletion)completion {
    [self.queue addOperationWithBlock:^{
        MainListItemModel * _Nullable __block itemModel = nil;
        
        [self.dataSource.snapshot.itemIdentifiers enumerateObjectsUsingBlock:^(MainListItemModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if (obj.type == type) {
                itemModel = obj;
                *stop = YES;
            }
        }];
        
        if (itemModel == nil) {
            completion(nil);
        }
        
        completion([self.dataSource indexPathForItemIdentifier:itemModel]);
    }];
}

- (MainListItemModel * _Nullable)itemModelForndexPath:(NSIndexPath *)indexPath {
    return [self.dataSource itemIdentifierForIndexPath:indexPath];
}

@end
