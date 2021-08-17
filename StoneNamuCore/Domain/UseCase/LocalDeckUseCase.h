//
//  LocalDeckUseCase.h
//  LocalDeckUseCase
//
//  Created by Jinwoo Kim on 8/17/21.
//

#import <Foundation/Foundation.h>
#import "LocalDeck.h"

NS_ASSUME_NONNULL_BEGIN

typedef void (^LocalDeckUseCaseFetchWithCompletion)(NSArray<LocalDeck *> * _Nullable, NSError * _Nullable);

static NSString * const LocalDeckUseCaseObserveDataNotificationName = @"LocalDeckUseCaseObserveDataNotificationName";
static NSString * const LocalDeckUseCaseLocalDeckNotificationItemKey = @"LocalDeckUseCaseLocalDeckNotificationItemKey";

@protocol LocalDeckUseCase <NSObject>
- (void)saveChanges;
- (void)fetchWithCompletion:(LocalDeckUseCaseFetchWithCompletion)completion;
- (void)deleteLocalDeck:(LocalDeck *)localDeck;
- (LocalDeck *)makeLocalDeck;
@end

NS_ASSUME_NONNULL_END
