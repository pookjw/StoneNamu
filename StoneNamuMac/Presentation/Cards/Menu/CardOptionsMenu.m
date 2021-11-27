//
//  CardOptionsMenu.m
//  StoneNamuMac
//
//  Created by Jinwoo Kim on 11/8/21.
//

#import "CardOptionsMenu.h"
#import "CardOptionsMenuFactory.h"
#import "StorableMenuItem.h"
#import "CardOptionsSearchField.h"
#import "NSUserInterfaceItemIdentifierCardOptions+BlizzardHSAPIOption.h"
#import <StoneNamuResources/StoneNamuResources.h>

@interface CardOptionsMenu () <NSSearchFieldDelegate>
@property (weak) id<CardOptionsMenuDelegate> cardOptionsMenuDelegate;

@property (retain) NSMenuItem *optionsMenuItem;
@property (retain) NSMenu *optionsSubMenu;

@property (retain) NSMenuItem *optionTypeTextFilterItem;
@property (retain) NSMenuItem *optionTypeSetItem;
@property (retain) NSMenuItem *optionTypeClassItem;
@property (retain) NSMenuItem *optionTypeManaCostItem;
@property (retain) NSMenuItem *optionTypeAttackItem;
@property (retain) NSMenuItem *optionTypeHealthItem;
@property (retain) NSMenuItem *optionTypeCollectibleItem;
@property (retain) NSMenuItem *optionTypeRarityItem;
@property (retain) NSMenuItem *optionTypeTypeItem;
@property (retain) NSMenuItem *optionTypeMinionTypeItem;
@property (retain) NSMenuItem *optionTypeSpellSchoolItem;
@property (retain) NSMenuItem *optionTypeKeywordItem;
@property (retain) NSMenuItem *optionTypeGameModeItem;
@property (retain) NSMenuItem *optionTypeSortItem;
@property (retain) NSArray<NSMenuItem *> *allItems;

@property (retain) NSMutableDictionary<NSString *, NSString *> *options;
@end

@implementation CardOptionsMenu

- (instancetype)initWithOptions:(NSDictionary<NSString *,NSString *> *)options cardOptionsMenuDelegate:(id<CardOptionsMenuDelegate>)cardOptionsMenuDelegate {
    self = [self init];
    
    if (self) {
        NSMutableDictionary<NSString *, NSString *> *mutableOptions = [options mutableCopy];
        self.options = mutableOptions;
        [mutableOptions release];
        
        self.cardOptionsMenuDelegate = cardOptionsMenuDelegate;
        [self configureOptionsMenu];
        [self configureOptionsItems];
    }
    
    return self;
}

- (void)dealloc {
    [_optionsMenuItem release];
    [_optionsSubMenu release];
    
    [_optionTypeTextFilterItem release];
    [_optionTypeSetItem release];
    [_optionTypeClassItem release];
    [_optionTypeManaCostItem release];
    [_optionTypeAttackItem release];
    [_optionTypeHealthItem release];
    [_optionTypeCollectibleItem release];
    [_optionTypeRarityItem release];
    [_optionTypeTypeItem release];
    [_optionTypeMinionTypeItem release];
    [_optionTypeSpellSchoolItem release];
    [_optionTypeKeywordItem release];
    [_optionTypeGameModeItem release];
    [_optionTypeSortItem release];
    
    [_allItems release];
    [_options release];
    [super dealloc];
}

- (void)updateItemsWithOptions:(NSDictionary<NSString *,NSString *> *)options {
    NSMutableDictionary<NSString *, NSString *> *mutableOptions = [options mutableCopy];
    self.options = mutableOptions;
    [mutableOptions release];
    
    [self.allItems enumerateObjectsUsingBlock:^(NSMenuItem * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        NSUserInterfaceItemIdentifier identifier = obj.identifier;
        BlizzardHSAPIOptionType optionType = BlizzardHSAPIOptionTypeFromNSUserInterfaceItemIdentifierCardOptions(identifier);
        NSString * _Nullable value = options[optionType];
        
        //
        
        obj.image = [CardOptionsMenuFactory imageForCardOptionsWithValue:value optionType:optionType];
        obj.title = [CardOptionsMenuFactory titleForCardOptionsWithValue:value optionType:optionType];
        
        [self updateStateOfItem:obj];
    }];
}

- (void)configureOptionsMenu {
    NSMenuItem *optionsMenuItem = [NSMenuItem new];
    self.optionsMenuItem = optionsMenuItem;
    
    NSMenu *optionsSubMenu = [[NSMenu alloc] initWithTitle:[ResourcesService localizationForKey:LocalizableKeyCardOptionsTitleShort]];
    self.optionsSubMenu = optionsSubMenu;
    optionsMenuItem.submenu = optionsSubMenu;
    
    [self insertItem:optionsMenuItem atIndex:3];
    [optionsMenuItem release];
    [optionsSubMenu release];
}

