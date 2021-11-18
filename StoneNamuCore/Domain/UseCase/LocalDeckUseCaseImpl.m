//
//  LocalDeckUseCaseImpl.m
//  LocalDeckUseCaseImpl
//
//  Created by Jinwoo Kim on 8/17/21.
//

#import <StoneNamuCore/LocalDeckUseCaseImpl.h>
#import <StoneNamuCore/LocalDeckRepositoryImpl.h>
#import <StoneNamuCore/HSCardHero.h>
#import <StoneNamuCore/NSMutableArray+removeSingle.h>
#import <StoneNamuCore/StoneNamuError.h>
#import <StoneNamuCore/NSString+arrayOfCharacters.h>

@interface LocalDeckUseCaseImpl ()
@property (retain) id<LocalDeckRepository> localDeckRepository;
@end

@implementation LocalDeckUseCaseImpl

- (instancetype)init {
    self = [super init];
    
    if (self) {LocalDeckRepositoryImpl *localDeckRepository = [LocalDeckRepositoryImpl new];
        self.localDeckRepository = localDeckRepository;
        [localDeckRepository release];
        
        [self startObserving];
    }
    
    return self;
}

- (void)dealloc {
    [_localDeckRepository release];
    [super dealloc];
}

- (void)deleteLocalDeck:(nonnull LocalDeck *)localDeck {
    [self.localDeckRepository deleteLocalDeck:localDeck];
}

- (void)deleteAllLocalDecks {
    [self.localDeckRepository deleteAllLocalDecks];
}

- (void)fetchWithCompletion:(nonnull LocalDeckUseCaseFetchWithCompletion)completion {
    [self.localDeckRepository fetchWithCompletion:completion];
}

- (void)refreshObject:(NSManagedObject *)object mergeChanges:(BOOL)flag completion:(nonnull LocalDeckUseCaseRefreshObjectWithCompletion)completion {
    [self.localDeckRepository refreshObject:object mergeChanges:flag completion:completion];
}

- (void)makeLocalDeckWithCompletion:(LocalDeckUseCaseMakeWithCompletion)completion {
    [self.localDeckRepository makeLocalDeckWithCompletion:^(LocalDeck * _Nonnull localDeck) {
        [localDeck updateTimestamp];
        completion(localDeck);
    }];
}

- (void)saveChanges {
    [self.localDeckRepository saveChanges];
}

- (BOOL)isEasterEggDeckFromLocalDeck:(LocalDeck *)localDeck {
    NSArray<NSString *> *easterEggs = @[@"피나무", @"pnamu"];
    NSMutableArray<HSCard *> *allCards = [[[NSSet setWithArray:localDeck.hsCards] allObjects] mutableCopy];
    
    [allCards sortUsingComparator:^NSComparisonResult(HSCard * _Nonnull obj1, HSCard * _Nonnull obj2) {
        return [obj1 compare:obj2];
    }];
    
    NSMutableString *firstNames = [@"" mutableCopy];
    
    [allCards enumerateObjectsUsingBlock:^(HSCard * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSString *firstName = [obj.name.arrayOfCharacters firstObject];
        [firstNames appendString:firstName];
    }];
    
    [allCards release];
    
    BOOL __block result = NO;
    
    [easterEggs enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([firstNames localizedCaseInsensitiveContainsString:obj]) {
            result = YES;
            *stop = YES;
        }
    }];
    
    [firstNames release];
    
    return result;
}

