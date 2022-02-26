//
//  MainListViewModel.m
//  MainListViewModel
//
//  Created by Jinwoo Kim on 10/15/21.
//

#import "MainListViewModel.h"
#import "UICollectionViewDiffableDataSource+applySnapshotAndWait.h"

@interface MainListViewModel ()
@property (retain) NSOperationQueue *queue;
@end

@implementation MainListViewModel

- (instancetype)initWithDataSource:(MainDataSource *)dataSource {
    self = [self init];
    
    if (self) {
        [self->_dataSource release];
        self->_dataSource = [dataSource retain];
        
        NSOperationQueue *queue = [NSOperationQueue new];
        queue.qualityOfService = NSQualityOfServiceUserInitiated;
        self.queue = queue;
        [queue release];
        
        [self requestDataSource];
    }
    
    return self;
}

- (void)dealloc {
    [_dataSource release];
    [_queue release];
    [super dealloc];
}

- (NSString * _Nullable)headerTextFromIndexPath:(NSIndexPath *)indexPath {
    MainListSectionModel * _Nullable sectionModel = [self.dataSource sectionIdentifierForIndex:indexPath.section];
    return sectionModel.headerText;
}

- (NSString * _Nullable)footerTextFromIndexPath:(NSIndexPath *)indexPath {
    MainListSectionModel * _Nullable sectionModel = [self.dataSource sectionIdentifierForIndex:indexPath.section];
    return sectionModel.footerText;
}

- (void)indexPathOfItemType:(MainListItemModelType)itemType completion:(MainListViewModelIndexPathForItemTypeCompletion)completion {
    [self.queue addBarrierBlock:^{
        MainListItemModel * _Nullable __block itemModel = nil;
        
        [self.dataSource.snapshot.itemIdentifiers enumerateObjectsUsingBlock:^(MainListItemModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if (obj.type == itemType) {
                itemModel = obj;
                *stop = YES;
            }
        }];
        
        if (itemModel == nil) {
            completion(nil);
        }
        
        NSIndexPath * _Nullable indexPath = [self.dataSource indexPathForItemIdentifier:itemModel];
        completion(indexPath);
    }];
}

- (void)requestDataSource {
    [self.queue addBarrierBlock:^{
        NSDiffableDataSourceSnapshot *snapshot = [self.dataSource.snapshot copy];
        
        [snapshot deleteAllItems];
        
        //
        
        MainListSectionModel *cardsSectionModel = [[MainListSectionModel alloc] initWithType:MainSectionModelTypeCards];
        MainListSectionModel *deckSectionModel = [[MainListSectionModel alloc] initWithType:MainSectionModelTypeDeck];
        
        [snapshot appendSectionsWithIdentifiers:@[cardsSectionModel, deckSectionModel]];
        
        MainListItemModel *cardsItemModel = [[MainListItemModel alloc] initWithType:MainListItemModelTypeCards];
        MainListItemModel *battlegroundsItemModel = [[MainListItemModel alloc] initWithType:MainListItemModelTypeBattlegrounds];
        [snapshot appendItemsWithIdentifiers:@[cardsItemModel, battlegroundsItemModel] intoSectionWithIdentifier:cardsSectionModel];
        [cardsItemModel release];
        [battlegroundsItemModel release];
        
        MainListItemModel *decksItemModel = [[MainListItemModel alloc] initWithType:MainListItemModelTypeDecks];
        [snapshot appendItemsWithIdentifiers:@[decksItemModel] intoSectionWithIdentifier:deckSectionModel];
        [decksItemModel release];
        
        [cardsSectionModel release];
        [deckSectionModel release];
        
        [self.dataSource applySnapshotAndWait:snapshot animatingDifferences:YES completion:^{}];
        [snapshot release];
    }];
}

@end
