//
//  DataCacheRepository.h
//  DataCacheRepository
//
//  Created by Jinwoo Kim on 8/2/21.
//

#import <CoreData/CoreData.h>
#import "DataCache.h"

@protocol DataCacheRepository <NSObject>
- (void)saveChanges;
- (NSArray<DataCache *> *)dataCachesWithIdentity:(NSString *)identity;
- (void)removeAllDataCaches;
- (DataCache *)createDataCache;
@end
