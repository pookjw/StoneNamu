//
//  LocalDeckUseCaseImpl.m
//  LocalDeckUseCaseImpl
//
//  Created by Jinwoo Kim on 8/17/21.
//

#import <StoneNamuCore/LocalDeckUseCaseImpl.h>
#import <StoneNamuCore/LocalDeckRepositoryImpl.h>
#import <StoneNamuCore/NSMutableArray+removeSingle.h>
#import <StoneNamuCore/StoneNamuError.h>
#import <StoneNamuCore/NSString+arrayOfCharacters.h>
#import <StoneNamuCore/HSMetaDataRepositoryImpl.h>
#import <StoneNamuCore/HSMetaDataUseCaseImpl.h>

@interface LocalDeckUseCaseImpl ()
@property (retain) id<LocalDeckRepository> localDeckRepository;
@property (retain) id<HSMetaDataUseCase> hsMetaDataUseCase;
@end

@implementation LocalDeckUseCaseImpl

- (instancetype)init {
    self = [super init];
    
    if (self) {LocalDeckRepositoryImpl *localDeckRepository = [LocalDeckRepositoryImpl new];
        self.localDeckRepository = localDeckRepository;
        [localDeckRepository release];
        
        HSMetaDataUseCaseImpl *hsMetaDataUseCase = [HSMetaDataUseCaseImpl new];
        self.hsMetaDataUseCase = hsMetaDataUseCase;
        [hsMetaDataUseCase release];
        
        [self startObserving];
    }
    
    return self;
}

- (void)dealloc {
    [_localDeckRepository release];
    [_hsMetaDataUseCase release];
    [super dealloc];
}

- (void)deleteLocalDecks:(NSSet<LocalDeck *> *)localDecks {
    [self.localDeckRepository deleteLocalDecks:localDecks];
}

- (void)deleteAllLocalDecks {
    [self.localDeckRepository deleteAllLocalDecks];
}

- (void)fetchWithCompletion:(nonnull LocalDeckUseCaseFetchWithCompletion)completion {
    [self.localDeckRepository fetchWithCompletion:completion];
}

- (void)fetchUsingObjectIDs:(NSSet<NSManagedObjectID *> *)objectIds completion:(LocalDeckUseCaseFetchUsingObjectIDsWithCompletion)completion {
    [self.localDeckRepository fetchUsingObjectIDs:objectIds completion:completion];
}

