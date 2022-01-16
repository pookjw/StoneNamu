//
//  DecksViewModel.m
//  DecksViewModel
//
//  Created by Jinwoo Kim on 8/19/21.
//

#import "DecksViewModel.h"
#import <StoneNamuCore/StoneNamuCore.h>
#import <StoneNamuResources/StoneNamuResources.h>
#import "NSDiffableDataSourceSnapshot+sort.h"
#import "UICollectionViewDiffableDataSource+applySnapshotAndWait.h"

@interface DecksViewModel ()
@property (retain) NSOperationQueue *queue;
@property (retain) id<HSDeckUseCase> hsDeckUseCase;
@property (retain) id<LocalDeckUseCase> localDeckUseCase;
@end

@implementation DecksViewModel

- (instancetype)initWithDataSource:(DecksDataSource *)dataSource {
    self = [self init];
    
    if (self) {
        [self->_dataSource release];
        self->_dataSource = [dataSource retain];
        self.contextMenuIndexPath = nil;
        
        NSOperationQueue *queue = [NSOperationQueue new];
        queue.qualityOfService = NSQualityOfServiceUserInitiated;
        self.queue = queue;
        [queue release];
        
        HSDeckUseCaseImpl *hsDeckUseCase = [HSDeckUseCaseImpl new];
        self.hsDeckUseCase = hsDeckUseCase;
        [hsDeckUseCase release];
        
        LocalDeckUseCaseImpl *localDeckUseCase = [LocalDeckUseCaseImpl new];
        self.localDeckUseCase = localDeckUseCase;
        [localDeckUseCase release];
        
        [self startLocalDeckObserving];
    }
    
    return self;
}

- (void)dealloc {
    [_queue release];
    [_dataSource release];
    [_contextMenuIndexPath release];
    [_hsDeckUseCase release];
    [_localDeckUseCase release];
    [super dealloc];
}

- (void)requestDataSource {
    [self.localDeckUseCase fetchWithCompletion:^(NSArray<LocalDeck *> * _Nullable localDeck, NSError * _Nullable error) {
        [self requestDataSourceFromLocalDecks:localDeck];
    }];
}

- (void)fetchDeckCode:(NSString *)deckCode
                title:(NSString * _Nullable)title
           completion:(DecksViewModelFetchDeckCodeCompletion)completion {
    
    [self.hsDeckUseCase fetchDeckByDeckCode:deckCode completion:^(HSDeck * _Nullable hsDeck, NSError * _Nullable error) {
        if (error) {
            NSLog(@"%@", error.localizedDescription);
            completion(nil, nil, error);
            return;
        }
        
        if (hsDeck) {
            [self makeLocalDeckWithHSDeck:hsDeck title:title completion:^(LocalDeck * _Nonnull localDeck) {
                completion(localDeck, hsDeck, error);
            }];
        }
    }];
}

/**
 Use this method to make a new LocalDeck object.
 This method also makes new DecksItemModel into NSDiffableDataSourceSnapshot immediately. It's handy for selecting cell item on UICollectionView when LocalDeck is created.
 */
- (void)makeLocalDeckWithClass:(HSCardClass)hsCardClass
                    deckFormat:(HSDeckFormat)deckFormat
                    completion:(DecksViewModelMakeLocalDeckCompletion)completion {
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
        
        [self.localDeckUseCase makeLocalDeckWithCompletion:^(LocalDeck * _Nonnull localDeck) {
            [self.queue addBarrierBlock:^{
                localDeck.format = deckFormat;
                localDeck.name = [ResourcesService localizationForHSCardClass:hsCardClass];
                localDeck.classId = [NSNumber numberWithUnsignedInteger:hsCardClass];
                
                DecksItemModel *itemModel = [[DecksItemModel alloc] initWithType:DecksItemModelTypeDeck localDeck:localDeck];
                
                [snapshot appendItemsWithIdentifiers:@[itemModel] intoSectionWithIdentifier:sectionModel];
                [itemModel release];
                [self sortSnapshot:snapshot];
                
                [self.dataSource applySnapshotAndWait:snapshot animatingDifferences:YES completion:^{
                    [self.localDeckUseCase saveChanges];
                    completion(localDeck);
                }];
                
                [snapshot release];
            }];
        }];
    }];
}

