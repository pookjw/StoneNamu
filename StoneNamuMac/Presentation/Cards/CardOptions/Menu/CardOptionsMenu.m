//
//  CardOptionsMenu.m
//  StoneNamuMac
//
//  Created by Jinwoo Kim on 11/8/21.
//

#import "CardOptionsMenu.h"
#import "CardOptionsMenuFactory.h"
#import "StorableMenuItem.h"
#import "StorableSearchField.h"
#import "NSUserInterfaceItemIdentifierCardOptionType+BlizzardHSAPIOption.h"
#import <StoneNamuResources/StoneNamuResources.h>

static NSUserInterfaceItemIdentifier const NSUserInterfaceItemIdentifierCardOptionsMenuResetOptions = @"NSUserInterfaceItemIdentifierCardOptionsMenuResetOptions";

@interface CardOptionsMenu () <NSSearchFieldDelegate>
@property (assign) id<CardOptionsMenuDelegate> cardOptionsMenuDelegate;
@property (retain) CardOptionsMenuFactory *factory;
@property (retain) NSOperationQueue *queue;
@property (retain) NSMenuItem *optionsMenuItem;
@property (retain) NSMenu *optionsSubMenu;
@property (retain) NSDictionary<BlizzardHSAPIOptionType, NSMenuItem *> *allOptionItems;
@property (retain) NSMenuItem *resetOptionsItem;
@property (retain) NSMutableDictionary<NSString *, NSSet<NSString *> *> *options;
@end

@implementation CardOptionsMenu

