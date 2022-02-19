//
//  DeckDetailsViewModel.m
//  DeckDetailsViewModel
//
//  Created by Jinwoo Kim on 8/20/21.
//

#import "DeckDetailsViewModel.h"
#import <StoneNamuResources/StoneNamuResources.h>
#import "NSDiffableDataSourceSnapshot+sort.h"
#import "UICollectionViewDiffableDataSource+applySnapshotAndWait.h"

@interface DeckDetailsViewModel ()
@property (retain) NSOperationQueue *queue;
@property (retain) id<HSDeckUseCase> hsDeckUseCase;
@property (retain) id<LocalDeckUseCase> localDeckUseCase;
@property (retain) id<DataCacheUseCase> dataCacheUseCase;
@property (retain) id<HSMetaDataUseCase> hsMetaDataUseCase;
@end

@implementation DeckDetailsViewModel

- (instancetype)initWithDataSource:(DeckDetailsDataSource *)dataSource {
    self = [self init];
    
    if (self) {
        self.contextMenuIndexPath = nil;
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
        
        HSMetaDataUseCaseImpl *hsMetaDataUseCase = [HSMetaDataUseCaseImpl new];
        self.hsMetaDataUseCase = hsMetaDataUseCase;
        [hsMetaDataUseCase release];
        
        [self startObserving];
    }
    
    return self;
}

- (void)dealloc {
    [_contextMenuIndexPath release];
    [_queue release];
    [_dataSource release];
    [_localDeck release];
    [_hsDeckUseCase release];
    [_localDeckUseCase release];
    [_dataCacheUseCase release];
    [_hsMetaDataUseCase release];
    [super dealloc];
}

- (void)addHSCards:(NSArray<HSCard *> *)hsCards {
    [self.hsMetaDataUseCase fetchWithCompletionHandler:^(HSMetaData * _Nullable hsMetaData, NSError * _Nullable error) {
        [self.localDeckUseCase addHSCards:hsCards toLocalDeck:self.localDeck validation:^(NSError * _Nullable error) {
            if (error != nil) {
                [self postErrorOccurredNotification:error];
            } else {
                [self.queue addBarrierBlock:^{
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
                    
                    for (HSCard *hsCard in hsCards) {
                        BOOL __block isDuplicated = NO;
                        
                        [[snapshot itemIdentifiersInSectionWithIdentifier:cardsSectionModel] enumerateObjectsUsingBlock:^(DeckDetailsItemModel *obj, NSUInteger idx, BOOL * _Nonnull stop) {
                            if (obj.type != DeckDetailsItemModelTypeCard) return;
                            
                            if ([hsCard isEqual:obj.hsCard]) {
                                obj.hsCardCount = [NSNumber numberWithUnsignedInteger:obj.hsCardCount.unsignedIntegerValue + 1];
                                [snapshot reconfigureItemsWithIdentifiers:@[obj]];
                                
                                isDuplicated = YES;
                                *stop = YES;
                            }
                        }];
                        
                        if (!isDuplicated) {
                            HSCardRarity * _Nullable hsCardRarity = [self.hsMetaDataUseCase hsCardRarityFromRarityId:hsCard.rarityId usingHSMetaData:hsMetaData];
                            HSCardRaritySlugType raritySlugType = hsCardRarity.slug;
                            
                            DeckDetailsItemModel *cardItemModel = [[DeckDetailsItemModel alloc] initWithType:DeckDetailsItemModelTypeCard];
                            cardItemModel.hsCard = hsCard;
                            cardItemModel.raritySlugType = raritySlugType;
                            cardItemModel.hsCardCount = @1;
                            [snapshot appendItemsWithIdentifiers:@[cardItemModel] intoSectionWithIdentifier:cardsSectionModel];
                            [cardItemModel release];
                        }
                    }
                    
                    [self addCostGraphItemToSnapshot:snapshot];
                    [self updateCardsSectionHeaderTitleFromSnapshot:snapshot];
                    [self sortSnapshot:snapshot];
                    
                    [self.dataSource applySnapshotAndWait:snapshot animatingDifferences:YES completion:^{
                        [self postApplyingSnapshotToDataSourceWasDoneNotification];
                    }];
                    [snapshot release];
                }];
            }
        }];
    }];
}

