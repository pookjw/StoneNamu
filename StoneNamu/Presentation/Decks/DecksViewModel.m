//
//  DecksViewModel.m
//  DecksViewModel
//
//  Created by Jinwoo Kim on 8/19/21.
//

#import "DecksViewModel.h"
#import "HSDeckUseCaseImpl.h"
#import "LocalDeckUseCaseImpl.h"

@interface DecksViewModel ()
@property (retain) NSOperationQueue *queue;
@property (retain) id<HSDeckUseCase> hsDeckUseCase;
@property (retain) id<LocalDeckUseCase> localDeckUseCase;
@end

@implementation DecksViewModel

- (instancetype)initWithDataSource:(DecksDataSource *)dataSource {
    self = [self init];
    
    if (self) {
        self->_dataSource = [dataSource retain];
        
        NSOperationQueue *queue = [NSOperationQueue new];
        self.queue = queue;
        queue.qualityOfService = NSQualityOfServiceUserInitiated;
        [queue release];
        
        HSDeckUseCaseImpl *hsDeckUseCase = [HSDeckUseCaseImpl new];
        self.hsDeckUseCase = hsDeckUseCase;
        [hsDeckUseCase release];
        
        LocalDeckUseCaseImpl *localDeckUseCase = [LocalDeckUseCaseImpl new];
        self.localDeckUseCase = localDeckUseCase;
        [localDeckUseCase fetchWithCompletion:^(NSArray<LocalDeck *> * _Nullable localDeck, NSError * _Nullable error) {
            [self requestDataSourceWithLocalDecks:localDeck];
        }];
        
        [localDeckUseCase release];
        
        [self startLocalDeckObserving];
    }
    
    return self;
}

- (void)dealloc {
    [_queue release];
    [_dataSource release];
    [_hsDeckUseCase release];
    [_localDeckUseCase release];
    [super dealloc];
}

- (void)fetchDeckCode:(NSString *)deckCode completion:(DecksViewModelFetchDeckCodeCompletion)completion {
    [self.hsDeckUseCase fetchDeckByDeckCode:deckCode completion:^(HSDeck * _Nullable hsDeck, NSError * _Nullable error) {
        if (error) {
            NSLog(@"%@", error.localizedDescription);
            completion(nil, nil, error);
            return;
        }
        
        if (hsDeck) {
            [hsDeck retain];
            [self makeLocalDeckWithHSDeck:hsDeck completion:^(LocalDeck * _Nonnull localDeck) {
                completion(localDeck, [hsDeck autorelease], error);
            }];
        }
    }];
}

/**
 Use this method to make a new LocalDeck object.
 This method also makes new DecksItemModel into NSDiffableDataSourceSnapshot immediately. It's handy for select cell item on UICollectionView when LocalDeck is created.
 */
- (void)makeLocalDeckWithClass:(HSCardClass)hsCardClass completion:(DecksViewModelMakeLocalDeckCompletion)completion {
    [self.queue addBarrierBlock:^{
        NSDiffableDataSourceSnapshot *snapshot = [self.dataSource.snapshot copy];
        
        DecksSectionModel * _Nullable sectionModel = nil;
        
        for (DecksSectionModel *tmpSectionModel in snapshot.sectionIdentifiers) {
            if (tmpSectionModel.type == DecksSectionModelTypeNoName) {
                sectionModel = tmpSectionModel;
                break;
            }
        }
        
        if (sectionModel == nil) {
            [snapshot release];
            return;
        }
        
        LocalDeck *localDeck = [self.localDeckUseCase makeLocalDeck];
        localDeck.classId = [NSNumber numberWithUnsignedInteger:hsCardClass];
        
        DecksItemModel *itemModel = [[DecksItemModel alloc] initWithType:DecksItemModelTypeDeck localDeck:localDeck];
        
        [snapshot appendItemsWithIdentifiers:@[itemModel] intoSectionWithIdentifier:sectionModel];
        [itemModel release];
        
        [NSOperationQueue.mainQueue addOperationWithBlock:^{
            [self.dataSource applySnapshot:snapshot animatingDifferences:YES completion:^{
                [snapshot release];
                [self.localDeckUseCase saveChanges];
                completion(localDeck);
            }];
        }];
    }];
}

