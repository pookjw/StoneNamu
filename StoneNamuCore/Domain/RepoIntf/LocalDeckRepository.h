//
//  LocalDeckRepository.h
//  LocalDeckRepository
//
//  Created by Jinwoo Kim on 8/17/21.
//

#import <Foundation/Foundation.h>
#import "LocalDeck.h"

NS_ASSUME_NONNULL_BEGIN

typedef void (^LocalDeckRepositoryFetchWithCompletion)(NSArray<LocalDeck *> * _Nullable, NSError * _Nullable);

static NSString * const LocalDeckRepositoryObserveDataNotificationName = @"LocalDeckRepositoryObserveDataNotificationName";
static NSString * const LocalDeckRepositoryLocalDeckNotificationItemKey = @"LocalDeckRepositoryLocalDeckNotificationItemKey";

@protocol LocalDeckRepository <NSObject>
- (void)saveChanges;
- (void)fetchWithCompletion:(LocalDeckRepositoryFetchWithCompletion)completion;
- (void)deleteLocalDeck:(LocalDeck *)localDeck;
- (LocalDeck *)makeLocalDeck;
@end

NS_ASSUME_NONNULL_END
