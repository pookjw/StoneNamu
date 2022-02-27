//
//  NSToolbarIdentifierCardOptions+BlizzardHSAPIOptionType.h
//  StoneNamu
//
//  Created by Jinwoo Kim on 11/1/21.
//

#import <Cocoa/Cocoa.h>
#import <StoneNamuCore/StoneNamuCore.h>

NS_ASSUME_NONNULL_BEGIN

static NSToolbarIdentifier const NSToolbarIdentifierCardOptionTypeTextFilter = @"NSToolbarIdentifierCardOptionTypeTextFilter";
static NSToolbarIdentifier const NSToolbarIdentifierCardOptionTypeSet = @"NSToolbarIdentifierCardOptionTypeSet";
static NSToolbarIdentifier const NSToolbarIdentifierCardOptionTypeClass = @"NSToolbarIdentifierCardOptionTypeClass";
static NSToolbarIdentifier const NSToolbarIdentifierCardOptionTypeManaCost = @"NSToolbarIdentifierCardOptionTypeManaCost";
static NSToolbarIdentifier const NSToolbarIdentifierCardOptionTypeAttack = @"NSToolbarIdentifierCardOptionTypeAttack";
static NSToolbarIdentifier const NSToolbarIdentifierCardOptionTypeHealth = @"NSToolbarIdentifierCardOptionTypeHealth";
static NSToolbarIdentifier const NSToolbarIdentifierCardOptionTypeCollecticle = @"NSToolbarIdentifierCardOptionTypeCollecticle";
static NSToolbarIdentifier const NSToolbarIdentifierCardOptionTypeRarity = @"NSToolbarIdentifierCardOptionTypeRarity";
static NSToolbarIdentifier const NSToolbarIdentifierCardOptionTypeType = @"NSToolbarIdentifierCardOptionTypeType";
static NSToolbarIdentifier const NSToolbarIdentifierCardOptionTypeMinionType = @"NSToolbarIdentifierCardOptionTypeMinionType";
static NSToolbarIdentifier const NSToolbarIdentifierCardOptionTypeSpellSchool = @"NSToolbarIdentifierCardOptionTypeSpellSchool";
static NSToolbarIdentifier const NSToolbarIdentifierCardOptionTypeKeyword = @"NSToolbarIdentifierCardOptionTypeKeyword";
static NSToolbarIdentifier const NSToolbarIdentifierCardOptionTypeGameMode = @"NSToolbarIdentifierCardOptionTypeGameMode";
static NSToolbarIdentifier const NSToolbarIdentifierCardOptionTypeSort = @"NSToolbarIdentifierCardOptionTypeSort";

NSArray<NSToolbarIdentifier> * allNSToolbarIdentifierCardOptionTypes(void);
NSToolbarIdentifier NSToolbarIdentifierCardOptionTypeFromBlizzardHSAPIOptionType(BlizzardHSAPIOptionType type);
BlizzardHSAPIOptionType BlizzardHSAPIOptionTypeFromNSToolbarIdentifierCardOptionType(NSToolbarIdentifier itemIdentifier);

NS_ASSUME_NONNULL_END
