//
//  DecksViewModel.m
//  StoneNamuMac
//
//  Created by Jinwoo Kim on 11/25/21.
//

#import "DecksViewModel.h"
#import <StoneNamuCore/StoneNamuCore.h>
#import <StoneNamuResources/StoneNamuResources.h>
#import "NSDiffableDataSourceSnapshot+sort.h"
#import "NSCollectionViewDiffableDataSource+applySnapshotAndWait.h"
#import "NSDiffableDataSourceSnapshot+Private.h"

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
 This method also makes new DecksItemModel into NSDiffableDataSourceSnapshot immediately. It's handy for selecting cell item on NSCollectionView when LocalDeck is created.
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
                
                NSArray<HSCard *> *hsCards = localDeck.hsCards;
                BOOL isEasterEgg = [self.localDeckUseCase isEasterEggDeckFromHSCards:[NSSet setWithArray:hsCards]];
                NSUInteger count = hsCards.count;
                
                DecksItemModel *itemModel = [[DecksItemModel alloc] initWithType:DecksItemModelTypeDeck localDeck:localDeck isEasterEgg:isEasterEgg count:count];
                
                [snapshot appendItemsWithIdentifiers:@[itemModel] intoSectionWithIdentifier:sectionModel];
                [itemModel release];
                [self sortSnapshot:snapshot];
                
                [self.dataSource applySnapshotAndWait:snapshot animatingDifferences:YES completion:^{
                    [self postApplyingSnapshotToDataSourceWasDone];
                    completion(localDeck);
                    [self.localDeckUseCase saveChanges];
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
                
                NSArray<HSCard *> *hsCards = localDeck.hsCards;
                BOOL isEasterEgg = [self.localDeckUseCase isEasterEggDeckFromHSCards:[NSSet setWithArray:hsCards]];
                NSUInteger count = hsCards.count;
                
                DecksItemModel *itemModel = [[DecksItemModel alloc] initWithType:DecksItemModelTypeDeck localDeck:localDeck isEasterEgg:isEasterEgg count:count];
                
                [snapshot appendItemsWithIdentifiers:@[itemModel] intoSectionWithIdentifier:sectionModel];
                [itemModel release];
                [self sortSnapshot:snapshot];
                
                [self.dataSource applySnapshotAndWait:snapshot animatingDifferences:YES completion:^{
                    [self postApplyingSnapshotToDataSourceWasDone];
                    completion(localDeck);
                    [self.localDeckUseCase saveChanges];
                }];
                [snapshot release];
            }];
        }];
    }];
}

- (void)deleteLocalDecksFromIndexPaths:(NSSet<NSIndexPath *> *)indexPaths {
    [self.queue addBarrierBlock:^{
        NSMutableSet<LocalDeck *> *localDecks = [NSMutableSet new];
        
        [indexPaths enumerateObjectsUsingBlock:^(NSIndexPath * _Nonnull obj, BOOL * _Nonnull stop) {
            DecksItemModel * _Nullable itemModel = [self.dataSource itemIdentifierForIndexPath:obj];
            
            if (itemModel == nil) return;
            
            [localDecks addObject:itemModel.localDeck];
        }];
        
        [self deleteLocalDecks:localDecks];
        [localDecks autorelease];
    }];
}

- (void)deleteLocalDecks:(NSSet<LocalDeck *> *)localDecks {
    [self.queue addBarrierBlock:^{
        NSDiffableDataSourceSnapshot *snapshot = [self.dataSource.snapshot copy];
        
        [snapshot.itemIdentifiers enumerateObjectsUsingBlock:^(DecksItemModel *obj1, NSUInteger idx, BOOL * _Nonnull stop1) {
            [localDecks enumerateObjectsUsingBlock:^(LocalDeck * _Nonnull obj2, BOOL * _Nonnull stop2) {
                if ([obj1.localDeck isEqual:obj2]) {
                    [snapshot deleteItemsWithIdentifiers:@[obj1]];
                    *stop2 = YES;
                }
            }];
        }];
        
        [self.dataSource applySnapshotAndWait:snapshot animatingDifferences:YES completion:^{
            [self postApplyingSnapshotToDataSourceWasDone];
            [self.localDeckUseCase deleteLocalDecks:localDecks];
        }];
        [snapshot release];
    }];
}

- (void)updateDeckName:(NSString *)name forLocalDeck:(LocalDeck *)localDeck {
    localDeck.name = name;
    [localDeck updateTimestamp];
    [self.localDeckUseCase saveChanges];
}

