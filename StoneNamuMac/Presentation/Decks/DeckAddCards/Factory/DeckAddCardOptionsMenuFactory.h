//
//  DeckAddCardOptionsMenuFactory.h
//  StoneNamuMac
//
//  Created by Jinwoo Kim on 12/3/21.
//

#import <Cocoa/Cocoa.h>
#import <StoneNamuCore/StoneNamuCore.h>

NS_ASSUME_NONNULL_BEGIN

static NSString * const DeckAddCardOptionsMenuFactoryStorableMenuItemOptionTypeKey = @"DeckAddCardOptionsMenuFactoryStorableMenuItemOptionTypeKey";
static NSString * const DeckAddCardOptionsMenuFactoryStorableMenuItemValueKey = @"DeckAddCardOptionsMenuFactoryStorableMenuItemValueKey";
static NSString * const DeckAddCardOptionsMenuFactoryStorableMenuItemShowsEmptyItemKey = @"DeckAddCardOptionsMenuFactoryStorableMenuItemShowsEmptyItemKey";
static NSString * const DeckAddCardOptionsMenuFactoryStorableMenuItemSuppoertsMultipleSelection = @"DeckAddCardOptionsMenuFactoryStorableMenuItemSuppoertsMultipleSelection";

@interface DeckAddCardOptionsMenuFactory : NSObject
@property (class, readonly) SEL keyMenuItemTriggeredSelector;
+ (BOOL)hasEmptyItemAtOptionType:(BlizzardHSAPIOptionType)optionType;
+ (BOOL)supportsMultipleSelectionFromOptionType:(BlizzardHSAPIOptionType)optionType;
+ (NSString * _Nullable)titleForOptionType:(BlizzardHSAPIOptionType)optionType;
+ (NSImage * _Nullable)imageForCardOptionTypeWithValues:(NSSet<NSString *> * _Nullable)values optionType:(BlizzardHSAPIOptionType)optionType;
+ (NSMenu *)menuForOptionType:(BlizzardHSAPIOptionType)optionType deckFormat:(HSDeckFormat)deckFormat classId:(HSCardClass)classId target:(id<NSSearchFieldDelegate>)target;
@end

NS_ASSUME_NONNULL_END
