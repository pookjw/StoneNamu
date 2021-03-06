//
//  CardOptionsMenuFactory.h
//  StoneNamu
//
//  Created by Jinwoo Kim on 11/9/21.
//

#import <Cocoa/Cocoa.h>
#import <StoneNamuCore/StoneNamuCore.h>

NS_ASSUME_NONNULL_BEGIN

static NSNotificationName const NSNotificationNameCardOptionsMenuFactoryShouldUpdateItems = @"NSNotificationNameCardOptionsMenuFactoryShouldUpdateItems";

static NSString * const CardOptionsMenuFactoryStorableMenuItemOptionTypeKey = @"CardOptionsMenuFactoryStorableMenuItemOptionTypeKey";
static NSString * const CardOptionsMenuFactoryStorableMenuItemValueKey = @"CardOptionsMenuFactoryStorableMenuItemValueKey";
static NSString * const CardOptionsMenuFactoryStorableMenuItemShowsEmptyItemKey = @"CardOptionsMenuFactoryStorableMenuItemShowsEmptyItemKey";
static NSString * const CardOptionsMenuFactoryStorableMenuItemAllowsMultipleSelection = @"CardOptionsMenuFactoryStorableMenuItemAllowsMultipleSelection";

@interface CardOptionsMenuFactory : NSObject
@property (readonly) SEL keyMenuItemTriggeredSelector;
@property (readonly, copy) NSDictionary<BlizzardHSAPIOptionType, NSDictionary<NSString *, NSNumber *> *> * _Nullable slugsAndIds;
@property (readonly, copy) NSDictionary<BlizzardHSAPIOptionType, NSDictionary<NSString *, NSString *> *> * _Nullable slugsAndNames;
- (BOOL)hasEmptyItemAtOptionType:(BlizzardHSAPIOptionType)optionType;
- (BOOL)supportsMultipleSelectionFromOptionType:(BlizzardHSAPIOptionType)optionType;
- (NSString * _Nullable)titleForOptionType:(BlizzardHSAPIOptionType)optionType;
- (NSImage * _Nullable)imageForCardOptionTypeWithValues:(NSSet<NSString *> * _Nullable)values optionType:(BlizzardHSAPIOptionType)optionType;
- (NSMenu *)menuForOptionType:(BlizzardHSAPIOptionType)optionType target:(id<NSSearchFieldDelegate>)target;
- (void)load;
@end

NS_ASSUME_NONNULL_END
