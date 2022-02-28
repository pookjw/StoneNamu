//
//  BattlegroundsCardOptionsMenu.m
//  StoneNamuMac
//
//  Created by Jinwoo Kim on 2/27/22.
//

#import "BattlegroundsCardOptionsMenu.h"
#import "BattlegroundsCardOptionsMenuFactory.h"
#import "StorableMenuItem.h"
#import "StorableSearchField.h"
#import "NSUserInterfaceItemIdentifierBattlegroundsCardOptionType+BlizzardHSAPIOption.h"
#import <StoneNamuResources/StoneNamuResources.h>

static NSUserInterfaceItemIdentifier const NSUserInterfaceItemIdentifierBattlegroundsCardOptionsMenuResetOptions = @"NSUserInterfaceItemIdentifierBattlegroundsCardOptionsMenuResetOptions";

@interface BattlegroundsCardOptionsMenu () <NSSearchFieldDelegate>
@property (assign) id<BattlegroundsCardOptionsMenuDelegate> battlegroundsCardOptionsMenuDelegate;
@property (retain) BattlegroundsCardOptionsMenuFactory *factory;
@property (retain) NSOperationQueue *queue;
@property (retain) NSMenuItem *optionsMenuItem;
@property (retain) NSMenu *optionsSubMenu;
@property (retain) NSDictionary<BlizzardHSAPIOptionType, NSMenuItem *> *allOptionItems;
@property (retain) NSMenuItem *resetOptionsItem;
@property (retain) NSMutableDictionary<NSString *, NSSet<NSString *> *> *options;
@end

@implementation BattlegroundsCardOptionsMenu

- (instancetype)initWithOptions:(NSDictionary<NSString *,NSSet<NSString *> *> *)options battlegroundsCardOptionsMenuDelegate:(id<BattlegroundsCardOptionsMenuDelegate>)battlegroundsCardOptionsMenuDelegate {
    self = [self init];
    
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
        
        self.battlegroundsCardOptionsMenuDelegate = battlegroundsCardOptionsMenuDelegate;
        [self configureOptionsMenu];
        [self configureOptionsItems];
        [self configureResetOptionsItem];
        [self bind];
        [self.factory load];
    }
    
    return self;
}

- (void)dealloc {
    [_factory release];
    [_queue release];
    [_optionsMenuItem release];
    [_optionsSubMenu release];
    [_allOptionItems release];
    [_resetOptionsItem release];
    [_options release];
    [super dealloc];
}

- (void)updateItemsWithOptions:(NSDictionary<NSString *,NSSet<NSString *> *> *)options {
    [self updateItemsWithOptions:options force:NO];
}

- (void)updateItemsWithOptions:(NSDictionary<NSString *,NSSet<NSString *> *> *)options force:(BOOL)force {
    [self.queue addBarrierBlock:^{
        if (!force) {
            if (compareNullableValues(self.options, options, @selector(isEqualToDictionary:))) return;
        }
        
        NSMutableDictionary<NSString *, NSSet<NSString *> *> *mutableOptions = [options mutableCopy];
        self.options = mutableOptions;
        [mutableOptions release];
        
        [self.allOptionItems enumerateKeysAndObjectsUsingBlock:^(BlizzardHSAPIOptionType  _Nonnull key, NSMenuItem * _Nonnull obj, BOOL * _Nonnull stop) {
            NSSet<NSString *> * _Nullable values = options[key];
            
            //
            
            [NSOperationQueue.mainQueue addOperationWithBlock:^{
                NSSearchField * _Nullable searchField = (NSSearchField * _Nullable)obj.submenu.itemArray.firstObject.view;
                
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
            }];
            
            [self updateStateOfItem:obj];
        }];
    }];
}

- (void)configureOptionsMenu {
    NSMenuItem *optionsMenuItem = [NSMenuItem new];
    NSMenu *optionsSubMenu = [[NSMenu alloc] initWithTitle:[ResourcesService localizationForKey:LocalizableKeyCardOptionsTitleShort]];
    
    optionsMenuItem.submenu = optionsSubMenu;
    [self insertItem:optionsMenuItem atIndex:3];
    
    self.optionsMenuItem = optionsMenuItem;
    self.optionsSubMenu = optionsSubMenu;
    [optionsMenuItem release];
    [optionsSubMenu release];
}

