//
//  BlizzardHSAPI.h
//  StoneNamuCore
//
//  Created by Jinwoo Kim on 7/17/21.
//

#import <Foundation/Foundation.h>
#import "BlizzardAPIRegionHost.h"

typedef void (^BlizzardHSAPICompletion)(NSData *, NSURLResponse *, NSError *);

@protocol BlizzardHSAPI <NSObject>

- (void)getAtRegion:(BlizzardAPIRegionHost)regionHost
               path:(NSString *)path
        accessToken:(NSString *)accessToken
            options:(NSDictionary<NSString *, id> *)options
  completionHandler:(BlizzardHSAPICompletion)completion;

@end
