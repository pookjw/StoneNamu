//
//  CardOptionsToolbar.m
//  StoneNamuMac
//
//  Created by Jinwoo Kim on 10/30/21.
//

#import "CardOptionsToolbar.h"
#import "CardOptionsMenuItem.h"
#import "CardOptionsTextField.h"
#import "DynamicMenuToolbarItem.h"
#import "NSToolbarIdentifierCardOption+BlizzardHSAPIOptionType.h"
#import "CardOptionsFactory.h"
#import <StoneNamuResources/StoneNamuResources.h>

@interface CardOptionsToolbar () <NSToolbarDelegate, NSTextFieldDelegate>
@property (weak) id<CardOptionsToolbarDelegate> cardOptionsToolbarDelegate;
@property (retain) DynamicMenuToolbarItem *optionTypeTextFilterItem;
@property (retain) DynamicMenuToolbarItem *optionTypeSetItem;
@property (retain) DynamicMenuToolbarItem *optionTypeClassItem;
@property (retain) DynamicMenuToolbarItem *optionTypeManaCostItem;
@property (retain) DynamicMenuToolbarItem *optionTypeAttackItem;
@property (retain) DynamicMenuToolbarItem *optionTypeHealthItem;
@property (retain) DynamicMenuToolbarItem *optionTypeCollectibleItem;
@property (retain) DynamicMenuToolbarItem *optionTypeRarityItem;
@property (retain) DynamicMenuToolbarItem *optionTypeTypeItem;
@property (retain) DynamicMenuToolbarItem *optionTypeMinionTypeItem;
@property (retain) DynamicMenuToolbarItem *optionTypeSpellSchoolItem;
@property (retain) DynamicMenuToolbarItem *optionTypeKeyowrdItem;
@property (retain) DynamicMenuToolbarItem *optionTypeGameModeItem;
@property (retain) DynamicMenuToolbarItem *optionTypeSortItem;
@property (retain) NSArray<DynamicMenuToolbarItem *> *optionTypeAllItems;
@property (retain) NSMutableDictionary<NSString *, NSString *> *options;
@end

@implementation CardOptionsToolbar

- (instancetype)initWithOptions:(NSDictionary<NSString *,NSString *> * _Nullable)options cardOptionsToolbarDelegate:(nonnull id<CardOptionsToolbarDelegate>)cardOptionsToolbarDelegate {
    self = [super initWithIdentifier:@"CardOptionsToolbar"];
    
    if (self) {
        NSMutableDictionary<NSString *, NSString *> *mutableOptions = [options mutableCopy];
        self.options = mutableOptions;
        [mutableOptions release];
        
        self.cardOptionsToolbarDelegate = cardOptionsToolbarDelegate;
        [self configureToolbarItems];
        [self setAttributes];
        [self updateItemsWithOptions:options];
    }
    
    return self;
}

- (void)dealloc {
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
    [_optionTypeKeyowrdItem release];
    [_optionTypeGameModeItem release];
    [_optionTypeSortItem release];
    [_optionTypeAllItems release];
    [_options release];
    [super dealloc];
}

- (void)setAttributes {
    self.delegate = self;
    self.allowsUserCustomization = YES;
    self.autosavesConfiguration = YES;
}