- (void)increaseAtIndexPath:(NSIndexPath *)indexPath {
    DeckDetailsItemModel *itemModel = [self.dataSource itemIdentifierForIndexPath:indexPath];
    HSCard *hsCard = itemModel.hsCard;
    
    [self.localDeckUseCase increaseHSCards:[NSSet setWithObject:hsCard] toLocalDeck:self.localDeck validation:^(NSError * _Nullable error) {
        if (error != nil) {
            [self postErrorOccurredNotification:error];
        } else {
            [self.queue addBarrierBlock:^{
                NSDiffableDataSourceSnapshot *snapshot = [self.dataSource.snapshot copy];
                DeckDetailsItemModel *itemModel = [self.dataSource itemIdentifierForIndexPath:indexPath];
                
                itemModel.hsCardCount = [NSNumber numberWithUnsignedInteger:itemModel.hsCardCount.unsignedIntegerValue + 1];
                [snapshot reconfigureItemsWithIdentifiers:@[itemModel]];
                
                [self addCostGraphItemToSnapshot:snapshot];
                [self updateCardsSectionHeaderTitleFromSnapshot:snapshot];
                [self sortSnapshot:snapshot];
                
                [self.dataSource applySnapshotAndWait:snapshot animatingDifferences:YES completion:^{
                    [self postApplyingSnapshotToDataSourceWasDoneNotification];
                }];
                [snapshot release];
            }];
        }
    }];
}

- (BOOL)decreaseAtIndexPath:(NSIndexPath *)indexPath {
    DeckDetailsItemModel *itemModel = [self.dataSource itemIdentifierForIndexPath:indexPath];
    
    if (itemModel.hsCardCount.unsignedIntegerValue <= 1) {
        [self deleteHSCards:[NSSet setWithObject:itemModel.hsCard]];
        return NO;
    }
    
    HSCard *hsCard = itemModel.hsCard;
    
    [self.localDeckUseCase decreaseHSCards:[NSSet setWithObject:hsCard] toLocalDeck:self.localDeck validation:^(NSError * _Nullable error) {
        if (error != nil) {
            [self postErrorOccurredNotification:error];
        } else {
            [self.queue addBarrierBlock:^{
                NSDiffableDataSourceSnapshot *snapshot = [self.dataSource.snapshot copy];
                DeckDetailsItemModel *itemModel = [self.dataSource itemIdentifierForIndexPath:indexPath];
                
                itemModel.hsCardCount = [NSNumber numberWithUnsignedInteger:(itemModel.hsCardCount.unsignedIntegerValue - 1)];
                [snapshot reconfigureItemsWithIdentifiers:@[itemModel]];
                
                [self addCostGraphItemToSnapshot:snapshot];
                [self updateCardsSectionHeaderTitleFromSnapshot:snapshot];
                [self sortSnapshot:snapshot];
                
                [self.dataSource applySnapshotAndWait:snapshot animatingDifferences:YES completion:^{
                    [self postApplyingSnapshotToDataSourceWasDoneNotification];
                }];
                [snapshot release];
            }];
        }
    }];
    
    return YES;
}

- (void)deleteAtIndexPathes:(NSSet<NSIndexPath *> *)indexPathes {
    NSMutableSet<HSCard *> *hsCards = [NSMutableSet<HSCard *> new];
    
    [indexPathes enumerateObjectsUsingBlock:^(NSIndexPath * _Nonnull obj, BOOL * _Nonnull stop) {
        DeckDetailsItemModel *itemModel = [self.dataSource itemIdentifierForIndexPath:obj];
        [hsCards addObject:itemModel.hsCard];
    }];
    
    [self deleteHSCards:hsCards];
    [hsCards autorelease];
}

- (void)deleteHSCards:(NSSet<HSCard *> *)hsCards {
    [self.localDeckUseCase deleteHSCards:hsCards toLocalDeck:self.localDeck validation:^(NSError * _Nullable error) {
        if (error != nil) {
            [self postErrorOccurredNotification:error];
        } else {
            [self.queue addBarrierBlock:^{
                NSDiffableDataSourceSnapshot *snapshot = [self.dataSource.snapshot copy];
                
                [snapshot.itemIdentifiers enumerateObjectsUsingBlock:^(DeckDetailsItemModel *obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    if (obj.type != DeckDetailsItemModelTypeCard) return;
                    
                    if ([hsCards containsObject:obj.hsCard]) {
                        [snapshot deleteItemsWithIdentifiers:@[obj]];
                    }
                }];
                
                [self addCostGraphItemToSnapshot:snapshot];
                [self updateCardsSectionHeaderTitleFromSnapshot:snapshot];
                [self sortSnapshot:snapshot];
                
                [self.dataSource applySnapshotAndWait:snapshot animatingDifferences:YES completion:^{
                    [self postApplyingSnapshotToDataSourceWasDoneNotification];
                }];
                [snapshot release];
            }];
        }
    }];
}

- (NSArray<UIDragItem *> *)makeDragItemFromIndexPath:(NSIndexPath *)indexPath {
    DeckDetailsItemModel * _Nullable itemModel = [self.dataSource itemIdentifierForIndexPath:indexPath];
    
    if (itemModel == nil) {
        return @[];
    }
    
    if (itemModel.type != DeckDetailsItemModelTypeCard) {
        return @[];
    }
    
    NSItemProvider *itemProvider = [[NSItemProvider alloc] initWithObject:itemModel.hsCard];
    UIDragItem *dragItem = [[UIDragItem alloc] initWithItemProvider:itemProvider];
    [itemProvider release];
    
    return @[[dragItem autorelease]];
}