- (void)addHSCards:(NSArray<HSCard *> *)hsCards toLocalDeck:(LocalDeck *)localDeck validation:(LocalDeckUseCaseFetchWithValidation)validation {
    NSArray<HSCard *> *copyHSCards = [hsCards copy];
    
    [self.localDeckRepository.queue addBarrierBlock:^{
        NSArray<HSCard *> *localDeckHSCards = localDeck.hsCards;
        
        if ((localDeckHSCards.count + copyHSCards.count) > HSDECK_MAX_TOTAL_CARDS) {
            NSError *error = [StoneNamuError errorWithErrorType:StoneNamuErrorTypeCannotAddNoMoreThanThirtyCards];
            validation(error);
            [copyHSCards release];
            return;
        }
        
        NSArray<NSNumber *> *hsCardHeroesArray = hsCardHeroes();
        
        for (HSCard *hsCard in copyHSCards) {
            if ((hsCard.classId != localDeck.classId.unsignedIntegerValue) &&
                (![hsCard.multiClassIds containsObject:localDeck.classId]) &&
                (hsCard.classId != HSCardClassNeutral))
            {
                
                NSError *error = [StoneNamuError errorWithErrorType:StoneNamuErrorTypeCannotAddDifferentClassCard];
                validation(error);
                [copyHSCards release];
                return;
            }
            
            if (hsCard.collectible != HSCardCollectibleYES) {
                NSError *error = [StoneNamuError errorWithErrorType:StoneNamuErrorTypeCannotAddNotCollectibleCard];
                validation(error);
                [copyHSCards release];
                return;
            }
            
            if ([hsCardHeroesArray containsObject:[NSNumber numberWithUnsignedInteger:hsCard.parentId]]) {
                NSError *error = [StoneNamuError errorWithErrorType:StoneNamuErrorTypeCannotAddHeroPortraitCard];
                validation(error);
                [copyHSCards release];
                return;
            }
            
            //
            
            NSUInteger countOfContaining = 0;
            
            for (HSCard *tmp in localDeckHSCards) {
                if ([tmp isEqual:hsCard]) {
                    countOfContaining += 1;
                }
            }
            
            if ((hsCard.rarityId == HSCardRarityLegendary) && (countOfContaining >= HSDECK_MAX_SINGLE_LEGENDARY_CARD)) {
                NSError *error = [StoneNamuError errorWithErrorType:StoneNamuErrorTypeCannotAddSingleLegendaryCardMoreThanOne];
                validation(error);
                [copyHSCards release];
                return;
            }
            
            if (countOfContaining >= HSDECK_MAX_SINGLE_CARD) {
                NSError *error = [StoneNamuError errorWithErrorType:StoneNamuErrorTypeCannotAddSingleCardMoreThanTwo];
                validation(error);
                [copyHSCards release];
                return;
            }
        }
        
        // validation was done
        validation(nil);
        
        NSMutableArray<HSCard *> *mutableLocalDeckHSCards = [localDeckHSCards mutableCopy];
        [mutableLocalDeckHSCards addObjectsFromArray:copyHSCards];
        [copyHSCards release];
        localDeck.hsCards = mutableLocalDeckHSCards;
        [mutableLocalDeckHSCards release];
        localDeck.deckCode = nil;
        [localDeck updateTimestamp];
        [self saveChanges];
    }];
}

- (void)deleteHSCards:(NSSet<HSCard *> *)hsCards toLocalDeck:(LocalDeck *)localDeck validation:(LocalDeckUseCaseFetchWithValidation)validation {
    NSSet<HSCard *> *copyHSCards = [hsCards copy];
    
    [self.localDeckRepository.queue addBarrierBlock:^{
        validation(nil);
        
        NSMutableArray<HSCard *> *mutableCards = [localDeck.hsCards mutableCopy];
        [mutableCards removeObjectsInArray:copyHSCards.allObjects];
        [copyHSCards release];
        
        localDeck.hsCards = mutableCards;
        [mutableCards release];
        localDeck.deckCode = nil;
        [localDeck updateTimestamp];
        [self saveChanges];
        
    }];
}

