//
//  DeckDetailsViewModel.m
//  DeckDetailsViewModel
//
//  Created by Jinwoo Kim on 8/20/21.
//

#import "DeckDetailsViewModel.h"
#import "HSDeckUseCaseImpl.h"
#import "LocalDeckUseCaseImpl.h"
#import "HSCardUseCaseImpl.h"
#import "NSSemaphoreCondition.h"
#import "NSDiffableDataSourceSnapshot+sort.h"
#import "NSMutableArray+removeSingle.h"

@interface DeckDetailsViewModel ()
@property (retain) NSOperationQueue *queue;
@property (retain) id<HSDeckUseCase> hsDeckUseCase;
@property (retain) id<LocalDeckUseCase> localDeckUseCase;
@property (retain) id<HSCardUseCase> hsCardUseCase;
@end

@implementation DeckDetailsViewModel

- (instancetype)initWithDataSource:(DecksDetailsDataSource *)dataSource {
    self = [self init];
    
    if (self) {
        self.dataSource = dataSource;
        
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
        
        HSCardUseCaseImpl *hsCardUseCase = [HSCardUseCaseImpl new];
        self.hsCardUseCase = hsCardUseCase;
        [hsCardUseCase release];
        
        [self startLocalDeckObserving];
    }
    
    return self;
}

- (void)dealloc {
    [_queue release];
    [_dataSource release];
    [_localDeck release];
    [_hsDeckUseCase release];
    [_localDeckUseCase release];
    [_hsCardUseCase release];
    [super dealloc];
}

- (void)addHSCards:(NSArray<HSCard *> *)hsCards {
    NSArray<HSCard *> *copyHSCards = [hsCards copy];

    [self.queue addBarrierBlock:^{
        if (([self totalCardsInSnapshot:self.dataSource.snapshot] + copyHSCards.count) > HSDECK_MAX_TOTAL_CARDS) {
            [copyHSCards release];
            NSError *error = [NSError errorWithDomain:@"com.pookjw.StoneNamu"
                                                 code:109
                                             userInfo:@{NSLocalizedDescriptionKey: NSLocalizedString(@"DECK_ADD_CARD_ERROR_NO_MORE_THAN_THIRTY_CARDS", @"")}];
            [self postErrorOccuredNotification:error];
            return;
        }
        
        NSDiffableDataSourceSnapshot *snapshot = [self.dataSource.snapshot copy];

        DeckDetailsSectionModel * _Nullable cardsSectionModel = nil;

        for (DeckDetailsSectionModel *tmp in snapshot.sectionIdentifiers) {
            if (tmp.type == DeckDetailsSectionModelTypeCards) {
                cardsSectionModel = tmp;
                break;
            }
        }

        if (cardsSectionModel == nil) {
            [copyHSCards release];
            [snapshot release];
            return;
        }
        
        //
        
        NSMutableArray<DeckDetailsItemModel *> *cardsItemModels = [@[] mutableCopy];
        
        for (HSCard *hsCard in copyHSCards) {
            BOOL __block isDuplicated = NO;
            
            [snapshot.itemIdentifiers enumerateObjectsUsingBlock:^(DeckDetailsItemModel *obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if ([obj.hsCard isEqual:hsCard]) {
                    
                    if ((obj.hsCard.rarityId == HSCardRarityLegendary) && (obj.hsCardCount >= HSDECK_MAX_SINGLE_LEGENDARY_CARD)) {
                        NSLog(@"Duplicated legenday card was detected!");
                    } else if (obj.hsCardCount >= HSDECK_MAX_SINGLE_CARD) {
                        NSLog(@"Duplicated card was detected!");
                    } else {
                        DeckDetailsItemModel *copy = [obj copy];
                        copy.hsCardCount += 1;
                        
                        /*
                         if hsCardCount is changed, isEqual ans hash value will be changed. So reload or reconfigure won't work.
                         */
                        [snapshot deleteItemsWithIdentifiers:@[obj]];
                        [snapshot appendItemsWithIdentifiers:@[copy] intoSectionWithIdentifier:cardsSectionModel];
                        [copy release];
                    }
                    
                    isDuplicated = YES;
                    *stop = YES;
                }
            }];
            
            if (!isDuplicated) {
                DeckDetailsItemModel *cardItemModel = [[DeckDetailsItemModel alloc] initWithType:DeckDetailsItemModelTypeCard];
                cardItemModel.hsCard = hsCard;
                cardItemModel.hsCardCount = 1;
                [cardsItemModels addObject:cardItemModel];
                [cardItemModel release];
            }
        }
        
        if (cardsItemModels.count == 0) {
            [copyHSCards release];
            [cardsItemModels release];
            [snapshot release];
            return;
        }
        
        //
        
        [snapshot appendItemsWithIdentifiers:cardsItemModels intoSectionWithIdentifier:cardsSectionModel];
        [cardsItemModels release];
        [self sortSnapshot:snapshot sectionModel:cardsSectionModel];

        [NSOperationQueue.mainQueue addOperationWithBlock:^{
            [self.dataSource applySnapshot:snapshot animatingDifferences:YES completion:^{
                [snapshot release];
                
                NSMutableArray<NSNumber *> *mutableCardIds = [self.localDeck.cards mutableCopy];
                for (HSCard *hsCard in copyHSCards) {
                    [mutableCardIds addObject:[NSNumber numberWithUnsignedInteger:hsCard.cardId]];
                }
                self.localDeck.cards = mutableCardIds;
                [mutableCardIds release];
                self.localDeck.deckCode = nil;
                [self.localDeck updateTimestamp];
                [self.localDeckUseCase saveChanges];
                
                [copyHSCards release];
            }];
        }];
    }];
}

