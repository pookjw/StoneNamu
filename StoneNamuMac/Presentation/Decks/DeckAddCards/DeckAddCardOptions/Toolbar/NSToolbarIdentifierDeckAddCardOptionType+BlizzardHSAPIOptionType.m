//
//  NSToolbarIdentifierDeckAddCardOptionType+BlizzardHSAPIOptionType.m
//  StoneNamuMac
//
//  Created by Jinwoo Kim on 12/3/21.
//

#import "NSToolbarIdentifierDeckAddCardOptionType+BlizzardHSAPIOptionType.h"

NSArray<NSToolbarIdentifier> * allNSToolbarIdentifierDeckAddCardOptionTypes(void) {
    return @[
        NSToolbarIdentifierDeckAddCardOptionTypeTextFilter,
        NSToolbarIdentifierDeckAddCardOptionTypeSet,
        NSToolbarIdentifierDeckAddCardOptionTypeClass,
        NSToolbarIdentifierDeckAddCardOptionTypeManaCost,
        NSToolbarIdentifierDeckAddCardOptionTypeAttack,
        NSToolbarIdentifierDeckAddCardOptionTypeHealth,
        NSToolbarIdentifierDeckAddCardOptionTypeCollecticle,
        NSToolbarIdentifierDeckAddCardOptionTypeRarity,
        NSToolbarIdentifierDeckAddCardOptionTypeType,
        NSToolbarIdentifierDeckAddCardOptionTypeMinionType,
        NSToolbarIdentifierDeckAddCardOptionTypeSpellSchool,
        NSToolbarIdentifierDeckAddCardOptionTypeKeyword,
        NSToolbarIdentifierDeckAddCardOptionTypeGameMode,
        NSToolbarIdentifierDeckAddCardOptionTypeSort
    ];
}

NSToolbarIdentifier NSToolbarIdentifierDeckAddCardOptionTypeFromBlizzardHSAPIOptionType(BlizzardHSAPIOptionType type) {
    if ([type isEqualToString:BlizzardHSAPIOptionTypeSet]) {
        return NSToolbarIdentifierDeckAddCardOptionTypeSet;
    } else if ([type isEqualToString:BlizzardHSAPIOptionTypeClass]) {
        return NSToolbarIdentifierDeckAddCardOptionTypeClass;
    } else if ([type isEqualToString:BlizzardHSAPIOptionTypeManaCost]) {
        return NSToolbarIdentifierDeckAddCardOptionTypeManaCost;
    } else if ([type isEqualToString:BlizzardHSAPIOptionTypeAttack]) {
        return NSToolbarIdentifierDeckAddCardOptionTypeAttack;
    } else if ([type isEqualToString:BlizzardHSAPIOptionTypeHealth]) {
        return NSToolbarIdentifierDeckAddCardOptionTypeHealth;
    } else if ([type isEqualToString:BlizzardHSAPIOptionTypeCollectible]) {
        return NSToolbarIdentifierDeckAddCardOptionTypeCollecticle;
    } else if ([type isEqualToString:BlizzardHSAPIOptionTypeRarity]) {
        return NSToolbarIdentifierDeckAddCardOptionTypeRarity;
    } else if ([type isEqualToString:BlizzardHSAPIOptionTypeType]) {
        return NSToolbarIdentifierDeckAddCardOptionTypeType;
    } else if ([type isEqualToString:BlizzardHSAPIOptionTypeMinionType]) {
        return NSToolbarIdentifierDeckAddCardOptionTypeMinionType;
    } else if ([type isEqualToString:BlizzardHSAPIOptionTypeSpellSchool]) {
        return NSToolbarIdentifierDeckAddCardOptionTypeSpellSchool;
    } else if ([type isEqualToString:BlizzardHSAPIOptionTypeKeyword]) {
        return NSToolbarIdentifierDeckAddCardOptionTypeKeyword;
    } else if ([type isEqualToString:BlizzardHSAPIOptionTypeTextFilter]) {
        return NSToolbarIdentifierDeckAddCardOptionTypeTextFilter;
    } else if ([type isEqualToString:BlizzardHSAPIOptionTypeGameMode]) {
        return NSToolbarIdentifierDeckAddCardOptionTypeGameMode;
    } else if ([type isEqualToString:BlizzardHSAPIOptionTypeSort]) {
        return NSToolbarIdentifierDeckAddCardOptionTypeSort;
    } else {
        return @"";
    }
}

BlizzardHSAPIOptionType BlizzardHSAPIOptionTypeFromNSToolbarIdentifierDeckAddCardOptionType(NSToolbarIdentifier itemIdentifier) {
    if ([itemIdentifier isEqualToString:NSToolbarIdentifierDeckAddCardOptionTypeTextFilter]) {
        return BlizzardHSAPIOptionTypeTextFilter;
    } else if ([itemIdentifier isEqualToString:NSToolbarIdentifierDeckAddCardOptionTypeSet]) {
        return BlizzardHSAPIOptionTypeSet;
    } else if ([itemIdentifier isEqualToString:NSToolbarIdentifierDeckAddCardOptionTypeClass]) {
        return BlizzardHSAPIOptionTypeClass;
    } else if ([itemIdentifier isEqualToString:NSToolbarIdentifierDeckAddCardOptionTypeManaCost]) {
        return BlizzardHSAPIOptionTypeManaCost;
    } else if ([itemIdentifier isEqualToString:NSToolbarIdentifierDeckAddCardOptionTypeAttack]) {
        return BlizzardHSAPIOptionTypeAttack;
    } else if ([itemIdentifier isEqualToString:NSToolbarIdentifierDeckAddCardOptionTypeHealth]) {
        return BlizzardHSAPIOptionTypeHealth;
    } else if ([itemIdentifier isEqualToString:NSToolbarIdentifierDeckAddCardOptionTypeCollecticle]) {
        return BlizzardHSAPIOptionTypeCollectible;
    } else if ([itemIdentifier isEqualToString:NSToolbarIdentifierDeckAddCardOptionTypeRarity]) {
        return BlizzardHSAPIOptionTypeRarity;
    } else if ([itemIdentifier isEqualToString:NSToolbarIdentifierDeckAddCardOptionTypeType]) {
        return BlizzardHSAPIOptionTypeType;
    } else if ([itemIdentifier isEqualToString:NSToolbarIdentifierDeckAddCardOptionTypeMinionType]) {
        return BlizzardHSAPIOptionTypeMinionType;
    } else if ([itemIdentifier isEqualToString:NSToolbarIdentifierDeckAddCardOptionTypeSpellSchool]) {
        return BlizzardHSAPIOptionTypeSpellSchool;
    } else if ([itemIdentifier isEqualToString:NSToolbarIdentifierDeckAddCardOptionTypeKeyword]) {
        return BlizzardHSAPIOptionTypeKeyword;
    } else if ([itemIdentifier isEqualToString:NSToolbarIdentifierDeckAddCardOptionTypeGameMode]) {
        return BlizzardHSAPIOptionTypeGameMode;
    } else if ([itemIdentifier isEqualToString:NSToolbarIdentifierDeckAddCardOptionTypeSort]) {
        return BlizzardHSAPIOptionTypeSort;
    } else {
        return @"";
    }
}

