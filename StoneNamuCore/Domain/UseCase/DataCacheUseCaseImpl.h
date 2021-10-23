//
//  DataCacheUseCaseImpl.h
//  DataCacheUseCaseImpl
//
//  Created by Jinwoo Kim on 8/2/21.
//

#import <Foundation/Foundation.h>
#include <TargetConditionals.h>
#if TARGET_OS_OSX
#import <StoneNamuMacCore/DataCacheUseCase.h>
#else
#import <StoneNamuCore/DataCacheUseCase.h>
#endif

NS_ASSUME_NONNULL_BEGIN

@interface DataCacheUseCaseImpl : NSObject <DataCacheUseCase>

@end

NS_ASSUME_NONNULL_END
