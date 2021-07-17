//
//  BlizzardHSAPI.h
//  StoneNamuCore
//
//  Created by Jinwoo Kim on 7/17/21.
//

#import <Foundation/Foundation.h>
#import "BlizzardAPIRegionHost.h"
#import "BlizzardHSAPILocale.h"

typedef void (^BlizzardHSAPICompletionType)(NSData *, NSURLResponse *, NSError *);

@protocol BlizzardHSAPI <NSObject>

- (void)fetchCardsAtRegion:(BlizzardAPIRegionHost)regionHost
               accessToken:(NSString *)accessToken
                   options:(NSDictionary<NSString *, id> *)options
         completionHandler:(BlizzardHSAPICompletionType)completion;

- (void)fetchCardAtRegion:(BlizzardAPIRegionHost)regionHost
              accessToken:(NSString *)accessToken
                 cardSlug:(NSString *)cardSlug
                  options:(NSDictionary<NSString *, id> *)options
        completionHandler:(BlizzardHSAPICompletionType)completion;
@end
