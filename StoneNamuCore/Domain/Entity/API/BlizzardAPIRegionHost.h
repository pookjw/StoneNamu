//
//  BlizzardHSAPIRegionHost.h
//  StoneNamuCore
//
//  Created by Jinwoo Kim on 7/18/21.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, BlizzardAPIRegionHost) {
    BlizzardAPIRegionHostUS,
    BlizzardAPIRegionHostEU,
    BlizzardAPIRegionHostKR,
    BlizzardAPIRegionHostTW,
    BlizzardAPIRegionHostCN
};

NSString *NSStringForAPIFromRegionHost(BlizzardAPIRegionHost);
NSString *NSStringForOAuthFromRegionHost(BlizzardAPIRegionHost);
