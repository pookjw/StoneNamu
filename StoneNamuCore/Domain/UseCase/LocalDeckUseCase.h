//
//  LocalDeckUseCase.h
//  LocalDeckUseCase
//
//  Created by Jinwoo Kim on 8/17/21.
//

#import <CoreData/CoreData.h>
#import <StoneNamuCore/LocalDeck.h>
#import <StoneNamuCore/HSDeck.h>
#import <StoneNamuCore/HSCard.h>

NS_ASSUME_NONNULL_BEGIN

typedef void (^LocalDeckUseCaseFetchWithCompletion)(NSArray<LocalDeck *> * _Nullable, NSError * _Nullable);
typedef void (^LocalDeckUseCaseRefreshObjectWithCompletion)(void);
typedef void (^LocalDeckUseCaseFetchWithValidation)(NSError * _Nullable);
typedef void (^LocalDeckUseCaseMakeWithCompletion)(LocalDeck *);

static NSNotificationName const NSNotificationNameLocalDeckUseCaseObserveData = @"NSNotificationNameLocalDeckUseCaseObserveData";

static NSNotificationName const NSNotificationNameLocalDeckUseCaseDeleteAll = @"NSNotificationNameLocalDeckUseCaseDeleteAll";

@protocol LocalDeckUseCase <NSObject>
- (void)saveChanges;
- (void)fetchWithCompletion:(LocalDeckUseCaseFetchWithCompletion)completion;
- (void)fetchUsingURI:(NSURL *)uri completion:(LocalDeckUseCaseFetchWithCompletion)completion;
- (void)refreshObject:(NSManagedObject *)object mergeChanges:(BOOL)flag completion:(LocalDeckUseCaseRefreshObjectWithCompletion)completion;
- (void)deleteLocalDeck:(LocalDeck *)localDeck;
- (void)deleteAllLocalDecks;

- (BOOL)isEasterEggDeckFromLocalDeck:(LocalDeck *)localDeck;

- (void)addHSCards:(NSArray<HSCard *> *)hsCards toLocalDeck:(LocalDeck *)localDeck validation:(LocalDeckUseCaseFetchWithValidation)validation;
- (void)deleteHSCards:(NSSet<HSCard *> *)hsCards toLocalDeck:(LocalDeck *)localDeck validation:(LocalDeckUseCaseFetchWithValidation)validation;
- (void)increaseHSCards:(NSSet<HSCard *> *)hsCards toLocalDeck:(LocalDeck *)localDeck validation:(LocalDeckUseCaseFetchWithValidation)validation;
- (void)decreaseHSCards:(NSSet<HSCard *> *)hsCards toLocalDeck:(LocalDeck *)localDeck validation:(LocalDeckUseCaseFetchWithValidation)validation;
- (void)makeLocalDeckWithCompletion:(LocalDeckUseCaseMakeWithCompletion)completion;
@end

NS_ASSUME_NONNULL_END
