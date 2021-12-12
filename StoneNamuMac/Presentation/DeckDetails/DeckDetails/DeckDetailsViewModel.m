//
//  DeckDetailsViewModel.m
//  StoneNamuMac
//
//  Created by Jinwoo Kim on 12/12/21.
//

#import "DeckDetailsViewModel.h"
#import <StoneNamuResources/StoneNamuResources.h>
#import "NSDiffableDataSourceSnapshot+sort.h"
#import "NSCollectionViewDiffableDataSource+applySnapshotAndWait.h"
#import "NSDiffableDataSourceSnapshot+Private.h"

@interface DeckDetailsViewModel ()
@property (retain) NSOperationQueue *queue;
@property (retain) id<HSDeckUseCase> hsDeckUseCase;
@property (retain) id<LocalDeckUseCase> localDeckUseCase;
@property (retain) id<DataCacheUseCase> dataCacheUseCase;
@end

@implementation DeckDetailsViewModel

- (instancetype)initWithDataSource:(DeckDetailsDataSource *)dataSource {
    self = [self init];
    
    if (self) {
        [self->_localDeck release];
        self->_localDeck = nil;
        self->_dataSource = [dataSource retain];
        self.shouldPresentDeckEditor = YES;
        
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
        
        DataCacheUseCaseImpl *dataCacheUseCase = [DataCacheUseCaseImpl new];
        self.dataCacheUseCase = dataCacheUseCase;
        [dataCacheUseCase release];
        
        [self startObserving];
    }
    
    return self;
}

- (void)dealloc {
    [_queue release];
    [_dataSource release];
    [_localDeck release];
    [_hsDeckUseCase release];
    [_localDeckUseCase release];
    [_dataCacheUseCase release];
    [super dealloc];
}

- (void)addHSCards:(NSArray<HSCard *> *)hsCards {
    NSArray<HSCard *> *copyHSCards = [hsCards copy];
    
    [self.localDeckUseCase addHSCards:copyHSCards toLocalDeck:self.localDeck validation:^(NSError * _Nullable error) {
        if (error != nil) {
            [self postErrorOccurredNotification:error];
        } else {
            
            NSDiffableDataSourceSnapshot *snapshot = [self.dataSource.snapshot copy];
            
            DeckDetailsSectionModel * _Nullable cardsSectionModel = nil;
            
            for (DeckDetailsSectionModel *tmp in snapshot.sectionIdentifiers) {
                if (tmp.type == DeckDetailsSectionModelTypeCards) {
                    cardsSectionModel = tmp;
                    break;
                }
            }
            
            if (cardsSectionModel == nil) {
                cardsSectionModel = [[[DeckDetailsSectionModel alloc] initWithType:DeckDetailsSectionModelTypeCards] autorelease];
                [snapshot appendSectionsWithIdentifiers:@[cardsSectionModel]];
            }
            
            //
            
            for (HSCard *hsCard in copyHSCards) {
                BOOL __block isDuplicated = NO;
                
                [snapshot.itemIdentifiers enumerateObjectsUsingBlock:^(DeckDetailsItemModel *obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    if ([hsCard isEqual:obj.hsCard]) {
                        obj.hsCardCount = [NSNumber numberWithUnsignedInteger:obj.hsCardCount.unsignedIntegerValue + 1];
                        [snapshot reconfigureItemsWithIdentifiers:@[obj]];
                        
                        isDuplicated = YES;
                        *stop = YES;
                    }
                }];
                
                if (!isDuplicated) {
                    DeckDetailsItemModel *cardItemModel = [[DeckDetailsItemModel alloc] initWithType:DeckDetailsItemModelTypeCard];
                    cardItemModel.hsCard = hsCard;
                    cardItemModel.hsCardCount = @1;
                    [snapshot appendItemsWithIdentifiers:@[cardItemModel] intoSectionWithIdentifier:cardsSectionModel];
                    [cardItemModel release];
                }
            }
            
            [self addCostGraphItemToSnapshot:snapshot];
            [self updateCardsSectionHeaderTitleFromSnapshot:snapshot];
            [self sortSnapshot:snapshot];
            
            [self.dataSource applySnapshotAndWait:snapshot animatingDifferences:YES completion:^{
                [snapshot release];
                [self postApplyingSnapshotToDataSourceWasDoneNotification];
            }];
        }
        
        [copyHSCards release];
    }];
}

