//
//  DeckAddCardOptionsMenu.m
//  StoneNamuMac
//
//  Created by Jinwoo Kim on 12/3/21.
//

#import "DeckAddCardOptionsMenu.h"
#import "DeckAddCardOptionsMenuFactory.h"
#import "StorableMenuItem.h"
#import "StorableSearchField.h"
#import "NSUserInterfaceItemIdentifierDeckAddCardOptionType+BlizzardHSAPIOption.h"
#import <StoneNamuResources/StoneNamuResources.h>

@interface DeckAddCardOptionsMenu () <NSSearchFieldDelegate>
@property (copy) HSDeckFormat deckFormat;
@property HSCardClass classId;
@property (assign) id<DeckAddCardOptionsMenuDelegate> deckAddCardOptionsMenuDelegate;

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

@implementation DeckAddCardOptionsMenu

- (instancetype)initWithOptions:(NSDictionary<NSString *,NSString *> *)options deckFormat:(HSDeckFormat)deckFormat classId:(HSCardClass)classId deckAddCardOptionsMenuDelegate:(id<DeckAddCardOptionsMenuDelegate>)deckAddCardOptionsMenuDelegate {
    self = [self init];
    
    if (self) {
        NSMutableDictionary<NSString *, NSString *> *mutableOptions = [options mutableCopy];
        self.options = mutableOptions;
        [mutableOptions release];
        
        self.deckFormat = deckFormat;
        self.classId = classId;
        self.deckAddCardOptionsMenuDelegate = deckAddCardOptionsMenuDelegate;
        [self configureOptionsMenu];
        [self configureOptionsItems];
    }
    
    return self;
}

