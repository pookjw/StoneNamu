//
//  CardOptionsToolbar.m
//  StoneNamuMac
//
//  Created by Jinwoo Kim on 10/30/21.
//

#import "CardOptionsToolbar.h"
#import "StorableMenuItem.h"
#import "StorableSearchField.h"
#import "DynamicMenuToolbarItem.h"
#import "NSToolbarIdentifierCardOptionType+BlizzardHSAPIOptionType.h"
#import "CardOptionsMenuFactory.h"
#import <StoneNamuResources/StoneNamuResources.h>

@interface CardOptionsToolbar () <NSToolbarDelegate, NSSearchFieldDelegate>
@property (assign) id<CardOptionsToolbarDelegate> cardOptionsToolbarDelegate;
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
@property (retain) NSMutableDictionary<NSString *, NSSet<NSString *> *> *options;
@end

@implementation CardOptionsToolbar

- (instancetype)initWithIdentifier:(NSToolbarIdentifier)identifier options:(NSDictionary<NSString *, NSSet<NSString *> *> * _Nullable)options cardOptionsToolbarDelegate:(id<CardOptionsToolbarDelegate>)cardOptionsToolbarDelegate {
    self = [self initWithIdentifier:identifier];
    
    if (self) {
        NSMutableDictionary<NSString *, NSSet<NSString *> *> *mutableOptions = [options mutableCopy];
        self.options = mutableOptions;
        [mutableOptions release];
        
        self.cardOptionsToolbarDelegate = cardOptionsToolbarDelegate;
        [self setAttributes];
        [self configureToolbarItems];
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
    DynamicMenuToolbarItem *optionTypeTextFilterItem = [[DynamicMenuToolbarItem alloc] initWithItemIdentifier:NSToolbarIdentifierCardOptionTypeTextFilter];
    optionTypeTextFilterItem.toolTip = [ResourcesService localizationForKey:LocalizableKeyCardTextFilterTooltipDescription];
    optionTypeTextFilterItem.menu = [self menuForMenuToolbarItem:optionTypeTextFilterItem];
    [self insertItemWithItemIdentifier:NSToolbarIdentifierCardOptionTypeTextFilter atIndex:0];
    
    DynamicMenuToolbarItem *optionTypeSetItem = [[DynamicMenuToolbarItem alloc] initWithItemIdentifier:NSToolbarIdentifierCardOptionTypeSet];
    optionTypeSetItem.toolTip = [ResourcesService localizationForKey:LocalizableKeyCardSetTooltipDescription];
    optionTypeSetItem.menu = [self menuForMenuToolbarItem:optionTypeSetItem];
    [self insertItemWithItemIdentifier:NSToolbarIdentifierCardOptionTypeSet atIndex:1];
    
    DynamicMenuToolbarItem *optionTypeClassItem = [[DynamicMenuToolbarItem alloc] initWithItemIdentifier:NSToolbarIdentifierCardOptionTypeClass];
    optionTypeClassItem.toolTip = [ResourcesService localizationForKey:LocalizableKeyCardClassTooltipDescription];
    optionTypeClassItem.menu = [self menuForMenuToolbarItem:optionTypeClassItem];
    [self insertItemWithItemIdentifier:NSToolbarIdentifierCardOptionTypeClass atIndex:2];
    
    DynamicMenuToolbarItem *optionTypeManaCostItem = [[DynamicMenuToolbarItem alloc] initWithItemIdentifier:NSToolbarIdentifierCardOptionTypeManaCost];
    optionTypeManaCostItem.toolTip = [ResourcesService localizationForKey:LocalizableKeyCardManaCostTooltipDescription];
    optionTypeManaCostItem.menu = [self menuForMenuToolbarItem:optionTypeManaCostItem];
    [self insertItemWithItemIdentifier:NSToolbarIdentifierCardOptionTypeManaCost atIndex:3];
    
    DynamicMenuToolbarItem *optionTypeAttackItem = [[DynamicMenuToolbarItem alloc] initWithItemIdentifier:NSToolbarIdentifierCardOptionTypeAttack];
    optionTypeAttackItem.toolTip = [ResourcesService localizationForKey:LocalizableKeyCardAttackTooltipDescription];
    optionTypeAttackItem.menu = [self menuForMenuToolbarItem:optionTypeAttackItem];
    [self insertItemWithItemIdentifier:NSToolbarIdentifierCardOptionTypeAttack atIndex:4];
    
    DynamicMenuToolbarItem *optionTypeHealthItem = [[DynamicMenuToolbarItem alloc] initWithItemIdentifier:NSToolbarIdentifierCardOptionTypeHealth];
    optionTypeHealthItem.toolTip = [ResourcesService localizationForKey:LocalizableKeyCardHealthTooltipDescription];
    optionTypeHealthItem.menu = [self menuForMenuToolbarItem:optionTypeHealthItem];
    [self insertItemWithItemIdentifier:NSToolbarIdentifierCardOptionTypeHealth atIndex:5];
    
    DynamicMenuToolbarItem *optionTypeCollectibleItem = [[DynamicMenuToolbarItem alloc] initWithItemIdentifier:NSToolbarIdentifierCardOptionTypeCollecticle];
    optionTypeCollectibleItem.toolTip = [ResourcesService localizationForKey:LocalizableKeyCardCollectibleTooltipDescription];
    optionTypeCollectibleItem.menu = [self menuForMenuToolbarItem:optionTypeCollectibleItem];
    [self insertItemWithItemIdentifier:NSToolbarIdentifierCardOptionTypeCollecticle atIndex:6];
    
    DynamicMenuToolbarItem *optionTypeRarityItem = [[DynamicMenuToolbarItem alloc] initWithItemIdentifier:NSToolbarIdentifierCardOptionTypeRarity];
    optionTypeRarityItem.toolTip = [ResourcesService localizationForKey:LocalizableKeyCardRarityTooltipDescription];
    optionTypeRarityItem.menu = [self menuForMenuToolbarItem:optionTypeRarityItem];
    [self insertItemWithItemIdentifier:NSToolbarIdentifierCardOptionTypeRarity atIndex:7];
    
    DynamicMenuToolbarItem *optionTypeTypeItem = [[DynamicMenuToolbarItem alloc] initWithItemIdentifier:NSToolbarIdentifierCardOptionTypeType];
    optionTypeTypeItem.toolTip = [ResourcesService localizationForKey:LocalizableKeyCardTypeTooltipDescription];
    optionTypeTypeItem.menu = [self menuForMenuToolbarItem:optionTypeTypeItem];
    [self insertItemWithItemIdentifier:NSToolbarIdentifierCardOptionTypeType atIndex:8];
    
    DynamicMenuToolbarItem *optionTypeMinionTypeItem = [[DynamicMenuToolbarItem alloc] initWithItemIdentifier:NSToolbarIdentifierCardOptionTypeMinionType];
    optionTypeMinionTypeItem.toolTip = [ResourcesService localizationForKey:LocalizableKeyCardMinionTypeTooltipDescription];
    optionTypeMinionTypeItem.menu = [self menuForMenuToolbarItem:optionTypeMinionTypeItem];
    [self insertItemWithItemIdentifier:NSToolbarIdentifierCardOptionTypeMinionType atIndex:9];
    
    DynamicMenuToolbarItem *optionTypeSpellSchoolItem = [[DynamicMenuToolbarItem alloc] initWithItemIdentifier:NSToolbarIdentifierCardOptionTypeSpellSchool];
    optionTypeSpellSchoolItem.toolTip = [ResourcesService localizationForKey:LocalizableKeyCardSpellSchoolTooltipDescription];
    optionTypeSpellSchoolItem.menu = [self menuForMenuToolbarItem:optionTypeSpellSchoolItem];
    [self insertItemWithItemIdentifier:NSToolbarIdentifierCardOptionTypeSpellSchool atIndex:10];
    
    DynamicMenuToolbarItem *optionTypeKeyowrdItem = [[DynamicMenuToolbarItem alloc] initWithItemIdentifier:NSToolbarIdentifierCardOptionTypeKeyword];
    optionTypeKeyowrdItem.toolTip = [ResourcesService localizationForKey:LocalizableKeyCardKeywordTooltipDescription];
    optionTypeKeyowrdItem.menu = [self menuForMenuToolbarItem:optionTypeKeyowrdItem];
    [self insertItemWithItemIdentifier:NSToolbarIdentifierCardOptionTypeKeyword atIndex:11];
    
    DynamicMenuToolbarItem *optionTypeGameModeItem = [[DynamicMenuToolbarItem alloc] initWithItemIdentifier:NSToolbarIdentifierCardOptionTypeGameMode];
    optionTypeGameModeItem.toolTip = [ResourcesService localizationForKey:LocalizableKeyCardGameModeTooltipDescription];
    optionTypeGameModeItem.menu = [self menuForMenuToolbarItem:optionTypeGameModeItem];
    [self insertItemWithItemIdentifier:NSToolbarIdentifierCardOptionTypeGameMode atIndex:12];
    
    DynamicMenuToolbarItem *optionTypeSortItem = [[DynamicMenuToolbarItem alloc] initWithItemIdentifier:NSToolbarIdentifierCardOptionTypeSort];
    optionTypeSortItem.toolTip = [ResourcesService localizationForKey:LocalizableKeyCardSortTooltipDescription];
    optionTypeSortItem.menu = [self menuForMenuToolbarItem:optionTypeSortItem];
    [self insertItemWithItemIdentifier:NSToolbarIdentifierCardOptionTypeSort atIndex:13];
    
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
    self.optionTypeKeyowrdItem = optionTypeKeyowrdItem;
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
    [optionTypeKeyowrdItem release];
    [optionTypeGameModeItem release];
    [optionTypeSortItem release];
    
    [self validateVisibleItems];
}

- (void)updateItemsWithOptions:(NSDictionary<NSString *, NSSet<NSString *> *> * _Nullable)options {
    NSMutableDictionary<NSString *, NSSet<NSString *> *> *mutableOptions = [options mutableCopy];
    self.options = mutableOptions;
    [mutableOptions release];
    
    [self.optionTypeAllItems enumerateObjectsUsingBlock:^(NSMenuToolbarItem * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        DynamicMenuToolbarItem *item = (DynamicMenuToolbarItem *)obj;
        
        if (![item isKindOfClass:[DynamicMenuToolbarItem class]]) return;
        
        NSToolbarItemIdentifier itemIdentifier = item.itemIdentifier;
        BlizzardHSAPIOptionType optionType = BlizzardHSAPIOptionTypeFromNSToolbarIdentifierCardOptionType(itemIdentifier);
        NSSet<NSString *> * _Nullable values = options[optionType];
        
        //
        
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
        
        obj.image = [CardOptionsMenuFactory imageForCardOptionTypeWithValues:values optionType:optionType];
        obj.title = [CardOptionsMenuFactory titleForOptionType:optionType];
        
        [self updateStateOfMenuToolbarItem:item];
    }];
}

- (NSMenu *)menuForMenuToolbarItem:(DynamicMenuToolbarItem *)menuToolbarItem {
    NSToolbarItemIdentifier itemIdentifier = menuToolbarItem.itemIdentifier;
    BlizzardHSAPIOptionType optionType = BlizzardHSAPIOptionTypeFromNSToolbarIdentifierCardOptionType(itemIdentifier);
    
    return [CardOptionsMenuFactory menuForOptionType:optionType target:self];
}

- (void)updateStateOfMenuToolbarItem:(DynamicMenuToolbarItem *)menuToolbarItem {
    NSToolbarItemIdentifier itemIdentifier = menuToolbarItem.itemIdentifier;
    BlizzardHSAPIOptionType optionType = BlizzardHSAPIOptionTypeFromNSToolbarIdentifierCardOptionType(itemIdentifier);
    
    NSArray<NSString *> * _Nullable values = self.options[optionType].allObjects;
    BOOL shouldSelectEmptyValue = ((values == nil) || (values.count == 0));
    
    [menuToolbarItem.menu.itemArray enumerateObjectsUsingBlock:^(NSMenuItem * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        StorableMenuItem *item = (StorableMenuItem *)obj;
        
        if (![item isKindOfClass:[StorableMenuItem class]]) return;
        
        NSString *itemValue = item.userInfo[CardOptionsMenuFactoryStorableMenuItemValueKey];
        
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

- (DynamicMenuToolbarItem * _Nullable)menuToolbarItemForOptionType:(BlizzardHSAPIOptionType)optionType {
    DynamicMenuToolbarItem * _Nullable __block result = nil;
    
    [self.optionTypeAllItems enumerateObjectsUsingBlock:^(DynamicMenuToolbarItem * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSToolbarItemIdentifier itemIdentifier = obj.itemIdentifier;
        BlizzardHSAPIOptionType tmp = BlizzardHSAPIOptionTypeFromNSToolbarIdentifierCardOptionType(itemIdentifier);
        
        if ([optionType isEqualToString:tmp]) {
            result = obj;
            *stop = YES;
        }
    }];
    
    return result;
}

- (void)keyMenuItemTriggered:(StorableMenuItem *)sender {
    NSDictionary<NSString *, id> *userInfo = sender.userInfo;
    
    BOOL showsEmptyItem;
    BOOL supportsMultipleSelection;
    
    if (userInfo[CardOptionsMenuFactoryStorableMenuItemShowsEmptyItemKey]) {
        showsEmptyItem = [(NSNumber *)userInfo[CardOptionsMenuFactoryStorableMenuItemShowsEmptyItemKey] boolValue];
    } else {
        showsEmptyItem = NO;
    }
    
    if (userInfo[CardOptionsMenuFactoryStorableMenuItemSuppoertsMultipleSelection]) {
        supportsMultipleSelection = [(NSNumber *)userInfo[CardOptionsMenuFactoryStorableMenuItemSuppoertsMultipleSelection] boolValue];
    } else {
        supportsMultipleSelection = NO;
    }
    
    NSString *key = userInfo[CardOptionsMenuFactoryStorableMenuItemOptionTypeKey];
    NSString *value = userInfo[CardOptionsMenuFactoryStorableMenuItemValueKey];
    
    //
    
    if ([value isEqualToString:@""]) {
        [self.options removeObjectForKey:key];
    } else if (!supportsMultipleSelection) {
        self.options[key] = [NSSet setWithObject:value];
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
//            [self.options removeObjectForKey:key];
        }
        
        [values release];
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
    return allNSToolbarIdentifierCardOptionTypes();
}

- (NSArray<NSToolbarItemIdentifier> *)toolbarAllowedItemIdentifiers:(NSToolbar *)toolbar {
    return allNSToolbarIdentifierCardOptionTypes();
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
        
        [[self menuToolbarItemForOptionType:key].menu cancelTracking];
        
        if ([value isEqualToString:@""]) {
            [self.options removeObjectForKey:key];
        } else {
            self.options[key] = [NSSet setWithObject:value];
        }
        
        [self updateItemsWithOptions:self.options];
        [self.cardOptionsToolbarDelegate cardOptionsToolbar:self changedOption:self.options];
    }
}

@end
