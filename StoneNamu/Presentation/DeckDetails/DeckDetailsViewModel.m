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
            if (![hsCard isKindOfClass:[HSCard class]]) continue;
            DeckDetailsItemModel *cardItemModel = [[DeckDetailsItemModel alloc] initWithType:DeckDetailsItemModelTypeCard];
            cardItemModel.hsCard = hsCard;
            [cardsItemModels addObject:cardItemModel];
            [cardItemModel release];
        }
        
        [snapshot appendItemsWithIdentifiers:cardsItemModels intoSectionWithIdentifier:cardsSectionModel];
        [cardsItemModels release];

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

- (void)removeAtIndexPath:(NSIndexPath *)indexPath {
    HSCard * _Nullable hsCard = [self.dataSource itemIdentifierForIndexPath:indexPath].hsCard;
    
    if (hsCard) {
        [self removeHSCard:hsCard];
    }
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
                
                [mutableCards enumerateObjectsUsingBlock:^(NSNumber * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    if (obj.unsignedIntegerValue == copyHSCard.cardId) {
                        [mutableCards removeObject:obj];
                        *stop = YES;
                    }
                }];
                
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
            DeckDetailsItemModel *cardItemModel = [[DeckDetailsItemModel alloc] initWithType:DeckDetailsItemModelTypeCard];
            cardItemModel.hsCard = hsCard;
            [cardItemModels addObject:cardItemModel];
            [cardItemModel release];
        }
        
        [snapshot appendItemsWithIdentifiers:cardItemModels intoSectionWithIdentifier:cardsSectionModel];
        
        //
        
        [snapshot sortItemsWithSectionIdentifiers:@[cardsSectionModel] usingComparator:^NSComparisonResult(DeckDetailsItemModel *obj1, DeckDetailsItemModel *obj2) {
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
