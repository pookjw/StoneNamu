//
//  NSTouchBarItemIdentifierCardOptions+BlizzardHSAPIOptionType.m
//  StoneNamuMac
//
//  Created by Jinwoo Kim on 11/1/21.
//

#import "NSTouchBarItemIdentifierCardOptions+BlizzardHSAPIOptionType.h"

NSArray<NSTouchBarItemIdentifier> * AllNSTouchBarItemIdentifierCardOptions(void) {
    return @[
        NSTouchBarItemIdentifierCardOptionsTypeSet,
        NSTouchBarItemIdentifierCardOptionsTypeClass,
        NSTouchBarItemIdentifierCardOptionsTypeManaCost,
        NSTouchBarItemIdentifierCardOptionsTypeAttack,
        NSTouchBarItemIdentifierCardOptionsTypeHealth,
        NSTouchBarItemIdentifierCardOptionsTypeCollecticle,
        NSTouchBarItemIdentifierCardOptionsTypeRarity,
        NSTouchBarItemIdentifierCardOptionsTypeType,
        NSTouchBarItemIdentifierCardOptionsTypeMinionType,
        NSTouchBarItemIdentifierCardOptionsTypeSchoolSpell,
        NSTouchBarItemIdentifierCardOptionsTypeKeyword,
        NSTouchBarItemIdentifierCardOptionsTypeGameMode,
        NSTouchBarItemIdentifierCardOptionsTypeSort
    ];
}

NSTouchBarItemIdentifier NSTouchBarItemIdentifierCardOptionsFromBlizzardHSAPIOptionType(BlizzardHSAPIOptionType type) {
    if ([type isEqualToString:BlizzardHSAPIOptionTypeSet]) {
        return NSTouchBarItemIdentifierCardOptionsTypeSet;
    } else if ([type isEqualToString:BlizzardHSAPIOptionTypeClass]) {
        return NSTouchBarItemIdentifierCardOptionsTypeClass;
    } else if ([type isEqualToString:BlizzardHSAPIOptionTypeManaCost]) {
        return NSTouchBarItemIdentifierCardOptionsTypeManaCost;
    } else if ([type isEqualToString:BlizzardHSAPIOptionTypeAttack]) {
        return NSTouchBarItemIdentifierCardOptionsTypeAttack;
    } else if ([type isEqualToString:BlizzardHSAPIOptionTypeHealth]) {
        return NSTouchBarItemIdentifierCardOptionsTypeHealth;
    } else if ([type isEqualToString:BlizzardHSAPIOptionTypeCollectible]) {
        return NSTouchBarItemIdentifierCardOptionsTypeCollecticle;
    } else if ([type isEqualToString:BlizzardHSAPIOptionTypeRarity]) {
        return NSTouchBarItemIdentifierCardOptionsTypeRarity;
    } else if ([type isEqualToString:BlizzardHSAPIOptionTypeType]) {
        return NSTouchBarItemIdentifierCardOptionsTypeType;
    } else if ([type isEqualToString:BlizzardHSAPIOptionTypeMinionType]) {
        return NSTouchBarItemIdentifierCardOptionsTypeMinionType;
    } else if ([type isEqualToString:BlizzardHSAPIOptionTypeSpellSchool]) {
        return NSTouchBarItemIdentifierCardOptionsTypeSchoolSpell;
    } else if ([type isEqualToString:BlizzardHSAPIOptionTypeKeyword]) {
        return NSTouchBarItemIdentifierCardOptionsTypeKeyword;
    } else if ([type isEqualToString:BlizzardHSAPIOptionTypeGameMode]) {
        return NSTouchBarItemIdentifierCardOptionsTypeGameMode;
    } else if ([type isEqualToString:BlizzardHSAPIOptionTypeSort]) {
        return NSTouchBarItemIdentifierCardOptionsTypeSort;
    } else {
        return @"";
    }
}

BlizzardHSAPIOptionType BlizzardHSAPIOptionTypeFromNSTouchBarItemIdentifierCardOptions(NSTouchBarItemIdentifier itemIdentifier) {
    if ([itemIdentifier isEqualToString:NSTouchBarItemIdentifierCardOptionsTypeSet]) {
        return BlizzardHSAPIOptionTypeSet;
    } else if ([itemIdentifier isEqualToString:NSTouchBarItemIdentifierCardOptionsTypeClass]) {
        return BlizzardHSAPIOptionTypeClass;
    } else if ([itemIdentifier isEqualToString:NSTouchBarItemIdentifierCardOptionsTypeManaCost]) {
        return BlizzardHSAPIOptionTypeManaCost;
    } else if ([itemIdentifier isEqualToString:NSTouchBarItemIdentifierCardOptionsTypeAttack]) {
        return BlizzardHSAPIOptionTypeAttack;
    } else if ([itemIdentifier isEqualToString:NSTouchBarItemIdentifierCardOptionsTypeHealth]) {
        return BlizzardHSAPIOptionTypeHealth;
    } else if ([itemIdentifier isEqualToString:NSTouchBarItemIdentifierCardOptionsTypeCollecticle]) {
        return BlizzardHSAPIOptionTypeCollectible;
    } else if ([itemIdentifier isEqualToString:NSTouchBarItemIdentifierCardOptionsTypeRarity]) {
        return BlizzardHSAPIOptionTypeRarity;
    } else if ([itemIdentifier isEqualToString:NSTouchBarItemIdentifierCardOptionsTypeType]) {
        return BlizzardHSAPIOptionTypeType;
    } else if ([itemIdentifier isEqualToString:NSTouchBarItemIdentifierCardOptionsTypeMinionType]) {
        return BlizzardHSAPIOptionTypeMinionType;
    } else if ([itemIdentifier isEqualToString:NSTouchBarItemIdentifierCardOptionsTypeSchoolSpell]) {
        return BlizzardHSAPIOptionTypeSpellSchool;
    } else if ([itemIdentifier isEqualToString:NSTouchBarItemIdentifierCardOptionsTypeKeyword]) {
        return BlizzardHSAPIOptionTypeKeyword;
    } else if ([itemIdentifier isEqualToString:NSTouchBarItemIdentifierCardOptionsTypeGameMode]) {
        return BlizzardHSAPIOptionTypeGameMode;
    } else if ([itemIdentifier isEqualToString:NSTouchBarItemIdentifierCardOptionsTypeSort]) {
        return BlizzardHSAPIOptionTypeSort;
    } else {
        return @"";
    }
}
