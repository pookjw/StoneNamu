//
//  BlizzardHSAPIKeys.m
//  BlizzardHSAPIKeys
//
//  Created by Jinwoo Kim on 9/1/21.
//

#import "BlizzardHSAPIKeys.h"
#import <StoneNamuCore/HSCardSet.h>
#import <StoneNamuCore/HSCardCollectible.h>
#import <StoneNamuCore/HSCardGameMode.h>
#import <StoneNamuCore/HSCardSort.h>

NSDictionary<BlizzardHSAPIOptionType, NSString *> *BlizzardHSAPIDefaultOptions(void) {
    return @{
        BlizzardHSAPIOptionTypeCollectible: NSStringFromHSCardCollectible(HSCardCollectibleYES),
        BlizzardHSAPIOptionTypeGameMode: NSStringFromHSCardGameMode(HSCardGameModeConstructed),
        BlizzardHSAPIOptionTypeSort: NSStringFromHSCardSort(HSCardSortManaCostAsc)
    };
}