- (void)removeHSCard:(HSCard *)hsCard {
    HSCard *copyHSCard = [hsCard copy];
    
    [self.queue addBarrierBlock:^{
        NSDiffableDataSourceSnapshot *snapshot = [self.dataSource.snapshot copy];
        
        [snapshot.itemIdentifiers enumerateObjectsUsingBlock:^(DeckDetailsItemModel *obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj.hsCard isEqual:copyHSCard]) {
                [snapshot deleteItemsWithIdentifiers:@[obj]];
                *stop = YES;
            }
        }];
        
        [NSOperationQueue.mainQueue addOperationWithBlock:^{
            [self.dataSource applySnapshot:snapshot animatingDifferences:YES completion:^{
                [snapshot release];
                
                NSMutableArray<NSNumber *> *mutableCards = [self.localDeck.cards mutableCopy];
                [mutableCards removeSingleObject:[NSNumber numberWithUnsignedInteger:copyHSCard.cardId]];
                
                self.localDeck.cards = mutableCards;
                [mutableCards release];
                self.localDeck.deckCode = nil;
                [self.localDeck updateTimestamp];
                [self.localDeckUseCase saveChanges];
                
                [copyHSCard release];
            }];
        }];
    }];
}

- (void)increaseAtIndexPath:(NSIndexPath *)indexPath {
    [self.queue addBarrierBlock:^{
        if (([self totalCardsInSnapshot:self.dataSource.snapshot]) >= HSDECK_MAX_TOTAL_CARDS) {
            NSError *error = [NSError errorWithDomain:@"com.pookjw.StoneNamu"
                                                 code:109
                                             userInfo:@{NSLocalizedDescriptionKey: NSLocalizedString(@"DECK_ADD_CARD_ERROR_NO_MORE_THAN_THIRTY_CARDS", @"")}];
            [self postErrorOccuredNotification:error];
            return;
        }
        
        //
        
        DeckDetailsItemModel *itemModel = [self.dataSource itemIdentifierForIndexPath:indexPath];
        
        if ((itemModel.hsCard.rarityId == HSCardRarityLegendary) && (itemModel.hsCardCount >= HSDECK_MAX_SINGLE_LEGENDARY_CARD)) {
            NSError *error = [NSError errorWithDomain:@"com.pookjw.StoneNamu"
                                                 code:107
                                             userInfo:@{NSLocalizedDescriptionKey: NSLocalizedString(@"DECK_ADD_CARD_ERROR_CANNOT_ADD_SINGLE_LAGENDARY_CARD_MORE_THAN_TWO", @"")}];
            [self postErrorOccuredNotification:error];
            return;
        } else if (itemModel.hsCardCount >= HSDECK_MAX_SINGLE_CARD) {
            NSError *error = [NSError errorWithDomain:@"com.pookjw.StoneNamu"
                                                 code:108
                                             userInfo:@{NSLocalizedDescriptionKey: NSLocalizedString(@"DECK_ADD_CARD_ERROR_CANNOT_ADD_SINGLE_CARD_MORE_THAN_TWO", @"")}];
            [self postErrorOccuredNotification:error];
            return;
        }
        
        NSDiffableDataSourceSnapshot *snapshot = [self.dataSource.snapshot copy];
            
        DeckDetailsSectionModel *sectionModel;
        if (@available(iOS 15.0, *)) {
            sectionModel = [self.dataSource sectionIdentifierForIndex:indexPath.section];
        } else {
            sectionModel = [snapshot sectionIdentifierForSectionContainingItemIdentifier:itemModel];
        }
        
        //
        
        DeckDetailsItemModel *copy = [itemModel copy];
        copy.hsCardCount += 1;
        
        [snapshot deleteItemsWithIdentifiers:@[itemModel]];
        [snapshot appendItemsWithIdentifiers:@[copy] intoSectionWithIdentifier:sectionModel];
        
        [self sortSnapshot:snapshot sectionModel:sectionModel];
        
        [NSOperationQueue.mainQueue addOperationWithBlock:^{
            [self.dataSource applySnapshot:snapshot animatingDifferences:YES completion:^{
                [snapshot release];
                
                NSMutableArray *localDeckCards = [self.localDeck.cards mutableCopy];
                [localDeckCards addObject:[NSNumber numberWithUnsignedInteger:copy.hsCard.cardId]];
                self.localDeck.cards = localDeckCards;
                self.localDeck.deckCode = nil;
                [self.localDeck updateTimestamp];
                [localDeckCards release];
                [copy release];
                
                [self.localDeckUseCase saveChanges];
            }];
        }];
    }];
}