- (void)exportLocalizedDeckCodeWithCompletion:(DeckDetailsViewModelExportDeckCodeCompletion)completion {
    [self.queue addBarrierBlock:^{
        if (self.localDeck.hsCards.count < HSDECK_MAX_TOTAL_CARDS) {
            [self postCardsAreNotFilledNotification];
            completion(nil);
            return;
        }
        
        [self.hsMetaDataUseCase fetchWithCompletionHandler:^(HSMetaData * _Nullable hsMetaData, NSError * _Nullable error) {
            [self.hsDeckUseCase fetchDeckByCardList:self.localDeck.hsCardIds
                                            classId:self.localDeck.classId
                                         completion:^(HSDeck * _Nullable hsDeck, NSError * _Nullable error) {
                if (error) {
                    [self postErrorOccurredNotification:error];
                } else if (hsDeck.deckCode) {
                    [self.queue addBarrierBlock:^{
                        [self.localDeck setValuesAsHSDeck:hsDeck];
                        [self.localDeck updateTimestamp];
                        [self.localDeckUseCase saveChanges];
                        
                        HSCardClass *hsCardClass = [self.hsMetaDataUseCase hsCardClassFromClassId:self.localDeck.classId usingHSMetaData:hsMetaData];
                        
                        completion([ResourcesService localizationForHSDeck:hsDeck title:self.localDeck.name className:hsCardClass.name]);
                    }];
                } else {
                    NSError *error = [NSError errorWithDomain:@"com.pookjw.StoneNamu" code:105 userInfo:@{NSLocalizedDescriptionKey: [ResourcesService localizationForKey:LocalizableKeyDeckcodeFetchError]}];
                    [self postErrorOccurredNotification:error];
                }
            }];
        }];
    }];
}

- (void)updateDeckName:(NSString *)name {
    self.localDeck.name = name;
    [self postDidChangeLocalDeckNameNotification:name];
    [self.localDeck updateTimestamp];
    [self.localDeckUseCase saveChanges];
}

- (void)requestDataSourceFromLocalDeck:(LocalDeck *)localDeck {
    [localDeck retain];
    [self->_localDeck release];
    self->_localDeck = localDeck;
    
    [self.queue addBarrierBlock:^{
        [self updateDataSourceWithHSCards:localDeck.hsCards];
        [self postDidChangeLocalDeckNameNotification:localDeck.name];
    }];
}

