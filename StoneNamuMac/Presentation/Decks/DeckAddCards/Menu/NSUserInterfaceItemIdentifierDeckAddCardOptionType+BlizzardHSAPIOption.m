//
//  NSUserInterfaceItemIdentifierDeckAddCardOptionType+BlizzardHSAPIOption.m
//  StoneNamuMac
//
//  Created by Jinwoo Kim on 12/3/21.
//

#import "NSUserInterfaceItemIdentifierDeckAddCardOptionType+BlizzardHSAPIOption.h"

NSArray<NSUserInterfaceItemIdentifier> *allNSUserInterfaceItemIdentifierDeckAddCardOptionType(void) {
    return @[
        NSUserInterfaceItemIdentifierDeckAddCardOptionTypeTextFilter,
        NSUserInterfaceItemIdentifierDeckAddCardOptionTypeSet,
        NSUserInterfaceItemIdentifierDeckAddCardOptionTypeClass,
        NSUserInterfaceItemIdentifierDeckAddCardOptionTypeManaCost,
        NSUserInterfaceItemIdentifierDeckAddCardOptionTypeAttack,
        NSUserInterfaceItemIdentifierDeckAddCardOptionTypeHealth,
        NSUserInterfaceItemIdentifierDeckAddCardOptionTypeCollectible,
        NSUserInterfaceItemIdentifierDeckAddCardOptionTypeRarity,
        NSUserInterfaceItemIdentifierDeckAddCardOptionTypeType,
        NSUserInterfaceItemIdentifierDeckAddCardOptionTypeMinionType,
        NSUserInterfaceItemIdentifierDeckAddCardOptionTypeSpellSchool,
        NSUserInterfaceItemIdentifierDeckAddCardOptionTypeKeyword,
        NSUserInterfaceItemIdentifierDeckAddCardOptionTypeGameMode,
        NSUserInterfaceItemIdentifierDeckAddCardOptionTypeSort
    ];
}

NSUserInterfaceItemIdentifier NSUserInterfaceItemIdentifierDeckAddCardOptionTypeFromBlizzardHSAPIOptionType(BlizzardHSAPIOptionType type) {
    if ([type isEqualToString:BlizzardHSAPIOptionTypeTextFilter]) {
        return NSUserInterfaceItemIdentifierDeckAddCardOptionTypeTextFilter;
    } else if ([type isEqualToString:BlizzardHSAPIOptionTypeSet]) {
        return NSUserInterfaceItemIdentifierDeckAddCardOptionTypeSet;
    } else if ([type isEqualToString:BlizzardHSAPIOptionTypeClass]) {
        return NSUserInterfaceItemIdentifierDeckAddCardOptionTypeClass;
    } else if ([type isEqualToString:BlizzardHSAPIOptionTypeManaCost]) {
        return NSUserInterfaceItemIdentifierDeckAddCardOptionTypeManaCost;
    } else if ([type isEqualToString:BlizzardHSAPIOptionTypeAttack]) {
        return NSUserInterfaceItemIdentifierDeckAddCardOptionTypeAttack;
    } else if ([type isEqualToString:BlizzardHSAPIOptionTypeHealth]) {
        return NSUserInterfaceItemIdentifierDeckAddCardOptionTypeHealth;
    } else if ([type isEqualToString:BlizzardHSAPIOptionTypeCollectible]) {
        return NSUserInterfaceItemIdentifierDeckAddCardOptionTypeCollectible;
    } else if ([type isEqualToString:BlizzardHSAPIOptionTypeRarity]) {
        return NSUserInterfaceItemIdentifierDeckAddCardOptionTypeRarity;
    } else if ([type isEqualToString:BlizzardHSAPIOptionTypeType]) {
        return NSUserInterfaceItemIdentifierDeckAddCardOptionTypeType;
    } else if ([type isEqualToString:BlizzardHSAPIOptionTypeMinionType]) {
        return NSUserInterfaceItemIdentifierDeckAddCardOptionTypeMinionType;
    } else if ([type isEqualToString:BlizzardHSAPIOptionTypeSpellSchool]) {
        return NSUserInterfaceItemIdentifierDeckAddCardOptionTypeSpellSchool;
    } else if ([type isEqualToString:BlizzardHSAPIOptionTypeKeyword]) {
        return NSUserInterfaceItemIdentifierDeckAddCardOptionTypeKeyword;
    } else if ([type isEqualToString:BlizzardHSAPIOptionTypeGameMode]) {
        return NSUserInterfaceItemIdentifierDeckAddCardOptionTypeGameMode;
    } else if ([type isEqualToString:BlizzardHSAPIOptionTypeSort]) {
        return NSUserInterfaceItemIdentifierDeckAddCardOptionTypeSort;
    } else {
        return @"";
    }
}

BlizzardHSAPIOptionType BlizzardHSAPIOptionTypeFromNSUserInterfaceItemIdentifierDeckAddCardOptionType(NSUserInterfaceItemIdentifier item) {
    if ([item isEqualToString:NSUserInterfaceItemIdentifierDeckAddCardOptionTypeTextFilter]) {
        return BlizzardHSAPIOptionTypeTextFilter;
    } else if ([item isEqualToString:NSUserInterfaceItemIdentifierDeckAddCardOptionTypeSet]) {
        return BlizzardHSAPIOptionTypeSet;
    } else if ([item isEqualToString:NSUserInterfaceItemIdentifierDeckAddCardOptionTypeClass]) {
        return BlizzardHSAPIOptionTypeClass;
    } else if ([item isEqualToString:NSUserInterfaceItemIdentifierDeckAddCardOptionTypeManaCost]) {
        return BlizzardHSAPIOptionTypeManaCost;
    } else if ([item isEqualToString:NSUserInterfaceItemIdentifierDeckAddCardOptionTypeAttack]) {
        return BlizzardHSAPIOptionTypeAttack;
    } else if ([item isEqualToString:NSUserInterfaceItemIdentifierDeckAddCardOptionTypeHealth]) {
        return BlizzardHSAPIOptionTypeHealth;
    } else if ([item isEqualToString:NSUserInterfaceItemIdentifierDeckAddCardOptionTypeCollectible]) {
        return BlizzardHSAPIOptionTypeCollectible;
    } else if ([item isEqualToString:NSUserInterfaceItemIdentifierDeckAddCardOptionTypeRarity]) {
        return BlizzardHSAPIOptionTypeRarity;
    } else if ([item isEqualToString:NSUserInterfaceItemIdentifierDeckAddCardOptionTypeType]) {
        return BlizzardHSAPIOptionTypeType;
    } else if ([item isEqualToString:NSUserInterfaceItemIdentifierDeckAddCardOptionTypeMinionType]) {
        return BlizzardHSAPIOptionTypeMinionType;
    } else if ([item isEqualToString:NSUserInterfaceItemIdentifierDeckAddCardOptionTypeSpellSchool]) {
        return BlizzardHSAPIOptionTypeSpellSchool;
    } else if ([item isEqualToString:NSUserInterfaceItemIdentifierDeckAddCardOptionTypeKeyword]) {
        return BlizzardHSAPIOptionTypeKeyword;
    } else if ([item isEqualToString:NSUserInterfaceItemIdentifierDeckAddCardOptionTypeGameMode]) {
        return BlizzardHSAPIOptionTypeGameMode;
    } else if ([item isEqualToString:NSUserInterfaceItemIdentifierDeckAddCardOptionTypeSort]) {
        return BlizzardHSAPIOptionTypeSort;
    } else {
        return @"";
    }
}