- (void)increaseAtIndexPath:(NSIndexPath *)indexPath {
    DeckDetailsItemModel *itemModel = [self.dataSource itemIdentifierForIndexPath:indexPath];
    HSCard *hsCard = itemModel.hsCard;
    
    [self.localDeckUseCase increaseHSCards:[NSSet setWithArray:@[hsCard]] toLocalDeck:self.localDeck validation:^(NSError * _Nullable error) {
        if (error != nil) {
            [self postErrorOccurredNotification:error];
        } else {
            
            NSDiffableDataSourceSnapshot *snapshot = [self.dataSource.snapshot copy];
            DeckDetailsItemModel *itemModel = [self.dataSource itemIdentifierForIndexPath:indexPath];
            
            itemModel.hsCardCount = [NSNumber numberWithUnsignedInteger:itemModel.hsCardCount.unsignedIntegerValue + 1];
            [snapshot reconfigureItemsWithIdentifiers:@[itemModel]];
            
            [self addCostGraphItemToSnapshot:snapshot];
            [self updateCardsSectionHeaderTitleFromSnapshot:snapshot];
            [self sortSnapshot:snapshot];
            
            [self.dataSource applySnapshotAndWait:snapshot animatingDifferences:YES completion:^{
                [snapshot release];
                [self postApplyingSnapshotToDataSourceWasDoneNotification];
            }];
        }
    }];
}

- (BOOL)decreaseAtIndexPath:(NSIndexPath *)indexPath {
    DeckDetailsItemModel *itemModel = [self.dataSource itemIdentifierForIndexPath:indexPath];
    
    if (itemModel.hsCardCount.unsignedIntegerValue <= 1) {
        [self deleteAtIndexPath:indexPath];
        [indexPath release];
        return NO;
    }
    
    HSCard *hsCard = itemModel.hsCard;
    
    [self.localDeckUseCase decreaseHSCards:[NSSet setWithArray:@[hsCard]] toLocalDeck:self.localDeck validation:^(NSError * _Nullable error) {
        if (error != nil) {
            [self postErrorOccurredNotification:error];
        } else {
            
            NSDiffableDataSourceSnapshot *snapshot = [self.dataSource.snapshot copy];
            DeckDetailsItemModel *itemModel = [self.dataSource itemIdentifierForIndexPath:indexPath];
            
            itemModel.hsCardCount = [NSNumber numberWithUnsignedInteger:(itemModel.hsCardCount.unsignedIntegerValue - 1)];
            [snapshot reconfigureItemsWithIdentifiers:@[itemModel]];
            
            [self addCostGraphItemToSnapshot:snapshot];
            [self updateCardsSectionHeaderTitleFromSnapshot:snapshot];
            [self sortSnapshot:snapshot];
            
            [self.dataSource applySnapshotAndWait:snapshot animatingDifferences:YES completion:^{
                [snapshot release];
                [self postApplyingSnapshotToDataSourceWasDoneNotification];
            }];
        }
    }];
    
    return YES;
}

- (void)deleteAtIndexPath:(NSIndexPath *)indexPath {
    HSCard * _Nullable hsCard = [self.dataSource itemIdentifierForIndexPath:indexPath].hsCard;
    
    if (hsCard) {
        [self deleteHSCard:hsCard];
    }
}

