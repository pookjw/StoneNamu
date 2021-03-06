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
#import <StoneNamuCore/HSCardClass.h>
#import <StoneNamuCore/HSCardType.h>

NSDictionary<BlizzardHSAPIOptionType, NSSet<NSString *> *> *BlizzardHSAPIDefaultOptionsFromHSCardTypeSlugType(HSCardGameModeSlugType hsCardTypeSlugType) {
    if ([HSCardGameModeSlugTypeConstructed isEqualToString:hsCardTypeSlugType]) {
        return @{
//            BlizzardHSAPIOptionTypeSet: [NSSet setWithObject:HSCardSetSlugTypeWildCards],
            BlizzardHSAPIOptionTypeCollectible: [NSSet setWithObject:NSStringFromHSCardCollectible(HSCardCollectibleYES)],
            BlizzardHSAPIOptionTypeGameMode: [NSSet setWithObject:HSCardGameModeSlugTypeConstructed],
            BlizzardHSAPIOptionTypeSort: [NSSet setWithArray:@[NSStringFromHSCardSort(HSCardSortManaCostAsc), NSStringFromHSCardSort(HSCardSortNameAsc)]]
        };
    } else if ([HSCardGameModeSlugTypeBattlegrounds isEqualToString:hsCardTypeSlugType]) {
        return @{
            BlizzardHSAPIOptionTypeType: [NSSet setWithObject:HSCardTypeSlugTypeMinion],
            BlizzardHSAPIOptionTypeGameMode: [NSSet setWithObject:HSCardGameModeSlugTypeBattlegrounds],
            BlizzardHSAPIOptionTypeSort: [NSSet setWithArray:@[NSStringFromHSCardSort(HSCardSortTierAsc), NSStringFromHSCardSort(HSCardSortNameAsc)]]
        };
    } else {
        return @{};
    }
}

NSDictionary<BlizzardHSAPIOptionType, NSSet<NSString *> *> *BlizzardConstructedHSAPIDefaultOptionsFromHSDeckFormat(HSDeckFormat hsDeckFormat) {
    HSCardSetSlugType setSlugType;
    
    if ([HSDeckFormatClassic isEqualToString:hsDeckFormat]) {
        setSlugType = HSCardSetSlugTypeClassicCards;
    } else if ([HSDeckFormatStandard isEqualToString:hsDeckFormat]) {
        setSlugType = HSCardSetSlugTypeStandardCards;
    } else if ([HSDeckFormatWild isEqualToString:hsDeckFormat]) {
        setSlugType = HSCardSetSlugTypeWildCards;
    } else {
        setSlugType = @"";
    }
    
    return @{
        BlizzardHSAPIOptionTypeSet: [NSSet setWithObject:setSlugType],
        BlizzardHSAPIOptionTypeClass: [NSSet setWithObject:HSCardClassSlugTypeNeutral],
        BlizzardHSAPIOptionTypeCollectible: [NSSet setWithObject:NSStringFromHSCardCollectible(HSCardCollectibleYES)],
        BlizzardHSAPIOptionTypeGameMode: [NSSet setWithObject:HSCardGameModeSlugTypeConstructed],
        BlizzardHSAPIOptionTypeSort: [NSSet setWithArray:@[NSStringFromHSCardSort(HSCardSortManaCostAsc), NSStringFromHSCardSort(HSCardSortNameAsc)]]
    };
}

NSDictionary<BlizzardHSAPIOptionType, NSSet<NSString *> *> *BlizzardHSAPIDefaultOptionsForHSCardBacks(void) {
    return @{};
}
