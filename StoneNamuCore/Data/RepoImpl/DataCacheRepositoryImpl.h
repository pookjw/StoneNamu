//
//  DataCacheRepositoryImpl.h
//  DataCacheRepositoryImpl
//
//  Created by Jinwoo Kim on 8/2/21.
//

#include <TargetConditionals.h>
#if TARGET_OS_OSX
#import <StoneNamuMacCore/DataCacheRepository.h>
#else
#import <StoneNamuCore/DataCacheRepository.h>
#endif

NS_ASSUME_NONNULL_BEGIN

@interface DataCacheRepositoryImpl : NSObject <DataCacheRepository>

@end

NS_ASSUME_NONNULL_END
