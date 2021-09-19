//
//  LocalDeckRepository.h
//  LocalDeckRepository
//
//  Created by Jinwoo Kim on 8/17/21.
//

#import <CoreData/CoreData.h>
#import "LocalDeck.h"

NS_ASSUME_NONNULL_BEGIN

typedef void (^LocalDeckRepositoryFetchWithCompletion)(NSArray<LocalDeck *> * _Nullable, NSError * _Nullable);
typedef void (^LocalDeckRepositoryMakeWithCompletion)(LocalDeck *);
typedef void (^LocalDeckRepositoryRefreshObjectCompletion)(void);

static NSString * const LocalDeckRepositoryObserveDataNotificationName = @"LocalDeckRepositoryObserveDataNotificationName";

static NSString * const LocalDeckRepositoryDeleteAllNotificationName = @"LocalDeckRepositoryDeleteAllNotificationName";

@protocol LocalDeckRepository <NSObject>
@property (readonly, nonatomic) NSOperationQueue *queue;
- (void)saveChanges;
- (void)fetchWithCompletion:(LocalDeckRepositoryFetchWithCompletion)completion;
- (void)refreshObject:(NSManagedObject *)object mergeChanges:(BOOL)flag completion:(LocalDeckRepositoryRefreshObjectCompletion)completion;
- (void)deleteLocalDeck:(LocalDeck *)localDeck;
- (void)deleteAllLocalDecks;
- (void)makeLocalDeckWithCompletion:(LocalDeckRepositoryMakeWithCompletion)completion;
@end

NS_ASSUME_NONNULL_END