- (void)deleteHSCard:(HSCard *)hsCard {
    HSCard *copyHSCard = [hsCard copy];
    
    [self.localDeckUseCase deleteHSCards:[NSSet setWithArray:@[hsCard]] toLocalDeck:self.localDeck validation:^(NSError * _Nullable error) {
        if (error != nil) {
            [self postErrorOccurredNotification:error];
        } else {
            
            NSDiffableDataSourceSnapshot *snapshot = [self.dataSource.snapshot copy];
            
            [snapshot.itemIdentifiers enumerateObjectsUsingBlock:^(DeckDetailsItemModel *obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if ((obj.type == DeckDetailsItemModelTypeCard) && [copyHSCard isEqual:obj.hsCard]) {
                    [snapshot deleteItemsWithIdentifiers:@[obj]];
                    *stop = YES;
                }
            }];
            
            [self addCostGraphItemToSnapshot:snapshot];
            [self updateCardsSectionHeaderTitleFromSnapshot:snapshot];
            [self sortSnapshot:snapshot];
            
            [self.dataSource applySnapshotAndWait:snapshot animatingDifferences:YES completion:^{
                [snapshot release];
                [self postApplyingSnapshotToDataSourceWasDoneNotification];
            }];
        }
        
        [copyHSCard release];
    }];
}

- (void)exportLocalizedDeckCodeWithCompletion:(DeckDetailsViewModelExportDeckCodeCompletion)completion {
    if (self.localDeck.hsCards.count < HSDECK_MAX_TOTAL_CARDS) {
        [self postCardsAreNotFilledNotification];
        completion(nil);
        return;
    }
    
    [self.hsDeckUseCase fetchDeckByCardList:self.localDeck.hsCardIds
                                    classId:self.localDeck.classId.unsignedIntegerValue
                                 completion:^(HSDeck * _Nullable hsDeck, NSError * _Nullable error) {
        if (error) {
            [self postErrorOccurredNotification:error];
        } else if (hsDeck.deckCode) {
            [self.localDeck setValuesAsHSDeck:hsDeck];
            [self.localDeck updateTimestamp];
            [self.localDeckUseCase saveChanges];
            completion([ResourcesService localizationForHSDeck:hsDeck title:self.localDeck.name]);
        } else {
            NSError *error = [NSError errorWithDomain:@"com.pookjw.StoneNamu" code:105 userInfo:@{NSLocalizedDescriptionKey: [ResourcesService localizationForKey:LocalizableKeyDeckcodeFetchError]}];
            [self postErrorOccurredNotification:error];
        }
    }];
}

- (void)updateDeckName:(NSString *)name {
    self.localDeck.name = name;
    [self postDidChangeLocalDeckNameNotification:name];
    [self.localDeck updateTimestamp];
    [self.localDeckUseCase saveChanges];
}

- (void)requestDataSourceWithLocalDeck:(LocalDeck *)localDeck {
    [self->_localDeck release];
    self->_localDeck = [localDeck retain];
    
    if (localDeck.hsCards) {
        [self updateDataSourceWithHSCards:localDeck.hsCards];;
    } else {
        [self updateDataSourceWithHSCards:@[]];
    }
    
    [self postDidChangeLocalDeckNameNotification:localDeck.name];
}