- (instancetype)initWithOptions:(NSDictionary<NSString *,NSSet<NSString *> *> *)options cardOptionsMenuDelegate:(id<CardOptionsMenuDelegate>)cardOptionsMenuDelegate {
    self = [self init];
    
    if (self) {
        NSMutableDictionary<NSString *, NSSet<NSString *> *> *mutableOptions = [options mutableCopy];
        self.options = mutableOptions;
        [mutableOptions release];
        
        CardOptionsMenuFactory *factory = [CardOptionsMenuFactory new];
        self.factory = factory;
        [factory release];
        
        NSOperationQueue *queue = [NSOperationQueue new];
        queue.qualityOfService = NSQualityOfServiceUserInitiated;
        self.queue = queue;
        [queue release];
        
        self.cardOptionsMenuDelegate = cardOptionsMenuDelegate;
        
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
            if (compareNullableValues(self.options, options, @selector(isEqualToDictionary:))) {
                return;
            }
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
    optionTypeTextFilterItem.identifier = NSUserInterfaceItemIdentifierCardOptionTypeTextFilter;
    
    //
    
    NSMenuItem *optionTypeSetItem = [[NSMenuItem alloc] initWithTitle:@""
                                                               action:nil
                                                        keyEquivalent:@""];
    optionTypeSetItem.identifier = NSUserInterfaceItemIdentifierCardOptionTypeSet;
    
    //
    
    NSMenuItem *optionTypeClassItem = [[NSMenuItem alloc] initWithTitle:@""
                                                                 action:nil
                                                          keyEquivalent:@""];
    optionTypeClassItem.identifier = NSUserInterfaceItemIdentifierCardOptionTypeClass;
    
    //
    
    NSMenuItem *optionTypeManaCostItem = [[NSMenuItem alloc] initWithTitle:@""
                                                                    action:nil
                                                             keyEquivalent:@""];
    optionTypeManaCostItem.identifier = NSUserInterfaceItemIdentifierCardOptionTypeManaCost;
    
    //
    
    NSMenuItem *optionTypeAttackItem = [[NSMenuItem alloc] initWithTitle:@""
                                                                  action:nil
                                                           keyEquivalent:@""];
    optionTypeAttackItem.identifier = NSUserInterfaceItemIdentifierCardOptionTypeAttack;
    
    //
    
    NSMenuItem *optionTypeHealthItem = [[NSMenuItem alloc] initWithTitle:@""
                                                                  action:nil
                                                           keyEquivalent:@""];
    optionTypeHealthItem.identifier = NSUserInterfaceItemIdentifierCardOptionTypeHealth;
    
    //
    
    NSMenuItem *optionTypeCollectibleItem = [[NSMenuItem alloc] initWithTitle:@""
                                                                       action:nil
                                                                keyEquivalent:@""];
    optionTypeCollectibleItem.identifier = NSUserInterfaceItemIdentifierCardOptionTypeCollectible;
    
    //
    
    NSMenuItem *optionTypeRarityItem = [[NSMenuItem alloc] initWithTitle:@""
                                                                  action:nil
                                                           keyEquivalent:@""];
    optionTypeRarityItem.identifier = NSUserInterfaceItemIdentifierCardOptionTypeRarity;
    
    //
    
    NSMenuItem *optionTypeTypeItem = [[NSMenuItem alloc] initWithTitle:@""
                                                                action:nil
                                                         keyEquivalent:@""];
    optionTypeTypeItem.identifier = NSUserInterfaceItemIdentifierCardOptionTypeType;
    
    //
    
    NSMenuItem *optionTypeMinionTypeItem = [[NSMenuItem alloc] initWithTitle:@""
                                                                      action:nil
                                                               keyEquivalent:@""];
    optionTypeMinionTypeItem.identifier = NSUserInterfaceItemIdentifierCardOptionTypeMinionType;
    
    //
    
    NSMenuItem *optionTypeSpellSchoolItem = [[NSMenuItem alloc] initWithTitle:@""
                                                                       action:nil
                                                                keyEquivalent:@""];
    optionTypeSpellSchoolItem.identifier = NSUserInterfaceItemIdentifierCardOptionTypeSpellSchool;
    
    //
    
    NSMenuItem *optionTypeKeywordItem = [[NSMenuItem alloc] initWithTitle:@""
                                                                   action:nil
                                                            keyEquivalent:@""];
    optionTypeKeywordItem.identifier = NSUserInterfaceItemIdentifierCardOptionTypeKeyword;
    
    //
    
    NSMenuItem *optionTypeGameModeItem = [[NSMenuItem alloc] initWithTitle:@""
                                                                    action:nil
                                                             keyEquivalent:@""];
    optionTypeGameModeItem.identifier = NSUserInterfaceItemIdentifierCardOptionTypeGameMode;
    
    //
    
    NSMenuItem *optionTypeSortItem = [[NSMenuItem alloc] initWithTitle:@""
                                                                action:nil
                                                         keyEquivalent:@""];
    optionTypeSortItem.identifier = NSUserInterfaceItemIdentifierCardOptionTypeSort;
    
    //
    
    NSArray<NSMenuItem *> *sortedAllOptionItems = @[
        optionTypeTextFilterItem,
        optionTypeSetItem,
        optionTypeClassItem,
        optionTypeManaCostItem,
        optionTypeAttackItem,
        optionTypeHealthItem,
        optionTypeCollectibleItem,
        optionTypeRarityItem,
        optionTypeTypeItem,
        optionTypeMinionTypeItem,
        optionTypeSpellSchoolItem,
        optionTypeKeywordItem,
        optionTypeGameModeItem,
        optionTypeSortItem
    ];
    NSMutableDictionary<BlizzardHSAPIOptionType, NSMenuItem *> *allOptionItems = [NSMutableDictionary<BlizzardHSAPIOptionType, NSMenuItem *> new];
    [sortedAllOptionItems enumerateObjectsUsingBlock:^(NSMenuItem * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        BlizzardHSAPIOptionType optionType = BlizzardHSAPIOptionTypeFromNSUserInterfaceItemIdentifierCardOptionType(obj.identifier);
        allOptionItems[optionType] = obj;
    }];
    
    self.allOptionItems = allOptionItems;
    [allOptionItems release];
    self.optionsSubMenu.itemArray = sortedAllOptionItems;
    
    [optionTypeTextFilterItem release];
    [optionTypeSetItem release];
    [optionTypeClassItem release];
    [optionTypeManaCostItem release];
    [optionTypeAttackItem release];
    [optionTypeHealthItem release];
    [optionTypeCollectibleItem release];
    [optionTypeRarityItem release];
    [optionTypeTypeItem release];
    [optionTypeMinionTypeItem release];
    [optionTypeSpellSchoolItem release];
    [optionTypeKeywordItem release];
    [optionTypeGameModeItem release];
    [optionTypeSortItem release];
}

- (void)configureResetOptionsItem {
    NSMenuItem *resetOptionsItem = [[NSMenuItem alloc] initWithTitle:[ResourcesService localizationForKey:LocalizableKeyReset]
                                                              action:@selector(resetOptionsItemTriggered:)
                                                       keyEquivalent:@""];
    resetOptionsItem.target = self;
    resetOptionsItem.identifier = NSUserInterfaceItemIdentifierCardOptionsMenuResetOptions;
    
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
                                               name:NSNotificationNameCardOptionsMenuFactoryShouldUpdateItems
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
        
        if (userInfo[CardOptionsMenuFactoryStorableMenuItemShowsEmptyItemKey]) {
            showsEmptyItem = [(NSNumber *)userInfo[CardOptionsMenuFactoryStorableMenuItemShowsEmptyItemKey] boolValue];
        } else {
            showsEmptyItem = NO;
        }
        
        if (userInfo[CardOptionsMenuFactoryStorableMenuItemAllowsMultipleSelection]) {
            allowsMultipleSelection = [(NSNumber *)userInfo[CardOptionsMenuFactoryStorableMenuItemAllowsMultipleSelection] boolValue];
        } else {
            allowsMultipleSelection = NO;
        }
        
        NSString *key = userInfo[CardOptionsMenuFactoryStorableMenuItemOptionTypeKey];
        NSString *value = userInfo[CardOptionsMenuFactoryStorableMenuItemValueKey];
        
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
        [self.cardOptionsMenuDelegate cardOptionsMenu:self changedOption:newOptions];
        
        [newOptions release];
    }];
}

- (void)updateStateOfItem:(NSMenuItem *)item {
    NSUserInterfaceItemIdentifier itemIdentifier = item.identifier;
    
    [self.queue addBarrierBlock:^{
        BlizzardHSAPIOptionType optionType = BlizzardHSAPIOptionTypeFromNSUserInterfaceItemIdentifierCardOptionType(itemIdentifier);
        
        NSArray<NSString *> * _Nullable values = self.options[optionType].allObjects;
        BOOL shouldSelectEmptyValue = ((values == nil) || (values.count == 0));
        
        [item.submenu.itemArray enumerateObjectsUsingBlock:^(NSMenuItem * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            StorableMenuItem *item = (StorableMenuItem *)obj;
            
            if (![item isKindOfClass:[StorableMenuItem class]]) return;
            
            NSString *itemValue = item.userInfo[CardOptionsMenuFactoryStorableMenuItemValueKey];
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
    [self.cardOptionsMenuDelegate cardOptionsMenu:self defaultOptionsAreNeedWithSender:sender];
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
        [self.cardOptionsMenuDelegate cardOptionsMenu:self changedOption:newOptions];
        
        [newOptions release];
    }
}

@end
