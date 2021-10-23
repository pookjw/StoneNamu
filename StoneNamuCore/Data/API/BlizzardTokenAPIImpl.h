//
//  BlizzardTokenAPIImpl.h
//  StoneNamuCore
//
//  Created by Jinwoo Kim on 7/18/21.
//

#include <TargetConditionals.h>
#if TARGET_OS_OSX
#import <StoneNamuMacCore/BlizzardTokenAPI.h>
#else
#import <StoneNamuCore/BlizzardTokenAPI.h>
#endif

@interface BlizzardTokenAPIImpl : NSObject <BlizzardTokenAPI>
@end