- (void)configureToolbarItems {
    DynamicMenuToolbarItem *optionTypeTextFilterItem = [[DynamicMenuToolbarItem alloc] initWithItemIdentifier:NSToolbarIdentifierCardOptionsTypeTextFilter];
    self.optionTypeTextFilterItem = optionTypeTextFilterItem;
    optionTypeTextFilterItem.toolTip = [ResourcesService localizaedStringForKey:LocalizableKeyCardTextFilterTooltipDescription];
    optionTypeTextFilterItem.menu = [self menuForMenuToolbarItem:optionTypeTextFilterItem];
    [self insertItemWithItemIdentifier:NSToolbarIdentifierCardOptionsTypeTextFilter atIndex:0];
    
    DynamicMenuToolbarItem *optionTypeSetItem = [[DynamicMenuToolbarItem alloc] initWithItemIdentifier:NSToolbarIdentifierCardOptionsTypeSet];
    self.optionTypeSetItem = optionTypeSetItem;
    optionTypeSetItem.toolTip = [ResourcesService localizaedStringForKey:LocalizableKeyCardSetTooltipDescription];
    optionTypeSetItem.menu = [self menuForMenuToolbarItem:optionTypeSetItem];
    [self insertItemWithItemIdentifier:NSToolbarIdentifierCardOptionsTypeSet atIndex:1];
    
    DynamicMenuToolbarItem *optionTypeClassItem = [[DynamicMenuToolbarItem alloc] initWithItemIdentifier:NSToolbarIdentifierCardOptionsTypeClass];
    self.optionTypeClassItem = optionTypeClassItem;
    optionTypeClassItem.toolTip = [ResourcesService localizaedStringForKey:LocalizableKeyCardClassTooltipDescription];
    optionTypeClassItem.menu = [self menuForMenuToolbarItem:optionTypeClassItem];
    [self insertItemWithItemIdentifier:NSToolbarIdentifierCardOptionsTypeClass atIndex:2];
    
    DynamicMenuToolbarItem *optionTypeManaCostItem = [[DynamicMenuToolbarItem alloc] initWithItemIdentifier:NSToolbarIdentifierCardOptionsTypeManaCost];
    self.optionTypeManaCostItem = optionTypeManaCostItem;
    optionTypeManaCostItem.toolTip = [ResourcesService localizaedStringForKey:LocalizableKeyCardManaCostTooltipDescription];
    optionTypeManaCostItem.menu = [self menuForMenuToolbarItem:optionTypeManaCostItem];
    [self insertItemWithItemIdentifier:NSToolbarIdentifierCardOptionsTypeManaCost atIndex:3];
    
    DynamicMenuToolbarItem *optionTypeAttackItem = [[DynamicMenuToolbarItem alloc] initWithItemIdentifier:NSToolbarIdentifierCardOptionsTypeAttack];
    self.optionTypeAttackItem = optionTypeAttackItem;
    optionTypeAttackItem.toolTip = [ResourcesService localizaedStringForKey:LocalizableKeyCardAttackTooltipDescription];
    optionTypeAttackItem.menu = [self menuForMenuToolbarItem:optionTypeAttackItem];
    [self insertItemWithItemIdentifier:NSToolbarIdentifierCardOptionsTypeAttack atIndex:4];
    
    DynamicMenuToolbarItem *optionTypeHealthItem = [[DynamicMenuToolbarItem alloc] initWithItemIdentifier:NSToolbarIdentifierCardOptionsTypeHealth];
    self.optionTypeHealthItem = optionTypeHealthItem;
    optionTypeHealthItem.toolTip = [ResourcesService localizaedStringForKey:LocalizableKeyCardHealthTooltipDescription];
    optionTypeHealthItem.menu = [self menuForMenuToolbarItem:optionTypeHealthItem];
    [self insertItemWithItemIdentifier:NSToolbarIdentifierCardOptionsTypeHealth atIndex:5];
    
    DynamicMenuToolbarItem *optionTypeCollectibleItem = [[DynamicMenuToolbarItem alloc] initWithItemIdentifier:NSToolbarIdentifierCardOptionsTypeCollecticle];
    self.optionTypeCollectibleItem = optionTypeCollectibleItem;
    optionTypeCollectibleItem.toolTip = [ResourcesService localizaedStringForKey:LocalizableKeyCardCollectibleTooltipDescription];
    optionTypeCollectibleItem.menu = [self menuForMenuToolbarItem:optionTypeCollectibleItem];
    [self insertItemWithItemIdentifier:NSToolbarIdentifierCardOptionsTypeCollecticle atIndex:6];
    
    DynamicMenuToolbarItem *optionTypeRarityItem = [[DynamicMenuToolbarItem alloc] initWithItemIdentifier:NSToolbarIdentifierCardOptionsTypeRarity];
    self.optionTypeRarityItem = optionTypeRarityItem;
    optionTypeRarityItem.toolTip = [ResourcesService localizaedStringForKey:LocalizableKeyCardRarityTooltipDescription];
    optionTypeRarityItem.menu = [self menuForMenuToolbarItem:optionTypeRarityItem];
    [self insertItemWithItemIdentifier:NSToolbarIdentifierCardOptionsTypeRarity atIndex:7];
    
    DynamicMenuToolbarItem *optionTypeTypeItem = [[DynamicMenuToolbarItem alloc] initWithItemIdentifier:NSToolbarIdentifierCardOptionsTypeType];
    self.optionTypeTypeItem = optionTypeTypeItem;
    optionTypeTypeItem.toolTip = [ResourcesService localizaedStringForKey:LocalizableKeyCardTypeTooltipDescription];
    optionTypeTypeItem.menu = [self menuForMenuToolbarItem:optionTypeTypeItem];
    [self insertItemWithItemIdentifier:NSToolbarIdentifierCardOptionsTypeType atIndex:8];
    
    DynamicMenuToolbarItem *optionTypeMinionTypeItem = [[DynamicMenuToolbarItem alloc] initWithItemIdentifier:NSToolbarIdentifierCardOptionsTypeMinionType];
    self.optionTypeMinionTypeItem = optionTypeMinionTypeItem;
    optionTypeMinionTypeItem.toolTip = [ResourcesService localizaedStringForKey:LocalizableKeyCardMinionTypeTooltipDescription];
    optionTypeMinionTypeItem.menu = [self menuForMenuToolbarItem:optionTypeMinionTypeItem];
    [self insertItemWithItemIdentifier:NSToolbarIdentifierCardOptionsTypeMinionType atIndex:9];
    
    DynamicMenuToolbarItem *optionTypeSpellSchoolItem = [[DynamicMenuToolbarItem alloc] initWithItemIdentifier:NSToolbarIdentifierCardOptionsTypeSpellSchool];
    self.optionTypeSpellSchoolItem = optionTypeSpellSchoolItem;
    optionTypeSpellSchoolItem.toolTip = [ResourcesService localizaedStringForKey:LocalizableKeyCardSpellSchoolTooltipDescription];
    optionTypeSpellSchoolItem.menu = [self menuForMenuToolbarItem:optionTypeSpellSchoolItem];
    [self insertItemWithItemIdentifier:NSToolbarIdentifierCardOptionsTypeSpellSchool atIndex:10];
    
    DynamicMenuToolbarItem *optionTypeKeyowrdItem = [[DynamicMenuToolbarItem alloc] initWithItemIdentifier:NSToolbarIdentifierCardOptionsTypeKeyword];
    self.optionTypeKeyowrdItem = optionTypeKeyowrdItem;
    optionTypeKeyowrdItem.toolTip = [ResourcesService localizaedStringForKey:LocalizableKeyCardKeywordTooltipDescription];
    optionTypeKeyowrdItem.menu = [self menuForMenuToolbarItem:optionTypeKeyowrdItem];
    [self insertItemWithItemIdentifier:NSToolbarIdentifierCardOptionsTypeKeyword atIndex:11];
    
    DynamicMenuToolbarItem *optionTypeGameModeItem = [[DynamicMenuToolbarItem alloc] initWithItemIdentifier:NSToolbarIdentifierCardOptionsTypeGameMode];
    self.optionTypeGameModeItem = optionTypeGameModeItem;
    optionTypeGameModeItem.toolTip = [ResourcesService localizaedStringForKey:LocalizableKeyCardGameModeTooltipDescription];
    optionTypeGameModeItem.menu = [self menuForMenuToolbarItem:optionTypeGameModeItem];
    [self insertItemWithItemIdentifier:NSToolbarIdentifierCardOptionsTypeGameMode atIndex:12];
    
    DynamicMenuToolbarItem *optionTypeSortItem = [[DynamicMenuToolbarItem alloc] initWithItemIdentifier:NSToolbarIdentifierCardOptionsTypeSort];
    self.optionTypeSortItem = optionTypeSortItem;
    optionTypeSortItem.toolTip = [ResourcesService localizaedStringForKey:LocalizableKeyCardSortTooltipDescription];
    optionTypeSortItem.menu = [self menuForMenuToolbarItem:optionTypeSortItem];
    [self insertItemWithItemIdentifier:NSToolbarIdentifierCardOptionsTypeSort atIndex:13];
    
    //
    
    self.optionTypeAllItems = @[
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
        optionTypeKeyowrdItem,
        optionTypeGameModeItem,
        optionTypeSortItem
    ];
    
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
    [optionTypeKeyowrdItem release];
    [optionTypeGameModeItem release];
    [optionTypeSortItem release];
    
    [self validateVisibleItems];
}

