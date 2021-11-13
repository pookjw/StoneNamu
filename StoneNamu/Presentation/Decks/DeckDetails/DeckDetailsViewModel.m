//
//  DeckDetailsViewModel.m
//  DeckDetailsViewModel
//
//  Created by Jinwoo Kim on 8/20/21.
//

#import "DeckDetailsViewModel.h"
#import <StoneNamuCore/StoneNamuCore.h>
#import <StoneNamuResources/StoneNamuResources.h>
#import "NSDiffableDataSourceSnapshot+sort.h"
#import "UICollectionViewDiffableDataSource+applySnapshotAndWait.h"

@interface DeckDetailsViewModel ()
@property (retain) NSOperationQueue *queue;
@property (retain) id<HSDeckUseCase> hsDeckUseCase;
@property (retain) id<LocalDeckUseCase> localDeckUseCase;
@property (retain) id<DataCacheUseCase> dataCacheUseCase;
@end

@implementation DeckDetailsViewModel

- (instancetype)initWithDataSource:(DecksDetailsDataSource *)dataSource {
    self = [self init];
    
    if (self) {
        self.contextMenuIndexPath = nil;
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
    [_contextMenuIndexPath release];
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
                        obj.hsCardCount += 1;
                        [snapshot reconfigureItemsWithIdentifiers:@[obj]];
                        
                        isDuplicated = YES;
                        *stop = YES;
                    }
                }];
                
                if (!isDuplicated) {
                    DeckDetailsItemModel *cardItemModel = [[DeckDetailsItemModel alloc] initWithType:DeckDetailsItemModelTypeCard];
                    cardItemModel.hsCard = hsCard;
                    cardItemModel.hsCardCount = 1;
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
    NSIndexPath *copyIndexPath = [indexPath copy];
    
    DeckDetailsItemModel *itemModel = [self.dataSource itemIdentifierForIndexPath:copyIndexPath];
    HSCard *copyHSCard = [itemModel.hsCard copy];
    
    [self.localDeckUseCase increaseHSCards:[NSSet setWithArray:@[copyHSCard]] toLocalDeck:self.localDeck validation:^(NSError * _Nullable error) {
        if (error != nil) {
            [self postErrorOccurredNotification:error];
        } else {
            
            NSDiffableDataSourceSnapshot *snapshot = [self.dataSource.snapshot copy];
            DeckDetailsItemModel *itemModel = [self.dataSource itemIdentifierForIndexPath:copyIndexPath];
            
            itemModel.hsCardCount += 1;
            [snapshot reconfigureItemsWithIdentifiers:@[itemModel]];
            
            [self addCostGraphItemToSnapshot:snapshot];
            [self updateCardsSectionHeaderTitleFromSnapshot:snapshot];
            [self sortSnapshot:snapshot];
            
            [self.dataSource applySnapshotAndWait:snapshot animatingDifferences:YES completion:^{
                [snapshot release];
                [self postApplyingSnapshotToDataSourceWasDoneNotification];
            }];
        }
        
        [copyIndexPath release];
    }];
    
    [copyHSCard release];
}

