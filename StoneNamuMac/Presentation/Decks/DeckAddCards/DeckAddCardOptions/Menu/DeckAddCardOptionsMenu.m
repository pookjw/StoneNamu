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

static NSUserInterfaceItemIdentifier const NSUserInterfaceItemIdentifierDeckAddCardOptionsMenuResetOptions = @"NSUserInterfaceItemIdentifierDeckAddCardOptionsMenuResetOptions";

@interface DeckAddCardOptionsMenu () <NSSearchFieldDelegate>
@property (assign) id<DeckAddCardOptionsMenuDelegate> deckAddCardOptionsMenuDelegate;
@property (retain) DeckAddCardOptionsMenuFactory *factory;

@property (retain) NSMenuItem *saveAsImageItem;
@property (retain) NSMenuItem *exportDeckCodeItem;
@property (retain) NSMenuItem *editDeckNameItem;
@property (retain) NSMenuItem *deleteItem;

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
@property (retain) NSArray<NSMenuItem *> *allOptionsItems;

@property (retain) NSMenuItem *resetOptionsItem;

@property (retain) NSMutableDictionary<NSString *, NSSet<NSString *> *> *options;
@end

@implementation DeckAddCardOptionsMenu

- (instancetype)initWithOptions:(NSDictionary<NSString *,NSSet<NSString *> *> *)options localDeck:(LocalDeck * _Nullable)localDeck deckAddCardOptionsMenuDelegate:(id<DeckAddCardOptionsMenuDelegate>)deckAddCardOptionsMenuDelegate {
    self = [self init];
    
    if (self) {
        NSMutableDictionary<NSString *, NSSet<NSString *> *> *mutableOptions = [options mutableCopy];
        self.options = mutableOptions;
        [mutableOptions release];
        
        DeckAddCardOptionsMenuFactory *factory = [[DeckAddCardOptionsMenuFactory alloc] initWithLocalDeck:localDeck];
        self.factory = factory;
        [factory release];
        
        self.deckAddCardOptionsMenuDelegate = deckAddCardOptionsMenuDelegate;
        
        [self.fileMenuItem.submenu addItem:[NSMenuItem separatorItem]];
        [self configureSaveAsImageItem];
        [self configureExportDeckCodeItem];
        
        [self.editMenuItem.submenu addItem:[NSMenuItem separatorItem]];
        [self configureEditDeckNameItem];
        [self configureDeleteItem];
        
        [self configureOptionsMenu];
        [self configureOptionsItems];
        [self configureResetOptionsItem];
        [self bind];
        [self.factory updateItems];
    }
    
    return self;
}

- (void)dealloc {
    [_factory release];
    
    [_saveAsImageItem release];
    [_exportDeckCodeItem release];
    [_editDeckNameItem release];
    [_deleteItem release];
    
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
    [_allOptionsItems release];
    
    [_resetOptionsItem release];
    [_options release];
    [super dealloc];
}

- (void)updateItemsWithOptions:(NSDictionary<NSString *,NSSet<NSString *> *> *)options {
    NSMutableDictionary<NSString *, NSSet<NSString *> *> *mutableOptions = [options mutableCopy];
    self.options = mutableOptions;
    [mutableOptions release];
    
    [self.allOptionsItems enumerateObjectsUsingBlock:^(NSMenuItem * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        NSUserInterfaceItemIdentifier identifier = obj.identifier;
        BlizzardHSAPIOptionType optionType = BlizzardHSAPIOptionTypeFromNSUserInterfaceItemIdentifierDeckAddCardOptionType(identifier);
        NSSet<NSString *> * _Nullable values = options[optionType];
        
        //
        
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
        
        obj.image = [self.factory imageForCardOptionTypeWithValues:values optionType:optionType];
        
        [self updateStateOfItem:obj];
    }];
}

- (void)setLocalDeck:(LocalDeck *)localDeck {
    [self.factory setLocalDeck:localDeck];
}

- (void)configureSaveAsImageItem {
    NSMenuItem *saveAsImageItem = [[NSMenuItem alloc] initWithTitle:[ResourcesService localizationForKey:LocalizableKeySaveAsImage]
                                                             action:NSSelectorFromString(@"saveAsImageItemTriggered:")
                                                      keyEquivalent:@""];
//    saveAsImageItem.image = [NSImage imageWithSystemSymbolName:@"photo" accessibilityDescription:nil];
    
    [self.fileMenuItem.submenu addItem:saveAsImageItem];
    
    self.saveAsImageItem = saveAsImageItem;
    [saveAsImageItem release];
}