- (void)updateItemsWithOptions:(NSDictionary<NSString *, NSString *> * _Nullable)options {
    NSMutableDictionary<NSString *, NSString *> *mutableOptions = [options mutableCopy];
    self.options = mutableOptions;
    [mutableOptions release];
    
    [self.optionTypeAllItems enumerateObjectsUsingBlock:^(NSMenuToolbarItem * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        DynamicMenuToolbarItem *item = (DynamicMenuToolbarItem *)obj;
        
        if (![item isKindOfClass:[DynamicMenuToolbarItem class]]) return;
        
        NSToolbarItemIdentifier itemIdentifier = item.itemIdentifier;
        BlizzardHSAPIOptionType optionType = BlizzardHSAPIOptionTypeFromNSToolbarIdentifierCardOption(itemIdentifier);
        NSString * _Nullable value = options[optionType];
        
        //
        
        item.image = [CardOptionsFactory imageForCardOptionsWithValue:value optionType:optionType];
        item.title = [CardOptionsFactory titleForCardOptionsWithValue:value optionType:optionType];
        
        [self updateStateOfMenuToolbarItem:item];
    }];
}

- (NSMenu *)menuForMenuToolbarItem:(DynamicMenuToolbarItem *)menuToolbarItem {
    NSToolbarItemIdentifier itemIdentifier = menuToolbarItem.itemIdentifier;
    BlizzardHSAPIOptionType optionType = BlizzardHSAPIOptionTypeFromNSToolbarIdentifierCardOption(itemIdentifier);
    
    return [CardOptionsFactory menuForOptionType:optionType target:self];
}