- (void)updateDataSourceWithHSCards:(NSArray<HSCard *> *)hsCards {
    [self.queue addBarrierBlock:^{
        NSDiffableDataSourceSnapshot *snapshot = [self.dataSource.snapshot copy];
        
        if (hsCards.count == 0) {
            [snapshot deleteAllItems];
        } else {
            DeckDetailsSectionModel * __block _Nullable sectionModel = nil;
            
            [snapshot.sectionIdentifiers enumerateObjectsUsingBlock:^(DeckDetailsSectionModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if (obj.type == DeckDetailsSectionModelTypeCards) {
                    sectionModel = obj;
                    *stop = YES;
                }
            }];
            
            if (sectionModel == nil) {
                sectionModel = [[[DeckDetailsSectionModel alloc] initWithType:DeckDetailsSectionModelTypeCards] autorelease];
                [snapshot appendSectionsWithIdentifiers:@[sectionModel]];
            }
            
            //
            
            NSMutableArray<HSCard *> *addedHSCards = [@[] mutableCopy];
            
            for (HSCard *hsCard in hsCards) {
                if ([addedHSCards containsObject:hsCard]) continue;
                [addedHSCards addObject:hsCard];
                
                BOOL __block exists = NO;
                
                [snapshot.itemIdentifiers enumerateObjectsUsingBlock:^(DeckDetailsItemModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    if ([hsCard isEqual:obj.hsCard]) {
                        exists = YES;
                        *stop = YES;
                        obj.hsCardCount = [NSNumber numberWithUnsignedInteger:[hsCards countOfObject:hsCard]];
                        [snapshot reconfigureItemsWithIdentifiers:@[obj]];
                    }
                }];
                
                if (!exists) {
                    DeckDetailsItemModel *itemModel = [[DeckDetailsItemModel alloc] initWithType:DeckDetailsItemModelTypeCard];
                    itemModel.hsCard = hsCard;
                    itemModel.hsCardCount = [NSNumber numberWithUnsignedInteger:[hsCards countOfObject:hsCard]];
                    [snapshot appendItemsWithIdentifiers:@[itemModel] intoSectionWithIdentifier:sectionModel];
                    [itemModel release];
                }
            }
            
            [addedHSCards release];
            
            //
            
            NSMutableArray<DeckDetailsItemModel *> *willBeDeletedItems = [@[] mutableCopy];
            
            [snapshot.itemIdentifiers enumerateObjectsUsingBlock:^(DeckDetailsItemModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if (![hsCards containsObject:obj.hsCard]) {
                    [snapshot deleteItemsWithIdentifiers:@[obj]];
                }
            }];
            
            [snapshot deleteItemsWithIdentifiers:willBeDeletedItems];
            [willBeDeletedItems release];
        }
        
        //
        
        [self addCostGraphItemToSnapshot:snapshot];
        [self updateCardsSectionHeaderTitleFromSnapshot:snapshot];
        [self sortSnapshot:snapshot];
        
        //
        
        [self.dataSource applySnapshotAndWait:snapshot animatingDifferences:YES completion:^{
            [snapshot release];
            [self postApplyingSnapshotToDataSourceWasDoneNotification];
        }];
    }];
}

- (void)sortSnapshot:(NSDiffableDataSourceSnapshot *)snapshot {
    [snapshot sortSectionsUsingComparator:^NSComparisonResult(DeckDetailsSectionModel *obj1, DeckDetailsSectionModel *obj2) {
        if (obj1.type < obj2.type) {
            return NSOrderedAscending;
        } else if (obj1.type > obj2.type) {
            return NSOrderedDescending;
        } else {
            return NSOrderedSame;
        }
    }];
    
    //
    
    [snapshot sortItemsWithSectionIdentifiers:snapshot.sectionIdentifiers
                              usingComparator:^NSComparisonResult(DeckDetailsItemModel *obj1, DeckDetailsItemModel *obj2) {
        if ((obj1.type == DeckDetailsItemModelTypeCard) && (obj2.type == DeckDetailsItemModelTypeCard)) {
            HSCard *obj1Card = obj1.hsCard;
            HSCard *obj2Card = obj2.hsCard;
            
            return [obj1Card compare:obj2Card];
        } else if ((obj1.type == DeckDetailsItemModelTypeManaCostGraph) && (obj2.type == DeckDetailsItemModelTypeManaCostGraph)) {
            return [obj1.graphManaCost compare:obj2.graphManaCost];
        } else {
            return NSOrderedSame;
        }
    }];
}