- (void)configureOptionsItems {
    NSMenuItem *optionTypeTextFilterItem = [[NSMenuItem alloc] initWithTitle:@""
                                                                      action:nil
                                                               keyEquivalent:@""];
    optionTypeTextFilterItem.identifier = NSUserInterfaceItemIdentifierBattlegroundsCardOptionTypeTextFilter;
    
    //
    
    NSMenuItem *optionTypeTierItem = [[NSMenuItem alloc] initWithTitle:@""
                                                                    action:nil
                                                             keyEquivalent:@""];
    optionTypeTierItem.identifier = NSUserInterfaceItemIdentifierBattlegroundsCardOptionTypeTier;
    
    //
    
    NSMenuItem *optionTypeAttackItem = [[NSMenuItem alloc] initWithTitle:@""
                                                                  action:nil
                                                           keyEquivalent:@""];
    optionTypeAttackItem.identifier = NSUserInterfaceItemIdentifierBattlegroundsCardOptionTypeAttack;
    
    //
    
    NSMenuItem *optionTypeHealthItem = [[NSMenuItem alloc] initWithTitle:@""
                                                                  action:nil
                                                           keyEquivalent:@""];
    optionTypeHealthItem.identifier = NSUserInterfaceItemIdentifierBattlegroundsCardOptionTypeHealth;
    
    //
    
    NSMenuItem *optionTypeTypeItem = [[NSMenuItem alloc] initWithTitle:@""
                                                                      action:nil
                                                               keyEquivalent:@""];
    optionTypeTypeItem.identifier = NSUserInterfaceItemIdentifierBattlegroundsCardOptionTypeType;
    
    //
    
    NSMenuItem *optionTypeMinionTypeItem = [[NSMenuItem alloc] initWithTitle:@""
                                                                      action:nil
                                                               keyEquivalent:@""];
    optionTypeMinionTypeItem.identifier = NSUserInterfaceItemIdentifierBattlegroundsCardOptionTypeMinionType;
    
    //
    
    NSMenuItem *optionTypeKeywordItem = [[NSMenuItem alloc] initWithTitle:@""
                                                                   action:nil
                                                            keyEquivalent:@""];
    optionTypeKeywordItem.identifier = NSUserInterfaceItemIdentifierBattlegroundsCardOptionTypeKeyword;
    
    //
    
    NSMenuItem *optionTypeSortItem = [[NSMenuItem alloc] initWithTitle:@""
                                                                action:nil
                                                         keyEquivalent:@""];
    optionTypeSortItem.identifier = NSUserInterfaceItemIdentifierBattlegroundsCardOptionTypeSort;
    
    //
    
    NSArray<NSMenuItem *> *sortedAllOptionItems = @[optionTypeTextFilterItem,
                                                    optionTypeTierItem,
                                                    optionTypeAttackItem,
                                                    optionTypeHealthItem,
                                                    optionTypeTypeItem,
                                                    optionTypeMinionTypeItem,
                                                    optionTypeKeywordItem,
                                                    optionTypeSortItem];
    NSMutableDictionary<BlizzardHSAPIOptionType, NSMenuItem *> *allOptionItems = [NSMutableDictionary<BlizzardHSAPIOptionType, NSMenuItem *> new];
    [sortedAllOptionItems enumerateObjectsUsingBlock:^(NSMenuItem * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        BlizzardHSAPIOptionType optionType = BlizzardHSAPIOptionTypeFromNSUserInterfaceItemIdentifierBattlegroundsCardOptionType(obj.identifier);
        allOptionItems[optionType] = obj;
    }];
    
    self.allOptionItems = allOptionItems;
    [allOptionItems release];
    self.optionsSubMenu.itemArray = sortedAllOptionItems;
    
    [optionTypeTextFilterItem release];
    [optionTypeTierItem release];
    [optionTypeAttackItem release];
    [optionTypeHealthItem release];
    [optionTypeTypeItem release];
    [optionTypeMinionTypeItem release];
    [optionTypeKeywordItem release];
    [optionTypeSortItem release];
}

