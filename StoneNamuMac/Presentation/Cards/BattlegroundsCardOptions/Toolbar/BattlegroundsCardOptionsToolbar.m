//
//  BattlegroundsCardOptionsToolbar.m
//  StoneNamuMac
//
//  Created by Jinwoo Kim on 2/27/22.
//

#import "BattlegroundsCardOptionsToolbar.h"
#import "StorableMenuItem.h"
#import "StorableSearchField.h"
#import "DynamicMenuToolbarItem.h"
#import "NSToolbarIdentifierBattlegroundsCardOptionType+BlizzardHSAPIOptionType.h"
#import "BattlegroundsCardOptionsMenuFactory.h"
#import <StoneNamuResources/StoneNamuResources.h>

@interface BattlegroundsCardOptionsToolbar () <NSToolbarDelegate, NSSearchFieldDelegate>
@property (assign) id<BattlegroundsCardOptionsToolbarDelegate> battlegroundsCardOptionsToolbarDelegate;
@property (retain) BattlegroundsCardOptionsMenuFactory *factory;
@property (retain) NSOperationQueue *queue;
@property (retain) NSDictionary<BlizzardHSAPIOptionType, DynamicMenuToolbarItem *> *allOptionItems;
@property (retain) NSMutableDictionary<NSString *, NSSet<NSString *> *> *options;
@end

@implementation BattlegroundsCardOptionsToolbar

- (instancetype)initWithIdentifier:(NSToolbarIdentifier)identifier options:(NSDictionary<NSString *, NSSet<NSString *> *> * _Nullable)options battlegroundsCardOptionsToolbarDelegate:(id<BattlegroundsCardOptionsToolbarDelegate>)battlegroundsCardOptionsToolbarDelegate {
    self = [self initWithIdentifier:identifier];
    
    if (self) {
        NSMutableDictionary<NSString *, NSSet<NSString *> *> *mutableOptions = [options mutableCopy];
        self.options = mutableOptions;
        [mutableOptions release];
        
        BattlegroundsCardOptionsMenuFactory *factory = [BattlegroundsCardOptionsMenuFactory new];
        self.factory = factory;
        [factory release];
        
        NSOperationQueue *queue = [NSOperationQueue new];
        queue.qualityOfService = NSQualityOfServiceUserInitiated;
        self.queue = queue;
        [queue release];
        
        self.battlegroundsCardOptionsToolbarDelegate = battlegroundsCardOptionsToolbarDelegate;
        
        [self setAttributes];
        [self configureToolbarItems];
        [self updateItemsWithOptions:options];
        [self bind];
        [self.factory load];
    }
    
    return self;
}

- (void)dealloc {
    [_factory release];
    [_queue release];
    [_allOptionItems release];
    [_options release];
    [super dealloc];
}

- (void)setAttributes {
    self.delegate = self;
    self.allowsUserCustomization = YES;
    self.autosavesConfiguration = YES;
}

