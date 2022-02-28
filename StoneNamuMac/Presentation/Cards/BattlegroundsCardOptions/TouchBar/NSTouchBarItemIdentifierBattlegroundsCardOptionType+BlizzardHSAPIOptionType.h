//
//  NSTouchBarItemIdentifierBattlegroundsCardOptionType+BlizzardHSAPIOptionType.h
//  StoneNamuMac
//
//  Created by Jinwoo Kim on 2/28/22.
//

#import <Cocoa/Cocoa.h>
#import <StoneNamuCore/StoneNamuCore.h>

NS_ASSUME_NONNULL_BEGIN

static NSTouchBarItemIdentifier const NSTouchBarItemIdentifierBattlegroundsCardOptionTypeTier = @"NSTouchBarItemIdentifierBattlegroundsCardOptionTypeTier";
static NSTouchBarItemIdentifier const NSTouchBarItemIdentifierBattlegroundsCardOptionTypeAttack = @"NSTouchBarItemIdentifierBattlegroundsCardOptionTypeAttack";
static NSTouchBarItemIdentifier const NSTouchBarItemIdentifierBattlegroundsCardOptionTypeHealth = @"NSTouchBarItemIdentifierBattlegroundsCardOptionTypeHealth";
static NSTouchBarItemIdentifier const NSTouchBarItemIdentifierBattlegroundsCardOptionTypeType = @"NSTouchBarItemIdentifierBattlegroundsCardOptionTypeType";
static NSTouchBarItemIdentifier const NSTouchBarItemIdentifierBattlegroundsCardOptionTypeMinionType = @"NSTouchBarItemIdentifierBattlegroundsCardOptionTypeMinionType";
static NSTouchBarItemIdentifier const NSTouchBarItemIdentifierBattlegroundsCardOptionTypeKeyword = @"NSTouchBarItemIdentifierBattlegroundsCardOptionTypeKeyword";
static NSTouchBarItemIdentifier const NSTouchBarItemIdentifierBattlegroundsCardOptionTypeSort = @"NSTouchBarItemIdentifierBattlegroundsCardOptionTypeSort";

NSArray<NSTouchBarItemIdentifier> * allNSTouchBarItemIdentifierBattlegroundsCardOptionTypes(void);
NSTouchBarItemIdentifier NSTouchBarItemIdentifierBattlegroundsCardOptionTypeFromBlizzardHSAPIOptionType(BlizzardHSAPIOptionType type);
BlizzardHSAPIOptionType BlizzardHSAPIOptionTypeFromNSTouchBarItemIdentifierBattlegroundsCardOptionType(NSTouchBarItemIdentifier itemIdentifier);

NS_ASSUME_NONNULL_END