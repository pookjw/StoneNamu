//
//  BlizzardHSAPIKeys.m
//  BlizzardHSAPIKeys
//
//  Created by Jinwoo Kim on 9/1/21.
//

#import "BlizzardHSAPIKeys.h"
#import "HSCardCollectible.h"
#import "HSCardGameMode.h"
#import "HSCardSort.h"

NSDictionary<BlizzardHSAPIOptionType, NSString *> *BlizzardHSAPIDefaultOptions(void) {
    return @{
        BlizzardHSAPIOptionTypeCollectible: NSStringFromHSCardCollectible(HSCardCollectibleYES),
        BlizzardHSAPIOptionTypeGameMode: NSStringFromHSCardGameMode(HSCardGameModeConstructed),
        BlizzardHSAPIOptionTypeSort: NSStringFromHSCardSort(HSCardSortManaCostAsc)
    };
}
