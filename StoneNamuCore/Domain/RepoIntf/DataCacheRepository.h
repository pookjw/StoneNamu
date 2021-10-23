//
//  DataCacheRepository.h
//  DataCacheRepository
//
//  Created by Jinwoo Kim on 8/2/21.
//

#import <Foundation/Foundation.h>
#include <TargetConditionals.h>
#if TARGET_OS_OSX
#import <StoneNamuMacCore/DataCache.h>
#else
#import <StoneNamuCore/DataCache.h>
#endif

NS_ASSUME_NONNULL_BEGIN

typedef void (^DataCacheRepositoryFetchWithIdentityCompletion)(NSArray<DataCache *> * _Nullable, NSError * _Nullable);

static NSString * const DataCacheRepositoryDeleteAllNotificationName = @"DataCacheRepositoryDeleteAllNotificationName";

@protocol DataCacheRepository <NSObject>
- (void)saveChanges;
- (void)dataCachesWithIdentity:(NSString *)identity completion:(DataCacheRepositoryFetchWithIdentityCompletion)completion;
- (void)deleteAllDataCaches;
- (DataCache *)makeDataCache;
@end

NS_ASSUME_NONNULL_END