- (void)configureExportDeckCodeItem {
    NSMenuItem *exportDeckCodeItem = [[NSMenuItem alloc] initWithTitle:[ResourcesService localizationForKey:LocalizableKeyExportDeckCode]
                                                                action:NSSelectorFromString(@"exportDeckCodeItemTriggered:")
                                                         keyEquivalent:@""];
//    exportDeckCodeItem.image = [NSImage imageWithSystemSymbolName:@"square.and.arrow.up" accessibilityDescription:nil];
    
    [self.fileMenuItem.submenu addItem:exportDeckCodeItem];
    
    self.exportDeckCodeItem = exportDeckCodeItem;
    [exportDeckCodeItem release];
}

- (void)configureEditDeckNameItem {
    NSMenuItem *editDeckNameItem = [[NSMenuItem alloc] initWithTitle:[ResourcesService localizationForKey:LocalizableKeyEditDeckName]
                                                              action:NSSelectorFromString(@"editDeckNameItemTriggered:")
                                                       keyEquivalent:@""];
//    editDeckNameItem.image = [NSImage imageWithSystemSymbolName:@"pencil" accessibilityDescription:nil];
    
    [self.editMenuItem.submenu addItem:editDeckNameItem];
    
    self.editDeckNameItem = editDeckNameItem;
    [editDeckNameItem release];
}