- (void)updateStateOfMenuToolbarItem:(DynamicMenuToolbarItem *)menuToolbarItem {
    NSToolbarItemIdentifier itemIdentifier = menuToolbarItem.itemIdentifier;
    BlizzardHSAPIOptionType optionType = BlizzardHSAPIOptionTypeFromNSToolbarIdentifierCardOption(itemIdentifier);
    NSString *selectedValue = self.options[optionType];
    
    [menuToolbarItem.menu.itemArray enumerateObjectsUsingBlock:^(NSMenuItem * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        CardOptionsMenuItem *item = (CardOptionsMenuItem *)obj;
        
        if (![item isKindOfClass:[CardOptionsMenuItem class]]) return;
        
        if ([item.key[optionType] isEqualToString:selectedValue]) {
            item.state = NSControlStateValueOn;
        } else if ([@"" isEqualToString:item.key[optionType]] && (selectedValue == nil)) {
            item.state = NSControlStateValueOn;
        } else {
            item.state = NSControlStateValueOff;
        }
    }];
}

- (DynamicMenuToolbarItem * _Nullable)menuToolbarItemForOptionType:(BlizzardHSAPIOptionType)optionType {
    DynamicMenuToolbarItem * _Nullable __block result = nil;
    
    [self.optionTypeAllItems enumerateObjectsUsingBlock:^(DynamicMenuToolbarItem * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSToolbarItemIdentifier itemIdentifier = obj.itemIdentifier;
        BlizzardHSAPIOptionType tmp = BlizzardHSAPIOptionTypeFromNSToolbarIdentifierCardOption(itemIdentifier);
        
        if ([optionType isEqualToString:tmp]) {
            result = obj;
            *stop = YES;
        }
    }];
    
    return result;
}

- (void)keyMenuItemTriggered:(CardOptionsMenuItem *)sender {
    NSString *key = sender.key.allKeys.firstObject;
    NSString *value = sender.key.allValues.firstObject;
    
    if ([value isEqualToString:@""]) {
        [self.options removeObjectForKey:key];
    } else {
        self.options[key] = value;
    }
    
    [self updateItemsWithOptions:self.options];
    [self.cardOptionsToolbarDelegate cardOptionsToolbar:self changedOption:self.options];
}

#pragma mark - NSToolbarDelegate

- (NSToolbarItem *)toolbar:(NSToolbar *)toolbar itemForItemIdentifier:(NSToolbarItemIdentifier)itemIdentifier willBeInsertedIntoToolbar:(BOOL)flag {
    NSMenuToolbarItem * _Nullable __block resultItem = nil;
    
    [self.optionTypeAllItems enumerateObjectsUsingBlock:^(NSMenuToolbarItem * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([itemIdentifier isEqualToString:obj.itemIdentifier]) {
            resultItem = obj;
            *stop = YES;
        }
    }];
    
    return resultItem;
}

- (NSArray<NSToolbarItemIdentifier> *)toolbarDefaultItemIdentifiers:(NSToolbar *)toolbar {
    return allNSToolbarIdentifierCardOptionsType();
}

- (NSArray<NSToolbarItemIdentifier> *)toolbarAllowedItemIdentifiers:(NSToolbar *)toolbar {
    return allNSToolbarIdentifierCardOptionsType();
}

#pragma mark - NSTextFieldDelegate

- (void)controlTextDidEndEditing:(NSNotification *)notification {
    CardOptionsTextField *textField = (CardOptionsTextField *)notification.object;
    
    if (![textField isKindOfClass:[CardOptionsTextField class]]) {
        return;
    }
    
    if ([[notification.userInfo objectForKey:@"NSTextMovement"] integerValue] == NSReturnTextMovement) {
        NSString *key = textField.key.allKeys.firstObject;
        NSString *value = textField.stringValue;
        
        [[self menuToolbarItemForOptionType:key].menu cancelTracking];
        
        if ([value isEqualToString:@""]) {
            [self.options removeObjectForKey:key];
        } else {
            self.options[key] = value;
        }
        
        [self updateItemsWithOptions:self.options];
        [self.cardOptionsToolbarDelegate cardOptionsToolbar:self changedOption:self.options];
    }
}

@end
