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

@end