- (void)addCostGraphItemToSnapshot:(NSDiffableDataSourceSnapshot *)snapshot {
    NSMutableDictionary<NSNumber *, NSNumber *> *manaDictionary = [@{} mutableCopy];
    NSUInteger __block highestCostCount = 0;
    
    for (DeckDetailsItemModel *itemModel in snapshot.itemIdentifiers) {
        if (itemModel.type != DeckDetailsItemModelTypeCard) continue;
        
        @autoreleasepool {
            NSNumber *cardManaCost;
            
            if (itemModel.hsCard.manaCost >= 10) {
                cardManaCost = @10;
            } else {
                cardManaCost = [NSNumber numberWithUnsignedInteger:itemModel.hsCard.manaCost];
            }
            
            //
            
            if (manaDictionary[cardManaCost] == nil) {
                manaDictionary[cardManaCost] = itemModel.hsCardCount;
            } else {
                NSNumber *newCount = [NSNumber numberWithUnsignedInteger:manaDictionary[cardManaCost].unsignedIntegerValue + itemModel.hsCardCount.unsignedIntegerValue];
                manaDictionary[cardManaCost] = newCount;
            }
            
            //
            
            highestCostCount = MAX(highestCostCount, manaDictionary[cardManaCost].unsignedIntegerValue);
        }
    }
    
    //
    
    BOOL __block shouldReconfigure = NO;
    
    [snapshot.sectionIdentifiers enumerateObjectsUsingBlock:^(DeckDetailsSectionModel *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj.type == DeckDetailsSectionModelTypeManaCostGraph) {
            [snapshot deleteSectionsWithIdentifiers:@[obj]];
            shouldReconfigure = YES;
            *stop = YES;
        }
    }];
    
    //
    
    if (manaDictionary.count == 0) {
        [manaDictionary release];
        return;
    } else {
        DeckDetailsSectionModel *sectionModel = [[DeckDetailsSectionModel alloc] initWithType:DeckDetailsSectionModelTypeManaCostGraph];
        [snapshot appendSectionsWithIdentifiers:@[sectionModel]];
        
        //
        
        [manaDictionary enumerateKeysAndObjectsUsingBlock:^(NSNumber * _Nonnull key, NSNumber * _Nonnull obj, BOOL * _Nonnull stop) {
            DeckDetailsItemModel *itemModel = [[DeckDetailsItemModel alloc] initWithType:DeckDetailsItemModelTypeManaCostGraph];
            
            itemModel.graphManaCost = key;
            
            if (highestCostCount == 0) {
                itemModel.graphPercentage = [NSNumber numberWithFloat:0.0f];
            } else {
                itemModel.graphPercentage = [NSNumber numberWithFloat:(obj.floatValue / (float)highestCostCount)];
            }
            
            itemModel.graphCount = obj;
            
            [snapshot appendItemsWithIdentifiers:@[itemModel] intoSectionWithIdentifier:sectionModel];
            
            if (shouldReconfigure) {
                [snapshot reconfigureItemsWithIdentifiers:@[itemModel]];
            }
            
            [itemModel release];
        }];
        
        [sectionModel release];
        [manaDictionary release];
    }
}

- (void)updateCardsSectionHeaderTitleFromSnapshot:(NSDiffableDataSourceSnapshot *)snapshot {
    for (DeckDetailsSectionModel *sectionModel in snapshot.sectionIdentifiers) {
        @autoreleasepool {
            if (sectionModel.type == DeckDetailsSectionModelTypeCards) {
                NSString *headerText = [NSString stringWithFormat:[ResourcesService localizationForKey:LocalizableKeyCardCount], [self totalCardsInSnapshot:snapshot], HSDECK_MAX_TOTAL_CARDS];
                sectionModel.headerText = headerText;
            }
        }
    }
}

- (NSUInteger)totalCardsInSnapshot:(NSDiffableDataSourceSnapshot *)snapshot {
    NSUInteger __block result = 0;
    
    [snapshot.itemIdentifiers enumerateObjectsUsingBlock:^(DeckDetailsItemModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        result += obj.hsCardCount.unsignedIntegerValue;
    }];
    
    return result;
}