- (void)makeLocalDeckWithHSDeck:(HSDeck * _Nullable)hsDeck
                          title:(NSString *)title
                     completion:(DecksViewModelMakeLocalDeckCompletion)completion {
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
        
        [self.localDeckUseCase makeLocalDeckWithCompletion:^(LocalDeck * _Nonnull localDeck) {
            [self.queue addBarrierBlock:^{
                if (hsDeck) {
                    [localDeck setValuesAsHSDeck:hsDeck];
                }
                
                if ((title == nil) || ([title isEqualToString:@""])) {
                    localDeck.name = [ResourcesService localizationForHSCardClass:hsDeck.classId];
                } else {
                    localDeck.name = title;
                }
                
                DecksItemModel *itemModel = [[DecksItemModel alloc] initWithType:DecksItemModelTypeDeck localDeck:localDeck];
                
                [snapshot appendItemsWithIdentifiers:@[itemModel] intoSectionWithIdentifier:sectionModel];
                [itemModel release];
                [self sortSnapshot:snapshot];
                
                [self.dataSource applySnapshotAndWait:snapshot animatingDifferences:YES completion:^{
                    [self.localDeckUseCase saveChanges];
                    completion(localDeck);
                }];
                [snapshot release];
            }];
        }];
    }];
}

- (void)deleteLocalDeckFromIndexPath:(NSIndexPath *)indexPath {
    NSIndexPath *copyIndexPath = [indexPath copy];
    
    [self.queue addBarrierBlock:^{
        DecksItemModel * _Nullable itemModel = [self.dataSource itemIdentifierForIndexPath:copyIndexPath];
        [copyIndexPath release];
        if (itemModel == nil) return;
        
        switch (itemModel.type) {
            case DecksItemModelTypeDeck:
                [self deleteLocalDeck:itemModel.localDeck];
                break;
            default:
                break;
        }
    }];
}

- (void)deleteLocalDeck:(LocalDeck *)localDeck {[self.queue addBarrierBlock:^{
    NSDiffableDataSourceSnapshot *snapshot = [self.dataSource.snapshot copy];
    
    [snapshot.itemIdentifiers enumerateObjectsUsingBlock:^(DecksItemModel *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj.localDeck isEqual:localDeck]) {
            [snapshot deleteItemsWithIdentifiers:@[obj]];
        }
    }];
    
    [self.dataSource applySnapshotAndWait:snapshot animatingDifferences:YES completion:^{
        [self.localDeckUseCase deleteLocalDeck:localDeck];
    }];
    [snapshot release];
}];
}

- (void)parseClipboardForDeckCodeWithCompletion:(DecksViewModelParseClipboardCompletion)completion {
    [self.queue addOperationWithBlock:^{
        NSString *text = UIPasteboard.generalPasteboard.string;
        NSDictionary<NSString *, NSString *> *result = [self.hsDeckUseCase parseDeckCodeFromString:text];
        
        NSString * __block _Nullable title = result.allKeys.firstObject;
        NSString * __block _Nullable deckCode = result.allValues.firstObject;
        
        completion(title, deckCode);
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

- (void)requestDataSourceFromLocalDecks:(NSArray<LocalDeck *> *)localDecks {
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
        [snapshot reconfigureItemsWithIdentifiers:itemModels];
        [itemModels release];
        [sectionModel release];
        
        [self sortSnapshot:snapshot];
        
        //
        
        [self.dataSource applySnapshotAndWait:snapshot animatingDifferences:YES completion:^{}];
        [snapshot release];
    }];
}

- (void)sortSnapshot:(NSDiffableDataSourceSnapshot *)snapshot {
    [snapshot sortItemsWithSectionIdentifiers:snapshot.sectionIdentifiers
                              usingComparator:^NSComparisonResult(DecksItemModel *obj1, DecksItemModel *obj2) {
        if ((obj1 == nil) || (obj2 == nil)) {
            return NSOrderedSame;
        }
        return [obj2.localDeck.timestamp compare:obj1.localDeck.timestamp];
    }];
}

- (void)startLocalDeckObserving {
    [NSNotificationCenter.defaultCenter addObserver:self
                                           selector:@selector(localDeckChangesReceived:)
                                               name:NSNotificationNameLocalDeckUseCaseObserveData
                                             object:self.localDeckUseCase];
    
    [NSNotificationCenter.defaultCenter addObserver:self
                                           selector:@selector(localDeckChangesReceived:)
                                               name:NSNotificationNameLocalDeckUseCaseDeleteAll
                                             object:nil];
}

- (void)localDeckChangesReceived:(NSNotification *)notification {
    [self.localDeckUseCase fetchWithCompletion:^(NSArray<LocalDeck *> * _Nullable localDecks, NSError * _Nullable error) {
        [self requestDataSourceFromLocalDecks:localDecks];
    }];
}

@end
