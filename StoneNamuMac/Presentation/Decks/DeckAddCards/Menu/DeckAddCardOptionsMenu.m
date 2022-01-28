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
@property (copy) HSDeckFormat deckFormat;
@property HSCardClass classId;
@property (assign) id<DeckAddCardOptionsMenuDelegate> deckAddCardOptionsMenuDelegate;

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
        
        [self.fileMenuItem.submenu addItem:[NSMenuItem separatorItem]];
        [self configureSaveAsImageItem];
        [self configureExportDeckCodeItem];
        
        [self.editMenuItem.submenu addItem:[NSMenuItem separatorItem]];
        [self configureEditDeckNameItem];
        [self configureDeleteItem];
        
        [self configureOptionsMenu];
        [self configureOptionsItems];
        [self configureResetOptionsItem];
    }
    
    return self;
}

- (void)dealloc {
    [_deckFormat release];
    
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
    
    [self.allOptionsItems enumerateObjectsUsingBlock:^(NSMenuItem * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        NSUserInterfaceItemIdentifier identifier = obj.identifier;
        BlizzardHSAPIOptionType optionType = BlizzardHSAPIOptionTypeFromNSUserInterfaceItemIdentifierDeckAddCardOptionType(identifier);
        NSString * _Nullable value = options[optionType];
        
        //
        
        NSSearchField * _Nullable searchField = (NSSearchField * _Nullable)obj.submenu.itemArray.firstObject.view;
        
        if ((searchField != nil) && ([searchField isKindOfClass:[NSSearchField class]])) {
            NSString *stringValue;
            
            if (value == nil) {
                stringValue = @"";
            } else {
                stringValue = value;
            }
            
            searchField.stringValue = stringValue;
        }
        
        //
        
        obj.image = [DeckAddCardOptionsMenuFactory imageForDeckAddCardOptionTypeWithValue:value optionType:optionType];
        obj.title = [DeckAddCardOptionsMenuFactory titleForDeckAddCardOptionTypeWithValue:value optionType:optionType];
        
        [self updateStateOfItem:obj];
    }];
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

- (void)updateOptionsItems {
    [self.allOptionsItems enumerateObjectsUsingBlock:^(NSMenuItem * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
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

- (void)resetOptionsItemTriggered:(NSMenuItem *)sender {
    [self.deckAddCardOptionsMenuDelegate deckAddCardOptionsMenu:self defaultOptionsAreNeedWithSender:sender];
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
