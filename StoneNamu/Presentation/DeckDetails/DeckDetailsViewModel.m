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

@interface DeckDetailsViewModel ()
@property (retain) LocalDeck *localDeck;
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
        
        for (DeckDetailsItemModel *itemModel in snapshot.itemIdentifiers) {
            if ([itemModel.hsCard isEqual:copyHSCard]) {
                [snapshot deleteItemsWithIdentifiers:@[itemModel]];
            }
        }
        
        [NSOperationQueue.mainQueue addOperationWithBlock:^{
            [self.dataSource applySnapshot:snapshot animatingDifferences:YES completion:^{
                [snapshot release];
                
                NSMutableArray<NSNumber *> *mutableCards = [self.localDeck.cards mutableCopy];
                
                [mutableCards enumerateObjectsUsingBlock:^(NSNumber * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    if ([obj isEqualToNumber:[NSNumber numberWithUnsignedInteger:copyHSCard.cardId]]) {
                        [mutableCards removeObject:obj];
                    }
                }];
                
                self.localDeck.cards = mutableCards;
                [mutableCards release];
                self.localDeck.deckCode = nil;
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
        if (hsDeck.deckCode) {
            self.localDeck.deckCode = hsDeck.deckCode;
            completion(hsDeck.deckCode, error);
        } else {
            NSError *error = [NSError errorWithDomain:@"com.pookjw.StoneNamy" code:105 userInfo:@{NSLocalizedDescriptionKey: NSLocalizedString(@"DECKCODE_FETCH_ERROR", @"")}];
            completion(nil, error);
        }
    }];
}

- (void)requestDataSourcdWithLocalDeck:(LocalDeck *)localDeck {
    self.localDeck = localDeck;
    
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
            NSArray<NSNumber *> *cardIds = [localDeck.cards copy];
            NSSemaphoreCondition *semaphore = [[NSSemaphoreCondition alloc] initWithValue:-(cardIds.count) + 1];
            NSMutableArray<HSCard *> *hsCards = [@[] mutableCopy];
            
            for (NSNumber *cardId in cardIds) {
                [self.hsCardUseCase fetchWithIdOrSlug:cardId.stringValue withOptions:nil completionHandler:^(HSCard * _Nullable hsCard, NSError * _Nullable error) {
                    if (error) {
                        NSLog(@"%@", error.localizedDescription);
                    } else if (hsCard) {
                        HSCard *copyCard = [hsCard copy];
                        [hsCards addObject:copyCard];
                        [copyCard release];
                    }
                    
                    [semaphore signal];
                }];
            }
            
            [semaphore wait];
            [semaphore release];
            
            NSArray<HSCard *> *results = [hsCards copy];
            [cardIds release];
            [hsCards release];
            
            [self updateDataSourceWithHSCards:results];
            [results autorelease];
        } else {
            [self updateDataSourceWithHSCards:@[]];
        }
    }];
}

- (void)updateDataSourceWithHSDeck:(HSDeck *)hsDeck {
    HSDeck *copyHSDeck = [hsDeck copy];
    
    [self.queue addBarrierBlock:^{
        NSDiffableDataSourceSnapshot *snapshot = [self.dataSource.snapshot copy];
        
        [snapshot deleteAllItems];
        
        //
        
        DeckDetailsSectionModel *cardsSectionModel = [[DeckDetailsSectionModel alloc] initWithType:DeckDetailsSectionModelTypeCards];
        [snapshot appendSectionsWithIdentifiers:@[cardsSectionModel]];
        
        NSMutableArray<DeckDetailsItemModel *> *cardItemModels = [@[] mutableCopy];
        
        for (HSCard *hsCard in hsDeck.cards) {
            DeckDetailsItemModel *cardItemModel = [[DeckDetailsItemModel alloc] initWithType:DeckDetailsItemModelTypeCard];
            cardItemModel.hsCard = hsCard;
            [cardItemModels addObject:cardItemModel];
            [cardItemModel release];
        }
        
        [snapshot appendItemsWithIdentifiers:cardItemModels intoSectionWithIdentifier:cardsSectionModel];
        
        [cardsSectionModel release];
        [cardItemModels release];
        
        //
        
        [copyHSDeck release];
        
        [NSOperationQueue.mainQueue addOperationWithBlock:^{
            [self.dataSource applySnapshot:snapshot animatingDifferences:YES completion:^{
                [snapshot release];
            }];
        }];
    }];
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
        
        [cardsSectionModel release];
        [cardItemModels release];
        
        //
        
        [copyHSCards release];
        
        [NSOperationQueue.mainQueue addOperationWithBlock:^{
            [self.dataSource applySnapshot:snapshot animatingDifferences:YES completion:^{
                [snapshot release];
            }];
        }];
    }];
}

@end