- (void)configureResetOptionsItem {
    NSMenuItem *resetOptionsItem = [[NSMenuItem alloc] initWithTitle:[ResourcesService localizationForKey:LocalizableKeyReset]
                                                              action:@selector(resetOptionsItemTriggered:)
                                                       keyEquivalent:@""];
    resetOptionsItem.target = self;
    resetOptionsItem.identifier = NSUserInterfaceItemIdentifierBattlegroundsCardOptionsMenuResetOptions;
    
    NSMutableArray<NSMenuItem *> *itemArray = [self.optionsSubMenu.itemArray mutableCopy];
    [itemArray addObject:[NSMenuItem separatorItem]];
    [itemArray addObject:resetOptionsItem];
    self.optionsSubMenu.itemArray = itemArray;
    [itemArray release];
    
    self.resetOptionsItem = resetOptionsItem;
    [resetOptionsItem release];
}

- (void)bind {
    [NSNotificationCenter.defaultCenter addObserver:self
                                           selector:@selector(shouldUpdateReceived:)
                                               name:NSNotificationNameBattlegroundsCardOptionsMenuFactoryShouldUpdateItems
                                             object:self.factory];
}

- (void)shouldUpdateReceived:(NSNotification *)notification {
    [NSOperationQueue.mainQueue addOperationWithBlock:^{
        [self.allOptionItems enumerateKeysAndObjectsUsingBlock:^(BlizzardHSAPIOptionType  _Nonnull key, NSMenuItem * _Nonnull obj, BOOL * _Nonnull stop) {
            obj.submenu = [self.factory menuForOptionType:key target:self];
            obj.title = [self.factory titleForOptionType:key];
        }];
    }];
    
    [self updateItemsWithOptions:self.options force:YES];
}

- (void)keyMenuItemTriggered:(StorableMenuItem *)sender {
    [self.queue addBarrierBlock:^{
        NSDictionary<NSString *, id> *userInfo = sender.userInfo;
        
        BOOL showsEmptyItem;
        BOOL allowsMultipleSelection;
        
        if (userInfo[BattlegroundsCardOptionsMenuFactoryStorableMenuItemShowsEmptyItemKey]) {
            showsEmptyItem = [(NSNumber *)userInfo[BattlegroundsCardOptionsMenuFactoryStorableMenuItemShowsEmptyItemKey] boolValue];
        } else {
            showsEmptyItem = NO;
        }
        
        if (userInfo[BattlegroundsCardOptionsMenuFactoryStorableMenuItemAllowsMultipleSelection]) {
            allowsMultipleSelection = [(NSNumber *)userInfo[BattlegroundsCardOptionsMenuFactoryStorableMenuItemAllowsMultipleSelection] boolValue];
        } else {
            allowsMultipleSelection = NO;
        }
        
        NSString *key = userInfo[BattlegroundsCardOptionsMenuFactoryStorableMenuItemOptionTypeKey];
        NSString *value = userInfo[BattlegroundsCardOptionsMenuFactoryStorableMenuItemValueKey];
        
        //
        
        NSMutableDictionary<NSString *, NSSet<NSString *> *> *newOptions = [self.options mutableCopy];
        
        if ([value isEqualToString:@""]) {
            [newOptions removeObjectForKey:key];
        } else if (!allowsMultipleSelection) {
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
        [self.battlegroundsCardOptionsMenuDelegate battlegroundsCardOptionsMenu:self changedOption:newOptions];
        
        [newOptions release];
    }];
}

- (void)updateStateOfItem:(NSMenuItem *)item {
    NSUserInterfaceItemIdentifier itemIdentifier = item.identifier;
    
    [self.queue addBarrierBlock:^{
        BlizzardHSAPIOptionType optionType = BlizzardHSAPIOptionTypeFromNSUserInterfaceItemIdentifierBattlegroundsCardOptionType(itemIdentifier);
        
        NSArray<NSString *> * _Nullable values = self.options[optionType].allObjects;
        BOOL shouldSelectEmptyValue = ((values == nil) || (values.count == 0));
        
        [item.submenu.itemArray enumerateObjectsUsingBlock:^(NSMenuItem * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
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

- (void)resetOptionsItemTriggered:(NSMenuItem *)sender {
    [self.battlegroundsCardOptionsMenuDelegate battlegroundsCardOptionsMenu:self defaultOptionsAreNeedWithSender:sender];
}

#pragma mark - NSSearchFieldDelegate

- (void)controlTextDidEndEditing:(NSNotification *)notification {
    [self.queue addBarrierBlock:^{
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
            [self.battlegroundsCardOptionsMenuDelegate battlegroundsCardOptionsMenu:self changedOption:newOptions];
            
            [newOptions release];
        }
    }];
}

@end
