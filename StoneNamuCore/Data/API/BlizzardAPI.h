//
//  BlizzardAPI.h
//  StoneNamuCore
//
//  Created by Jinwoo Kim on 7/17/21.
//

#import <Foundation/Foundation.h>
#include <TargetConditionals.h>
#if TARGET_OS_OSX
#import <StoneNamuMacCore/BlizzardAPIRegionHost.h>
#else
#import <StoneNamuCore/BlizzardAPIRegionHost.h>
#endif

typedef void (^BlizzardAPICompletion)(NSData * _Nullable, NSURLResponse * _Nullable, NSError * _Nullable);

NS_ASSUME_NONNULL_BEGIN

@protocol BlizzardAPI <NSObject>

- (void)getAtRegion:(BlizzardAPIRegionHost)regionHost
               path:(NSString *)path
        accessToken:(NSString *)accessToken
            options:(NSDictionary<NSString *, id> * _Nullable)options
  completionHandler:(BlizzardAPICompletion)completion;

@end

NS_ASSUME_NONNULL_END
