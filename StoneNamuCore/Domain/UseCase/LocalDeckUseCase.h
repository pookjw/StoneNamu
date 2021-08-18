//
//  LocalDeckUseCase.h
//  LocalDeckUseCase
//
//  Created by Jinwoo Kim on 8/17/21.
//

#import <CoreData/CoreData.h>
#import "LocalDeck.h"
#import "HSDeck.h"

NS_ASSUME_NONNULL_BEGIN

typedef void (^LocalDeckUseCaseFetchWithCompletion)(NSArray<LocalDeck *> * _Nullable, NSError * _Nullable);
typedef void (^LocalDeckUseCaseFetchWithObjectIdCompletion)(LocalDeck * _Nullable);

static NSString * const LocalDeckUseCaseObserveDataNotificationName = @"LocalDeckUseCaseObserveDataNotificationName";

@protocol LocalDeckUseCase <NSObject>
- (void)saveChanges;
- (void)fetchWithCompletion:(LocalDeckUseCaseFetchWithCompletion)completion;
- (void)fetchWithObjectId:(NSManagedObjectID *)objectId completion:(LocalDeckUseCaseFetchWithObjectIdCompletion)completion;
- (void)deleteLocalDeck:(LocalDeck *)localDeck;
- (LocalDeck *)makeLocalDeck;
- (LocalDeck *)makeLocalDeckFromHSDeck:(HSDeck *)hsDeck;
@end

NS_ASSUME_NONNULL_END