- (void)decreaseAtIndexPath:(NSIndexPath *)indexPath {
    [self.queue addBarrierBlock:^{
        DeckDetailsItemModel *itemModel = [self.dataSource itemIdentifierForIndexPath:indexPath];
        
        if (itemModel.hsCardCount <= 1) {
            [self removeAtIndexPath:indexPath];
            return;
        }
        
        NSDiffableDataSourceSnapshot *snapshot = [self.dataSource.snapshot copy];
            
        DeckDetailsSectionModel *sectionModel;
        if (@available(iOS 15.0, *)) {
            sectionModel = [self.dataSource sectionIdentifierForIndex:indexPath.section];
        } else {
            sectionModel = [snapshot sectionIdentifierForSectionContainingItemIdentifier:itemModel];
        }
        
        //
        
        DeckDetailsItemModel *copy = [itemModel copy];
        copy.hsCardCount -= 1;
        
        [snapshot deleteItemsWithIdentifiers:@[itemModel]];
        [snapshot appendItemsWithIdentifiers:@[copy] intoSectionWithIdentifier:sectionModel];
        
        [self sortSnapshot:snapshot sectionModel:sectionModel];
        
        [NSOperationQueue.mainQueue addOperationWithBlock:^{
            [self.dataSource applySnapshot:snapshot animatingDifferences:YES completion:^{
                [snapshot release];
                
                NSMutableArray *localDeckCards = [self.localDeck.cards mutableCopy];
                [localDeckCards removeSingleObject:[NSNumber numberWithUnsignedInteger:copy.hsCard.cardId]];
                
                self.localDeck.cards = localDeckCards;
                self.localDeck.deckCode = nil;
                [self.localDeck updateTimestamp];
                [localDeckCards release];
                [copy release];
                
                [self.localDeckUseCase saveChanges];
            }];
        }];
    }];
}

- (void)removeAtIndexPath:(NSIndexPath *)indexPath {
    HSCard * _Nullable hsCard = [self.dataSource itemIdentifierForIndexPath:indexPath].hsCard;
    
    if (hsCard) {
        [self removeHSCard:hsCard];
    }
}

- (NSArray<UIDragItem *> *)makeDragItemFromIndexPath:(NSIndexPath *)indexPath {
    DeckDetailsItemModel * _Nullable itemModel = [self.dataSource itemIdentifierForIndexPath:indexPath];
    
    if (itemModel == nil) return @[];
    
    NSItemProvider *itemProvider = [NSItemProvider new];
    UIDragItem *dragItem = [[UIDragItem alloc] initWithItemProvider:itemProvider];
    [itemProvider release];
    
    dragItem.localObject = itemModel.hsCard;
    
    return @[[dragItem autorelease]];
}

