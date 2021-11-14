//
//  NSToolbarIdentifierCardOption+BlizzardHSAPIOptionType.h
//  StoneNamu
//
//  Created by Jinwoo Kim on 11/1/21.
//

#import <Cocoa/Cocoa.h>
#import <StoneNamuCore/StoneNamuCore.h>

static NSToolbarIdentifier const NSToolbarIdentifierCardOptionsTypeTextFilter = @"NSToolbarIdentifierCardOptionsTextFilter";
static NSToolbarIdentifier const NSToolbarIdentifierCardOptionsTypeSet = @"NSToolbarIdentifierCardOptionsTypeSet";
static NSToolbarIdentifier const NSToolbarIdentifierCardOptionsTypeClass = @"NSToolbarIdentifierCardOptionsTypeClass";
static NSToolbarIdentifier const NSToolbarIdentifierCardOptionsTypeManaCost = @"NSToolbarIdentifierCardOptionsTypeManaCost";
static NSToolbarIdentifier const NSToolbarIdentifierCardOptionsTypeAttack = @"NSToolbarIdentifierCardOptionsTypeAttack";
static NSToolbarIdentifier const NSToolbarIdentifierCardOptionsTypeHealth = @"NSToolbarIdentifierCardOptionsTypeHealth";
static NSToolbarIdentifier const NSToolbarIdentifierCardOptionsTypeCollecticle = @"NSToolbarIdentifierCardOptionsTypeCollecticle";
static NSToolbarIdentifier const NSToolbarIdentifierCardOptionsTypeRarity = @"NSToolbarIdentifierCardOptionsTypeRarity";
static NSToolbarIdentifier const NSToolbarIdentifierCardOptionsTypeType = @"NSToolbarIdentifierCardOptionsTypeType";
static NSToolbarIdentifier const NSToolbarIdentifierCardOptionsTypeMinionType = @"NSToolbarIdentifierCardOptionsTypeMinionType";
static NSToolbarIdentifier const NSToolbarIdentifierCardOptionsTypeSpellSchool = @"NSToolbarIdentifierCardOptionsTypeSpellSchool";
static NSToolbarIdentifier const NSToolbarIdentifierCardOptionsTypeKeyword = @"NSToolbarIdentifierCardOptionsTypeKeyword";
static NSToolbarIdentifier const NSToolbarIdentifierCardOptionsTypeGameMode = @"NSToolbarIdentifierCardOptionsTypeGameMode";
static NSToolbarIdentifier const NSToolbarIdentifierCardOptionsTypeSort = @"NSToolbarIdentifierCardOptionsTypeSort";

NSArray<NSToolbarIdentifier> * allNSToolbarIdentifierCardOptionsType(void);
NSToolbarIdentifier NSToolbarIdentifierCardOptionFromBlizzardHSAPIOptionType(BlizzardHSAPIOptionType type);
BlizzardHSAPIOptionType BlizzardHSAPIOptionTypeFromNSToolbarIdentifierCardOption(NSToolbarIdentifier itemIdentifier);
