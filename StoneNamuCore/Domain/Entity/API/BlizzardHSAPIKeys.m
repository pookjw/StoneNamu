//
//  BlizzardHSAPIKeys.m
//  BlizzardHSAPIKeys
//
//  Created by Jinwoo Kim on 9/1/21.
//

#import <StoneNamuCore/BlizzardHSAPIKeys.h>
#import <StoneNamuCore/HSCardSet.h>
#import <StoneNamuCore/HSCardCollectible.h>
#import <StoneNamuCore/HSCardGameMode.h>
#import <StoneNamuCore/HSCardSort.h>

NSDictionary<BlizzardHSAPIOptionType, NSSet<NSString *> *> *BlizzardHSAPIDefaultOptions(void) {
    return @{
        BlizzardHSAPIOptionTypeCollectible: [NSSet setWithObject:NSStringFromHSCardCollectible(HSCardCollectibleYES)],
        BlizzardHSAPIOptionTypeGameMode: [NSSet setWithObject:HSCardGameModeSlugTypeConstructed],
        BlizzardHSAPIOptionTypeSort: [NSSet setWithArray:@[NSStringFromHSCardSort(HSCardSortManaCostAsc), NSStringFromHSCardSort(HSCardSortNameAsc)]]
    };
}
