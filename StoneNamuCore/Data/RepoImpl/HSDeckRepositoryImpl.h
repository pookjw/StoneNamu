//
//  HSDeckRepositoryImpl.h
//  HSDeckRepositoryImpl
//
//  Created by Jinwoo Kim on 8/17/21.
//

#import <Foundation/Foundation.h>
#include <TargetConditionals.h>
#if TARGET_OS_OSX
#import <StoneNamuMacCore/HSDeckRepository.h>
#else
#import <StoneNamuCore/HSDeckRepository.h>
#endif

NS_ASSUME_NONNULL_BEGIN

@interface HSDeckRepositoryImpl : NSObject <HSDeckRepository>

@end

NS_ASSUME_NONNULL_END
