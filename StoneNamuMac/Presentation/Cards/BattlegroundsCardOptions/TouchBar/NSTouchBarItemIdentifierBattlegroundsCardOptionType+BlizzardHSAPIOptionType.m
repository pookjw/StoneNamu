//
//  NSTouchBarItemIdentifierBattlegroundsCardOptionType+BlizzardHSAPIOptionType.m
//  StoneNamuMac
//
//  Created by Jinwoo Kim on 2/28/22.
//

#import "NSTouchBarItemIdentifierBattlegroundsCardOptionType+BlizzardHSAPIOptionType.h"

NSArray<NSTouchBarItemIdentifier> * allNSTouchBarItemIdentifierBattlegroundsCardOptionTypes(void) {
    return @[
        NSTouchBarItemIdentifierBattlegroundsCardOptionTypeTier,
        NSTouchBarItemIdentifierBattlegroundsCardOptionTypeAttack,
        NSTouchBarItemIdentifierBattlegroundsCardOptionTypeHealth,
        NSTouchBarItemIdentifierBattlegroundsCardOptionTypeType,
        NSTouchBarItemIdentifierBattlegroundsCardOptionTypeMinionType,
        NSTouchBarItemIdentifierBattlegroundsCardOptionTypeKeyword,
        NSTouchBarItemIdentifierBattlegroundsCardOptionTypeSort
    ];
}

NSTouchBarItemIdentifier NSTouchBarItemIdentifierBattlegroundsCardOptionTypeFromBlizzardHSAPIOptionType(BlizzardHSAPIOptionType type) {
    if ([type isEqualToString:BlizzardHSAPIOptionTypeTier]) {
        return NSTouchBarItemIdentifierBattlegroundsCardOptionTypeTier;
    } else if ([type isEqualToString:BlizzardHSAPIOptionTypeAttack]) {
        return NSTouchBarItemIdentifierBattlegroundsCardOptionTypeAttack;
    } else if ([type isEqualToString:BlizzardHSAPIOptionTypeHealth]) {
        return NSTouchBarItemIdentifierBattlegroundsCardOptionTypeHealth;
    } else if ([type isEqualToString:BlizzardHSAPIOptionTypeType]) {
        return NSTouchBarItemIdentifierBattlegroundsCardOptionTypeType;
    } else if ([type isEqualToString:BlizzardHSAPIOptionTypeMinionType]) {
        return NSTouchBarItemIdentifierBattlegroundsCardOptionTypeMinionType;
    } else if ([type isEqualToString:BlizzardHSAPIOptionTypeKeyword]) {
        return NSTouchBarItemIdentifierBattlegroundsCardOptionTypeKeyword;
    } else if ([type isEqualToString:BlizzardHSAPIOptionTypeSort]) {
        return NSTouchBarItemIdentifierBattlegroundsCardOptionTypeSort;
    } else {
        return @"";
    }
}

BlizzardHSAPIOptionType BlizzardHSAPIOptionTypeFromNSTouchBarItemIdentifierBattlegroundsCardOptionType(NSTouchBarItemIdentifier itemIdentifier) {
    if ([itemIdentifier isEqualToString:NSTouchBarItemIdentifierBattlegroundsCardOptionTypeTier]) {
        return BlizzardHSAPIOptionTypeTier;
    } else if ([itemIdentifier isEqualToString:NSTouchBarItemIdentifierBattlegroundsCardOptionTypeAttack]) {
        return BlizzardHSAPIOptionTypeAttack;
    } else if ([itemIdentifier isEqualToString:NSTouchBarItemIdentifierBattlegroundsCardOptionTypeHealth]) {
        return BlizzardHSAPIOptionTypeHealth;
    } else if ([itemIdentifier isEqualToString:NSTouchBarItemIdentifierBattlegroundsCardOptionTypeType]) {
        return BlizzardHSAPIOptionTypeType;
    } else if ([itemIdentifier isEqualToString:NSTouchBarItemIdentifierBattlegroundsCardOptionTypeMinionType]) {
        return BlizzardHSAPIOptionTypeMinionType;
    } else if ([itemIdentifier isEqualToString:NSTouchBarItemIdentifierBattlegroundsCardOptionTypeKeyword]) {
        return BlizzardHSAPIOptionTypeKeyword;
    } else if ([itemIdentifier isEqualToString:NSTouchBarItemIdentifierBattlegroundsCardOptionTypeSort]) {
        return BlizzardHSAPIOptionTypeSort;
    } else {
        return @"";
    }
}
