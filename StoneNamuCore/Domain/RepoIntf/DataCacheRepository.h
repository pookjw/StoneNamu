//
//  DataCacheRepository.h
//  DataCacheRepository
//
//  Created by Jinwoo Kim on 8/2/21.
//

#import <Foundation/Foundation.h>
#import "DataCache.h"

NS_ASSUME_NONNULL_BEGIN

typedef void (^DataCacheRepositoryFetchWithIdentityCompletion)(NSArray<DataCache *> * _Nullable, NSError * _Nullable);

@protocol DataCacheRepository <NSObject>
- (void)saveChanges;
- (void)dataCachesWithIdentity:(NSString *)identity completion:(DataCacheRepositoryFetchWithIdentityCompletion)completion;
- (void)removeAllDataCaches;
- (DataCache *)createDataCache;
@end

NS_ASSUME_NONNULL_END
