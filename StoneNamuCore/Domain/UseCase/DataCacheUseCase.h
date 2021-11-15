//
//  DataCacheUseCase.h
//  DataCacheUseCase
//
//  Created by Jinwoo Kim on 8/2/21.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef void (^DataCacheUseCaseFileSizeWithCompletion)(NSNumber * _Nullable);
typedef void (^DataCacheUseCaseFetchWithIdentityCompletion)(NSArray<NSData *> * _Nullable, NSError * _Nullable);
typedef void (^DataCacheUseCaseMakeWithCompletion)(void);

static NSNotificationName const NSNotificationNameDataCacheUseCaseDeleteAll = @"NSNotificationNameDataCacheUseCaseDeleteAll";
static NSNotificationName const NSNotificationNameDataCacheUseCaseObserveData = @"NSNotificationNameDataCacheUseCaseObserveData";

@protocol DataCacheUseCase <NSObject>
- (void)dataCachesWithIdentity:(NSString *)identity completion:(DataCacheUseCaseFetchWithIdentityCompletion)completion;
- (void)deleteAllDataCaches;
- (void)fileSizeWithCompletion:(DataCacheUseCaseFileSizeWithCompletion)completion;
- (void)makeDataCache:(NSData *)data identity:(NSString *)identity completion:(DataCacheUseCaseMakeWithCompletion)completion;
- (void)saveChanges;
@end

NS_ASSUME_NONNULL_END
