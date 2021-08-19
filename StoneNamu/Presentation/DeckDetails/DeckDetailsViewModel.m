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

- (void)requestDataSourcdWithLocalDeck:(LocalDeck *)localDeck {
    [localDeck retain];
    
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
            
            [self updateDataSourceWithHSCards:hsCards];
            [results autorelease];
        } else {
            
        }
        
        [localDeck release];
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
        
        DeckDetailsItemModel *cardsItemModel = [[DeckDetailsItemModel alloc] initWithType:DeckDetailsItemModelTypeCards];
        cardsItemModel.hsCards = hsDeck.cards;
        
        [snapshot appendItemsWithIdentifiers:@[cardsItemModel]
                   intoSectionWithIdentifier:cardsSectionModel];
        
        [cardsSectionModel release];
        [cardsItemModel release];
        
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
    
}

@end
