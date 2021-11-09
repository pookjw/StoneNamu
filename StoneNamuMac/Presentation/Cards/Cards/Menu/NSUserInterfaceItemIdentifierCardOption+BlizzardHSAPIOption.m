//
//  NSUserInterfaceItemIdentifierCardOption+BlizzardHSAPIOption.m
//  StoneNamuMac
//
//  Created by Jinwoo Kim on 11/9/21.
//

#import "NSUserInterfaceItemIdentifierCardOption+BlizzardHSAPIOption.h"

NSArray<NSUserInterfaceItemIdentifier> *allNSUserInterfaceItemIdentifierCardOptions(void) {
    return @[
        NSUserInterfaceItemIdentifierCardOptionTextFilter,
        NSUserInterfaceItemIdentifierCardOptionSet,
        NSUserInterfaceItemIdentifierCardOptionClass,
        NSUserInterfaceItemIdentifierCardOptionManaCost,
        NSUserInterfaceItemIdentifierCardOptionAttack,
        NSUserInterfaceItemIdentifierCardOptionHealth,
        NSUserInterfaceItemIdentifierCardOptionCollectible,
        NSUserInterfaceItemIdentifierCardOptionRarity,
        NSUserInterfaceItemIdentifierCardOptionType,
        NSUserInterfaceItemIdentifierCardOptionMinionType,
        NSUserInterfaceItemIdentifierCardOptionSpellSchool,
        NSUserInterfaceItemIdentifierCardOptionKeyword,
        NSUserInterfaceItemIdentifierCardOptionGameMode,
        NSUserInterfaceItemIdentifierCardOptionSort
    ];
}

NSUserInterfaceItemIdentifier NSUserInterfaceItemIdentifierCardOptionFromBlizzardHSAPIOptionType(BlizzardHSAPIOptionType type) {
    if ([type isEqualToString:BlizzardHSAPIOptionTypeTextFilter]) {
        return NSUserInterfaceItemIdentifierCardOptionTextFilter;
    } else if ([type isEqualToString:BlizzardHSAPIOptionTypeSet]) {
        return NSUserInterfaceItemIdentifierCardOptionSet;
    } else if ([type isEqualToString:BlizzardHSAPIOptionTypeClass]) {
        return NSUserInterfaceItemIdentifierCardOptionClass;
    } else if ([type isEqualToString:BlizzardHSAPIOptionTypeManaCost]) {
        return NSUserInterfaceItemIdentifierCardOptionManaCost;
    } else if ([type isEqualToString:BlizzardHSAPIOptionTypeAttack]) {
        return NSUserInterfaceItemIdentifierCardOptionAttack;
    } else if ([type isEqualToString:BlizzardHSAPIOptionTypeHealth]) {
        return NSUserInterfaceItemIdentifierCardOptionHealth;
    } else if ([type isEqualToString:BlizzardHSAPIOptionTypeCollectible]) {
        return NSUserInterfaceItemIdentifierCardOptionCollectible;
    } else if ([type isEqualToString:BlizzardHSAPIOptionTypeRarity]) {
        return NSUserInterfaceItemIdentifierCardOptionRarity;
    } else if ([type isEqualToString:BlizzardHSAPIOptionTypeType]) {
        return NSUserInterfaceItemIdentifierCardOptionType;
    } else if ([type isEqualToString:BlizzardHSAPIOptionTypeMinionType]) {
        return NSUserInterfaceItemIdentifierCardOptionMinionType;
    } else if ([type isEqualToString:BlizzardHSAPIOptionTypeSpellSchool]) {
        return NSUserInterfaceItemIdentifierCardOptionSpellSchool;
    } else if ([type isEqualToString:BlizzardHSAPIOptionTypeKeyword]) {
        return NSUserInterfaceItemIdentifierCardOptionKeyword;
    } else if ([type isEqualToString:BlizzardHSAPIOptionTypeGameMode]) {
        return NSUserInterfaceItemIdentifierCardOptionGameMode;
    } else if ([type isEqualToString:BlizzardHSAPIOptionTypeSort]) {
        return NSUserInterfaceItemIdentifierCardOptionSort;
    } else {
        return @"";
    }
}

BlizzardHSAPIOptionType BlizzardHSAPIOptionTypeFromNSUserInterfaceItemIdentifierCardOption(NSUserInterfaceItemIdentifier item) {
    if ([item isEqualToString:NSUserInterfaceItemIdentifierCardOptionTextFilter]) {
        return BlizzardHSAPIOptionTypeTextFilter;
    } else if ([item isEqualToString:NSUserInterfaceItemIdentifierCardOptionSet]) {
        return BlizzardHSAPIOptionTypeSet;
    } else if ([item isEqualToString:NSUserInterfaceItemIdentifierCardOptionClass]) {
        return BlizzardHSAPIOptionTypeClass;
    } else if ([item isEqualToString:NSUserInterfaceItemIdentifierCardOptionManaCost]) {
        return BlizzardHSAPIOptionTypeManaCost;
    } else if ([item isEqualToString:NSUserInterfaceItemIdentifierCardOptionAttack]) {
        return BlizzardHSAPIOptionTypeAttack;
    } else if ([item isEqualToString:NSUserInterfaceItemIdentifierCardOptionHealth]) {
        return BlizzardHSAPIOptionTypeHealth;
    } else if ([item isEqualToString:NSUserInterfaceItemIdentifierCardOptionCollectible]) {
        return BlizzardHSAPIOptionTypeCollectible;
    } else if ([item isEqualToString:NSUserInterfaceItemIdentifierCardOptionRarity]) {
        return BlizzardHSAPIOptionTypeRarity;
    } else if ([item isEqualToString:NSUserInterfaceItemIdentifierCardOptionType]) {
        return BlizzardHSAPIOptionTypeType;
    } else if ([item isEqualToString:NSUserInterfaceItemIdentifierCardOptionMinionType]) {
        return BlizzardHSAPIOptionTypeMinionType;
    } else if ([item isEqualToString:NSUserInterfaceItemIdentifierCardOptionSpellSchool]) {
        return BlizzardHSAPIOptionTypeSpellSchool;
    } else if ([item isEqualToString:NSUserInterfaceItemIdentifierCardOptionKeyword]) {
        return BlizzardHSAPIOptionTypeKeyword;
    } else if ([item isEqualToString:NSUserInterfaceItemIdentifierCardOptionGameMode]) {
        return BlizzardHSAPIOptionTypeGameMode;
    } else if ([item isEqualToString:NSUserInterfaceItemIdentifierCardOptionSort]) {
        return BlizzardHSAPIOptionTypeSort;
    } else {
        return @"";
    }
}