- (void)configureToolbarItems {
    DynamicMenuToolbarItem *optionTypeTextFilterItem = [[DynamicMenuToolbarItem alloc] initWithItemIdentifier:NSToolbarIdentifierBattlegroundsCardOptionTypeTextFilter];
    optionTypeTextFilterItem.toolTip = [ResourcesService localizationForKey:LocalizableKeyCardTextFilterTooltipDescription];
    [self insertItemWithItemIdentifier:NSToolbarIdentifierBattlegroundsCardOptionTypeTextFilter atIndex:0];
    
    DynamicMenuToolbarItem *optionTypeTierItem = [[DynamicMenuToolbarItem alloc] initWithItemIdentifier:NSToolbarIdentifierBattlegroundsCardOptionTypeTier];
    optionTypeTierItem.toolTip = [ResourcesService localizationForKey:LocalizableKeyCardManaCostTooltipDescription];
    [self insertItemWithItemIdentifier:NSToolbarIdentifierBattlegroundsCardOptionTypeTier atIndex:1];
    
    DynamicMenuToolbarItem *optionTypeAttackItem = [[DynamicMenuToolbarItem alloc] initWithItemIdentifier:NSToolbarIdentifierBattlegroundsCardOptionTypeAttack];
    optionTypeAttackItem.toolTip = [ResourcesService localizationForKey:LocalizableKeyCardAttackTooltipDescription];
    [self insertItemWithItemIdentifier:NSToolbarIdentifierBattlegroundsCardOptionTypeAttack atIndex:2];
    
    DynamicMenuToolbarItem *optionTypeHealthItem = [[DynamicMenuToolbarItem alloc] initWithItemIdentifier:NSToolbarIdentifierBattlegroundsCardOptionTypeHealth];
    optionTypeHealthItem.toolTip = [ResourcesService localizationForKey:LocalizableKeyCardHealthTooltipDescription];
    [self insertItemWithItemIdentifier:NSToolbarIdentifierBattlegroundsCardOptionTypeHealth atIndex:3];
    
    DynamicMenuToolbarItem *optionTypeTypeItem = [[DynamicMenuToolbarItem alloc] initWithItemIdentifier:NSToolbarIdentifierBattlegroundsCardOptionTypeType];
    optionTypeTypeItem.toolTip = [ResourcesService localizationForKey:LocalizableKeyCardTypeTooltipDescription];
    [self insertItemWithItemIdentifier:NSToolbarIdentifierBattlegroundsCardOptionTypeType atIndex:4];
    
    DynamicMenuToolbarItem *optionTypeMinionTypeItem = [[DynamicMenuToolbarItem alloc] initWithItemIdentifier:NSToolbarIdentifierBattlegroundsCardOptionTypeMinionType];
    optionTypeMinionTypeItem.toolTip = [ResourcesService localizationForKey:LocalizableKeyCardMinionTypeTooltipDescription];
    [self insertItemWithItemIdentifier:NSToolbarIdentifierBattlegroundsCardOptionTypeMinionType atIndex:5];
    
    DynamicMenuToolbarItem *optionTypeKeyowrdItem = [[DynamicMenuToolbarItem alloc] initWithItemIdentifier:NSToolbarIdentifierBattlegroundsCardOptionTypeKeyword];
    optionTypeKeyowrdItem.toolTip = [ResourcesService localizationForKey:LocalizableKeyCardKeywordTooltipDescription];
    [self insertItemWithItemIdentifier:NSToolbarIdentifierBattlegroundsCardOptionTypeKeyword atIndex:6];
    
    DynamicMenuToolbarItem *optionTypeSortItem = [[DynamicMenuToolbarItem alloc] initWithItemIdentifier:NSToolbarIdentifierBattlegroundsCardOptionTypeSort];
    optionTypeSortItem.toolTip = [ResourcesService localizationForKey:LocalizableKeyCardSortTooltipDescription];
    [self insertItemWithItemIdentifier:NSToolbarIdentifierBattlegroundsCardOptionTypeSort atIndex:7];
    
    //
    
    NSDictionary<BlizzardHSAPIOptionType, DynamicMenuToolbarItem *> *allOptionItems = @{
        BlizzardHSAPIOptionTypeTextFilter: optionTypeTextFilterItem,
        BlizzardHSAPIOptionTypeTier: optionTypeTierItem,
        BlizzardHSAPIOptionTypeAttack: optionTypeAttackItem,
        BlizzardHSAPIOptionTypeHealth: optionTypeHealthItem,
        BlizzardHSAPIOptionTypeType: optionTypeTypeItem,
        BlizzardHSAPIOptionTypeMinionType: optionTypeMinionTypeItem,
        BlizzardHSAPIOptionTypeKeyword: optionTypeKeyowrdItem,
        BlizzardHSAPIOptionTypeSort: optionTypeSortItem
    };
    
    self.allOptionItems = allOptionItems;
    
    [optionTypeTextFilterItem release];
    [optionTypeTierItem release];
    [optionTypeAttackItem release];
    [optionTypeHealthItem release];
    [optionTypeTypeItem release];
    [optionTypeMinionTypeItem release];
    [optionTypeKeyowrdItem release];
    [optionTypeSortItem release];
    
    [self validateVisibleItems];
}

- (void)updateItemsWithOptions:(NSDictionary<NSString *, NSSet<NSString *> *> * _Nullable)options {
    [self updateItemsWithOptions:options force:NO];
}

