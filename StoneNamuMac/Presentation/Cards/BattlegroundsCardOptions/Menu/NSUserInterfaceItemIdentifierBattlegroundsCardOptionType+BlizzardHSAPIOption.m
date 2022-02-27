//
//  NSUserInterfaceItemIdentifierBattlegroundsCardOptionType+BlizzardHSAPIOption.m
//  StoneNamuMac
//
//  Created by Jinwoo Kim on 2/27/22.
//

#import "NSUserInterfaceItemIdentifierBattlegroundsCardOptionType+BlizzardHSAPIOption.h"

NSArray<NSUserInterfaceItemIdentifier> *allNSUserInterfaceItemIdentifierBattlegroundsCardOptionTypes(void) {
    return @[
        NSUserInterfaceItemIdentifierBattlegroundsCardOptionTypeTextFilter,
        NSUserInterfaceItemIdentifierBattlegroundsCardOptionTypeTier,
        NSUserInterfaceItemIdentifierBattlegroundsCardOptionTypeAttack,
        NSUserInterfaceItemIdentifierBattlegroundsCardOptionTypeHealth,
        NSUserInterfaceItemIdentifierBattlegroundsCardOptionTypeType,
        NSUserInterfaceItemIdentifierBattlegroundsCardOptionTypeMinionType,
        NSUserInterfaceItemIdentifierBattlegroundsCardOptionTypeKeyword,
        NSUserInterfaceItemIdentifierBattlegroundsCardOptionTypeSort
    ];
}

NSUserInterfaceItemIdentifier NSUserInterfaceItemIdentifierBattlegroundsCardOptionTypeFromBlizzardHSAPIOptionType(BlizzardHSAPIOptionType type) {
    if ([type isEqualToString:BlizzardHSAPIOptionTypeTextFilter]) {
        return NSUserInterfaceItemIdentifierBattlegroundsCardOptionTypeTextFilter;
    } else if ([type isEqualToString:BlizzardHSAPIOptionTypeTier]) {
        return NSUserInterfaceItemIdentifierBattlegroundsCardOptionTypeTier;
    } else if ([type isEqualToString:BlizzardHSAPIOptionTypeAttack]) {
        return NSUserInterfaceItemIdentifierBattlegroundsCardOptionTypeAttack;
    } else if ([type isEqualToString:BlizzardHSAPIOptionTypeHealth]) {
        return NSUserInterfaceItemIdentifierBattlegroundsCardOptionTypeHealth;
    } else if ([type isEqualToString:BlizzardHSAPIOptionTypeType]) {
        return NSUserInterfaceItemIdentifierBattlegroundsCardOptionTypeType;
    } else if ([type isEqualToString:BlizzardHSAPIOptionTypeMinionType]) {
        return NSUserInterfaceItemIdentifierBattlegroundsCardOptionTypeMinionType;
    } else if ([type isEqualToString:BlizzardHSAPIOptionTypeKeyword]) {
        return NSUserInterfaceItemIdentifierBattlegroundsCardOptionTypeKeyword;
    } else if ([type isEqualToString:BlizzardHSAPIOptionTypeSort]) {
        return NSUserInterfaceItemIdentifierBattlegroundsCardOptionTypeSort;
    } else {
        return @"";
    }
}

BlizzardHSAPIOptionType BlizzardHSAPIOptionTypeFromNSUserInterfaceItemIdentifierBattlegroundsCardOptionType(NSUserInterfaceItemIdentifier item) {
    if ([item isEqualToString:NSUserInterfaceItemIdentifierBattlegroundsCardOptionTypeTextFilter]) {
        return BlizzardHSAPIOptionTypeTextFilter;
    } else if ([item isEqualToString:NSUserInterfaceItemIdentifierBattlegroundsCardOptionTypeTier]) {
        return BlizzardHSAPIOptionTypeTier;
    } else if ([item isEqualToString:NSUserInterfaceItemIdentifierBattlegroundsCardOptionTypeAttack]) {
        return BlizzardHSAPIOptionTypeAttack;
    } else if ([item isEqualToString:NSUserInterfaceItemIdentifierBattlegroundsCardOptionTypeHealth]) {
        return BlizzardHSAPIOptionTypeHealth;
    } else if ([item isEqualToString:NSUserInterfaceItemIdentifierBattlegroundsCardOptionTypeType]) {
        return BlizzardHSAPIOptionTypeType;
    } else if ([item isEqualToString:NSUserInterfaceItemIdentifierBattlegroundsCardOptionTypeMinionType]) {
        return BlizzardHSAPIOptionTypeMinionType;
    } else if ([item isEqualToString:NSUserInterfaceItemIdentifierBattlegroundsCardOptionTypeKeyword]) {
        return BlizzardHSAPIOptionTypeKeyword;
    } else if ([item isEqualToString:NSUserInterfaceItemIdentifierBattlegroundsCardOptionTypeSort]) {
        return BlizzardHSAPIOptionTypeSort;
    } else {
        return @"";
    }
}