- (void)configureOptionsItems {
    NSMenuItem *optionTypeTextFilterItem = [[NSMenuItem alloc] initWithTitle:@""
                                                                      action:nil
                                                               keyEquivalent:@""];
    self.optionTypeTextFilterItem = optionTypeTextFilterItem;
    optionTypeTextFilterItem.identifier = NSUserInterfaceItemIdentifierCardOptionsTextFilter;
    optionTypeTextFilterItem.submenu = [self menuForMenuItem:optionTypeTextFilterItem];
    
    //
    
    NSMenuItem *optionTypeSetItem = [[NSMenuItem alloc] initWithTitle:@""
                                                               action:nil
                                                        keyEquivalent:@""];
    self.optionTypeSetItem = optionTypeSetItem;
    optionTypeSetItem.identifier = NSUserInterfaceItemIdentifierCardOptionsSet;
    optionTypeSetItem.submenu = [self menuForMenuItem:optionTypeSetItem];
    
    //
    
    NSMenuItem *optionTypeClassItem = [[NSMenuItem alloc] initWithTitle:@""
                                                                 action:nil
                                                          keyEquivalent:@""];
    self.optionTypeClassItem = optionTypeClassItem;
    optionTypeClassItem.identifier = NSUserInterfaceItemIdentifierCardOptionsClass;
    optionTypeClassItem.submenu = [self menuForMenuItem:optionTypeClassItem];
    
    //
    
    NSMenuItem *optionTypeManaCostItem = [[NSMenuItem alloc] initWithTitle:@""
                                                                    action:nil
                                                             keyEquivalent:@""];
    self.optionTypeManaCostItem = optionTypeManaCostItem;
    optionTypeManaCostItem.identifier = NSUserInterfaceItemIdentifierCardOptionsManaCost;
    optionTypeManaCostItem.submenu = [self menuForMenuItem:optionTypeManaCostItem];
    
    //
    
    NSMenuItem *optionTypeAttackItem = [[NSMenuItem alloc] initWithTitle:@""
                                                                  action:nil
                                                           keyEquivalent:@""];
    self.optionTypeAttackItem = optionTypeAttackItem;
    optionTypeAttackItem.identifier = NSUserInterfaceItemIdentifierCardOptionsAttack;
    optionTypeAttackItem.submenu = [self menuForMenuItem:optionTypeAttackItem];
    
    //
    
    NSMenuItem *optionTypeHealthItem = [[NSMenuItem alloc] initWithTitle:@""
                                                                  action:nil
                                                           keyEquivalent:@""];
    self.optionTypeHealthItem = optionTypeHealthItem;
    optionTypeHealthItem.identifier = NSUserInterfaceItemIdentifierCardOptionsHealth;
    optionTypeHealthItem.submenu = [self menuForMenuItem:optionTypeHealthItem];
    
    //
    
    NSMenuItem *optionTypeCollectibleItem = [[NSMenuItem alloc] initWithTitle:@""
                                                                       action:nil
                                                                keyEquivalent:@""];
    self.optionTypeCollectibleItem = optionTypeCollectibleItem;
    optionTypeCollectibleItem.identifier = NSUserInterfaceItemIdentifierCardOptionsCollectible;
    optionTypeCollectibleItem.submenu = [self menuForMenuItem:optionTypeCollectibleItem];
    
    //
    
    NSMenuItem *optionTypeRarityItem = [[NSMenuItem alloc] initWithTitle:@""
                                                                  action:nil
                                                           keyEquivalent:@""];
    self.optionTypeRarityItem = optionTypeRarityItem;
    optionTypeRarityItem.identifier = NSUserInterfaceItemIdentifierCardOptionsRarity;
    optionTypeRarityItem.submenu = [self menuForMenuItem:optionTypeRarityItem];
    
    //
    
    NSMenuItem *optionTypeTypeItem = [[NSMenuItem alloc] initWithTitle:@""
                                                                action:nil
                                                         keyEquivalent:@""];
    self.optionTypeTypeItem = optionTypeTypeItem;
    optionTypeTypeItem.identifier = NSUserInterfaceItemIdentifierCardOptionsType;
    optionTypeTypeItem.submenu = [self menuForMenuItem:optionTypeTypeItem];
    
    //
    
    NSMenuItem *optionTypeMinionTypeItem = [[NSMenuItem alloc] initWithTitle:@""
                                                                      action:nil
                                                               keyEquivalent:@""];
    self.optionTypeMinionTypeItem = optionTypeMinionTypeItem;
    optionTypeMinionTypeItem.identifier = NSUserInterfaceItemIdentifierCardOptionsMinionType;
    optionTypeMinionTypeItem.submenu = [self menuForMenuItem:optionTypeMinionTypeItem];
    
    //
    
    NSMenuItem *optionTypeSpellSchoolItem = [[NSMenuItem alloc] initWithTitle:@""
                                                                       action:nil
                                                                keyEquivalent:@""];
    self.optionTypeSpellSchoolItem = optionTypeSpellSchoolItem;
    optionTypeSpellSchoolItem.identifier = NSUserInterfaceItemIdentifierCardOptionsSpellSchool;
    optionTypeSpellSchoolItem.submenu = [self menuForMenuItem:optionTypeSpellSchoolItem];
    
    //
    
    NSMenuItem *optionTypeKeywordItem = [[NSMenuItem alloc] initWithTitle:@""
                                                                   action:nil
                                                            keyEquivalent:@""];
    self.optionTypeKeywordItem = optionTypeKeywordItem;
    optionTypeKeywordItem.identifier = NSUserInterfaceItemIdentifierCardOptionsKeyword;
    optionTypeKeywordItem.submenu = [self menuForMenuItem:optionTypeKeywordItem];
    
    //
    
    NSMenuItem *optionTypeGameModeItem = [[NSMenuItem alloc] initWithTitle:@""
                                                                    action:nil
                                                             keyEquivalent:@""];
    self.optionTypeGameModeItem = optionTypeGameModeItem;
    optionTypeGameModeItem.identifier = NSUserInterfaceItemIdentifierCardOptionsGameMode;
    optionTypeGameModeItem.submenu = [self menuForMenuItem:optionTypeGameModeItem];
    
    //
    
    NSMenuItem *optionTypeSortItem = [[NSMenuItem alloc] initWithTitle:@""
                                                                action:nil
                                                         keyEquivalent:@""];
    self.optionTypeSortItem = optionTypeSortItem;
    optionTypeSortItem.identifier = NSUserInterfaceItemIdentifierCardOptionsSort;
    optionTypeSortItem.submenu = [self menuForMenuItem:optionTypeSortItem];
    
    //
    
    NSArray *allItems = @[
        optionTypeTextFilterItem,
        optionTypeSetItem,
        optionTypeClassItem,
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
    self.allItems = allItems;
    self.optionsSubMenu.itemArray = allItems;
    
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

- (NSMenu *)menuForMenuItem:(NSMenuItem *)item {
    NSUserInterfaceItemIdentifier itemIdentifier = item.identifier;
    BlizzardHSAPIOptionType optionType = BlizzardHSAPIOptionTypeFromNSUserInterfaceItemIdentifierCardOptions(itemIdentifier);
    
    return [CardOptionsMenuFactory menuForOptionType:optionType target:self];
}

- (NSMenuItem * _Nullable)itemForOptionType:(BlizzardHSAPIOptionType)optionType {
    NSMenuItem * _Nullable __block result = nil;
    
    [self.allItems enumerateObjectsUsingBlock:^(NSMenuItem * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSUserInterfaceItemIdentifier itemIdentifier = obj.identifier;
        BlizzardHSAPIOptionType tmp = BlizzardHSAPIOptionTypeFromNSUserInterfaceItemIdentifierCardOptions(itemIdentifier);
        
        if ([optionType isEqualToString:tmp]) {
            result = obj;
            *stop = YES;
        }
    }];
    
    return result;
}

- (void)keyMenuItemTriggered:(StorableMenuItem *)sender {
    NSString *key = sender.userInfo.allKeys.firstObject;
    NSString *value = sender.userInfo.allValues.firstObject;
    
    if ([value isEqualToString:@""]) {
        [self.options removeObjectForKey:key];
    } else {
        self.options[key] = value;
    }
    
    [self updateItemsWithOptions:self.options];
    [self.cardOptionsMenuDelegate cardOptionsMenu:self changedOption:self.options];
}

- (void)updateStateOfItem:(NSMenuItem *)item {
    NSUserInterfaceItemIdentifier itemIdentifier = item.identifier;
    BlizzardHSAPIOptionType optionType = BlizzardHSAPIOptionTypeFromNSUserInterfaceItemIdentifierCardOptions(itemIdentifier);
    NSString *selectedValue = self.options[optionType];
    
    [item.submenu.itemArray enumerateObjectsUsingBlock:^(NSMenuItem * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        StorableMenuItem *item = (StorableMenuItem *)obj;
        
        if (![item isKindOfClass:[StorableMenuItem class]]) return;
        
        if ([item.userInfo[optionType] isEqualToString:selectedValue]) {
            item.state = NSControlStateValueOn;
        } else if ([@"" isEqualToString:item.userInfo[optionType]] && (selectedValue == nil)) {
            item.state = NSControlStateValueOn;
        } else {
            item.state = NSControlStateValueOff;
        }
    }];
}

#pragma mark - NSSearchFieldDelegate

- (void)controlTextDidEndEditing:(NSNotification *)notification {
    CardOptionsSearchField *searchField = (CardOptionsSearchField *)notification.object;
    
    if (![searchField isKindOfClass:[CardOptionsSearchField class]]) {
        return;
    }
    
    if ([[notification.userInfo objectForKey:@"NSTextMovement"] integerValue] == NSReturnTextMovement) {
        NSString *key = searchField.key.allKeys.firstObject;
        NSString *value = searchField.stringValue;
        
        [[self itemForOptionType:key].menu cancelTracking];
        
        if ([value isEqualToString:@""]) {
            [self.options removeObjectForKey:key];
        } else {
            self.options[key] = value;
        }
        
        [self updateItemsWithOptions:self.options];
        [self.cardOptionsMenuDelegate cardOptionsMenu:self changedOption:self.options];
    }
}

@end
