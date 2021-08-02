//
//  DataCacheUseCase.h
//  DataCacheUseCase
//
//  Created by Jinwoo Kim on 8/2/21.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol DataCacheUseCase <NSObject>
- (NSArray<NSData *> *)dataCachesWithIdentity:(NSString *)identity;
- (void)removeAllDataCaches;
- (void)createDataCache:(NSData *)data identity:(NSString *)identity;
@end

NS_ASSUME_NONNULL_END
