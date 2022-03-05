//
//  BlizzardHSAPIKeys.h
//  StoneNamuCore
//
//  Created by Jinwoo Kim on 7/18/21.
//

#import <Foundation/Foundation.h>
#import <StoneNamuCore/HSDeckFormat.h>
#import <StoneNamuCore/HSCardGameMode.h>

/*
 https://develop.battle.net/documentation/hearthstone/game-data-apis
 */

NS_ASSUME_NONNULL_BEGIN

typedef NSString * BlizzardHSAPIOptionType NS_TYPED_EXTENSIBLE_ENUM;

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
static BlizzardHSAPIOptionType const BlizzardHSAPIOptionTypeSpellSchool = @"spellSchool";
static BlizzardHSAPIOptionType const BlizzardHSAPIOptionTypeKeyword = @"keyword";
static BlizzardHSAPIOptionType const BlizzardHSAPIOptionTypeTextFilter = @"textFilter";
static BlizzardHSAPIOptionType const BlizzardHSAPIOptionTypeGameMode = @"gameMode";
static BlizzardHSAPIOptionType const BlizzardHSAPIOptionTypeSort = @"sort";
static BlizzardHSAPIOptionType const BlizzardHSAPIOptionTypeTier = @"tier";
static BlizzardHSAPIOptionType const BlizzardHSAPIOptionTypePage = @"page";

static BlizzardHSAPIOptionType const BlizzardHSAPIOptionTypeIds = @"ids";
static BlizzardHSAPIOptionType const BlizzardHSAPIOptionTypeCode = @"code";
static BlizzardHSAPIOptionType const BlizzardHSAPIOptionTypeHero = @"hero";

static BlizzardHSAPIOptionType const BlizzardHSAPIOptionTypeCardBackCategory = @"cardBackCategory";

NSDictionary<BlizzardHSAPIOptionType, NSSet<NSString *> *> *BlizzardHSAPIDefaultOptionsFromHSCardTypeSlugType(HSCardGameModeSlugType);
NSDictionary<BlizzardHSAPIOptionType, NSSet<NSString *> *> *BlizzardConstructedHSAPIDefaultOptionsFromHSDeckFormat(HSDeckFormat);
NSDictionary<BlizzardHSAPIOptionType, NSSet<NSString *> *> *BlizzardHSAPIDefaultOptionsForHSCardBacks(void);

NS_ASSUME_NONNULL_END
