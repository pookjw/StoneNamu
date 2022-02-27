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

@property (retain) DynamicMenuToolbarItem *optionTypeTextFilterItem;
@property (retain) DynamicMenuToolbarItem *optionTypeTierItem;
@property (retain) DynamicMenuToolbarItem *optionTypeAttackItem;
@property (retain) DynamicMenuToolbarItem *optionTypeHealthItem;
@property (retain) DynamicMenuToolbarItem *optionTypeTypeItem;
@property (retain) DynamicMenuToolbarItem *optionTypeMinionTypeItem;
@property (retain) DynamicMenuToolbarItem *optionTypeKeyowrdItem;
@property (retain) DynamicMenuToolbarItem *optionTypeSortItem;
@property (retain) NSArray<DynamicMenuToolbarItem *> *allOptionsItems;
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
    [_optionTypeTextFilterItem release];
    [_optionTypeTierItem release];
    [_optionTypeAttackItem release];
    [_optionTypeHealthItem release];
    [_optionTypeTypeItem release];
    [_optionTypeMinionTypeItem release];
    [_optionTypeKeyowrdItem release];
    [_optionTypeSortItem release];
    [_allOptionsItems release];
    [_options release];
    [super dealloc];
}

- (void)setAttributes {
    self.delegate = self;
    self.allowsUserCustomization = NO;
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
    
    self.allOptionsItems = @[
        optionTypeTextFilterItem,
        optionTypeTierItem,
        optionTypeAttackItem,
        optionTypeHealthItem,
        optionTypeTypeItem,
        optionTypeMinionTypeItem,
        optionTypeKeyowrdItem,
        optionTypeSortItem
    ];
    
    self.optionTypeTextFilterItem = optionTypeTextFilterItem;
    self.optionTypeTierItem = optionTypeTierItem;
    self.optionTypeAttackItem = optionTypeAttackItem;
    self.optionTypeHealthItem = optionTypeHealthItem;
    self.optionTypeTypeItem = optionTypeTypeItem;
    self.optionTypeMinionTypeItem = optionTypeMinionTypeItem;
    self.optionTypeKeyowrdItem = optionTypeKeyowrdItem;
    self.optionTypeSortItem = optionTypeSortItem;
    
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
    NSMutableDictionary<NSString *, NSSet<NSString *> *> *mutableOptions = [options mutableCopy];
    self.options = mutableOptions;
    [mutableOptions release];
    
    [self.allOptionsItems enumerateObjectsUsingBlock:^(NSMenuToolbarItem * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        DynamicMenuToolbarItem *item = (DynamicMenuToolbarItem *)obj;
        
        if (![item isKindOfClass:[DynamicMenuToolbarItem class]]) return;
        
        NSToolbarItemIdentifier itemIdentifier = item.itemIdentifier;
        BlizzardHSAPIOptionType optionType = BlizzardHSAPIOptionTypeFromNSToolbarIdentifierBattlegroundsCardOptionType(itemIdentifier);
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
        
        obj.image = [self.factory imageForCardOptionTypeWithValues:values optionType:optionType];
        
        [self updateStateOfMenuToolbarItem:item];
    }];
}

- (void)updateStateOfMenuToolbarItem:(DynamicMenuToolbarItem *)menuToolbarItem {
    NSToolbarItemIdentifier itemIdentifier = menuToolbarItem.itemIdentifier;
    BlizzardHSAPIOptionType optionType = BlizzardHSAPIOptionTypeFromNSToolbarIdentifierBattlegroundsCardOptionType(itemIdentifier);
    
    NSArray<NSString *> * _Nullable values = self.options[optionType].allObjects;
    BOOL shouldSelectEmptyValue = ((values == nil) || (values.count == 0));
    
    [menuToolbarItem.menu.itemArray enumerateObjectsUsingBlock:^(NSMenuItem * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        StorableMenuItem *item = (StorableMenuItem *)obj;
        
        if (![item isKindOfClass:[StorableMenuItem class]]) return;
        
        NSString *itemValue = item.userInfo[BattlegroundsCardOptionsMenuFactoryStorableMenuItemValueKey];
        
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

- (void)bind {
    [NSNotificationCenter.defaultCenter addObserver:self
                                           selector:@selector(shouldUpdateReceived:)
                                               name:NSNotificationNameBattlegroundsCardOptionsMenuFactoryShouldUpdateItems
                                             object:self.factory];
}

- (void)shouldUpdateReceived:(NSNotification *)notification {
    [NSOperationQueue.mainQueue addOperationWithBlock:^{
        [self.allOptionsItems enumerateObjectsUsingBlock:^(DynamicMenuToolbarItem * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            NSUserInterfaceItemIdentifier itemIdentifier = obj.itemIdentifier;
            BlizzardHSAPIOptionType optionType = BlizzardHSAPIOptionTypeFromNSToolbarIdentifierBattlegroundsCardOptionType(itemIdentifier);
            
            obj.menu = [self.factory menuForOptionType:optionType target:self];
            obj.title = [self.factory titleForOptionType:optionType];
        }];
        
        [self updateItemsWithOptions:self.options];
    }];
}

- (DynamicMenuToolbarItem * _Nullable)menuToolbarItemForOptionType:(BlizzardHSAPIOptionType)optionType {
    DynamicMenuToolbarItem * _Nullable __block result = nil;
    
    [self.allOptionsItems enumerateObjectsUsingBlock:^(DynamicMenuToolbarItem * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSToolbarItemIdentifier itemIdentifier = obj.itemIdentifier;
        BlizzardHSAPIOptionType tmp = BlizzardHSAPIOptionTypeFromNSToolbarIdentifierBattlegroundsCardOptionType(itemIdentifier);
        
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
    
    if ([value isEqualToString:@""]) {
        [self.options removeObjectForKey:key];
    } else if (!supportsMultipleSelection) {
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
    [self.battlegroundsCardOptionsToolbarDelegate battlegroundsCardOptionsToolbar:self changedOption:self.options];
}

#pragma mark - NSToolbarDelegate

- (NSToolbarItem *)toolbar:(NSToolbar *)toolbar itemForItemIdentifier:(NSToolbarItemIdentifier)itemIdentifier willBeInsertedIntoToolbar:(BOOL)flag {
    NSMenuToolbarItem * _Nullable __block resultItem = nil;
    
    [self.allOptionsItems enumerateObjectsUsingBlock:^(NSMenuToolbarItem * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
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
        
        [[self menuToolbarItemForOptionType:key].menu cancelTracking];
        
        if ([value isEqualToString:@""]) {
            [self.options removeObjectForKey:key];
        } else {
            self.options[key] = [NSSet setWithObject:value];
        }
        
        [self updateItemsWithOptions:self.options];
        [self.battlegroundsCardOptionsToolbarDelegate battlegroundsCardOptionsToolbar:self changedOption:self.options];
    }
}

@end
