//
//  NSToolbarIdentifierDeckAddCardOptionType+BlizzardHSAPIOptionType.h
//  StoneNamu
//
//  Created by Jinwoo Kim on 12/3/21.
//

#import <Cocoa/Cocoa.h>
#import <StoneNamuCore/StoneNamuCore.h>

NS_ASSUME_NONNULL_BEGIN

static NSToolbarIdentifier const NSToolbarIdentifierDeckAddCardOptionTypeTextFilter = @"NSToolbarIdentifierDeckAddCardOptionTypeTextFilter";
static NSToolbarIdentifier const NSToolbarIdentifierDeckAddCardOptionTypeSet = @"NSToolbarIdentifierDeckAddCardOptionTypeSet";
static NSToolbarIdentifier const NSToolbarIdentifierDeckAddCardOptionTypeClass = @"NSToolbarIdentifierDeckAddCardOptionTypeClass";
static NSToolbarIdentifier const NSToolbarIdentifierDeckAddCardOptionTypeManaCost = @"NSToolbarIdentifierDeckAddCardOptionTypeManaCost";
static NSToolbarIdentifier const NSToolbarIdentifierDeckAddCardOptionTypeAttack = @"NSToolbarIdentifierDeckAddCardOptionTypeAttack";
static NSToolbarIdentifier const NSToolbarIdentifierDeckAddCardOptionTypeHealth = @"NSToolbarIdentifierDeckAddCardOptionTypeHealth";
static NSToolbarIdentifier const NSToolbarIdentifierDeckAddCardOptionTypeCollecticle = @"NSToolbarIdentifierDeckAddCardOptionTypeCollecticle";
static NSToolbarIdentifier const NSToolbarIdentifierDeckAddCardOptionTypeRarity = @"NSToolbarIdentifierDeckAddCardOptionTypeRarity";
static NSToolbarIdentifier const NSToolbarIdentifierDeckAddCardOptionTypeType = @"NSToolbarIdentifierDeckAddCardOptionTypeType";
static NSToolbarIdentifier const NSToolbarIdentifierDeckAddCardOptionTypeMinionType = @"NSToolbarIdentifierDeckAddCardOptionTypeMinionType";
static NSToolbarIdentifier const NSToolbarIdentifierDeckAddCardOptionTypeSpellSchool = @"NSToolbarIdentifierDeckAddCardOptionTypeSpellSchool";
static NSToolbarIdentifier const NSToolbarIdentifierDeckAddCardOptionTypeKeyword = @"NSToolbarIdentifierDeckAddCardOptionTypeKeyword";
static NSToolbarIdentifier const NSToolbarIdentifierDeckAddCardOptionTypeGameMode = @"NSToolbarIdentifierDeckAddCardOptionTypeGameMode";
static NSToolbarIdentifier const NSToolbarIdentifierDeckAddCardOptionTypeSort = @"NSToolbarIdentifierDeckAddCardOptionTypeSort";

NSArray<NSToolbarIdentifier> * allNSToolbarIdentifierDeckAddCardOptionTypes(void);
NSToolbarIdentifier NSToolbarIdentifierCardOptionFromBlizzardHSAPIOptionType(BlizzardHSAPIOptionType type);
BlizzardHSAPIOptionType BlizzardHSAPIOptionTypeFromNSToolbarIdentifierDeckAddCardOptionType(NSToolbarIdentifier itemIdentifier);

NS_ASSUME_NONNULL_END
