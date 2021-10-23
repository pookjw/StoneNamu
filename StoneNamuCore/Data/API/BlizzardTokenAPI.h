//
//  BlizzardTokenAPI.h
//  StoneNamuCore
//
//  Created by Jinwoo Kim on 7/18/21.
//

#import <Foundation/Foundation.h>
#include <TargetConditionals.h>
#if TARGET_OS_OSX
#import <StoneNamuMacCore/BlizzardAPIRegionHost.h>
#else
#import <StoneNamuCore/BlizzardAPIRegionHost.h>
#endif

typedef void (^BlizzardTokenAPICompletionType)(NSData *, NSURLResponse *, NSError *);

@protocol BlizzardTokenAPI <NSObject>
- (void)getAccessTokenAtRegion:(BlizzardAPIRegionHost)regionHost
             completionHandler:(BlizzardTokenAPICompletionType)completion;
@end