- (void)updateItemsWithOptions:(NSDictionary<NSString *, NSSet<NSString *> *> * _Nullable)options force:(BOOL)force {
    [self.queue addBarrierBlock:^{
        if (!force) {
            if (compareNullableValues(self.options, options, @selector(isEqualToDictionary:))) {
                return;
            }
        }
        
        NSMutableDictionary<NSString *, NSSet<NSString *> *> *mutableOptions = [options mutableCopy];
        self.options = mutableOptions;
        [mutableOptions release];
        
        [self.allOptionItems enumerateKeysAndObjectsUsingBlock:^(BlizzardHSAPIOptionType  _Nonnull key, DynamicMenuToolbarItem * _Nonnull obj, BOOL * _Nonnull stop) {
            DynamicMenuToolbarItem *item = (DynamicMenuToolbarItem *)obj;
            if (![item isKindOfClass:[DynamicMenuToolbarItem class]]) return;
            
            NSSet<NSString *> * _Nullable values = options[key];
            BOOL isEnabled = [self.factory isEnabledItemWithOptionType:key options:options];
            
            //
            
            [NSOperationQueue.mainQueue addOperationWithBlock:^{
                NSSearchField * _Nullable searchField = (NSSearchField * _Nullable)obj.menu.itemArray.firstObject.view;
                
                if ((searchField != nil) && ([searchField isKindOfClass:[NSSearchField class]])) {
                    NSString * _Nullable stringValue = values.allObjects.firstObject;
                    
                    if (stringValue == nil) {
                        searchField.stringValue = @"";
                    } else {
                        searchField.stringValue = stringValue;
                    }
                }
                
                //
                
                obj.image = [self.factory imageForCardOptionTypeWithValues:values optionType:key];
                obj.enabled = isEnabled;
            }];
            
            [self updateStateOfMenuToolbarItem:item];
        }];
    }];
}

- (void)updateStateOfMenuToolbarItem:(DynamicMenuToolbarItem *)menuToolbarItem {
    NSToolbarItemIdentifier itemIdentifier = menuToolbarItem.itemIdentifier;
    
    [self.queue addBarrierBlock:^{
        BlizzardHSAPIOptionType optionType = BlizzardHSAPIOptionTypeFromNSToolbarIdentifierBattlegroundsCardOptionType(itemIdentifier);
        
        NSArray<NSString *> * _Nullable values = self.options[optionType].allObjects;
        BOOL shouldSelectEmptyValue = ((values == nil) || (values.count == 0));
        
        [menuToolbarItem.menu.itemArray enumerateObjectsUsingBlock:^(NSMenuItem * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            StorableMenuItem *item = (StorableMenuItem *)obj;
            
            if (![item isKindOfClass:[StorableMenuItem class]]) return;
            
            NSString *itemValue = item.userInfo[BattlegroundsCardOptionsMenuFactoryStorableMenuItemValueKey];
            NSControlStateValue state;
            
            if (shouldSelectEmptyValue) {
                if ([@"" isEqualToString:itemValue]) {
                    state = NSControlStateValueOn;
                } else {
                    state = NSControlStateValueOff;
                }
            } else {
                if ([@"" isEqualToString:itemValue]) {
                    state = NSControlStateValueOff;
                } else if ([values containsString:itemValue]) {
                    state = NSControlStateValueOn;
                } else {
                    state = NSControlStateValueOff;
                }
            }
            
            [NSOperationQueue.mainQueue addOperationWithBlock:^{
                item.state = state;
            }];
        }];
    }];
}

- (void)bind {
    [NSNotificationCenter.defaultCenter addObserver:self
                                           selector:@selector(shouldUpdateReceived:)
                                               name:NSNotificationNameBattlegroundsCardOptionsMenuFactoryShouldUpdateItems
                                             object:self.factory];
}

- (void)shouldUpdateReceived:(NSNotification *)notification {
    [NSOperationQueue.mainQueue addOperationWithBlock:^{
        [self.allOptionItems enumerateKeysAndObjectsUsingBlock:^(BlizzardHSAPIOptionType  _Nonnull key, DynamicMenuToolbarItem * _Nonnull obj, BOOL * _Nonnull stop) {
            obj.menu = [self.factory menuForOptionType:key target:self];
            obj.title = [self.factory titleForOptionType:key];
        }];
        
        [self updateItemsWithOptions:self.options force:YES];
    }];
}

