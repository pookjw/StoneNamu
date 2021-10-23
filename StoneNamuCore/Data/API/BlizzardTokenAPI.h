//
//  BlizzardTokenAPI.h
//  StoneNamuCore
//
//  Created by Jinwoo Kim on 7/18/21.
//

#import <Foundation/Foundation.h>
#import <StoneNamuCore/BlizzardAPIRegionHost.h>

typedef void (^BlizzardTokenAPICompletionType)(NSData *, NSURLResponse *, NSError *);

@protocol BlizzardTokenAPI <NSObject>
- (void)getAccessTokenAtRegion:(BlizzardAPIRegionHost)regionHost
             completionHandler:(BlizzardTokenAPICompletionType)completion;
@end
