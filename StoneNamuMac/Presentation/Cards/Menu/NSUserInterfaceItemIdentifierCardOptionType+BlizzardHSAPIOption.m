//
//  NSUserInterfaceItemIdentifierCardOptionType+BlizzardHSAPIOption.m
//  StoneNamuMac
//
//  Created by Jinwoo Kim on 11/9/21.
//

#import "NSUserInterfaceItemIdentifierCardOptionType+BlizzardHSAPIOption.h"

NSArray<NSUserInterfaceItemIdentifier> *allNSUserInterfaceItemIdentifierCardOptionTypes(void) {
    return @[
        NSUserInterfaceItemIdentifierCardOptionTypeTextFilter,
        NSUserInterfaceItemIdentifierCardOptionTypeSet,
        NSUserInterfaceItemIdentifierCardOptionTypeClass,
        NSUserInterfaceItemIdentifierCardOptionTypeManaCost,
        NSUserInterfaceItemIdentifierCardOptionTypeAttack,
        NSUserInterfaceItemIdentifierCardOptionTypeHealth,
        NSUserInterfaceItemIdentifierCardOptionTypeCollectible,
        NSUserInterfaceItemIdentifierCardOptionTypeRarity,
        NSUserInterfaceItemIdentifierCardOptionTypeType,
        NSUserInterfaceItemIdentifierCardOptionTypeMinionType,
        NSUserInterfaceItemIdentifierCardOptionTypeSpellSchool,
        NSUserInterfaceItemIdentifierCardOptionTypeKeyword,
        NSUserInterfaceItemIdentifierCardOptionTypeGameMode,
        NSUserInterfaceItemIdentifierCardOptionTypeSort
    ];
}

NSUserInterfaceItemIdentifier NSUserInterfaceItemIdentifierCardOptionTypeFromBlizzardHSAPIOptionType(BlizzardHSAPIOptionType type) {
    if ([type isEqualToString:BlizzardHSAPIOptionTypeTextFilter]) {
        return NSUserInterfaceItemIdentifierCardOptionTypeTextFilter;
    } else if ([type isEqualToString:BlizzardHSAPIOptionTypeSet]) {
        return NSUserInterfaceItemIdentifierCardOptionTypeSet;
    } else if ([type isEqualToString:BlizzardHSAPIOptionTypeClass]) {
        return NSUserInterfaceItemIdentifierCardOptionTypeClass;
    } else if ([type isEqualToString:BlizzardHSAPIOptionTypeManaCost]) {
        return NSUserInterfaceItemIdentifierCardOptionTypeManaCost;
    } else if ([type isEqualToString:BlizzardHSAPIOptionTypeAttack]) {
        return NSUserInterfaceItemIdentifierCardOptionTypeAttack;
    } else if ([type isEqualToString:BlizzardHSAPIOptionTypeHealth]) {
        return NSUserInterfaceItemIdentifierCardOptionTypeHealth;
    } else if ([type isEqualToString:BlizzardHSAPIOptionTypeCollectible]) {
        return NSUserInterfaceItemIdentifierCardOptionTypeCollectible;
    } else if ([type isEqualToString:BlizzardHSAPIOptionTypeRarity]) {
        return NSUserInterfaceItemIdentifierCardOptionTypeRarity;
    } else if ([type isEqualToString:BlizzardHSAPIOptionTypeType]) {
        return NSUserInterfaceItemIdentifierCardOptionTypeType;
    } else if ([type isEqualToString:BlizzardHSAPIOptionTypeMinionType]) {
        return NSUserInterfaceItemIdentifierCardOptionTypeMinionType;
    } else if ([type isEqualToString:BlizzardHSAPIOptionTypeSpellSchool]) {
        return NSUserInterfaceItemIdentifierCardOptionTypeSpellSchool;
    } else if ([type isEqualToString:BlizzardHSAPIOptionTypeKeyword]) {
        return NSUserInterfaceItemIdentifierCardOptionTypeKeyword;
    } else if ([type isEqualToString:BlizzardHSAPIOptionTypeGameMode]) {
        return NSUserInterfaceItemIdentifierCardOptionTypeGameMode;
    } else if ([type isEqualToString:BlizzardHSAPIOptionTypeSort]) {
        return NSUserInterfaceItemIdentifierCardOptionTypeSort;
    } else {
        return @"";
    }
}

BlizzardHSAPIOptionType BlizzardHSAPIOptionTypeFromNSUserInterfaceItemIdentifierCardOptionType(NSUserInterfaceItemIdentifier item) {
    if ([item isEqualToString:NSUserInterfaceItemIdentifierCardOptionTypeTextFilter]) {
        return BlizzardHSAPIOptionTypeTextFilter;
    } else if ([item isEqualToString:NSUserInterfaceItemIdentifierCardOptionTypeSet]) {
        return BlizzardHSAPIOptionTypeSet;
    } else if ([item isEqualToString:NSUserInterfaceItemIdentifierCardOptionTypeClass]) {
        return BlizzardHSAPIOptionTypeClass;
    } else if ([item isEqualToString:NSUserInterfaceItemIdentifierCardOptionTypeManaCost]) {
        return BlizzardHSAPIOptionTypeManaCost;
    } else if ([item isEqualToString:NSUserInterfaceItemIdentifierCardOptionTypeAttack]) {
        return BlizzardHSAPIOptionTypeAttack;
    } else if ([item isEqualToString:NSUserInterfaceItemIdentifierCardOptionTypeHealth]) {
        return BlizzardHSAPIOptionTypeHealth;
    } else if ([item isEqualToString:NSUserInterfaceItemIdentifierCardOptionTypeCollectible]) {
        return BlizzardHSAPIOptionTypeCollectible;
    } else if ([item isEqualToString:NSUserInterfaceItemIdentifierCardOptionTypeRarity]) {
        return BlizzardHSAPIOptionTypeRarity;
    } else if ([item isEqualToString:NSUserInterfaceItemIdentifierCardOptionTypeType]) {
        return BlizzardHSAPIOptionTypeType;
    } else if ([item isEqualToString:NSUserInterfaceItemIdentifierCardOptionTypeMinionType]) {
        return BlizzardHSAPIOptionTypeMinionType;
    } else if ([item isEqualToString:NSUserInterfaceItemIdentifierCardOptionTypeSpellSchool]) {
        return BlizzardHSAPIOptionTypeSpellSchool;
    } else if ([item isEqualToString:NSUserInterfaceItemIdentifierCardOptionTypeKeyword]) {
        return BlizzardHSAPIOptionTypeKeyword;
    } else if ([item isEqualToString:NSUserInterfaceItemIdentifierCardOptionTypeGameMode]) {
        return BlizzardHSAPIOptionTypeGameMode;
    } else if ([item isEqualToString:NSUserInterfaceItemIdentifierCardOptionTypeSort]) {
        return BlizzardHSAPIOptionTypeSort;
    } else {
        return @"";
    }
}
