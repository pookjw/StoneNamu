//
//  NSTouchBarItemIdentifierDeckAddCardOptionType+BlizzardHSAPIOptionType.m
//  StoneNamuMac
//
//  Created by Jinwoo Kim on 12/3/21.
//

#import "NSTouchBarItemIdentifierDeckAddCardOptionType+BlizzardHSAPIOptionType.h"

NSArray<NSTouchBarItemIdentifier> * allNSTouchBarItemIdentifierDeckAddCardOptionTypes(void) {
    return @[
        NSTouchBarItemIdentifierDeckAddCardOptionTypeSet,
        NSTouchBarItemIdentifierDeckAddCardOptionTypeClass,
        NSTouchBarItemIdentifierDeckAddCardOptionTypeManaCost,
        NSTouchBarItemIdentifierDeckAddCardOptionTypeAttack,
        NSTouchBarItemIdentifierDeckAddCardOptionTypeHealth,
        NSTouchBarItemIdentifierDeckAddCardOptionTypeCollecticle,
        NSTouchBarItemIdentifierDeckAddCardOptionTypeRarity,
        NSTouchBarItemIdentifierDeckAddCardOptionTypeType,
        NSTouchBarItemIdentifierDeckAddCardOptionTypeMinionType,
        NSTouchBarItemIdentifierDeckAddCardOptionTypeSchoolSpell,
        NSTouchBarItemIdentifierDeckAddCardOptionTypeKeyword,
        NSTouchBarItemIdentifierDeckAddCardOptionTypeGameMode,
        NSTouchBarItemIdentifierDeckAddCardOptionTypeSort
    ];
}

NSTouchBarItemIdentifier NSTouchBarItemIdentifierDeckAddCardOptionTypeFromBlizzardHSAPIOptionType(BlizzardHSAPIOptionType type) {
    if ([type isEqualToString:BlizzardHSAPIOptionTypeSet]) {
        return NSTouchBarItemIdentifierDeckAddCardOptionTypeSet;
    } else if ([type isEqualToString:BlizzardHSAPIOptionTypeClass]) {
        return NSTouchBarItemIdentifierDeckAddCardOptionTypeClass;
    } else if ([type isEqualToString:BlizzardHSAPIOptionTypeManaCost]) {
        return NSTouchBarItemIdentifierDeckAddCardOptionTypeManaCost;
    } else if ([type isEqualToString:BlizzardHSAPIOptionTypeAttack]) {
        return NSTouchBarItemIdentifierDeckAddCardOptionTypeAttack;
    } else if ([type isEqualToString:BlizzardHSAPIOptionTypeHealth]) {
        return NSTouchBarItemIdentifierDeckAddCardOptionTypeHealth;
    } else if ([type isEqualToString:BlizzardHSAPIOptionTypeCollectible]) {
        return NSTouchBarItemIdentifierDeckAddCardOptionTypeCollecticle;
    } else if ([type isEqualToString:BlizzardHSAPIOptionTypeRarity]) {
        return NSTouchBarItemIdentifierDeckAddCardOptionTypeRarity;
    } else if ([type isEqualToString:BlizzardHSAPIOptionTypeType]) {
        return NSTouchBarItemIdentifierDeckAddCardOptionTypeType;
    } else if ([type isEqualToString:BlizzardHSAPIOptionTypeMinionType]) {
        return NSTouchBarItemIdentifierDeckAddCardOptionTypeMinionType;
    } else if ([type isEqualToString:BlizzardHSAPIOptionTypeSpellSchool]) {
        return NSTouchBarItemIdentifierDeckAddCardOptionTypeSchoolSpell;
    } else if ([type isEqualToString:BlizzardHSAPIOptionTypeKeyword]) {
        return NSTouchBarItemIdentifierDeckAddCardOptionTypeKeyword;
    } else if ([type isEqualToString:BlizzardHSAPIOptionTypeGameMode]) {
        return NSTouchBarItemIdentifierDeckAddCardOptionTypeGameMode;
    } else if ([type isEqualToString:BlizzardHSAPIOptionTypeSort]) {
        return NSTouchBarItemIdentifierDeckAddCardOptionTypeSort;
    } else {
        return @"";
    }
}

BlizzardHSAPIOptionType BlizzardHSAPIOptionTypeFromNSTouchBarItemIdentifierDeckAddCardOptionType(NSTouchBarItemIdentifier itemIdentifier) {
    if ([itemIdentifier isEqualToString:NSTouchBarItemIdentifierDeckAddCardOptionTypeSet]) {
        return BlizzardHSAPIOptionTypeSet;
    } else if ([itemIdentifier isEqualToString:NSTouchBarItemIdentifierDeckAddCardOptionTypeClass]) {
        return BlizzardHSAPIOptionTypeClass;
    } else if ([itemIdentifier isEqualToString:NSTouchBarItemIdentifierDeckAddCardOptionTypeManaCost]) {
        return BlizzardHSAPIOptionTypeManaCost;
    } else if ([itemIdentifier isEqualToString:NSTouchBarItemIdentifierDeckAddCardOptionTypeAttack]) {
        return BlizzardHSAPIOptionTypeAttack;
    } else if ([itemIdentifier isEqualToString:NSTouchBarItemIdentifierDeckAddCardOptionTypeHealth]) {
        return BlizzardHSAPIOptionTypeHealth;
    } else if ([itemIdentifier isEqualToString:NSTouchBarItemIdentifierDeckAddCardOptionTypeCollecticle]) {
        return BlizzardHSAPIOptionTypeCollectible;
    } else if ([itemIdentifier isEqualToString:NSTouchBarItemIdentifierDeckAddCardOptionTypeRarity]) {
        return BlizzardHSAPIOptionTypeRarity;
    } else if ([itemIdentifier isEqualToString:NSTouchBarItemIdentifierDeckAddCardOptionTypeType]) {
        return BlizzardHSAPIOptionTypeType;
    } else if ([itemIdentifier isEqualToString:NSTouchBarItemIdentifierDeckAddCardOptionTypeMinionType]) {
        return BlizzardHSAPIOptionTypeMinionType;
    } else if ([itemIdentifier isEqualToString:NSTouchBarItemIdentifierDeckAddCardOptionTypeSchoolSpell]) {
        return BlizzardHSAPIOptionTypeSpellSchool;
    } else if ([itemIdentifier isEqualToString:NSTouchBarItemIdentifierDeckAddCardOptionTypeKeyword]) {
        return BlizzardHSAPIOptionTypeKeyword;
    } else if ([itemIdentifier isEqualToString:NSTouchBarItemIdentifierDeckAddCardOptionTypeGameMode]) {
        return BlizzardHSAPIOptionTypeGameMode;
    } else if ([itemIdentifier isEqualToString:NSTouchBarItemIdentifierDeckAddCardOptionTypeSort]) {
        return BlizzardHSAPIOptionTypeSort;
    } else {
        return @"";
    }
}
