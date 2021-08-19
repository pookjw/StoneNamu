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
typedef void (^LocalDeckRepositoryFetchWithObjectIdCompletion)(LocalDeck * _Nullable);

static NSString * const LocalDeckRepositoryObserveDataNotificationName = @"LocalDeckRepositoryObserveDataNotificationName";

static NSString * const LocalDeckRepositoryDeleteAllNotificationName = @"LocalDeckRepositoryDeleteAllNotificationName";

@protocol LocalDeckRepository <NSObject>
- (void)saveChanges;
- (void)fetchWithCompletion:(LocalDeckRepositoryFetchWithCompletion)completion;
- (void)fetchWithObjectId:(NSManagedObjectID *)objectId completion:(LocalDeckRepositoryFetchWithObjectIdCompletion)completion;
- (void)deleteLocalDeck:(LocalDeck *)localDeck;
- (void)deleteAllLocalDecks;
- (LocalDeck *)makeLocalDeck;
@end

NS_ASSUME_NONNULL_END
