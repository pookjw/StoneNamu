//
//  BlizzardAPIImpl.h
//  StoneNamuCore
//
//  Created by Jinwoo Kim on 7/17/21.
//

#include <TargetConditionals.h>
#if TARGET_OS_OSX
#import <StoneNamuMacCore/BlizzardAPI.h>
#else
#import <StoneNamuCore/BlizzardAPI.h>
#endif

NS_ASSUME_NONNULL_BEGIN

@interface BlizzardAPIImpl : NSObject <BlizzardAPI>

@end

NS_ASSUME_NONNULL_END
