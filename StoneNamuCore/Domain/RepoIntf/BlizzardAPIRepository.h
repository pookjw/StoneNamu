//
//  BlizzardAPIRepository.h
//  StoneNamu
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

typedef void (^BlizzardAPIRepositoryCompletion)(NSData * _Nullable, NSURLResponse * _Nullable, NSError * _Nullable);

NS_ASSUME_NONNULL_BEGIN

@protocol BlizzardAPIRepository <NSObject>
- (void)getAtRegion:(BlizzardAPIRegionHost)regionHost
               path:(NSString *)path
            options:(NSDictionary<NSString *, NSString *> * _Nullable)options
  completionHandler:(BlizzardAPIRepositoryCompletion)completion;
@end

NS_ASSUME_NONNULL_END
