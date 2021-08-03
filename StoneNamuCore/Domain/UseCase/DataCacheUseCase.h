//
//  DataCacheUseCase.h
//  DataCacheUseCase
//
//  Created by Jinwoo Kim on 8/2/21.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef void (^DataCacheUseCaseFetchWithIdentityCompletion)(NSArray<NSData *> *);

@protocol DataCacheUseCase <NSObject>
- (void)dataCachesWithIdentity:(NSString *)identity completion:(DataCacheUseCaseFetchWithIdentityCompletion)completion;
- (void)removeAllDataCaches;
- (void)createDataCache:(NSData *)data identity:(NSString *)identity;
@end

NS_ASSUME_NONNULL_END