- (void)dealloc {
    [_deckFormat release];
    
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

- (void)updateItemsWithOptions:(NSDictionary<NSString *,NSString *> *)options deckFormat:(HSDeckFormat _Nullable)deckFormat classId:(HSCardClass)classId {
    NSMutableDictionary<NSString *, NSString *> *mutableOptions = [options mutableCopy];
    self.options = mutableOptions;
    [mutableOptions release];
    
    BOOL shouldReconfigure = ((deckFormat != nil) && (!([deckFormat isEqualToString:self.deckFormat]) || (self.classId != classId)));
    
    self.deckFormat = deckFormat;
    self.classId = classId;
    
    if (shouldReconfigure) {
        [self updateOptionsItems];
    }
    
    [self.allItems enumerateObjectsUsingBlock:^(NSMenuItem * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        NSUserInterfaceItemIdentifier identifier = obj.identifier;
        BlizzardHSAPIOptionType optionType = BlizzardHSAPIOptionTypeFromNSUserInterfaceItemIdentifierDeckAddCardOptionType(identifier);
        NSString * _Nullable value = options[optionType];
        
        //
        
        obj.image = [DeckAddCardOptionsMenuFactory imageForDeckAddCardOptionTypeWithValue:value optionType:optionType];
        obj.title = [DeckAddCardOptionsMenuFactory titleForDeckAddCardOptionTypeWithValue:value optionType:optionType];
        
        [self updateStateOfItem:obj];
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
    optionTypeTextFilterItem.identifier = NSUserInterfaceItemIdentifierDeckAddCardOptionTypeTextFilter;
    optionTypeTextFilterItem.submenu = [self menuForMenuItem:optionTypeTextFilterItem];
    
    //
    
    NSMenuItem *optionTypeSetItem = [[NSMenuItem alloc] initWithTitle:@""
                                                               action:nil
                                                        keyEquivalent:@""];
    optionTypeSetItem.identifier = NSUserInterfaceItemIdentifierDeckAddCardOptionTypeSet;
    optionTypeSetItem.submenu = [self menuForMenuItem:optionTypeSetItem];
    
    //
    
    NSMenuItem *optionTypeClassItem = [[NSMenuItem alloc] initWithTitle:@""
                                                                 action:nil
                                                          keyEquivalent:@""];
    optionTypeClassItem.identifier = NSUserInterfaceItemIdentifierDeckAddCardOptionTypeClass;
    optionTypeClassItem.submenu = [self menuForMenuItem:optionTypeClassItem];
    
    //
    
    NSMenuItem *optionTypeManaCostItem = [[NSMenuItem alloc] initWithTitle:@""
                                                                    action:nil
                                                             keyEquivalent:@""];
    optionTypeManaCostItem.identifier = NSUserInterfaceItemIdentifierDeckAddCardOptionTypeManaCost;
    optionTypeManaCostItem.submenu = [self menuForMenuItem:optionTypeManaCostItem];
    
    //
    
    NSMenuItem *optionTypeAttackItem = [[NSMenuItem alloc] initWithTitle:@""
                                                                  action:nil
                                                           keyEquivalent:@""];
    optionTypeAttackItem.identifier = NSUserInterfaceItemIdentifierDeckAddCardOptionTypeAttack;
    optionTypeAttackItem.submenu = [self menuForMenuItem:optionTypeAttackItem];
    
    //
    
    NSMenuItem *optionTypeHealthItem = [[NSMenuItem alloc] initWithTitle:@""
                                                                  action:nil
                                                           keyEquivalent:@""];
    optionTypeHealthItem.identifier = NSUserInterfaceItemIdentifierDeckAddCardOptionTypeHealth;
    optionTypeHealthItem.submenu = [self menuForMenuItem:optionTypeHealthItem];
    
    //
    
    NSMenuItem *optionTypeCollectibleItem = [[NSMenuItem alloc] initWithTitle:@""
                                                                       action:nil
                                                                keyEquivalent:@""];
    optionTypeCollectibleItem.identifier = NSUserInterfaceItemIdentifierDeckAddCardOptionTypeCollectible;
    optionTypeCollectibleItem.submenu = [self menuForMenuItem:optionTypeCollectibleItem];
    
    //
    
    NSMenuItem *optionTypeRarityItem = [[NSMenuItem alloc] initWithTitle:@""
                                                                  action:nil
                                                           keyEquivalent:@""];
    optionTypeRarityItem.identifier = NSUserInterfaceItemIdentifierDeckAddCardOptionTypeRarity;
    optionTypeRarityItem.submenu = [self menuForMenuItem:optionTypeRarityItem];
    
    //
    
    NSMenuItem *optionTypeTypeItem = [[NSMenuItem alloc] initWithTitle:@""
                                                                action:nil
                                                         keyEquivalent:@""];
    optionTypeTypeItem.identifier = NSUserInterfaceItemIdentifierDeckAddCardOptionTypeType;
    optionTypeTypeItem.submenu = [self menuForMenuItem:optionTypeTypeItem];
    
    //
    
    NSMenuItem *optionTypeMinionTypeItem = [[NSMenuItem alloc] initWithTitle:@""
                                                                      action:nil
                                                               keyEquivalent:@""];
    optionTypeMinionTypeItem.identifier = NSUserInterfaceItemIdentifierDeckAddCardOptionTypeMinionType;
    optionTypeMinionTypeItem.submenu = [self menuForMenuItem:optionTypeMinionTypeItem];
    
    //
    
    NSMenuItem *optionTypeSpellSchoolItem = [[NSMenuItem alloc] initWithTitle:@""
                                                                       action:nil
                                                                keyEquivalent:@""];
    optionTypeSpellSchoolItem.identifier = NSUserInterfaceItemIdentifierDeckAddCardOptionTypeSpellSchool;
    optionTypeSpellSchoolItem.submenu = [self menuForMenuItem:optionTypeSpellSchoolItem];
    
    //
    
    NSMenuItem *optionTypeKeywordItem = [[NSMenuItem alloc] initWithTitle:@""
                                                                   action:nil
                                                            keyEquivalent:@""];
    optionTypeKeywordItem.identifier = NSUserInterfaceItemIdentifierDeckAddCardOptionTypeKeyword;
    optionTypeKeywordItem.submenu = [self menuForMenuItem:optionTypeKeywordItem];
    
    //
    
    NSMenuItem *optionTypeGameModeItem = [[NSMenuItem alloc] initWithTitle:@""
                                                                    action:nil
                                                             keyEquivalent:@""];
    optionTypeGameModeItem.identifier = NSUserInterfaceItemIdentifierDeckAddCardOptionTypeGameMode;
    optionTypeGameModeItem.submenu = [self menuForMenuItem:optionTypeGameModeItem];
    
    //
    
    NSMenuItem *optionTypeSortItem = [[NSMenuItem alloc] initWithTitle:@""
                                                                action:nil
                                                         keyEquivalent:@""];
    optionTypeSortItem.identifier = NSUserInterfaceItemIdentifierDeckAddCardOptionTypeSort;
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
    [self.optionsSubMenu update];
    
    self.optionTypeTextFilterItem = optionTypeTextFilterItem;
    self.optionTypeSetItem = optionTypeSetItem;
    self.optionTypeClassItem = optionTypeClassItem;
    self.optionTypeManaCostItem = optionTypeManaCostItem;
    self.optionTypeAttackItem = optionTypeAttackItem;
    self.optionTypeHealthItem = optionTypeHealthItem;
    self.optionTypeCollectibleItem = optionTypeCollectibleItem;
    self.optionTypeRarityItem = optionTypeRarityItem;
    self.optionTypeTypeItem = optionTypeTypeItem;
    self.optionTypeMinionTypeItem = optionTypeMinionTypeItem;
    self.optionTypeSpellSchoolItem = optionTypeSpellSchoolItem;
    self.optionTypeKeywordItem = optionTypeKeywordItem;
    self.optionTypeGameModeItem = optionTypeGameModeItem;
    self.optionTypeSortItem = optionTypeSortItem;
    
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

- (void)updateOptionsItems {
    [self.allItems enumerateObjectsUsingBlock:^(NSMenuItem * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj.submenu = [self menuForMenuItem:obj];
    }];
}

- (NSMenu *)menuForMenuItem:(NSMenuItem *)item {
    NSUserInterfaceItemIdentifier itemIdentifier = item.identifier;
    BlizzardHSAPIOptionType optionType = BlizzardHSAPIOptionTypeFromNSUserInterfaceItemIdentifierDeckAddCardOptionType(itemIdentifier);
    
    return [DeckAddCardOptionsMenuFactory menuForOptionType:optionType deckFormat:self.deckFormat classId:self.classId target:self];
}

- (NSMenuItem * _Nullable)itemForOptionType:(BlizzardHSAPIOptionType)optionType {
    NSMenuItem * _Nullable __block result = nil;
    
    [self.allItems enumerateObjectsUsingBlock:^(NSMenuItem * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSUserInterfaceItemIdentifier itemIdentifier = obj.identifier;
        BlizzardHSAPIOptionType tmp = BlizzardHSAPIOptionTypeFromNSUserInterfaceItemIdentifierDeckAddCardOptionType(itemIdentifier);
        
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
    
    [self updateItemsWithOptions:self.options deckFormat:self.deckFormat classId:self.classId];
    [self.deckAddCardOptionsMenuDelegate deckAddCardOptionsMenu:self changedOption:self.options];
}

- (void)updateStateOfItem:(NSMenuItem *)item {
    NSUserInterfaceItemIdentifier itemIdentifier = item.identifier;
    BlizzardHSAPIOptionType optionType = BlizzardHSAPIOptionTypeFromNSUserInterfaceItemIdentifierDeckAddCardOptionType(itemIdentifier);
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
    StorableSearchField *searchField = (StorableSearchField *)notification.object;
    
    if (![searchField isKindOfClass:[StorableSearchField class]]) {
        return;
    }
    
    if ([[notification.userInfo objectForKey:@"NSTextMovement"] integerValue] == NSReturnTextMovement) {
        NSString *key = searchField.userInfo.allKeys.firstObject;
        NSString *value = searchField.stringValue;
        
        [[self itemForOptionType:key].menu cancelTracking];
        
        if ([value isEqualToString:@""]) {
            [self.options removeObjectForKey:key];
        } else {
            self.options[key] = value;
        }
        
        [self updateItemsWithOptions:self.options deckFormat:self.deckFormat classId:self.classId];
        [self.deckAddCardOptionsMenuDelegate deckAddCardOptionsMenu:self changedOption:self.options];
    }
}

@end