- (void)updateDeckName:(NSString *)name forIndexPath:(NSIndexPath *)indexPath {
    [self localDecksFromIndexPaths:[NSSet setWithObject:indexPath] completion:^(NSSet<LocalDeck *> * _Nonnull localDecks) {
        if (localDecks.count == 0) return;
        
        [self updateDeckName:name forLocalDeck:localDecks.allObjects.firstObject];
    }];
}

- (void)parseClipboardForDeckCodeWithCompletion:(DecksViewModelParseClipboardCompletion)completion {
    [self.queue addOperationWithBlock:^{
        NSString *text = [NSPasteboard.generalPasteboard stringForType:NSPasteboardTypeString];
        NSDictionary<NSString *, NSString *> *result = [self.hsDeckUseCase parseDeckCodeFromString:text];
        
        NSString * __block _Nullable title = result.allKeys.firstObject;
        NSString * __block _Nullable deckCode = result.allValues.firstObject;
        
        completion(title, deckCode);
    }];
}

- (void)localDecksFromIndexPaths:(NSSet<NSIndexPath *> *)indexPaths completion:(DecksViewModelLocalDecksFromIndexPathsCompletion)completion {
    [self.queue addBarrierBlock:^{
        NSMutableSet<LocalDeck *> *localDecks = [NSMutableSet new];
        
        [indexPaths enumerateObjectsUsingBlock:^(NSIndexPath * _Nonnull obj, BOOL * _Nonnull stop) {
            DecksItemModel * _Nullable itemModel = [self.dataSource itemIdentifierForIndexPath:obj];
            
            if (itemModel == nil) return;
            
            [localDecks addObject:itemModel.localDeck];
        }];
        
        completion([localDecks autorelease]);
    }];
}

- (void)requestDataSourceFromLocalDecks:(NSArray<LocalDeck *> *)localDecks {
    [self.queue addBarrierBlock:^{
        NSDiffableDataSourceSnapshot *snapshot = [self.dataSource.snapshot copy];
        
        DecksSectionModel * _Nullable __block sectionModel = nil;
        
        [snapshot.sectionIdentifiers enumerateObjectsUsingBlock:^(DecksSectionModel *obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if (obj.type == DecksSectionModelTypeNoName) {
                sectionModel = obj;
                *stop = YES;
                return;
            }
        }];
        
        if (sectionModel == nil) {
            sectionModel = [[DecksSectionModel alloc] initWithType:DecksSectionModelTypeNoName];
            [snapshot appendSectionsWithIdentifiers:@[sectionModel]];
            [sectionModel autorelease];
        }
        
        //
        
        NSMutableArray<DecksItemModel *> *oldItemModels = [[snapshot itemIdentifiersInSectionWithIdentifier:sectionModel] mutableCopy];
        
        for (LocalDeck *localDeck in localDecks) {
            DecksItemModel * _Nullable __block itemModel = nil;
            NSUInteger __block index = 0;
            
            [oldItemModels enumerateObjectsUsingBlock:^(DecksItemModel *obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if ([localDeck isEqual:obj.localDeck]) {
                    itemModel = obj;
                    index = idx;
                    *stop = YES;
                    return;
                }
            }];
            
            NSArray<HSCard *> *hsCards = localDeck.hsCards;
            BOOL isEasterEgg = [self.localDeckUseCase isEasterEggDeckFromHSCards:[NSSet setWithArray:hsCards]];
            NSUInteger count = hsCards.count;
            
            if (itemModel == nil) {
                itemModel = [[DecksItemModel alloc] initWithType:DecksItemModelTypeDeck localDeck:localDeck isEasterEgg:isEasterEgg count:count];
                [snapshot appendItemsWithIdentifiers:@[itemModel] intoSectionWithIdentifier:sectionModel];
                [itemModel autorelease];
            } else {
                itemModel.isEasterEgg = isEasterEgg;
                [snapshot reconfigureItemsWithIdentifiers:@[itemModel]];
                [oldItemModels removeObjectAtIndex:index];
            }
        }
        
        [snapshot deleteItemsWithIdentifiers:oldItemModels];
        [oldItemModels release];
        
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

- (void)postApplyingSnapshotToDataSourceWasDone {
    [NSNotificationCenter.defaultCenter postNotificationName:NSNotificationNameDecksViewModelApplyingSnapshotToDataSourceWasDone
                                                      object:self
                                                    userInfo:nil];
}

@end
