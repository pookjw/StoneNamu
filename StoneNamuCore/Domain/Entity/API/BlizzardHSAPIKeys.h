//
//  BlizzardHSAPIKeys.h
//  StoneNamuCore
//
//  Created by Jinwoo Kim on 7/18/21.
//

#import <Foundation/Foundation.h>

/*
 https://develop.battle.net/documentation/hearthstone/game-data-apis
 */

typedef NSString * BlizzardHSAPIOptionType NS_STRING_ENUM;

static BlizzardHSAPIOptionType const BlizzardHSAPIOptionTypeLocale = @"locale";
static BlizzardHSAPIOptionType const BlizzardHSAPIOptionTypeSet = @"set";
static BlizzardHSAPIOptionType const BlizzardHSAPIOptionTypeClass = @"class";
static BlizzardHSAPIOptionType const BlizzardHSAPIOptionTypeManaCost = @"manaCost";
static BlizzardHSAPIOptionType const BlizzardHSAPIOptionTypeAttack = @"attack";
static BlizzardHSAPIOptionType const BlizzardHSAPIOptionTypeHealth = @"health";
static BlizzardHSAPIOptionType const BlizzardHSAPIOptionTypeCollectible = @"collectible";
static BlizzardHSAPIOptionType const BlizzardHSAPIOptionTypeRarity = @"rarity";
static BlizzardHSAPIOptionType const BlizzardHSAPIOptionTypeType = @"type";
static BlizzardHSAPIOptionType const BlizzardHSAPIOptionTypeMinionType = @"minionType";
static BlizzardHSAPIOptionType const BlizzardHSAPIOptionTypeKeyword = @"keyword";
static BlizzardHSAPIOptionType const BlizzardHSAPIOptionTypeTextFilter = @"textFilter";
static BlizzardHSAPIOptionType const BlizzardHSAPIOptionTypeGameMode = @"gameMode";
static BlizzardHSAPIOptionType const BlizzardHSAPIOptionTypeSort = @"sort";
static BlizzardHSAPIOptionType const BlizzardHSAPIOptionTypePage = @"page";

static BlizzardHSAPIOptionType const BlizzardHSAPIOptionTypeIds = @"ids";
static BlizzardHSAPIOptionType const BlizzardHSAPIOptionTypeCode = @"code";
