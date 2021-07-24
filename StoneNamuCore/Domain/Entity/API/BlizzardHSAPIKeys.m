//
//  BlizzardHSAPIKeys.m
//  StoneNamuCore
//
//  Created by Jinwoo Kim on 7/24/21.
//

#import "BlizzardHSAPIKeys.h"

NSString * NSStringFromOptionType(BlizzardHSAPIOptionType type) {
    switch (type) {
        case BlizzardHSAPIOptionTypeLocale:
            return @"locale";
        case BlizzardHSAPIOptionTypeSet:
            return @"set";
        case BlizzardHSAPIOptionTypeClass:
            return @"class";
        case BlizzardHSAPIOptionTypeManaCost:
            return @"manaCost";
        case BlizzardHSAPIOptionTypeAttack:
            return @"attack";
        case BlizzardHSAPIOptionTypeHealth:
            return @"health";
        case BlizzardHSAPIOptionTypeCollectible:
            return @"collectible";
        case BlizzardHSAPIOptionTypeRarity:
            return @"rarity";
        case BlizzardHSAPIOptionTypeType:
            return @"type";
        case BlizzardHSAPIOptionTypeMinionType:
            return @"minionType";
        case BlizzardHSAPIOptionTypeKeyword:
            return @"keyword";
        case BlizzardHSAPIOptionTypeTextFilter:
            return @"textFilter";
        case BlizzardHSAPIOptionTypeGameMode:
            return @"gameMode";
        case BlizzardHSAPIOptionTypeSort:
            return @"sort";
        case BlizzardHSAPIOptionTypePage:
            return @"page";
        default:
            return @"";
    }
}