- (void)fetchUsingURI:(NSURL *)uri completion:(LocalDeckUseCaseFetchWithCompletion)completion {
    [self.localDeckRepository fetchUsingURI:uri completion:completion];
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

- (BOOL)isEasterEggDeckFromHSCards:(NSSet<HSCard *> *)hsCards {
    NSArray<NSString *> *easterEggs = @[@"피나무", @"pnamu"];
    NSMutableArray<HSCard *> *allCards = [[hsCards allObjects] mutableCopy];
    
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

- (BOOL)isEasterEggDeckFromLocalDeck:(LocalDeck *)localDeck {
    return [self isEasterEggDeckFromHSCards:[NSSet setWithArray:localDeck.hsCards]];
}

- (void)addHSCards:(NSArray<HSCard *> *)hsCards toLocalDeck:(LocalDeck *)localDeck validation:(LocalDeckUseCaseFetchWithValidation)validation {
    
    [self.hsMetaDataUseCase fetchWithCompletionHandler:^(HSMetaData * _Nullable hsMetaData, NSError * _Nullable error) {
        if (error != nil) {
            validation(error);
            return;
        }
        
        [self.localDeckRepository.queue addBarrierBlock:^{
            NSArray<HSCard *> *localDeckHSCards = localDeck.hsCards;

            if ((localDeckHSCards.count + hsCards.count) > HSDECK_MAX_TOTAL_CARDS) {
                NSError *error = [StoneNamuError errorWithErrorType:StoneNamuErrorTypeCannotAddNoMoreThanThirtyCards];
                validation(error);
                return;
            }

            HSCardClass * _Nullable hsCardClass = [self.hsMetaDataUseCase hsCardClassFromClassId:localDeck.classId usingHSMetaData:hsMetaData];
            HSCardClass * _Nullable neutralClass = [self.hsMetaDataUseCase hsCardClassFromClassSlug:HSCardClassSlugTypeNeutral usingHSMetaData:hsMetaData];
            HSCardRarity * _Nullable legendaryRarity = [self.hsMetaDataUseCase hsCardRarityFromRaritySlug:HSCardRaritySlugTypeLegendary usingHSMetaData:hsMetaData];

            for (HSCard *hsCard in hsCards) {
                if ((![hsCard.classId isEqualToNumber:localDeck.classId]) &&
                    (![hsCard.multiClassIds containsObject:localDeck.classId]) &&
                    (![hsCard.classId isEqualToNumber:neutralClass.classId]))
                {

                    NSError *error = [StoneNamuError errorWithErrorType:StoneNamuErrorTypeCannotAddDifferentClassCard];
                    validation(error);
                    return;
                }

                if (hsCard.collectible != HSCardCollectibleYES) {
                    NSError *error = [StoneNamuError errorWithErrorType:StoneNamuErrorTypeCannotAddNotCollectibleCard];
                    validation(error);
                    return;
                }

                NSNumber *cardId = [NSNumber numberWithUnsignedInteger:hsCard.cardId];
                if (([hsCardClass.heroCardId isEqualToNumber:cardId]) || ([hsCardClass.alternateHeroCardIds containsObject:cardId])) {
                    NSError *error = [StoneNamuError errorWithErrorType:StoneNamuErrorTypeCannotAddHeroPortraitCard];
                    validation(error);
                    return;
                }

                //

                NSUInteger countOfContaining = 0;

                for (HSCard *tmp in localDeckHSCards) {
                    if ([tmp isEqual:hsCard]) {
                        countOfContaining += 1;
                    }
                }

                if (([hsCard.rarityId isEqualToNumber:legendaryRarity.rarityId]) && (countOfContaining >= HSDECK_MAX_SINGLE_LEGENDARY_CARD)) {
                    NSError *error = [StoneNamuError errorWithErrorType:StoneNamuErrorTypeCannotAddSingleLegendaryCardMoreThanOne];
                    validation(error);
                    return;
                }

                if (countOfContaining >= HSDECK_MAX_SINGLE_CARD) {
                    NSError *error = [StoneNamuError errorWithErrorType:StoneNamuErrorTypeCannotAddSingleCardMoreThanTwo];
                    validation(error);
                    return;
                }
            }

            // validation was done
            validation(nil);

            NSMutableArray<HSCard *> *mutableLocalDeckHSCards = [localDeckHSCards mutableCopy];
            [mutableLocalDeckHSCards addObjectsFromArray:hsCards];
            localDeck.hsCards = mutableLocalDeckHSCards;
            [mutableLocalDeckHSCards release];
            localDeck.deckCode = nil;
            [localDeck updateTimestamp];
            [self saveChanges];
        }];
    }];
}

- (void)deleteHSCards:(NSSet<HSCard *> *)hsCards toLocalDeck:(LocalDeck *)localDeck validation:(LocalDeckUseCaseFetchWithValidation)validation {
    [self.localDeckRepository.queue addBarrierBlock:^{
        validation(nil);
        
        NSMutableArray<HSCard *> *mutableCards = [localDeck.hsCards mutableCopy];
        [mutableCards removeObjectsInArray:hsCards.allObjects];
        
        localDeck.hsCards = mutableCards;
        [mutableCards release];
        localDeck.deckCode = nil;
        [localDeck updateTimestamp];
        [self saveChanges];
        
    }];
}

- (void)increaseHSCards:(NSSet<HSCard *> *)hsCards toLocalDeck:(LocalDeck *)localDeck validation:(LocalDeckUseCaseFetchWithValidation)validation {
    [self.hsMetaDataUseCase fetchWithCompletionHandler:^(HSMetaData * _Nullable hsMetaData, NSError * _Nullable error) {
        [self.localDeckRepository.queue addBarrierBlock:^{
            NSArray<HSCard *> *localDeckHSCards = localDeck.hsCards;
            
            for (HSCard *hsCard in hsCards) {
                NSUInteger countOfContaining = 0;
                
                for (HSCard *tmp in localDeckHSCards) {
                    if ([tmp isEqual:hsCard]) {
                        countOfContaining += 1;
                    }
                }
                
                HSCardRarity * _Nullable legendaryRarity = [self.hsMetaDataUseCase hsCardRarityFromRaritySlug:HSCardRaritySlugTypeLegendary usingHSMetaData:hsMetaData];
                
                if (([hsCard.rarityId isEqualToNumber:legendaryRarity.rarityId]) && countOfContaining >= HSDECK_MAX_SINGLE_LEGENDARY_CARD) {
                    NSError *error = [StoneNamuError errorWithErrorType:StoneNamuErrorTypeCannotAddSingleLegendaryCardMoreThanOne];
                    validation(error);
                    return;
                }
                
                if (countOfContaining >= HSDECK_MAX_SINGLE_CARD) {
                    NSError *error = [StoneNamuError errorWithErrorType:StoneNamuErrorTypeCannotAddSingleCardMoreThanTwo];
                    validation(error);
                    return;
                }
            }
            
            //
            
            if ((localDeckHSCards.count + hsCards.count) > HSDECK_MAX_TOTAL_CARDS) {
                NSError *error = [StoneNamuError errorWithErrorType:StoneNamuErrorTypeCannotAddNoMoreThanThirtyCards];
                validation(error);
                return;
            }
            
            // validation was done
            validation(nil);
            
            NSMutableArray<HSCard *> *mutableLocalDeckHSCards = [localDeckHSCards mutableCopy];
            [mutableLocalDeckHSCards addObjectsFromArray:hsCards.allObjects];
            localDeck.hsCards = mutableLocalDeckHSCards;
            [mutableLocalDeckHSCards release];
            localDeck.deckCode = nil;
            [localDeck updateTimestamp];
            [self saveChanges];
        }];
    }];
}

- (void)decreaseHSCards:(NSSet<HSCard *> *)hsCards toLocalDeck:(LocalDeck *)localDeck validation:(LocalDeckUseCaseFetchWithValidation)validation {
    [self.localDeckRepository.queue addBarrierBlock:^{
        validation(nil);
        
        NSMutableArray<HSCard *> *mutableLocalDeckHSCards = [localDeck.hsCards mutableCopy];
        
        for (HSCard *hsCard in hsCards) {
            [mutableLocalDeckHSCards removeSingleObject:hsCard];
        }
        
        localDeck.hsCards = mutableLocalDeckHSCards;
        [mutableLocalDeckHSCards release];
        localDeck.deckCode = nil;
        [localDeck updateTimestamp];
        [self saveChanges];
    }];
}

- (NSUInteger)maxCardsCountFromHSCards:(NSArray<HSCard *> *)hsCards {
    BOOL __block hasRenathalCard = NO;
    
    [hsCards enumerateObjectsUsingBlock:^(HSCard * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj.cardId == PRINCE_RENATHAL_CARD_ID) {
            hasRenathalCard = YES;
            *stop = YES;
        }
    }];
    
    if (hasRenathalCard) {
        if (hsCards.count > HSDECK_MAX_TOTAL_CARDS_PRINCE_RENATHAL) {
            return HSDECK_MAX_TOTAL_CARDS;
        } else {
            return HSDECK_MAX_TOTAL_CARDS_PRINCE_RENATHAL;
        }
    } else {
        if (hsCards.count > HSDECK_MAX_TOTAL_CARDS_NORMAL) {
            return HSDECK_MAX_TOTAL_CARDS;
        } else {
            return HSDECK_MAX_TOTAL_CARDS_NORMAL;
        }
    }
}

- (NSUInteger)isFullFromHSCards:(NSArray<HSCard *> *)hsCards {
    NSUInteger count = hsCards.count;
    
    if (count == HSDECK_MAX_TOTAL_CARDS) {
        return YES;
    } else {
        BOOL __block hasPrinceRenathal = NO;
        
        [hsCards enumerateObjectsUsingBlock:^(HSCard * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if (obj.cardId == PRINCE_RENATHAL_CARD_ID) {
                hasPrinceRenathal = YES;
                *stop = YES;
            }
        }];
        
        if (hasPrinceRenathal) {
            return (count >= HSDECK_MAX_TOTAL_CARDS_PRINCE_RENATHAL);
        } else {
            return (count >= HSDECK_MAX_TOTAL_CARDS_NORMAL);
        }
    }
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