- (void)increaseHSCards:(NSSet<HSCard *> *)hsCards toLocalDeck:(LocalDeck *)localDeck validation:(LocalDeckUseCaseFetchWithValidation)validation {
    NSSet<HSCard *> *copyHSCards = [hsCards copy];
    
    [self.localDeckRepository.queue addBarrierBlock:^{
        NSArray<HSCard *> *localDeckHSCards = localDeck.hsCards;
        
        for (HSCard *hsCard in copyHSCards) {
            NSUInteger countOfContaining = 0;
            
            for (HSCard *tmp in localDeckHSCards) {
                if ([tmp isEqual:hsCard]) {
                    countOfContaining += 1;
                }
            }
            
            if ((hsCard.rarityId == HSCardRarityLegendary) && countOfContaining >= HSDECK_MAX_SINGLE_LEGENDARY_CARD) {
                NSError *error = [StoneNamuError errorWithErrorType:StoneNamuErrorTypeCannotAddSingleLegendaryCardMoreThanOne];
                validation(error);
                [copyHSCards release];
                return;
            }
            
            if (countOfContaining >= HSDECK_MAX_SINGLE_CARD) {
                NSError *error = [StoneNamuError errorWithErrorType:StoneNamuErrorTypeCannotAddSingleCardMoreThanTwo];
                validation(error);
                [copyHSCards release];
                return;
            }
        }
        
        //
        
        if ((localDeckHSCards.count + copyHSCards.count) > HSDECK_MAX_TOTAL_CARDS) {
            NSError *error = [StoneNamuError errorWithErrorType:StoneNamuErrorTypeCannotAddNoMoreThanThirtyCards];
            validation(error);
            [copyHSCards release];
            return;
        }
        
        // validation was done
        validation(nil);
        
        NSMutableArray<HSCard *> *mutableLocalDeckHSCards = [localDeckHSCards mutableCopy];
        [mutableLocalDeckHSCards addObjectsFromArray:copyHSCards.allObjects];
        [copyHSCards release];
        localDeck.hsCards = mutableLocalDeckHSCards;
        [mutableLocalDeckHSCards release];
        localDeck.deckCode = nil;
        [localDeck updateTimestamp];
        [self saveChanges];
    }];
}

- (void)decreaseHSCards:(NSSet<HSCard *> *)hsCards toLocalDeck:(LocalDeck *)localDeck validation:(LocalDeckUseCaseFetchWithValidation)validation {
    NSSet<HSCard *> *copyHSCards = [hsCards copy];
    
    [self.localDeckRepository.queue addBarrierBlock:^{
        validation(nil);
        
        NSMutableArray<HSCard *> *mutableLocalDeckHSCards = [localDeck.hsCards mutableCopy];
        
        for (HSCard *hsCard in copyHSCards) {
            [mutableLocalDeckHSCards removeSingleObject:hsCard];
        }
        [copyHSCards release];
        
        localDeck.hsCards = mutableLocalDeckHSCards;
        [mutableLocalDeckHSCards release];
        localDeck.deckCode = nil;
        [localDeck updateTimestamp];
        [self saveChanges];
    }];
}

- (void)startObserving {
    [NSNotificationCenter.defaultCenter addObserver:self
                                           selector:@selector(changesReceived:)
                                               name:NSNotificationNameLocalDeckRepositoryObserveData
                                             object:self.localDeckRepository];
    
    [NSNotificationCenter.defaultCenter addObserver:self
                                           selector:@selector(deleteAllEventReceived:)
                                               name:NSNotificationNameLocalDeckRepositoryDeleteAll
                                             object:self.localDeckRepository];
}

- (void)changesReceived:(NSNotification *)notification {
    [NSNotificationCenter.defaultCenter postNotificationName:NSNotificationNameLocalDeckUseCaseObserveData
                                                      object:self
                                                    userInfo:nil];
}

- (void)deleteAllEventReceived:(NSNotification *)notification {
    [NSNotificationCenter.defaultCenter postNotificationName:NSNotificationNameLocalDeckUseCaseDeleteAll
                                                      object:self
                                                    userInfo:nil];
}

@end
