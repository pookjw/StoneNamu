//
//  DeckAddCardOptionsMenuFactory.h
//  StoneNamuMac
//
//  Created by Jinwoo Kim on 12/3/21.
//

#import <Cocoa/Cocoa.h>
#import <StoneNamuCore/StoneNamuCore.h>

NS_ASSUME_NONNULL_BEGIN

static NSNotificationName const NSNotificationNameDeckAddCardOptionsMenuFactoryShouldUpdateItems = @"NSNotificationNameDeckAddCardOptionsMenuFactoryShouldUpdateItems";

static NSString * const DeckAddCardOptionsMenuFactoryStorableMenuItemOptionTypeKey = @"DeckAddCardOptionsMenuFactoryStorableMenuItemOptionTypeKey";
static NSString * const DeckAddCardOptionsMenuFactoryStorableMenuItemValueKey = @"DeckAddCardOptionsMenuFactoryStorableMenuItemValueKey";
static NSString * const DeckAddCardOptionsMenuFactoryStorableMenuItemShowsEmptyItemKey = @"DeckAddCardOptionsMenuFactoryStorableMenuItemShowsEmptyItemKey";
static NSString * const DeckAddCardOptionsMenuFactoryStorableMenuItemAllowsMultipleSelection = @"DeckAddCardOptionsMenuFactoryStorableMenuItemAllowsMultipleSelection";

@interface DeckAddCardOptionsMenuFactory : NSObject
@property (readonly) SEL keyMenuItemTriggeredSelector;
@property (copy, readonly) NSDictionary<BlizzardHSAPIOptionType, NSDictionary<NSString *, NSNumber *> *> * _Nullable slugsAndIds;
@property (copy, readonly) NSDictionary<BlizzardHSAPIOptionType, NSDictionary<NSString *, NSString *> *> * _Nullable slugsAndNames;
@property (copy, readonly) NSDictionary<NSString *, NSString *> * _Nullable classicSetSlugsAndNames;
@property (copy, readonly) NSDictionary<NSString *, NSString *> * _Nullable standardSetSlugsAndNames;
@property (copy, readonly) NSDictionary<NSString *, NSString *> * _Nullable wildSetSlugsAndNames;
+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithLocalDeck:(LocalDeck * _Nullable)localDeck;
- (BOOL)hasEmptyItemAtOptionType:(BlizzardHSAPIOptionType)optionType;
- (BOOL)supportsMultipleSelectionFromOptionType:(BlizzardHSAPIOptionType)optionType;
- (NSString * _Nullable)titleForOptionType:(BlizzardHSAPIOptionType)optionType;
- (NSImage * _Nullable)imageForCardOptionTypeWithValues:(NSSet<NSString *> * _Nullable)values optionType:(BlizzardHSAPIOptionType)optionType;
- (NSMenu *)menuForOptionType:(BlizzardHSAPIOptionType)optionType target:(id<NSSearchFieldDelegate>)target;
- (void)updateItems;
- (void)setLocalDeck:(LocalDeck *)localDeck;
@end

NS_ASSUME_NONNULL_END
