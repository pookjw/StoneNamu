//
//  NSUserInterfaceItemIdentifierCardOptions+BlizzardHSAPIOption.m
//  StoneNamuMac
//
//  Created by Jinwoo Kim on 11/9/21.
//

#import "NSUserInterfaceItemIdentifierCardOptions+BlizzardHSAPIOption.h"

NSArray<NSUserInterfaceItemIdentifier> *allNSUserInterfaceItemIdentifierCardOptions(void) {
    return @[
        NSUserInterfaceItemIdentifierCardOptionsTextFilter,
        NSUserInterfaceItemIdentifierCardOptionsSet,
        NSUserInterfaceItemIdentifierCardOptionsClass,
        NSUserInterfaceItemIdentifierCardOptionsManaCost,
        NSUserInterfaceItemIdentifierCardOptionsAttack,
        NSUserInterfaceItemIdentifierCardOptionsHealth,
        NSUserInterfaceItemIdentifierCardOptionsCollectible,
        NSUserInterfaceItemIdentifierCardOptionsRarity,
        NSUserInterfaceItemIdentifierCardOptionsType,
        NSUserInterfaceItemIdentifierCardOptionsMinionType,
        NSUserInterfaceItemIdentifierCardOptionsSpellSchool,
        NSUserInterfaceItemIdentifierCardOptionsKeyword,
        NSUserInterfaceItemIdentifierCardOptionsGameMode,
        NSUserInterfaceItemIdentifierCardOptionsSort
    ];
}

NSUserInterfaceItemIdentifier NSUserInterfaceItemIdentifierCardOptionsFromBlizzardHSAPIOptionType(BlizzardHSAPIOptionType type) {
    if ([type isEqualToString:BlizzardHSAPIOptionTypeTextFilter]) {
        return NSUserInterfaceItemIdentifierCardOptionsTextFilter;
    } else if ([type isEqualToString:BlizzardHSAPIOptionTypeSet]) {
        return NSUserInterfaceItemIdentifierCardOptionsSet;
    } else if ([type isEqualToString:BlizzardHSAPIOptionTypeClass]) {
        return NSUserInterfaceItemIdentifierCardOptionsClass;
    } else if ([type isEqualToString:BlizzardHSAPIOptionTypeManaCost]) {
        return NSUserInterfaceItemIdentifierCardOptionsManaCost;
    } else if ([type isEqualToString:BlizzardHSAPIOptionTypeAttack]) {
        return NSUserInterfaceItemIdentifierCardOptionsAttack;
    } else if ([type isEqualToString:BlizzardHSAPIOptionTypeHealth]) {
        return NSUserInterfaceItemIdentifierCardOptionsHealth;
    } else if ([type isEqualToString:BlizzardHSAPIOptionTypeCollectible]) {
        return NSUserInterfaceItemIdentifierCardOptionsCollectible;
    } else if ([type isEqualToString:BlizzardHSAPIOptionTypeRarity]) {
        return NSUserInterfaceItemIdentifierCardOptionsRarity;
    } else if ([type isEqualToString:BlizzardHSAPIOptionTypeType]) {
        return NSUserInterfaceItemIdentifierCardOptionsType;
    } else if ([type isEqualToString:BlizzardHSAPIOptionTypeMinionType]) {
        return NSUserInterfaceItemIdentifierCardOptionsMinionType;
    } else if ([type isEqualToString:BlizzardHSAPIOptionTypeSpellSchool]) {
        return NSUserInterfaceItemIdentifierCardOptionsSpellSchool;
    } else if ([type isEqualToString:BlizzardHSAPIOptionTypeKeyword]) {
        return NSUserInterfaceItemIdentifierCardOptionsKeyword;
    } else if ([type isEqualToString:BlizzardHSAPIOptionTypeGameMode]) {
        return NSUserInterfaceItemIdentifierCardOptionsGameMode;
    } else if ([type isEqualToString:BlizzardHSAPIOptionTypeSort]) {
        return NSUserInterfaceItemIdentifierCardOptionsSort;
    } else {
        return @"";
    }
}

BlizzardHSAPIOptionType BlizzardHSAPIOptionTypeFromNSUserInterfaceItemIdentifierCardOptions(NSUserInterfaceItemIdentifier item) {
    if ([item isEqualToString:NSUserInterfaceItemIdentifierCardOptionsTextFilter]) {
        return BlizzardHSAPIOptionTypeTextFilter;
    } else if ([item isEqualToString:NSUserInterfaceItemIdentifierCardOptionsSet]) {
        return BlizzardHSAPIOptionTypeSet;
    } else if ([item isEqualToString:NSUserInterfaceItemIdentifierCardOptionsClass]) {
        return BlizzardHSAPIOptionTypeClass;
    } else if ([item isEqualToString:NSUserInterfaceItemIdentifierCardOptionsManaCost]) {
        return BlizzardHSAPIOptionTypeManaCost;
    } else if ([item isEqualToString:NSUserInterfaceItemIdentifierCardOptionsAttack]) {
        return BlizzardHSAPIOptionTypeAttack;
    } else if ([item isEqualToString:NSUserInterfaceItemIdentifierCardOptionsHealth]) {
        return BlizzardHSAPIOptionTypeHealth;
    } else if ([item isEqualToString:NSUserInterfaceItemIdentifierCardOptionsCollectible]) {
        return BlizzardHSAPIOptionTypeCollectible;
    } else if ([item isEqualToString:NSUserInterfaceItemIdentifierCardOptionsRarity]) {
        return BlizzardHSAPIOptionTypeRarity;
    } else if ([item isEqualToString:NSUserInterfaceItemIdentifierCardOptionsType]) {
        return BlizzardHSAPIOptionTypeType;
    } else if ([item isEqualToString:NSUserInterfaceItemIdentifierCardOptionsMinionType]) {
        return BlizzardHSAPIOptionTypeMinionType;
    } else if ([item isEqualToString:NSUserInterfaceItemIdentifierCardOptionsSpellSchool]) {
        return BlizzardHSAPIOptionTypeSpellSchool;
    } else if ([item isEqualToString:NSUserInterfaceItemIdentifierCardOptionsKeyword]) {
        return BlizzardHSAPIOptionTypeKeyword;
    } else if ([item isEqualToString:NSUserInterfaceItemIdentifierCardOptionsGameMode]) {
        return BlizzardHSAPIOptionTypeGameMode;
    } else if ([item isEqualToString:NSUserInterfaceItemIdentifierCardOptionsSort]) {
        return BlizzardHSAPIOptionTypeSort;
    } else {
        return @"";
    }
}