- (void)startObserving {
    [NSNotificationCenter.defaultCenter addObserver:self
                                           selector:@selector(localDeckChangesReceived:)
                                               name:NSNotificationNameLocalDeckUseCaseObserveData
                                             object:self.localDeckUseCase];
    
    [NSNotificationCenter.defaultCenter addObserver:self
                                           selector:@selector(localDeckDeleteAllReceived:)
                                               name:NSNotificationNameLocalDeckUseCaseDeleteAll
                                             object:nil];
    
    [NSNotificationCenter.defaultCenter addObserver:self
                                           selector:@selector(dataCacheDeleteAllReceived:)
                                               name:NSNotificationNameDataCacheUseCaseDeleteAll
                                             object:nil];
}

- (void)localDeckChangesReceived:(NSNotification *)notification {
    if (self.localDeck != nil) {
        [self.localDeckUseCase refreshObject:self.localDeck mergeChanges:NO completion:^{
            if (self.localDeck.managedObjectContext == nil) {
                [self postShouldDismissNoficiation];
            } else {
                [self requestDataSourceWithLocalDeck:self.localDeck];
            }
        }];
    }
}

- (void)localDeckDeleteAllReceived:(NSNotification *)notification {
    [self postShouldDismissNoficiation];
}

- (void)dataCacheDeleteAllReceived:(NSNotification *)notification {
    [self postShouldDismissNoficiation];
}

- (void)postApplyingSnapshotToDataSourceWasDoneNotification {
    NSMutableDictionary * _Nullable userInfo = [@{} mutableCopy];
    BOOL hasCards = ([self totalCardsInSnapshot:self.dataSource.snapshot] > 0);
    
    userInfo[DeckDetailsViewModelApplyingSnapshotToDataSourceWasDoneHasAnyCardsItemKey] = [NSNumber numberWithBool:hasCards];
    
    //
    
    NSString * _Nullable __block headerText = nil;
    
    [self.dataSource.snapshot.sectionIdentifiers enumerateObjectsUsingBlock:^(DeckDetailsSectionModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj.type == DeckDetailsSectionModelTypeCards) {
            headerText = obj.headerText;
            *stop = YES;
        }
    }];
    
    if (headerText != nil) {
        userInfo[DeckDetailsViewModelApplyingSnapshotToDataSourceWasDoneCardsHeaderTextKey] = headerText;
    }
    
    [NSNotificationCenter.defaultCenter postNotificationName:NSNotificationNameDeckDetailsViewModelApplyingSnapshotToDataSourceWasDone
                                                      object:self
                                                    userInfo:userInfo];
    [userInfo release];
}

- (void)postShouldDismissNoficiation {
    [NSNotificationCenter.defaultCenter postNotificationName:NSNotificationNameDeckDetailsViewModelShouldDismiss
                                                      object:self
                                                    userInfo:nil];
}

- (void)postDidChangeLocalDeckNameNotification:(NSString *)name {
    NSMutableDictionary *userInfo = [@{} mutableCopy];
    
    if (name) {
        userInfo[DeckDetailsViewModelDidChangeLocalDeckNameItemKey] = name;
    }
    
    [NSNotificationCenter.defaultCenter postNotificationName:NSNotificationNameDeckDetailsViewModelDidChangeLocalDeck
                                                      object:self
                                                    userInfo:userInfo];
    
    [userInfo release];
}

- (void)postErrorOccurredNotification:(NSError *)error {
    [NSNotificationCenter.defaultCenter postNotificationName:NSNotificationNameDeckDetailsViewModelErrorOccurred
                                                      object:self
                                                    userInfo:@{DeckDetailsViewModelErrorOccurredItemKey: error}];
}

- (void)postCardsAreNotFilledNotification {
    NSString *message = [NSString stringWithFormat:[ResourcesService localizationForKey:LocalizableKeyDeckExportErrorCardsAreNotFilled],
                         HSDECK_MAX_TOTAL_CARDS,
                         self.localDeck.hsCards.count];
    NSError *error = [NSError errorWithDomain:@"com.pookjw.StoneNamu"
                                         code:113
                                     userInfo:@{NSLocalizedDescriptionKey: message}];
    [self postErrorOccurredNotification:error];
}

@end
