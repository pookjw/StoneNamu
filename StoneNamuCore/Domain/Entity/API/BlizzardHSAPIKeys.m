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

NSString * _Nullable PrefferedSystemSymbolFromBlizzardHSAPIDefaultOptions(BlizzardHSAPIOptionType option) {
    if ([option isEqualToString:BlizzardHSAPIOptionTypeSet]) {
        return @"book.circle";
    } else if ([option isEqualToString:BlizzardHSAPIOptionTypeClass]) {
        return @"person.circle";
    } else if ([option isEqualToString:BlizzardHSAPIOptionTypeManaCost]) {
        return @"dollarsign.circle";
    } else if ([option isEqualToString:BlizzardHSAPIOptionTypeAttack]) {
        return @"staroflife.circle";
    } else if ([option isEqualToString:BlizzardHSAPIOptionTypeHealth]) {
        return @"heart.circle";
    } else if ([option isEqualToString:BlizzardHSAPIOptionTypeCollectible]) {
        return @"tray.circle";
    } else if ([option isEqualToString:BlizzardHSAPIOptionTypeRarity]) {
        return @"star.circle";
    } else if ([option isEqualToString:BlizzardHSAPIOptionTypeType]) {
        return @"list.bullet.circle";
    } else if ([option isEqualToString:BlizzardHSAPIOptionTypeMinionType]) {
        return @"list.bullet.circle";
    } else if ([option isEqualToString:BlizzardHSAPIOptionTypeSpellSchool]) {
        return @"line.3.crossed.swirl.circle";
    } else if ([option isEqualToString:BlizzardHSAPIOptionTypeKeyword]) {
        return @"list.bullet.circle";
    } else if ([option isEqualToString:BlizzardHSAPIOptionTypeTextFilter]) {
        return @"a.circle";
    } else if ([option isEqualToString:BlizzardHSAPIOptionTypeGameMode]) {
        return @"flag.circle";
    } else if ([option isEqualToString:BlizzardHSAPIOptionTypeSort]) {
        return @"arrow.up.arrow.down.circle";
    } else {
        return nil;
    }
}
