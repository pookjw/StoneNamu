//
//  NSToolbarIdentifierCardOptions+BlizzardHSAPIOptionType.m
//  StoneNamuMac
//
//  Created by Jinwoo Kim on 11/1/21.
//

#import "NSToolbarIdentifierCardOptions+BlizzardHSAPIOptionType.h"

NSArray<NSToolbarIdentifier> * AllNSToolbarIdentifierCardOptionsType(void) {
    return @[
        NSToolbarIdentifierCardOptionsTypeTextFilter,
        NSToolbarIdentifierCardOptionsTypeSet,
        NSToolbarIdentifierCardOptionsTypeClass,
        NSToolbarIdentifierCardOptionsTypeManaCost,
        NSToolbarIdentifierCardOptionsTypeAttack,
        NSToolbarIdentifierCardOptionsTypeHealth,
        NSToolbarIdentifierCardOptionsTypeCollecticle,
        NSToolbarIdentifierCardOptionsTypeRarity,
        NSToolbarIdentifierCardOptionsTypeType,
        NSToolbarIdentifierCardOptionsTypeMinionType,
        NSToolbarIdentifierCardOptionsTypeSpellSchool,
        NSToolbarIdentifierCardOptionsTypeKeyword,
        NSToolbarIdentifierCardOptionsTypeGameMode,
        NSToolbarIdentifierCardOptionsTypeSort
    ];
}

NSToolbarIdentifier NSToolbarIdentifierCardOptionsFromBlizzardHSAPIOptionType(BlizzardHSAPIOptionType type) {
    if ([type isEqualToString:BlizzardHSAPIOptionTypeSet]) {
        return NSToolbarIdentifierCardOptionsTypeSet;
    } else if ([type isEqualToString:BlizzardHSAPIOptionTypeClass]) {
        return NSToolbarIdentifierCardOptionsTypeClass;
    } else if ([type isEqualToString:BlizzardHSAPIOptionTypeManaCost]) {
        return NSToolbarIdentifierCardOptionsTypeManaCost;
    } else if ([type isEqualToString:BlizzardHSAPIOptionTypeAttack]) {
        return NSToolbarIdentifierCardOptionsTypeAttack;
    } else if ([type isEqualToString:BlizzardHSAPIOptionTypeHealth]) {
        return NSToolbarIdentifierCardOptionsTypeHealth;
    } else if ([type isEqualToString:BlizzardHSAPIOptionTypeCollectible]) {
        return NSToolbarIdentifierCardOptionsTypeCollecticle;
    } else if ([type isEqualToString:BlizzardHSAPIOptionTypeRarity]) {
        return NSToolbarIdentifierCardOptionsTypeRarity;
    } else if ([type isEqualToString:BlizzardHSAPIOptionTypeType]) {
        return NSToolbarIdentifierCardOptionsTypeType;
    } else if ([type isEqualToString:BlizzardHSAPIOptionTypeMinionType]) {
        return NSToolbarIdentifierCardOptionsTypeMinionType;
    } else if ([type isEqualToString:BlizzardHSAPIOptionTypeSpellSchool]) {
        return NSToolbarIdentifierCardOptionsTypeSpellSchool;
    } else if ([type isEqualToString:BlizzardHSAPIOptionTypeKeyword]) {
        return NSToolbarIdentifierCardOptionsTypeKeyword;
    } else if ([type isEqualToString:BlizzardHSAPIOptionTypeTextFilter]) {
        return NSToolbarIdentifierCardOptionsTypeTextFilter;
    } else if ([type isEqualToString:BlizzardHSAPIOptionTypeGameMode]) {
        return NSToolbarIdentifierCardOptionsTypeGameMode;
    } else if ([type isEqualToString:BlizzardHSAPIOptionTypeSort]) {
        return NSToolbarIdentifierCardOptionsTypeSort;
    } else {
        return @"";
    }
}

BlizzardHSAPIOptionType BlizzardHSAPIOptionTypeFromNSToolbarIdentifierCardOptions(NSToolbarIdentifier itemIdentifier) {
    if ([itemIdentifier isEqualToString:NSToolbarIdentifierCardOptionsTypeTextFilter]) {
        return BlizzardHSAPIOptionTypeTextFilter;
    } else if ([itemIdentifier isEqualToString:NSToolbarIdentifierCardOptionsTypeSet]) {
        return BlizzardHSAPIOptionTypeSet;
    } else if ([itemIdentifier isEqualToString:NSToolbarIdentifierCardOptionsTypeClass]) {
        return BlizzardHSAPIOptionTypeClass;
    } else if ([itemIdentifier isEqualToString:NSToolbarIdentifierCardOptionsTypeManaCost]) {
        return BlizzardHSAPIOptionTypeManaCost;
    } else if ([itemIdentifier isEqualToString:NSToolbarIdentifierCardOptionsTypeAttack]) {
        return BlizzardHSAPIOptionTypeAttack;
    } else if ([itemIdentifier isEqualToString:NSToolbarIdentifierCardOptionsTypeHealth]) {
        return BlizzardHSAPIOptionTypeHealth;
    } else if ([itemIdentifier isEqualToString:NSToolbarIdentifierCardOptionsTypeCollecticle]) {
        return BlizzardHSAPIOptionTypeCollectible;
    } else if ([itemIdentifier isEqualToString:NSToolbarIdentifierCardOptionsTypeRarity]) {
        return BlizzardHSAPIOptionTypeRarity;
    } else if ([itemIdentifier isEqualToString:NSToolbarIdentifierCardOptionsTypeType]) {
        return BlizzardHSAPIOptionTypeType;
    } else if ([itemIdentifier isEqualToString:NSToolbarIdentifierCardOptionsTypeMinionType]) {
        return BlizzardHSAPIOptionTypeMinionType;
    } else if ([itemIdentifier isEqualToString:NSToolbarIdentifierCardOptionsTypeSpellSchool]) {
        return BlizzardHSAPIOptionTypeSpellSchool;
    } else if ([itemIdentifier isEqualToString:NSToolbarIdentifierCardOptionsTypeKeyword]) {
        return BlizzardHSAPIOptionTypeKeyword;
    } else if ([itemIdentifier isEqualToString:NSToolbarIdentifierCardOptionsTypeGameMode]) {
        return BlizzardHSAPIOptionTypeGameMode;
    } else if ([itemIdentifier isEqualToString:NSToolbarIdentifierCardOptionsTypeSort]) {
        return BlizzardHSAPIOptionTypeSort;
    } else {
        return @"";
    }
}
