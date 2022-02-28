//
//  NSUserInterfaceItemIdentifierBattlegroundsCardOptionType+BlizzardHSAPIOption.h
//  StoneNamuMac
//
//  Created by Jinwoo Kim on 2/27/22.
//

#import <Cocoa/Cocoa.h>
#import <StoneNamuCore/StoneNamuCore.h>

NS_ASSUME_NONNULL_BEGIN

static NSUserInterfaceItemIdentifier const NSUserInterfaceItemIdentifierBattlegroundsCardOptionTypeTextFilter = @"NSUserInterfaceItemIdentifierBattlegroundsCardOptionTypeTextFilter";
static NSUserInterfaceItemIdentifier const NSUserInterfaceItemIdentifierBattlegroundsCardOptionTypeTier = @"NSUserInterfaceItemIdentifierBattlegroundsCardOptionTypeTier";
static NSUserInterfaceItemIdentifier const NSUserInterfaceItemIdentifierBattlegroundsCardOptionTypeAttack = @"NSUserInterfaceItemIdentifierBattlegroundsCardOptionTypeAttack";
static NSUserInterfaceItemIdentifier const NSUserInterfaceItemIdentifierBattlegroundsCardOptionTypeHealth = @"NSUserInterfaceItemIdentifierBattlegroundsCardOptionTypeHealth";
static NSUserInterfaceItemIdentifier const NSUserInterfaceItemIdentifierBattlegroundsCardOptionTypeType = @"NSUserInterfaceItemIdentifierBattlegroundsCardOptionTypeType";
static NSUserInterfaceItemIdentifier const NSUserInterfaceItemIdentifierBattlegroundsCardOptionTypeMinionType = @"NSUserInterfaceItemIdentifierBattlegroundsCardOptionTypeMinionType";
static NSUserInterfaceItemIdentifier const NSUserInterfaceItemIdentifierBattlegroundsCardOptionTypeKeyword = @"NSUserInterfaceItemIdentifierBattlegroundsCardOptionTypeKeyword";
static NSUserInterfaceItemIdentifier const NSUserInterfaceItemIdentifierBattlegroundsCardOptionTypeSort = @"NSUserInterfaceItemIdentifierBattlegroundsCardOptionTypeSort";

NSArray<NSUserInterfaceItemIdentifier> *allNSUserInterfaceItemIdentifierBattlegroundsCardOptionTypes(void);
NSUserInterfaceItemIdentifier NSUserInterfaceItemIdentifierBattlegroundsCardOptionTypeFromBlizzardHSAPIOptionType(BlizzardHSAPIOptionType type);
BlizzardHSAPIOptionType BlizzardHSAPIOptionTypeFromNSUserInterfaceItemIdentifierBattlegroundsCardOptionType(NSUserInterfaceItemIdentifier item);


NS_ASSUME_NONNULL_END