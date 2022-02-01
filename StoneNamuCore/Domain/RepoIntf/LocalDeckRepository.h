//
//  LocalDeckRepository.h
//  LocalDeckRepository
//
//  Created by Jinwoo Kim on 8/17/21.
//

#import <CoreData/CoreData.h>
#import <StoneNamuCore/LocalDeck.h>

NS_ASSUME_NONNULL_BEGIN

typedef void (^LocalDeckRepositoryFetchWithCompletion)(NSArray<LocalDeck *> * _Nullable, NSError * _Nullable);
typedef void (^LocalDeckRepositoryFetchUsingObjectIDsWithCompletion)(NSSet<LocalDeck *> * _Nullable, NSError * _Nullable);
typedef void (^LocalDeckRepositoryMakeWithCompletion)(LocalDeck *);
typedef void (^LocalDeckRepositoryRefreshObjectCompletion)(void);

static NSNotificationName const NSNotificationNameLocalDeckRepositoryObserveData = @"NSNotificationNameLocalDeckRepositoryObserveData";

static NSNotificationName const NSNotificationNameLocalDeckRepositoryDeleteAll = @"NSNotificationNameLocalDeckRepositoryDeleteAll";

@protocol LocalDeckRepository <NSObject>
@property (readonly, nonatomic) NSOperationQueue *queue;
- (void)saveChanges;
- (void)fetchWithCompletion:(LocalDeckRepositoryFetchWithCompletion)completion;
- (void)fetchUsingObjectIDs:(NSSet<NSManagedObjectID *> *)objectIds completion:(LocalDeckRepositoryFetchUsingObjectIDsWithCompletion)completion;
- (void)fetchUsingURI:(NSURL *)uri completion:(LocalDeckRepositoryFetchWithCompletion)completion;
- (void)refreshObject:(NSManagedObject *)object mergeChanges:(BOOL)flag completion:(LocalDeckRepositoryRefreshObjectCompletion)completion;
- (void)deleteLocalDecks:(NSSet<LocalDeck *> *)localDecks;
- (void)deleteAllLocalDecks;
- (void)makeLocalDeckWithCompletion:(LocalDeckRepositoryMakeWithCompletion)completion;
@end

NS_ASSUME_NONNULL_END
