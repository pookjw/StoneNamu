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
@property (readonly) SEL keyMenuItemTriggeredSelector;
@property (copy) NSDictionary<BlizzardHSAPIOptionType, NSDictionary<NSString *, NSString *> *> * _Nullable slugsAndNames;
@property (copy) NSDictionary<BlizzardHSAPIOptionType, NSDictionary<NSString *, NSNumber *> *> * _Nullable slugsAndIds;
- (BOOL)hasEmptyItemAtOptionType:(BlizzardHSAPIOptionType)optionType;
- (BOOL)supportsMultipleSelectionFromOptionType:(BlizzardHSAPIOptionType)optionType;
- (NSString * _Nullable)titleForOptionType:(BlizzardHSAPIOptionType)optionType;
- (NSImage * _Nullable)imageForCardOptionTypeWithValues:(NSSet<NSString *> * _Nullable)values optionType:(BlizzardHSAPIOptionType)optionType;
- (NSMenu *)menuForOptionType:(BlizzardHSAPIOptionType)optionType target:(id<NSSearchFieldDelegate>)target;
@end

NS_ASSUME_NONNULL_END
