//
//  DataCacheRepository.h
//  DataCacheRepository
//
//  Created by Jinwoo Kim on 8/2/21.
//

#import <Foundation/Foundation.h>
#import <StoneNamuCore/DataCache.h>

NS_ASSUME_NONNULL_BEGIN

typedef void (^DataCacheRepositoryFileSizeWithCompletion)(NSNumber * _Nullable);
typedef void (^DataCacheRepositoryFetchWithIdentityCompletion)(NSArray<DataCache *> * _Nullable, NSError * _Nullable);
typedef void (^DataCacheRepositoryMakeWithCompletion)(DataCache *);

static NSNotificationName const NSNotificationNameDataCacheRepositoryDeleteAll = @"NSNotificationNameDataCacheRepositoryDeleteAll";
static NSNotificationName const NSNotificationNameDataCacheRepositoryObserveData = @"NSNotificationNameDataCacheRepositoryObserveData";

@protocol DataCacheRepository <NSObject>
- (void)fileSizeWithCompletion:(DataCacheRepositoryFileSizeWithCompletion)completion;
- (void)saveChanges;
- (void)dataCachesWithIdentity:(NSString *)identity completion:(DataCacheRepositoryFetchWithIdentityCompletion)completion;
- (void)deleteAllDataCaches;
- (void)makeDataCacheWithCompletion:(DataCacheRepositoryMakeWithCompletion)completion;
@end

NS_ASSUME_NONNULL_END