- (void)configureDeleteItem {
    NSMenuItem *deleteItem = [[NSMenuItem alloc] initWithTitle:[ResourcesService localizationForKey:LocalizableKeyDeleteDeck]
                                                        action:NSSelectorFromString(@"deleteItemTriggered:")
                                                 keyEquivalent:@""];
//    deleteItem.image = [NSImage imageWithSystemSymbolName:@"trash" accessibilityDescription:nil];
    
    [self.editMenuItem.submenu addItem:deleteItem];
    
    self.deleteItem = deleteItem;
    [deleteItem release];
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
    
    //
    
    NSMenuItem *optionTypeSetItem = [[NSMenuItem alloc] initWithTitle:@""
                                                               action:nil
                                                        keyEquivalent:@""];
    optionTypeSetItem.identifier = NSUserInterfaceItemIdentifierDeckAddCardOptionTypeSet;
    
    //
    
    NSMenuItem *optionTypeClassItem = [[NSMenuItem alloc] initWithTitle:@""
                                                                 action:nil
                                                          keyEquivalent:@""];
    optionTypeClassItem.identifier = NSUserInterfaceItemIdentifierDeckAddCardOptionTypeClass;
    
    //
    
    NSMenuItem *optionTypeManaCostItem = [[NSMenuItem alloc] initWithTitle:@""
                                                                    action:nil
                                                             keyEquivalent:@""];
    optionTypeManaCostItem.identifier = NSUserInterfaceItemIdentifierDeckAddCardOptionTypeManaCost;
    
    //
    
    NSMenuItem *optionTypeAttackItem = [[NSMenuItem alloc] initWithTitle:@""
                                                                  action:nil
                                                           keyEquivalent:@""];
    optionTypeAttackItem.identifier = NSUserInterfaceItemIdentifierDeckAddCardOptionTypeAttack;
    
    //
    
    NSMenuItem *optionTypeHealthItem = [[NSMenuItem alloc] initWithTitle:@""
                                                                  action:nil
                                                           keyEquivalent:@""];
    optionTypeHealthItem.identifier = NSUserInterfaceItemIdentifierDeckAddCardOptionTypeHealth;
    
    //
    
    NSMenuItem *optionTypeCollectibleItem = [[NSMenuItem alloc] initWithTitle:@""
                                                                       action:nil
                                                                keyEquivalent:@""];
    optionTypeCollectibleItem.identifier = NSUserInterfaceItemIdentifierDeckAddCardOptionTypeCollectible;
    
    //
    
    NSMenuItem *optionTypeRarityItem = [[NSMenuItem alloc] initWithTitle:@""
                                                                  action:nil
                                                           keyEquivalent:@""];
    optionTypeRarityItem.identifier = NSUserInterfaceItemIdentifierDeckAddCardOptionTypeRarity;
    
    //
    
    NSMenuItem *optionTypeTypeItem = [[NSMenuItem alloc] initWithTitle:@""
                                                                action:nil
                                                         keyEquivalent:@""];
    optionTypeTypeItem.identifier = NSUserInterfaceItemIdentifierDeckAddCardOptionTypeType;
    
    //
    
    NSMenuItem *optionTypeMinionTypeItem = [[NSMenuItem alloc] initWithTitle:@""
                                                                      action:nil
                                                               keyEquivalent:@""];
    optionTypeMinionTypeItem.identifier = NSUserInterfaceItemIdentifierDeckAddCardOptionTypeMinionType;
    
    //
    
    NSMenuItem *optionTypeSpellSchoolItem = [[NSMenuItem alloc] initWithTitle:@""
                                                                       action:nil
                                                                keyEquivalent:@""];
    optionTypeSpellSchoolItem.identifier = NSUserInterfaceItemIdentifierDeckAddCardOptionTypeSpellSchool;
    
    //
    
    NSMenuItem *optionTypeKeywordItem = [[NSMenuItem alloc] initWithTitle:@""
                                                                   action:nil
                                                            keyEquivalent:@""];
    optionTypeKeywordItem.identifier = NSUserInterfaceItemIdentifierDeckAddCardOptionTypeKeyword;
    
    //
    
    NSMenuItem *optionTypeGameModeItem = [[NSMenuItem alloc] initWithTitle:@""
                                                                    action:nil
                                                             keyEquivalent:@""];
    optionTypeGameModeItem.identifier = NSUserInterfaceItemIdentifierDeckAddCardOptionTypeGameMode;
    
    //
    
    NSMenuItem *optionTypeSortItem = [[NSMenuItem alloc] initWithTitle:@""
                                                                action:nil
                                                         keyEquivalent:@""];
    optionTypeSortItem.identifier = NSUserInterfaceItemIdentifierDeckAddCardOptionTypeSort;
    
    //
    
    NSArray *allOptionsItems = @[
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
    
    self.allOptionsItems = allOptionsItems;
    self.optionsSubMenu.itemArray = allOptionsItems;
    
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

- (void)configureResetOptionsItem {
    NSMenuItem *resetOptionsItem = [[NSMenuItem alloc] initWithTitle:[ResourcesService localizationForKey:LocalizableKeyReset]
                                                              action:@selector(resetOptionsItemTriggered:)
                                                       keyEquivalent:@""];
    resetOptionsItem.target = self;
    resetOptionsItem.identifier = NSUserInterfaceItemIdentifierDeckAddCardOptionsMenuResetOptions;
    
    NSMutableArray<NSMenuItem *> *itemArray = [self.optionsSubMenu.itemArray mutableCopy];
    [itemArray addObject:[NSMenuItem separatorItem]];
    [itemArray addObject:resetOptionsItem];
    self.optionsSubMenu.itemArray = itemArray;
    [itemArray release];
    
    self.resetOptionsItem = resetOptionsItem;
    [resetOptionsItem release];
}

- (NSMenuItem * _Nullable)itemForOptionType:(BlizzardHSAPIOptionType)optionType {
    NSMenuItem * _Nullable __block result = nil;
    
    [self.allOptionsItems enumerateObjectsUsingBlock:^(NSMenuItem * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSUserInterfaceItemIdentifier itemIdentifier = obj.identifier;
        BlizzardHSAPIOptionType tmp = BlizzardHSAPIOptionTypeFromNSUserInterfaceItemIdentifierDeckAddCardOptionType(itemIdentifier);
        
        if ([optionType isEqualToString:tmp]) {
            result = obj;
            *stop = YES;
        }
    }];
    
    return result;
}

- (void)bind {
    [NSNotificationCenter.defaultCenter addObserver:self
                                           selector:@selector(shouldUpdateReceived:)
                                               name:NSNotificationNameDeckAddCardOptionsMenuFactoryShouldUpdateItems
                                             object:self.factory];
}

- (void)shouldUpdateReceived:(NSNotification *)notification {
    [NSOperationQueue.mainQueue addOperationWithBlock:^{
        [self.allOptionsItems enumerateObjectsUsingBlock:^(NSMenuItem * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            NSUserInterfaceItemIdentifier itemIdentifier = obj.identifier;
            BlizzardHSAPIOptionType optionType = BlizzardHSAPIOptionTypeFromNSUserInterfaceItemIdentifierDeckAddCardOptionType(itemIdentifier);
            
            obj.submenu = [self.factory menuForOptionType:optionType target:self];
            obj.title = [self.factory titleForOptionType:optionType];
        }];
    }];
}


- (void)keyMenuItemTriggered:(StorableMenuItem *)sender {
    NSDictionary<NSString *, id> *userInfo = sender.userInfo;
    
    BOOL showsEmptyItem;
    BOOL allowsMultipleSelection;
    
    if (userInfo[DeckAddCardOptionsMenuFactoryStorableMenuItemShowsEmptyItemKey]) {
        showsEmptyItem = [(NSNumber *)userInfo[DeckAddCardOptionsMenuFactoryStorableMenuItemShowsEmptyItemKey] boolValue];
    } else {
        showsEmptyItem = NO;
    }
    
    if (userInfo[DeckAddCardOptionsMenuFactoryStorableMenuItemAllowsMultipleSelection]) {
        allowsMultipleSelection = [(NSNumber *)userInfo[DeckAddCardOptionsMenuFactoryStorableMenuItemAllowsMultipleSelection] boolValue];
    } else {
        allowsMultipleSelection = NO;
    }
    
    NSString *key = userInfo[DeckAddCardOptionsMenuFactoryStorableMenuItemOptionTypeKey];
    NSString *value = userInfo[DeckAddCardOptionsMenuFactoryStorableMenuItemValueKey];
    
    //
    
    if ([value isEqualToString:@""]) {
        [self.options removeObjectForKey:key];
    } else if (!allowsMultipleSelection) {
        NSSet<NSString *> * _Nullable values = self.options[key];
        
        if ((values == nil) || !([values containsObject:value])) {
            self.options[key] = [NSSet setWithObject:value];
        } else {
            [self.options removeObjectForKey:key];
        }
    } else {
        NSMutableSet<NSString *> * _Nullable values = [self.options[key] mutableCopy];
        if (values == nil) {
            values = [NSMutableSet<NSString *> new];
        }
        
        if ([values.allObjects containsString:value]) {
            [values removeObject:value];
        } else {
            [values addObject:value];
        }
        
        if (values.count > 0) {
            self.options[key] = values;
        } else if (showsEmptyItem) {
            [self.options removeObjectForKey:key];
        }
        
        [values release];
    }
    
    [self updateItemsWithOptions:self.options];
    [self.deckAddCardOptionsMenuDelegate deckAddCardOptionsMenu:self changedOption:self.options];
}

- (void)updateStateOfItem:(NSMenuItem *)item {
    NSUserInterfaceItemIdentifier itemIdentifier = item.identifier;
    BlizzardHSAPIOptionType optionType = BlizzardHSAPIOptionTypeFromNSUserInterfaceItemIdentifierDeckAddCardOptionType(itemIdentifier);
    
    NSArray<NSString *> * _Nullable values = self.options[optionType].allObjects;
    BOOL shouldSelectEmptyValue = ((values == nil) || (values.count == 0));
    
    [item.submenu.itemArray enumerateObjectsUsingBlock:^(NSMenuItem * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        StorableMenuItem *item = (StorableMenuItem *)obj;
        
        if (![item isKindOfClass:[StorableMenuItem class]]) return;
        
        NSString *itemValue = item.userInfo[DeckAddCardOptionsMenuFactoryStorableMenuItemValueKey];
        
        if (shouldSelectEmptyValue) {
            if ([@"" isEqualToString:itemValue]) {
                item.state = NSControlStateValueOn;
            } else {
                item.state = NSControlStateValueOff;
            }
        } else {
            if ([@"" isEqualToString:itemValue]) {
                item.state = NSControlStateValueOff;
            } else if ([values containsString:itemValue]) {
                item.state = NSControlStateValueOn;
            } else {
                item.state = NSControlStateValueOff;
            }
        }
    }];
}

- (void)resetOptionsItemTriggered:(NSMenuItem *)sender {
    [self.deckAddCardOptionsMenuDelegate deckAddCardOptionsMenu:self defaultOptionsAreNeedWithSender:sender];
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
        
        [[self itemForOptionType:key].menu cancelTracking];
        
        if ([value isEqualToString:@""]) {
            [self.options removeObjectForKey:key];
        } else {
            self.options[key] = [NSSet setWithObject:value];
        }
        
        [self updateItemsWithOptions:self.options];
        [self.deckAddCardOptionsMenuDelegate deckAddCardOptionsMenu:self changedOption:self.options];
    }
}

@end
