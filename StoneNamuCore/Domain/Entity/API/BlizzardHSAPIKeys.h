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

typedef NS_ENUM(NSUInteger, BlizzardHSAPIOptionType) {
#pragma mark Data Type
    BlizzardHSAPIOptionTypeLocale,
    
#pragma mark Card Type
    BlizzardHSAPIOptionTypeSet,
    BlizzardHSAPIOptionTypeClass,
    BlizzardHSAPIOptionTypeManaCost,
    BlizzardHSAPIOptionTypeAttack,
    BlizzardHSAPIOptionTypeHealth,
    BlizzardHSAPIOptionTypeCollectible,
    BlizzardHSAPIOptionTypeRarity,
    BlizzardHSAPIOptionTypeType,
    BlizzardHSAPIOptionTypeMinionType,
    BlizzardHSAPIOptionTypeKeyword,
    BlizzardHSAPIOptionTypeTextFilter,
    BlizzardHSAPIOptionTypeGameMode,
#pragma mark Sort Type
    BlizzardHSAPIOptionTypeSort,
    
    BlizzardHSAPIOptionTypePage
};

NSString * NSStringFromOptionType(BlizzardHSAPIOptionType);