- (void)updateDataSourceWithHSCards:(NSArray<HSCard *> *)hsCards {
    [self.hsMetaDataUseCase fetchWithCompletionHandler:^(HSMetaData * _Nullable hsMetaData, NSError * _Nullable error) {
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
                    sectionModel = [[DeckDetailsSectionModel alloc] initWithType:DeckDetailsSectionModelTypeCards];
                    [snapshot appendSectionsWithIdentifiers:@[sectionModel]];
                    [sectionModel autorelease];
                }
                
                //
                
                NSMutableArray<HSCard *> *addedHSCards = [@[] mutableCopy];
                
                for (HSCard *hsCard in hsCards) {
                    if ([addedHSCards containsObject:hsCard]) continue;
                    [addedHSCards addObject:hsCard];
                    
                    BOOL __block exists = NO;
                    
                    [[snapshot itemIdentifiersInSectionWithIdentifier:sectionModel] enumerateObjectsUsingBlock:^(DeckDetailsItemModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                        if ([hsCard isEqual:obj.hsCard]) {
                            exists = YES;
                            *stop = YES;
                            
                            NSUInteger hsCardCount = [hsCards countOfObject:hsCard];
                            
                            if (obj.hsCardCount.unsignedIntegerValue != hsCardCount) {
                                obj.hsCardCount = [NSNumber numberWithUnsignedInteger:hsCardCount];
                                [snapshot reconfigureItemsWithIdentifiers:@[obj]];
                            }
                        }
                    }];
                    
                    if (!exists) {
                        HSCardRarity * _Nullable hsCardRarity = [self.hsMetaDataUseCase hsCardRarityFromRarityId:hsCard.rarityId usingHSMetaData:hsMetaData];
                        HSCardRaritySlugType raritySlugType = hsCardRarity.slug;

                        DeckDetailsItemModel *itemModel = [[DeckDetailsItemModel alloc] initWithType:DeckDetailsItemModelTypeCard];
                        itemModel.hsCard = hsCard;
                        itemModel.raritySlugType = raritySlugType;
                        itemModel.hsCardCount = [NSNumber numberWithUnsignedInteger:[hsCards countOfObject:hsCard]];
                        [snapshot appendItemsWithIdentifiers:@[itemModel] intoSectionWithIdentifier:sectionModel];
                        [itemModel release];
                    }
                }
                
                [addedHSCards release];
                
                //
                
                NSMutableArray<DeckDetailsItemModel *> *willBeDeletedItems = [@[] mutableCopy];
                
                [[snapshot itemIdentifiersInSectionWithIdentifier:sectionModel] enumerateObjectsUsingBlock:^(DeckDetailsItemModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    if (![hsCards containsObject:obj.hsCard]) {
                        [snapshot deleteItemsWithIdentifiers:@[obj]];
                    }
                }];
                
                [snapshot deleteItemsWithIdentifiers:willBeDeletedItems];
                [willBeDeletedItems release];
            }
            
            [self addCostGraphItemToSnapshot:snapshot];
            [self updateCardsSectionHeaderTitleFromSnapshot:snapshot];
            [self sortSnapshot:snapshot];
            
            //
            
            [self.dataSource applySnapshotAndWait:snapshot animatingDifferences:YES completion:^{
                [self postApplyingSnapshotToDataSourceWasDoneNotification];
            }];
            [snapshot release];
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
    
    for (NSUInteger i = 0; i <= 10; i++) {
        manaDictionary[[NSNumber numberWithUnsignedInteger:i]] = @0;
    }
    
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
    
    if (manaDictionary.count == 0) {
        [manaDictionary release];
        return;
    } else {
        DeckDetailsSectionModel * __block _Nullable sectionModel = nil;
        
        [snapshot.sectionIdentifiers enumerateObjectsUsingBlock:^(DeckDetailsSectionModel *obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if (obj.type == DeckDetailsSectionModelTypeManaCostGraph) {
                sectionModel = obj;
                *stop = YES;
            }
        }];
        
        if (sectionModel == nil) {
            sectionModel = [[DeckDetailsSectionModel alloc] initWithType:DeckDetailsSectionModelTypeManaCostGraph];
            [snapshot appendSectionsWithIdentifiers:@[sectionModel]];
            [sectionModel autorelease];
        }
        
        //
        
        [manaDictionary enumerateKeysAndObjectsUsingBlock:^(NSNumber * _Nonnull key, NSNumber * _Nonnull obj1, BOOL * _Nonnull stop) {
            BOOL __block hasItemModel = NO;
            
            [snapshot.itemIdentifiers enumerateObjectsUsingBlock:^(DeckDetailsItemModel * _Nonnull obj2, NSUInteger idx, BOOL * _Nonnull stop) {
                if (obj2.type != DeckDetailsItemModelTypeManaCostGraph) return;
                
                if ([key isEqualToNumber:obj2.graphManaCost]) {
                    if (highestCostCount == 0) {
                        obj2.graphPercentage = [NSNumber numberWithFloat:0.0f];
                    } else {
                        obj2.graphPercentage = [NSNumber numberWithFloat:(obj1.floatValue / (float)highestCostCount)];
                    }

                    obj2.graphCount = obj1;

                    [snapshot reconfigureItemsWithIdentifiers:@[obj2]];

                    hasItemModel = YES;
                    *stop = YES;
                }
            }];
            
//            [[snapshot itemIdentifiersInSectionWithIdentifier:sectionModel] enumerateObjectsUsingBlock:^(DeckDetailsItemModel * _Nonnull obj2, NSUInteger idx, BOOL * _Nonnull stop) {
//                if ([key isEqualToNumber:obj2.graphManaCost]) {
//                    if (highestCostCount == 0) {
//                        obj2.graphPercentage = [NSNumber numberWithFloat:0.0f];
//                    } else {
//                        obj2.graphPercentage = [NSNumber numberWithFloat:(obj1.floatValue / (float)highestCostCount)];
//                    }
//
//                    obj2.graphCount = obj1;
//
//                    [snapshot reconfigureItemsWithIdentifiers:@[obj2]];
//
//                    hasItemModel = YES;
//                    *stop = YES;
//                }
//            }];
            
            if (!hasItemModel) {
                DeckDetailsItemModel *itemModel = [[DeckDetailsItemModel alloc] initWithType:DeckDetailsItemModelTypeManaCostGraph];
                
                itemModel.graphManaCost = key;
                
                if (highestCostCount == 0) {
                    itemModel.graphPercentage = [NSNumber numberWithFloat:0.0f];
                } else {
                    itemModel.graphPercentage = [NSNumber numberWithFloat:(obj1.floatValue / (float)highestCostCount)];
                }
                
                itemModel.graphCount = obj1;
                
                [snapshot appendItemsWithIdentifiers:@[itemModel] intoSectionWithIdentifier:sectionModel];
                
                [itemModel release];
            }
        }];
        
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
                [self requestDataSourceFromLocalDeck:self.localDeck];
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
