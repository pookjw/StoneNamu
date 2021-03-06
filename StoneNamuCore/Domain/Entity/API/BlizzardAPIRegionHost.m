//
//  BlizzardAPIRegionHost.m
//  StoneNamuCore
//
//  Created by Jinwoo Kim on 7/18/21.
//

#import <StoneNamuCore/BlizzardAPIRegionHost.h>
#import <StoneNamuCore/Identifier.h>

NSString *NSStringForAPIFromRegionHost(BlizzardAPIRegionHost regionHost) {
    switch (regionHost) {
        case BlizzardAPIRegionHostUS:
            return @"us.api.blizzard.com";
        case BlizzardAPIRegionHostEU:
            return @"eu.api.blizzard.com";
        case BlizzardAPIRegionHostKR:
            return @"kr.api.blizzard.com";
        case BlizzardAPIRegionHostTW:
            return @"tw.api.blizzard.com";
        case BlizzardAPIRegionHostCN:
            return @"gateway.battlenet.com.cn";
        default:
            return @"us.api.blizzard.com";
    }
}

NSString *NSStringForOAuthFromRegionHost(BlizzardAPIRegionHost regionHost) {
    switch (regionHost) {
        case BlizzardAPIRegionHostUS:
            return @"us.battle.net";
        case BlizzardAPIRegionHostEU:
            return @"eu.battle.net";
        case BlizzardAPIRegionHostKR:
            return @"apac.battle.net";
        case BlizzardAPIRegionHostTW:
            return @"apac.battle.net";
        case BlizzardAPIRegionHostCN:
            return @"www.battlenet.com.cn";
        default:
            return @"us.battle.net";
    }
}

BlizzardAPIRegionHost BlizzardAPIRegionHostFromNSStringForAPI(NSString * key) {
    if ([key isEqualToString:@"us.api.blizzard.com"]) {
        return BlizzardAPIRegionHostUS;
    } else if ([key isEqualToString:@"eu.api.blizzard.com"]) {
        return BlizzardAPIRegionHostEU;
    } else if ([key isEqualToString:@"kr.api.blizzard.com"]) {
        return BlizzardAPIRegionHostKR;
    } else if ([key isEqualToString:@"tw.api.blizzard.com"]) {
        return BlizzardAPIRegionHostTW;
    } else if ([key isEqualToString:@"gateway.battlenet.com.cn"]) {
        return BlizzardAPIRegionHostCN;
    } else {
        return BlizzardAPIRegionHostUS;
    }
}

NSArray<NSString *> *blizzardHSAPIRegionsForAPI(void) {
    return @[
        NSStringForAPIFromRegionHost(BlizzardAPIRegionHostUS),
        NSStringForAPIFromRegionHost(BlizzardAPIRegionHostEU),
        NSStringForAPIFromRegionHost(BlizzardAPIRegionHostKR),
        NSStringForAPIFromRegionHost(BlizzardAPIRegionHostTW),
        NSStringForAPIFromRegionHost(BlizzardAPIRegionHostCN)
    ];
}
