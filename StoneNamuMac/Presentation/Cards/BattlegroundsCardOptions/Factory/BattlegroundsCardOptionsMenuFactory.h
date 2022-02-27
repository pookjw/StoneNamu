//
//  BattlegroundsCardOptionsMenuFactory.h
//  StoneNamuMac
//
//  Created by Jinwoo Kim on 2/27/22.
//

#import <Cocoa/Cocoa.h>
#import <StoneNamuCore/StoneNamuCore.h>

NS_ASSUME_NONNULL_BEGIN

static NSNotificationName const NSNotificationNameBattlegroundsCardOptionsMenuFactoryShouldUpdateItems = @"NSNotificationNameBattlegroundsCardOptionsMenuFactoryShouldUpdateItems";

static NSString * const BattlegroundsCardOptionsMenuFactoryStorableMenuItemOptionTypeKey = @"BattlegroundsCardOptionsMenuFactoryStorableMenuItemOptionTypeKey";
static NSString * const BattlegroundsCardOptionsMenuFactoryStorableMenuItemValueKey = @"BattlegroundsCardOptionsMenuFactoryStorableMenuItemValueKey";
static NSString * const BattlegroundsCardOptionsMenuFactoryStorableMenuItemShowsEmptyItemKey = @"BattlegroundsCardOptionsMenuFactoryStorableMenuItemShowsEmptyItemKey";
static NSString * const BattlegroundsCardOptionsMenuFactoryStorableMenuItemAllowsMultipleSelection = @"BattlegroundsCardOptionsMenuFactoryStorableMenuItemAllowsMultipleSelection";

@interface BattlegroundsCardOptionsMenuFactory : NSObject
@property (readonly) SEL keyMenuItemTriggeredSelector;
@property (readonly, copy) NSDictionary<BlizzardHSAPIOptionType, NSDictionary<NSString *, NSNumber *> *> * _Nullable slugsAndIds;
@property (readonly, copy) NSDictionary<BlizzardHSAPIOptionType, NSDictionary<NSString *, NSString *> *> * _Nullable slugsAndNames;
@property (readonly, copy) NSDictionary<NSString *, NSNumber *> * _Nullable typeSlugsAndIds;
@property (readonly, copy) NSDictionary<NSString *, NSString *> * _Nullable typeSlugsAndNames;
- (BOOL)hasEmptyItemAtOptionType:(BlizzardHSAPIOptionType)optionType;
- (BOOL)supportsMultipleSelectionFromOptionType:(BlizzardHSAPIOptionType)optionType;
- (NSString * _Nullable)titleForOptionType:(BlizzardHSAPIOptionType)optionType;
- (NSImage * _Nullable)imageForCardOptionTypeWithValues:(NSSet<NSString *> * _Nullable)values optionType:(BlizzardHSAPIOptionType)optionType;
- (NSMenu *)menuForOptionType:(BlizzardHSAPIOptionType)optionType target:(id<NSSearchFieldDelegate>)target;
- (void)load;
- (void)setOptions:(NSDictionary<NSString *, NSSet<NSString *> *> *)options;
@end

NS_ASSUME_NONNULL_END
