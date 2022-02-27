//
//  NSToolbarIdentifierBattlegroundsCardOptionType+BlizzardHSAPIOptionType.m
//  StoneNamuMac
//
//  Created by Jinwoo Kim on 2/27/22.
//

#import "NSToolbarIdentifierBattlegroundsCardOptionType+BlizzardHSAPIOptionType.h"

NSArray<NSToolbarIdentifier> * allNSToolbarIdentifierBattlegroundsCardOptionTypes(void) {
    return @[
        NSToolbarIdentifierBattlegroundsCardOptionTypeTextFilter,
        NSToolbarIdentifierBattlegroundsCardOptionTypeTier,
        NSToolbarIdentifierBattlegroundsCardOptionTypeAttack,
        NSToolbarIdentifierBattlegroundsCardOptionTypeHealth,
        NSToolbarIdentifierBattlegroundsCardOptionTypeType,
        NSToolbarIdentifierBattlegroundsCardOptionTypeMinionType,
        NSToolbarIdentifierBattlegroundsCardOptionTypeKeyword,
        NSToolbarIdentifierBattlegroundsCardOptionTypeSort
    ];
}

NSToolbarIdentifier NSToolbarIdentifierBattlegroundsCardOptionTypeFromBlizzardHSAPIOptionType(BlizzardHSAPIOptionType type) {
    if ([type isEqualToString:BlizzardHSAPIOptionTypeTier]) {
        return NSToolbarIdentifierBattlegroundsCardOptionTypeTier;
    } else if ([type isEqualToString:BlizzardHSAPIOptionTypeAttack]) {
        return NSToolbarIdentifierBattlegroundsCardOptionTypeAttack;
    } else if ([type isEqualToString:BlizzardHSAPIOptionTypeHealth]) {
        return NSToolbarIdentifierBattlegroundsCardOptionTypeHealth;
    } else if ([type isEqualToString:BlizzardHSAPIOptionTypeType]) {
        return NSToolbarIdentifierBattlegroundsCardOptionTypeType;
    } else if ([type isEqualToString:BlizzardHSAPIOptionTypeMinionType]) {
        return NSToolbarIdentifierBattlegroundsCardOptionTypeMinionType;
    } else if ([type isEqualToString:BlizzardHSAPIOptionTypeKeyword]) {
        return NSToolbarIdentifierBattlegroundsCardOptionTypeKeyword;
    } else if ([type isEqualToString:BlizzardHSAPIOptionTypeTextFilter]) {
        return NSToolbarIdentifierBattlegroundsCardOptionTypeTextFilter;
    } else if ([type isEqualToString:BlizzardHSAPIOptionTypeSort]) {
        return NSToolbarIdentifierBattlegroundsCardOptionTypeSort;
    } else {
        return @"";
    }
}

BlizzardHSAPIOptionType BlizzardHSAPIOptionTypeFromNSToolbarIdentifierBattlegroundsCardOptionType(NSToolbarIdentifier itemIdentifier) {
    if ([itemIdentifier isEqualToString:NSToolbarIdentifierBattlegroundsCardOptionTypeTextFilter]) {
        return BlizzardHSAPIOptionTypeTextFilter;
    } else if ([itemIdentifier isEqualToString:NSToolbarIdentifierBattlegroundsCardOptionTypeTier]) {
        return BlizzardHSAPIOptionTypeTier;
    } else if ([itemIdentifier isEqualToString:NSToolbarIdentifierBattlegroundsCardOptionTypeAttack]) {
        return BlizzardHSAPIOptionTypeAttack;
    } else if ([itemIdentifier isEqualToString:NSToolbarIdentifierBattlegroundsCardOptionTypeHealth]) {
        return BlizzardHSAPIOptionTypeHealth;
    } else if ([itemIdentifier isEqualToString:NSToolbarIdentifierBattlegroundsCardOptionTypeType]) {
        return BlizzardHSAPIOptionTypeType;
    } else if ([itemIdentifier isEqualToString:NSToolbarIdentifierBattlegroundsCardOptionTypeMinionType]) {
        return BlizzardHSAPIOptionTypeMinionType;
    }else if ([itemIdentifier isEqualToString:NSToolbarIdentifierBattlegroundsCardOptionTypeKeyword]) {
        return BlizzardHSAPIOptionTypeKeyword;
    } else if ([itemIdentifier isEqualToString:NSToolbarIdentifierBattlegroundsCardOptionTypeSort]) {
        return BlizzardHSAPIOptionTypeSort;
    } else {
        return @"";
    }
}