- (void)exportDeckCodeWithCompletion:(DeckDetailsViewModelExportDeckCodeCompletion)completion {
    [self.hsDeckUseCase fetchDeckByCardList:self.localDeck.cards completion:^(HSDeck * _Nullable hsDeck, NSError * _Nullable error) {
        if (error) {
            [self postErrorOccuredNotification:error];
        } else if (hsDeck.deckCode) {
            self.localDeck.deckCode = hsDeck.deckCode;
            completion(hsDeck.deckCode);
        } else {
            NSError *error = [NSError errorWithDomain:@"com.pookjw.StoneNamy" code:105 userInfo:@{NSLocalizedDescriptionKey: NSLocalizedString(@"DECKCODE_FETCH_ERROR", @"")}];
            [self postErrorOccuredNotification:error];
        }
    }];
}

- (void)updateDeckName:(NSString *)name {
    self.localDeck.name = name;
    [self.localDeckUseCase saveChanges];
}

- (void)requestDataSourcdWithLocalDeck:(LocalDeck *)localDeck {
    [self->_localDeck release];
    self->_localDeck = [localDeck retain];
    
    [self.queue addBarrierBlock:^{
        if (localDeck.deckCode) {
            NSString *deckCode = [localDeck.deckCode copy];
            [self.hsDeckUseCase fetchDeckByDeckCode:localDeck.deckCode completion:^(HSDeck * _Nullable hsDeck, NSError * _Nullable error) {
                
                [deckCode release];
                
                if (error) {
                    NSLog(@"%@", error.localizedDescription);
                    return;
                }
                
                [self updateDataSourceWithHSDeck:hsDeck];
            }];
        } else if (localDeck.cards) {
            [self updateDataSourceWithCardIds:localDeck.cards];
        } else {
            [self updateDataSourceWithHSCards:@[]];
        }
        
        [self postDidChangeLocalDeckNameNotification:localDeck.name];
    }];
}

- (void)updateDataSourceWithCardIds:(NSArray<NSNumber *> *)cardIds {
    NSArray<NSNumber *> *copyCardIds = [cardIds copy];
    NSSemaphoreCondition *semaphore = [[NSSemaphoreCondition alloc] initWithValue:-(copyCardIds.count) + 1];
    NSMutableArray<HSCard *> *hsCards = [@[] mutableCopy];
    
    for (NSNumber *cardId in copyCardIds) {
        [self.hsCardUseCase fetchWithIdOrSlug:cardId.stringValue withOptions:nil completionHandler:^(HSCard * _Nullable hsCard, NSError * _Nullable error) {
            if (error) {
                NSLog(@"%@", error.localizedDescription);
            } else if (hsCard) {
                [hsCards addObject:hsCard];
            }
            
            [semaphore signal];
        }];
    }
    
    [semaphore wait];
    [semaphore release];
    [copyCardIds release];
    
    [self updateDataSourceWithHSCards:hsCards];
    [hsCards release];
}

- (void)updateDataSourceWithHSDeck:(HSDeck *)hsDeck {
    [self updateDataSourceWithHSCards:hsDeck.cards];
}

- (void)updateDataSourceWithHSCards:(NSArray<HSCard *> *)hsCards {
    NSArray<HSCard *> *copyHSCards = [hsCards copy];
    
    [self.queue addBarrierBlock:^{
        NSDiffableDataSourceSnapshot *snapshot = [self.dataSource.snapshot copy];
        
        [snapshot deleteAllItems];
        
        //
        
        DeckDetailsSectionModel *cardsSectionModel = [[DeckDetailsSectionModel alloc] initWithType:DeckDetailsSectionModelTypeCards];
        [snapshot appendSectionsWithIdentifiers:@[cardsSectionModel]];
        
        NSMutableArray<DeckDetailsItemModel *> *cardItemModels = [@[] mutableCopy];
        
        for (HSCard *hsCard in copyHSCards) {
            BOOL __block isDuplicated = NO;
            [cardItemModels enumerateObjectsUsingBlock:^(DeckDetailsItemModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if ([obj.hsCard isEqual:hsCard]) {
                    isDuplicated = YES;
                    obj.hsCardCount += 1;
                    *stop = YES;
                }
            }];
            
            if (!isDuplicated) {
                DeckDetailsItemModel *cardItemModel = [[DeckDetailsItemModel alloc] initWithType:DeckDetailsItemModelTypeCard];
                cardItemModel.hsCard = hsCard;
                cardItemModel.hsCardCount = 1;
                [cardItemModels addObject:cardItemModel];
                [cardItemModel release];
            }
        }
        
        [snapshot appendItemsWithIdentifiers:cardItemModels intoSectionWithIdentifier:cardsSectionModel];
        
        //
        
        [self sortSnapshot:snapshot sectionModel:cardsSectionModel];
        
        //
        
        [cardsSectionModel release];
        [cardItemModels release];
        
        //
        
        [NSOperationQueue.mainQueue addOperationWithBlock:^{
            [self.dataSource applySnapshot:snapshot animatingDifferences:YES completion:^{
                [snapshot release];
                
                [self postHasAnyCardsNotification:(copyHSCards.count > 0)];
                [copyHSCards release];
            }];
        }];
    }];
}

