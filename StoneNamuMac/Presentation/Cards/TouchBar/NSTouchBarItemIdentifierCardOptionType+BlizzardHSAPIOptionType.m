//
//  NSTouchBarItemIdentifierCardOptionType+BlizzardHSAPIOptionType.m
//  StoneNamuMac
//
//  Created by Jinwoo Kim on 11/1/21.
//

#import "NSTouchBarItemIdentifierCardOptionType+BlizzardHSAPIOptionType.h"

NSArray<NSTouchBarItemIdentifier> * allNSTouchBarItemIdentifierCardOptionTypes(void) {
    return @[
        NSTouchBarItemIdentifierCardOptionTypeSet,
        NSTouchBarItemIdentifierCardOptionTypeClass,
        NSTouchBarItemIdentifierCardOptionTypeManaCost,
        NSTouchBarItemIdentifierCardOptionTypeAttack,
        NSTouchBarItemIdentifierCardOptionTypeHealth,
        NSTouchBarItemIdentifierCardOptionTypeCollecticle,
        NSTouchBarItemIdentifierCardOptionTypeRarity,
        NSTouchBarItemIdentifierCardOptionTypeType,
        NSTouchBarItemIdentifierCardOptionTypeMinionType,
        NSTouchBarItemIdentifierCardOptionTypeSchoolSpell,
        NSTouchBarItemIdentifierCardOptionTypeKeyword,
        NSTouchBarItemIdentifierCardOptionTypeGameMode,
        NSTouchBarItemIdentifierCardOptionTypeSort
    ];
}

NSTouchBarItemIdentifier NSTouchBarItemIdentifierCardOptionTypeFromBlizzardHSAPIOptionType(BlizzardHSAPIOptionType type) {
    if ([type isEqualToString:BlizzardHSAPIOptionTypeSet]) {
        return NSTouchBarItemIdentifierCardOptionTypeSet;
    } else if ([type isEqualToString:BlizzardHSAPIOptionTypeClass]) {
        return NSTouchBarItemIdentifierCardOptionTypeClass;
    } else if ([type isEqualToString:BlizzardHSAPIOptionTypeManaCost]) {
        return NSTouchBarItemIdentifierCardOptionTypeManaCost;
    } else if ([type isEqualToString:BlizzardHSAPIOptionTypeAttack]) {
        return NSTouchBarItemIdentifierCardOptionTypeAttack;
    } else if ([type isEqualToString:BlizzardHSAPIOptionTypeHealth]) {
        return NSTouchBarItemIdentifierCardOptionTypeHealth;
    } else if ([type isEqualToString:BlizzardHSAPIOptionTypeCollectible]) {
        return NSTouchBarItemIdentifierCardOptionTypeCollecticle;
    } else if ([type isEqualToString:BlizzardHSAPIOptionTypeRarity]) {
        return NSTouchBarItemIdentifierCardOptionTypeRarity;
    } else if ([type isEqualToString:BlizzardHSAPIOptionTypeType]) {
        return NSTouchBarItemIdentifierCardOptionTypeType;
    } else if ([type isEqualToString:BlizzardHSAPIOptionTypeMinionType]) {
        return NSTouchBarItemIdentifierCardOptionTypeMinionType;
    } else if ([type isEqualToString:BlizzardHSAPIOptionTypeSpellSchool]) {
        return NSTouchBarItemIdentifierCardOptionTypeSchoolSpell;
    } else if ([type isEqualToString:BlizzardHSAPIOptionTypeKeyword]) {
        return NSTouchBarItemIdentifierCardOptionTypeKeyword;
    } else if ([type isEqualToString:BlizzardHSAPIOptionTypeGameMode]) {
        return NSTouchBarItemIdentifierCardOptionTypeGameMode;
    } else if ([type isEqualToString:BlizzardHSAPIOptionTypeSort]) {
        return NSTouchBarItemIdentifierCardOptionTypeSort;
    } else {
        return @"";
    }
}

BlizzardHSAPIOptionType BlizzardHSAPIOptionTypeFromNSTouchBarItemIdentifierCardOptionType(NSTouchBarItemIdentifier itemIdentifier) {
    if ([itemIdentifier isEqualToString:NSTouchBarItemIdentifierCardOptionTypeSet]) {
        return BlizzardHSAPIOptionTypeSet;
    } else if ([itemIdentifier isEqualToString:NSTouchBarItemIdentifierCardOptionTypeClass]) {
        return BlizzardHSAPIOptionTypeClass;
    } else if ([itemIdentifier isEqualToString:NSTouchBarItemIdentifierCardOptionTypeManaCost]) {
        return BlizzardHSAPIOptionTypeManaCost;
    } else if ([itemIdentifier isEqualToString:NSTouchBarItemIdentifierCardOptionTypeAttack]) {
        return BlizzardHSAPIOptionTypeAttack;
    } else if ([itemIdentifier isEqualToString:NSTouchBarItemIdentifierCardOptionTypeHealth]) {
        return BlizzardHSAPIOptionTypeHealth;
    } else if ([itemIdentifier isEqualToString:NSTouchBarItemIdentifierCardOptionTypeCollecticle]) {
        return BlizzardHSAPIOptionTypeCollectible;
    } else if ([itemIdentifier isEqualToString:NSTouchBarItemIdentifierCardOptionTypeRarity]) {
        return BlizzardHSAPIOptionTypeRarity;
    } else if ([itemIdentifier isEqualToString:NSTouchBarItemIdentifierCardOptionTypeType]) {
        return BlizzardHSAPIOptionTypeType;
    } else if ([itemIdentifier isEqualToString:NSTouchBarItemIdentifierCardOptionTypeMinionType]) {
        return BlizzardHSAPIOptionTypeMinionType;
    } else if ([itemIdentifier isEqualToString:NSTouchBarItemIdentifierCardOptionTypeSchoolSpell]) {
        return BlizzardHSAPIOptionTypeSpellSchool;
    } else if ([itemIdentifier isEqualToString:NSTouchBarItemIdentifierCardOptionTypeKeyword]) {
        return BlizzardHSAPIOptionTypeKeyword;
    } else if ([itemIdentifier isEqualToString:NSTouchBarItemIdentifierCardOptionTypeGameMode]) {
        return BlizzardHSAPIOptionTypeGameMode;
    } else if ([itemIdentifier isEqualToString:NSTouchBarItemIdentifierCardOptionTypeSort]) {
        return BlizzardHSAPIOptionTypeSort;
    } else {
        return @"";
    }
}
