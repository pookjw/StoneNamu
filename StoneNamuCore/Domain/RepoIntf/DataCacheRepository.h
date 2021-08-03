//
//  DataCacheRepository.h
//  DataCacheRepository
//
//  Created by Jinwoo Kim on 8/2/21.
//

#import <CoreData/CoreData.h>
#import "DataCache.h"

typedef void (^DataCacheRepositoryFetchWithIdentityCompletion)(NSArray<DataCache *> *);

@protocol DataCacheRepository <NSObject>
- (void)saveChanges;
- (void)dataCachesWithIdentity:(NSString *)identity completion:(DataCacheRepositoryFetchWithIdentityCompletion)completion;
- (void)removeAllDataCaches;
- (DataCache *)createDataCache;
@end