- (void)sortSnapshot:(NSDiffableDataSourceSnapshot *)snapshot sectionModel:(DeckDetailsSectionModel *)sectionModel {
    [snapshot sortItemsWithSectionIdentifiers:@[sectionModel] usingComparator:^NSComparisonResult(DeckDetailsItemModel *obj1, DeckDetailsItemModel *obj2) {
        HSCard *obj1Card = obj1.hsCard;
        HSCard *obj2Card = obj2.hsCard;
        
        if (obj1Card.manaCost < obj2Card.manaCost) {
            return NSOrderedAscending;
        } else if (obj1Card.manaCost > obj2Card.manaCost) {
            return NSOrderedDescending;
        } else {
            if ((obj1Card.name == nil) && (obj2Card.name == nil)) {
                return NSOrderedSame;
            } else if ((obj1Card.name == nil) && (obj2Card.name != nil)) {
                return NSOrderedAscending;
            } else if ((obj1Card.name != nil) && (obj2Card.name == nil)) {
                return NSOrderedDescending;
            } else {
                return [obj1Card.name compare:obj2Card.name];
            }
        }
    }];
}

- (NSUInteger)totalCardsInSnapshot:(NSDiffableDataSourceSnapshot *)snapshot {
    NSUInteger __block result = 0;
    
    [snapshot.itemIdentifiers enumerateObjectsUsingBlock:^(DeckDetailsItemModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        result += obj.hsCardCount;
    }];
    
    return result;
}

- (void)startLocalDeckObserving {
    [NSNotificationCenter.defaultCenter addObserver:self
                                           selector:@selector(localDeckChangesReceived:)
                                               name:LocalDeckUseCaseObserveDataNotificationName
                                             object:self.localDeckUseCase];
    
    [NSNotificationCenter.defaultCenter addObserver:self
                                           selector:@selector(localDeckDeleteAllReceived:)
                                               name:LocalDeckUseCaseDeleteAllNotificationName
                                             object:nil];
}

- (void)localDeckChangesReceived:(NSNotification *)notification {
    [self.localDeckUseCase fetchWithObjectId:self.localDeck.objectID completion:^(LocalDeck * _Nullable localDeck) {
        [self requestDataSourcdWithLocalDeck:localDeck];
    }];
}

- (void)localDeckDeleteAllReceived:(NSNotification *)notification {
    [NSNotificationCenter.defaultCenter postNotificationName:DeckDetailsViewModelShouldDismissNotificationName
                                                      object:self
                                                    userInfo:nil];
}

- (void)postHasAnyCardsNotification:(BOOL)hasCards {
    [NSNotificationCenter.defaultCenter postNotificationName:DeckDetailsViewModelHasAnyCardsNotificationName
                                                      object:self
                                                    userInfo:@{DeckDetailsViewModelHasAnyCardsItemKey: [NSNumber numberWithBool:hasCards]}];
}

- (void)postDidChangeLocalDeckNameNotification:(NSString *)name {
    [NSNotificationCenter.defaultCenter postNotificationName:DeckDetailsViewModelDidChangeLocalDeckNameNoficationName
                                                      object:self
                                                    userInfo:@{DeckDetailsViewModelDidChangeLocalDeckNameItemKey: name}];
}

- (void)postErrorOccuredNotification:(NSError *)error {
    [NSNotificationCenter.defaultCenter postNotificationName:DeckDetailsViewModelErrorOccuredNoficiationName
                                                      object:self
                                                    userInfo:@{DeckDetailsViewModelErrorOccuredItemKey: error}];
}

@end