- (BOOL)decreaseAtIndexPath:(NSIndexPath *)indexPath {
    NSIndexPath *copyIndexPath = [indexPath copy];
    
    DeckDetailsItemModel *itemModel = [self.dataSource itemIdentifierForIndexPath:copyIndexPath];
    
    if (itemModel.hsCardCount <= 1) {
        [self deleteAtIndexPath:copyIndexPath];
        [copyIndexPath release];
        return NO;
    }
    
    HSCard *copyHSCard = [itemModel.hsCard copy];
    
    [self.localDeckUseCase decreaseHSCards:[NSSet setWithArray:@[copyHSCard]] toLocalDeck:self.localDeck validation:^(NSError * _Nullable error) {
        if (error != nil) {
            [self postErrorOccurredNotification:error];
        } else {
            
            NSDiffableDataSourceSnapshot *snapshot = [self.dataSource.snapshot copy];
            DeckDetailsItemModel *itemModel = [self.dataSource itemIdentifierForIndexPath:copyIndexPath];
            
            itemModel.hsCardCount -= 1;
            [snapshot reconfigureItemsWithIdentifiers:@[itemModel]];
            
            [self addCostGraphItemToSnapshot:snapshot];
            [self updateCardsSectionHeaderTitleFromSnapshot:snapshot];
            [self sortSnapshot:snapshot];
            
            [self.dataSource applySnapshotAndWait:snapshot animatingDifferences:YES completion:^{
                [snapshot release];
                [self postApplyingSnapshotToDataSourceWasDoneNotification];
            }];
        }
        
        [copyIndexPath release];
    }];
    
    [copyHSCard release];
    
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
    NSArray<HSCard *> *copyHSCards = [hsCards copy];
    
    [self.queue addBarrierBlock:^{
        NSDiffableDataSourceSnapshot *snapshot = [self.dataSource.snapshot copy];
        
        if (copyHSCards.count == 0) {
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
            
            for (HSCard *hsCard in copyHSCards) {
                if ([addedHSCards containsObject:hsCard]) continue;
                [addedHSCards addObject:hsCard];
                
                BOOL __block exists = NO;
                
                [snapshot.itemIdentifiers enumerateObjectsUsingBlock:^(DeckDetailsItemModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    if ([hsCard isEqual:obj.hsCard]) {
                        exists = YES;
                        *stop = YES;
                        obj.hsCardCount = [copyHSCards countOfObject:hsCard];
                        [snapshot reconfigureItemsWithIdentifiers:@[obj]];
                    }
                }];
                
                if (!exists) {
                    DeckDetailsItemModel *itemModel = [[DeckDetailsItemModel alloc] initWithType:DeckDetailsItemModelTypeCard];
                    itemModel.hsCard = hsCard;
                    itemModel.hsCardCount = [copyHSCards countOfObject:hsCard];
                    [snapshot appendItemsWithIdentifiers:@[itemModel] intoSectionWithIdentifier:sectionModel];
                    [itemModel release];
                }
            }
            
            [addedHSCards release];
            
            //
            
            NSMutableArray<DeckDetailsItemModel *> *willBeDeletedItems = [@[] mutableCopy];
            
            [snapshot.itemIdentifiers enumerateObjectsUsingBlock:^(DeckDetailsItemModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if (![copyHSCards containsObject:obj.hsCard]) {
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
        
        [copyHSCards release];
        
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
        HSCard *obj1Card = obj1.hsCard;
        HSCard *obj2Card = obj2.hsCard;
        
        return [obj1Card compare:obj2Card];
    }];
}

- (void)addCostGraphItemToSnapshot:(NSDiffableDataSourceSnapshot *)snapshot {
    NSMutableDictionary<NSNumber *, NSNumber *> *manaDictionary = [@{} mutableCopy];
    
    for (DeckDetailsItemModel *itemModel in snapshot.itemIdentifiers) {
        if (itemModel.type != DeckDetailsItemModelTypeCard) continue;
        
        @autoreleasepool {
            NSNumber *manaCost = [NSNumber numberWithUnsignedInteger:itemModel.hsCard.manaCost];
            NSNumber *count = [NSNumber numberWithUnsignedInteger:itemModel.hsCardCount];
            
            if (manaDictionary[manaCost] == nil) {
                manaDictionary[manaCost] = count;
            } else {
                NSNumber *newCount = [NSNumber numberWithUnsignedInteger:manaDictionary[manaCost].unsignedIntegerValue + count.unsignedIntegerValue];
                manaDictionary[manaCost] = newCount;
            }
        }
    }
    
    //
    
    [snapshot.sectionIdentifiers enumerateObjectsUsingBlock:^(DeckDetailsSectionModel *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj.type == DeckDetailsSectionModelTypeGraph) {
            [snapshot deleteSectionsWithIdentifiers:@[obj]];
        }
    }];
    
    //
    
    if (manaDictionary.count == 0) {
        [manaDictionary release];
        return;
    } else {
        DeckDetailsSectionModel *sectionModel = [[DeckDetailsSectionModel alloc] initWithType:DeckDetailsSectionModelTypeGraph];
        [snapshot appendSectionsWithIdentifiers:@[sectionModel]];
        
        //
        
        DeckDetailsItemModel *itemModel = [[DeckDetailsItemModel alloc] initWithType:DeckDetailsItemModelTypeCost];
        itemModel.manaDictionary = manaDictionary;
        [manaDictionary release];
        
        [snapshot appendItemsWithIdentifiers:@[itemModel] intoSectionWithIdentifier:sectionModel];
        [sectionModel release];
        [itemModel release];
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
        result += obj.hsCardCount;
    }];
    
    return result;
}

- (void)startObserving {
    [NSNotificationCenter.defaultCenter addObserver:self
                                           selector:@selector(localDeckChangesReceived:)
                                               name:LocalDeckUseCaseObserveDataNotificationName
                                             object:self.localDeckUseCase];
    
    [NSNotificationCenter.defaultCenter addObserver:self
                                           selector:@selector(localDeckDeleteAllReceived:)
                                               name:LocalDeckUseCaseDeleteAllNotificationName
                                             object:nil];
    
    [NSNotificationCenter.defaultCenter addObserver:self
                                           selector:@selector(dataCacheDeleteAllReceived:)
                                               name:DataCacheUseCaseDeleteAllNotificationName
                                             object:nil];
}

- (void)localDeckChangesReceived:(NSNotification *)notification {
    if (self.localDeck != nil) {
        [self.localDeckUseCase refreshObject:self.localDeck mergeChanges:NO completion:^{
            [self requestDataSourceWithLocalDeck:self.localDeck];
        }];
    }
}

- (void)localDeckDeleteAllReceived:(NSNotification *)notification {
    [NSNotificationCenter.defaultCenter postNotificationName:DeckDetailsViewModelShouldDismissNotificationName
                                                      object:self
                                                    userInfo:nil];
}

- (void)dataCacheDeleteAllReceived:(NSNotification *)notification {
    [NSNotificationCenter.defaultCenter postNotificationName:DeckDetailsViewModelShouldDismissNotificationName
                                                      object:self
                                                    userInfo:nil];
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
    
    [NSNotificationCenter.defaultCenter postNotificationName:DeckDetailsViewModelApplyingSnapshotToDataSourceWasDoneNotificationName
                                                      object:self
                                                    userInfo:userInfo];
    [userInfo release];
}

- (void)postDidChangeLocalDeckNameNotification:(NSString *)name {
    NSMutableDictionary *userInfo = [@{} mutableCopy];
    
    if (name) {
        userInfo[DeckDetailsViewModelDidChangeLocalDeckNameItemKey] = name;
    }
    
    [NSNotificationCenter.defaultCenter postNotificationName:DeckDetailsViewModelDidChangeLocalDeckNameNoficationName
                                                      object:self
                                                    userInfo:userInfo];
    
    [userInfo release];
}

- (void)postErrorOccurredNotification:(NSError *)error {
    [NSNotificationCenter.defaultCenter postNotificationName:DeckDetailsViewModelErrorOccurredNoficiationName
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
