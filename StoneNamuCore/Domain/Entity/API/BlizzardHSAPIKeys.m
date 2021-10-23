//
//  BlizzardHSAPIKeys.m
//  BlizzardHSAPIKeys
//
//  Created by Jinwoo Kim on 9/1/21.
//

#import "BlizzardHSAPIKeys.h"
#include <TargetConditionals.h>
#if TARGET_OS_OSX
#import <StoneNamuMacCore/HSCardSet.h>
#import <StoneNamuMacCore/HSCardCollectible.h>
#import <StoneNamuMacCore/HSCardGameMode.h>
#import <StoneNamuMacCore/HSCardSort.h>
#else
#import <StoneNamuCore/HSCardSet.h>
#import <StoneNamuCore/HSCardCollectible.h>
#import <StoneNamuCore/HSCardGameMode.h>
#import <StoneNamuCore/HSCardSort.h>
#endif

NSDictionary<BlizzardHSAPIOptionType, NSString *> *BlizzardHSAPIDefaultOptions(void) {
    return @{
        BlizzardHSAPIOptionTypeCollectible: NSStringFromHSCardCollectible(HSCardCollectibleYES),
        BlizzardHSAPIOptionTypeGameMode: NSStringFromHSCardGameMode(HSCardGameModeConstructed),
        BlizzardHSAPIOptionTypeSort: NSStringFromHSCardSort(HSCardSortManaCostAsc)
    };
}
