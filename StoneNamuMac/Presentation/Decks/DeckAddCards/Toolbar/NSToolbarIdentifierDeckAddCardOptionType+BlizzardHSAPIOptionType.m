//
//  NSToolbarIdentifierDeckAddCardOptionType+BlizzardHSAPIOptionType.m
//  StoneNamuMac
//
//  Created by Jinwoo Kim on 12/3/21.
//

#import "NSToolbarIdentifierDeckAddCardOptionType+BlizzardHSAPIOptionType.h"

NSArray<NSToolbarIdentifier> * allNSToolbarIdentifierDeckAddCardOptionsType(void) {
    return @[
        NSToolbarIdentifierDeckAddCardOptionsTypeTextFilter,
        NSToolbarIdentifierDeckAddCardOptionsTypeSet,
        NSToolbarIdentifierDeckAddCardOptionsTypeClass,
        NSToolbarIdentifierDeckAddCardOptionsTypeManaCost,
        NSToolbarIdentifierDeckAddCardOptionsTypeAttack,
        NSToolbarIdentifierDeckAddCardOptionsTypeHealth,
        NSToolbarIdentifierDeckAddCardOptionsTypeCollecticle,
        NSToolbarIdentifierDeckAddCardOptionsTypeRarity,
        NSToolbarIdentifierDeckAddCardOptionsTypeType,
        NSToolbarIdentifierDeckAddCardOptionsTypeMinionType,
        NSToolbarIdentifierDeckAddCardOptionsTypeSpellSchool,
        NSToolbarIdentifierDeckAddCardOptionsTypeKeyword,
        NSToolbarIdentifierDeckAddCardOptionsTypeGameMode,
        NSToolbarIdentifierDeckAddCardOptionsTypeSort
    ];
}

NSToolbarIdentifier NSToolbarIdentifierDeckAddCardOptionsTypeFromBlizzardHSAPIOptionType(BlizzardHSAPIOptionType type) {
    if ([type isEqualToString:BlizzardHSAPIOptionTypeSet]) {
        return NSToolbarIdentifierDeckAddCardOptionsTypeSet;
    } else if ([type isEqualToString:BlizzardHSAPIOptionTypeClass]) {
        return NSToolbarIdentifierDeckAddCardOptionsTypeClass;
    } else if ([type isEqualToString:BlizzardHSAPIOptionTypeManaCost]) {
        return NSToolbarIdentifierDeckAddCardOptionsTypeManaCost;
    } else if ([type isEqualToString:BlizzardHSAPIOptionTypeAttack]) {
        return NSToolbarIdentifierDeckAddCardOptionsTypeAttack;
    } else if ([type isEqualToString:BlizzardHSAPIOptionTypeHealth]) {
        return NSToolbarIdentifierDeckAddCardOptionsTypeHealth;
    } else if ([type isEqualToString:BlizzardHSAPIOptionTypeCollectible]) {
        return NSToolbarIdentifierDeckAddCardOptionsTypeCollecticle;
    } else if ([type isEqualToString:BlizzardHSAPIOptionTypeRarity]) {
        return NSToolbarIdentifierDeckAddCardOptionsTypeRarity;
    } else if ([type isEqualToString:BlizzardHSAPIOptionTypeType]) {
        return NSToolbarIdentifierDeckAddCardOptionsTypeType;
    } else if ([type isEqualToString:BlizzardHSAPIOptionTypeMinionType]) {
        return NSToolbarIdentifierDeckAddCardOptionsTypeMinionType;
    } else if ([type isEqualToString:BlizzardHSAPIOptionTypeSpellSchool]) {
        return NSToolbarIdentifierDeckAddCardOptionsTypeSpellSchool;
    } else if ([type isEqualToString:BlizzardHSAPIOptionTypeKeyword]) {
        return NSToolbarIdentifierDeckAddCardOptionsTypeKeyword;
    } else if ([type isEqualToString:BlizzardHSAPIOptionTypeTextFilter]) {
        return NSToolbarIdentifierDeckAddCardOptionsTypeTextFilter;
    } else if ([type isEqualToString:BlizzardHSAPIOptionTypeGameMode]) {
        return NSToolbarIdentifierDeckAddCardOptionsTypeGameMode;
    } else if ([type isEqualToString:BlizzardHSAPIOptionTypeSort]) {
        return NSToolbarIdentifierDeckAddCardOptionsTypeSort;
    } else {
        return @"";
    }
}

BlizzardHSAPIOptionType BlizzardHSAPIOptionTypeFromNSToolbarIdentifierDeckAddCardOptionsType(NSToolbarIdentifier itemIdentifier) {
    if ([itemIdentifier isEqualToString:NSToolbarIdentifierDeckAddCardOptionsTypeTextFilter]) {
        return BlizzardHSAPIOptionTypeTextFilter;
    } else if ([itemIdentifier isEqualToString:NSToolbarIdentifierDeckAddCardOptionsTypeSet]) {
        return BlizzardHSAPIOptionTypeSet;
    } else if ([itemIdentifier isEqualToString:NSToolbarIdentifierDeckAddCardOptionsTypeClass]) {
        return BlizzardHSAPIOptionTypeClass;
    } else if ([itemIdentifier isEqualToString:NSToolbarIdentifierDeckAddCardOptionsTypeManaCost]) {
        return BlizzardHSAPIOptionTypeManaCost;
    } else if ([itemIdentifier isEqualToString:NSToolbarIdentifierDeckAddCardOptionsTypeAttack]) {
        return BlizzardHSAPIOptionTypeAttack;
    } else if ([itemIdentifier isEqualToString:NSToolbarIdentifierDeckAddCardOptionsTypeHealth]) {
        return BlizzardHSAPIOptionTypeHealth;
    } else if ([itemIdentifier isEqualToString:NSToolbarIdentifierDeckAddCardOptionsTypeCollecticle]) {
        return BlizzardHSAPIOptionTypeCollectible;
    } else if ([itemIdentifier isEqualToString:NSToolbarIdentifierDeckAddCardOptionsTypeRarity]) {
        return BlizzardHSAPIOptionTypeRarity;
    } else if ([itemIdentifier isEqualToString:NSToolbarIdentifierDeckAddCardOptionsTypeType]) {
        return BlizzardHSAPIOptionTypeType;
    } else if ([itemIdentifier isEqualToString:NSToolbarIdentifierDeckAddCardOptionsTypeMinionType]) {
        return BlizzardHSAPIOptionTypeMinionType;
    } else if ([itemIdentifier isEqualToString:NSToolbarIdentifierDeckAddCardOptionsTypeSpellSchool]) {
        return BlizzardHSAPIOptionTypeSpellSchool;
    } else if ([itemIdentifier isEqualToString:NSToolbarIdentifierDeckAddCardOptionsTypeKeyword]) {
        return BlizzardHSAPIOptionTypeKeyword;
    } else if ([itemIdentifier isEqualToString:NSToolbarIdentifierDeckAddCardOptionsTypeGameMode]) {
        return BlizzardHSAPIOptionTypeGameMode;
    } else if ([itemIdentifier isEqualToString:NSToolbarIdentifierDeckAddCardOptionsTypeSort]) {
        return BlizzardHSAPIOptionTypeSort;
    } else {
        return @"";
    }
}