- (void)keyMenuItemTriggered:(StorableMenuItem *)sender {
    [self.queue addBarrierBlock:^{
        NSDictionary<NSString *, id> *userInfo = sender.userInfo;
        
        BOOL showsEmptyItem;
        BOOL supportsMultipleSelection;
        
        if (userInfo[BattlegroundsCardOptionsMenuFactoryStorableMenuItemShowsEmptyItemKey]) {
            showsEmptyItem = [(NSNumber *)userInfo[BattlegroundsCardOptionsMenuFactoryStorableMenuItemShowsEmptyItemKey] boolValue];
        } else {
            showsEmptyItem = NO;
        }
        
        if (userInfo[BattlegroundsCardOptionsMenuFactoryStorableMenuItemAllowsMultipleSelection]) {
            supportsMultipleSelection = [(NSNumber *)userInfo[BattlegroundsCardOptionsMenuFactoryStorableMenuItemAllowsMultipleSelection] boolValue];
        } else {
            supportsMultipleSelection = NO;
        }
        
        NSString *key = userInfo[BattlegroundsCardOptionsMenuFactoryStorableMenuItemOptionTypeKey];
        NSString *value = userInfo[BattlegroundsCardOptionsMenuFactoryStorableMenuItemValueKey];
        
        //
        
        NSMutableDictionary<NSString *, NSSet<NSString *> *> *newOptions = [self.options mutableCopy];
        
        if ([value isEqualToString:@""]) {
            [newOptions removeObjectForKey:key];
        } else if (!supportsMultipleSelection) {
            NSSet<NSString *> * _Nullable values = newOptions[key];
            
            if ((values == nil) || !([values containsObject:value])) {
                newOptions[key] = [NSSet setWithObject:value];
            } else {
                [newOptions removeObjectForKey:key];
            }
        } else {
            NSMutableSet<NSString *> * _Nullable values = [newOptions[key] mutableCopy];
            if (values == nil) {
                values = [NSMutableSet<NSString *> new];
            }
            
            if ([values.allObjects containsString:value]) {
                [values removeObject:value];
            } else {
                [values addObject:value];
            }
            
            if (values.count > 0) {
                newOptions[key] = values;
            } else if (showsEmptyItem) {
                [newOptions removeObjectForKey:key];
            }
            
            [values release];
        }
        
        [self updateItemsWithOptions:newOptions];
        [self.battlegroundsCardOptionsToolbarDelegate battlegroundsCardOptionsToolbar:self changedOption:newOptions];
        
        [newOptions release];
    }];
}

#pragma mark - NSToolbarDelegate

- (NSToolbarItem *)toolbar:(NSToolbar *)toolbar itemForItemIdentifier:(NSToolbarItemIdentifier)itemIdentifier willBeInsertedIntoToolbar:(BOOL)flag {
    NSMenuToolbarItem * _Nullable __block resultItem = nil;
    
    [self.allOptionItems.allValues enumerateObjectsUsingBlock:^(DynamicMenuToolbarItem * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([itemIdentifier isEqualToString:obj.itemIdentifier]) {
            resultItem = obj;
            *stop = YES;
        }
    }];
    
    return resultItem;
}

- (NSArray<NSToolbarItemIdentifier> *)toolbarDefaultItemIdentifiers:(NSToolbar *)toolbar {
    return allNSToolbarIdentifierBattlegroundsCardOptionTypes();
}

- (NSArray<NSToolbarItemIdentifier> *)toolbarAllowedItemIdentifiers:(NSToolbar *)toolbar {
    return allNSToolbarIdentifierBattlegroundsCardOptionTypes();
}

#pragma mark - NSSearchFieldDelegate

- (void)controlTextDidEndEditing:(NSNotification *)notification {
    StorableSearchField *searchField = (StorableSearchField *)notification.object;
    
    if (![searchField isKindOfClass:[StorableSearchField class]]) {
        return;
    }
    
    if ([[notification.userInfo objectForKey:@"NSTextMovement"] integerValue] == NSTextMovementReturn) {
        NSString *key = searchField.userInfo.allKeys.firstObject;
        NSString *value = searchField.stringValue;
        
        [self.allOptionItems[key].menu cancelTracking];
        
        NSMutableDictionary<NSString *, NSSet<NSString *> *> *newOptions = [self.options mutableCopy];
        
        if ([value isEqualToString:@""]) {
            [newOptions removeObjectForKey:key];
        } else {
            newOptions[key] = [NSSet setWithObject:value];
        }
        
        [self updateItemsWithOptions:newOptions];
        [self.battlegroundsCardOptionsToolbarDelegate battlegroundsCardOptionsToolbar:self changedOption:newOptions];
        
        [newOptions release];
    }
}

@end