- (void)makeLocalDeckWithHSDeck:(HSDeck * _Nullable)hsDeck completion:(DecksViewModelMakeLocalDeckCompletion)completion {
    HSDeck * _Nullable copyHSDeck = [hsDeck copy];
    
    [self.queue addBarrierBlock:^{
        NSDiffableDataSourceSnapshot *snapshot = [self.dataSource.snapshot copy];
        
        DecksSectionModel * _Nullable sectionModel = nil;
        
        for (DecksSectionModel *tmpSectionModel in snapshot.sectionIdentifiers) {
            if (tmpSectionModel.type == DecksSectionModelTypeNoName) {
                sectionModel = tmpSectionModel;
                break;
            }
        }
        
        if (sectionModel == nil) {
            [snapshot release];
            return;
        }
        
        LocalDeck *localDeck = [self.localDeckUseCase makeLocalDeck];
        
        if (copyHSDeck) {
            [localDeck setValuesAsHSDeck:copyHSDeck];
        }
        [copyHSDeck release];
        
        DecksItemModel *itemModel = [[DecksItemModel alloc] initWithType:DecksItemModelTypeDeck localDeck:localDeck];
        
        [snapshot appendItemsWithIdentifiers:@[itemModel] intoSectionWithIdentifier:sectionModel];
        [itemModel release];
        
        [NSOperationQueue.mainQueue addOperationWithBlock:^{
            [self.dataSource applySnapshot:snapshot animatingDifferences:YES completion:^{
                [snapshot release];
                [self.localDeckUseCase saveChanges];
                completion(localDeck);
            }];
        }];
    }];
}

- (NSIndexPath * _Nullable)indexPathForLocalDeck:(LocalDeck *)localDeck {
    for (DecksItemModel *itemModel in self.dataSource.snapshot.itemIdentifiers) {
        if ([itemModel.localDeck isEqual:localDeck]) {
            NSIndexPath *indexPath = [self.dataSource indexPathForItemIdentifier:itemModel];
            return indexPath;
        }
    }
    
    return nil;
}

- (void)requestDataSourceWithLocalDecks:(NSArray<LocalDeck *> *)localDecks {
    [self.queue addBarrierBlock:^{
        NSDiffableDataSourceSnapshot *snapshot = [self.dataSource.snapshot copy];
        
        [snapshot deleteAllItems];
        
        DecksSectionModel *sectionModel = [[DecksSectionModel alloc] initWithType:DecksSectionModelTypeNoName];
        [snapshot appendSectionsWithIdentifiers:@[sectionModel]];
        
        //
        
        NSMutableArray<DecksItemModel *> *itemModels = [@[] mutableCopy];
        
        for (LocalDeck *localDeck in localDecks) {
            DecksItemModel *itemModel = [[DecksItemModel alloc] initWithType:DecksItemModelTypeDeck localDeck:localDeck];
            [itemModels addObject:itemModel];
            [itemModel release];
        }
        
        [snapshot appendItemsWithIdentifiers:itemModels intoSectionWithIdentifier:sectionModel];
        [itemModels release];
        [sectionModel release];
        
        //
        
        [NSOperationQueue.mainQueue addOperationWithBlock:^{
            [self.dataSource applySnapshot:snapshot animatingDifferences:YES completion:^{
                [snapshot release];
            }];
        }];
    }];
}

- (void)startLocalDeckObserving {
    [NSNotificationCenter.defaultCenter addObserver:self
                                           selector:@selector(localDeckChangesReceived:)
                                               name:LocalDeckUseCaseObserveDataNotificationName
                                             object:self.localDeckUseCase];
    
    [NSNotificationCenter.defaultCenter addObserver:self
                                           selector:@selector(localDeckChangesReceived:)
                                               name:LocalDeckUseCaseDeleteAllNotificationName
                                             object:nil];
}

- (void)localDeckChangesReceived:(NSNotification *)notification {
    [self.localDeckUseCase fetchWithCompletion:^(NSArray<LocalDeck *> * _Nullable localDecks, NSError * _Nullable error) {
        [self requestDataSourceWithLocalDecks:localDecks];
    }];
}

@end
