//
//  BlizzardAPIRepositoryImpl.h
//  StoneNamuCore
//
//  Created by Jinwoo Kim on 7/18/21.
//

#include <TargetConditionals.h>
#if TARGET_OS_OSX
#import <StoneNamuMacCore/BlizzardAPIRepository.h>
#else
#import <StoneNamuCore/BlizzardAPIRepository.h>
#endif


NS_ASSUME_NONNULL_BEGIN

@interface BlizzardAPIRepositoryImpl : NSObject<BlizzardAPIRepository>

@end

NS_ASSUME_NONNULL_END
