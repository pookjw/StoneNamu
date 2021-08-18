//
//  DataCacheUseCase.h
//  DataCacheUseCase
//
//  Created by Jinwoo Kim on 8/2/21.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef void (^DataCacheUseCaseFetchWithIdentityCompletion)(NSArray<NSData *> * _Nullable, NSError * _Nullable);

@protocol DataCacheUseCase <NSObject>
- (void)dataCachesWithIdentity:(NSString *)identity completion:(DataCacheUseCaseFetchWithIdentityCompletion)completion;
- (void)deleteAllDataCaches;
- (void)makeDataCache:(NSData *)data identity:(NSString *)identity;
- (void)saveChanges;
@end

NS_ASSUME_NONNULL_END
