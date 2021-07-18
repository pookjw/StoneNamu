//
//  BlizzardHSAPI.h
//  StoneNamuCore
//
//  Created by Jinwoo Kim on 7/17/21.
//

#import <Foundation/Foundation.h>
#import "BlizzardAPIRegionHost.h"

typedef void (^BlizzardHSAPICompletion)(NSData * _Nullable, NSURLResponse * _Nullable, NSError * _Nullable);

NS_ASSUME_NONNULL_BEGIN

@protocol BlizzardHSAPI <NSObject>

- (void)getAtRegion:(BlizzardAPIRegionHost)regionHost
               path:(NSString *)path
        accessToken:(NSString *)accessToken
            options:(NSDictionary<NSString *, id> * _Nullable)options
  completionHandler:(BlizzardHSAPICompletion)completion;

@end

NS_ASSUME_NONNULL_END
