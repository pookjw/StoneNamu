//
//  DeckAddCardOptionsToolbar.m
//  StoneNamuMac
//
//  Created by Jinwoo Kim on 12/3/21.
//

#import "DeckAddCardOptionsToolbar.h"
#import "StorableMenuItem.h"
#import "StorableSearchField.h"
#import "DynamicMenuToolbarItem.h"
#import "NSToolbarIdentifierCardOptionType+BlizzardHSAPIOptionType.h"
#import "DeckAddCardOptionsMenuFactory.h"
#import <StoneNamuResources/StoneNamuResources.h>

@interface DeckAddCardOptionsToolbar () <NSToolbarDelegate, NSSearchFieldDelegate>
@property (assign) id<DeckAddCardOptionsToolbarDelegate> deckAddCardOptionsToolbarDelegate;
@property (retain) DeckAddCardOptionsMenuFactory *factory;

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
@property (retain) NSArray<DynamicMenuToolbarItem *> *allOptionsItems;
@property (retain) NSMutableDictionary<NSString *, NSSet<NSString *> *> *options;
@end

@implementation DeckAddCardOptionsToolbar

- (instancetype)initWithIdentifier:(NSToolbarIdentifier)identifier options:(NSDictionary<NSString *, NSSet<NSString *> *> * _Nullable)options deckAddCardOptionsToolbarDelegate:(id<DeckAddCardOptionsToolbarDelegate>)deckAddCardOptionsToolbarDelegate {
    self = [self initWithIdentifier:identifier];
    
    if (self) {
        NSMutableDictionary<NSString *, NSSet<NSString *> *> *mutableOptions = [options mutableCopy];
        self.options = mutableOptions;
        [mutableOptions release];
        
        DeckAddCardOptionsMenuFactory *factory = [DeckAddCardOptionsMenuFactory new];
        self.factory = factory;
        [factory release];
        
        self.deckAddCardOptionsToolbarDelegate = deckAddCardOptionsToolbarDelegate;
        [self setAttributes];
        [self configureToolbarItems];
        [self updateItemsWithOptions:options];
    }
    
    return self;
}

- (void)dealloc {
    [_factory release];
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
    [_allOptionsItems release];
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
    [self insertItemWithItemIdentifier:NSToolbarIdentifierCardOptionTypeTextFilter atIndex:0];
    
    DynamicMenuToolbarItem *optionTypeSetItem = [[DynamicMenuToolbarItem alloc] initWithItemIdentifier:NSToolbarIdentifierCardOptionTypeSet];
    optionTypeSetItem.toolTip = [ResourcesService localizationForKey:LocalizableKeyCardSetTooltipDescription];
    [self insertItemWithItemIdentifier:NSToolbarIdentifierCardOptionTypeSet atIndex:1];
    
    DynamicMenuToolbarItem *optionTypeClassItem = [[DynamicMenuToolbarItem alloc] initWithItemIdentifier:NSToolbarIdentifierCardOptionTypeClass];
    optionTypeClassItem.toolTip = [ResourcesService localizationForKey:LocalizableKeyCardClassTooltipDescription];
    [self insertItemWithItemIdentifier:NSToolbarIdentifierCardOptionTypeClass atIndex:2];
    
    DynamicMenuToolbarItem *optionTypeManaCostItem = [[DynamicMenuToolbarItem alloc] initWithItemIdentifier:NSToolbarIdentifierCardOptionTypeManaCost];
    optionTypeManaCostItem.toolTip = [ResourcesService localizationForKey:LocalizableKeyCardManaCostTooltipDescription];
    [self insertItemWithItemIdentifier:NSToolbarIdentifierCardOptionTypeManaCost atIndex:3];
    
    DynamicMenuToolbarItem *optionTypeAttackItem = [[DynamicMenuToolbarItem alloc] initWithItemIdentifier:NSToolbarIdentifierCardOptionTypeAttack];
    optionTypeAttackItem.toolTip = [ResourcesService localizationForKey:LocalizableKeyCardAttackTooltipDescription];
    [self insertItemWithItemIdentifier:NSToolbarIdentifierCardOptionTypeAttack atIndex:4];
    
    DynamicMenuToolbarItem *optionTypeHealthItem = [[DynamicMenuToolbarItem alloc] initWithItemIdentifier:NSToolbarIdentifierCardOptionTypeHealth];
    optionTypeHealthItem.toolTip = [ResourcesService localizationForKey:LocalizableKeyCardHealthTooltipDescription];
    [self insertItemWithItemIdentifier:NSToolbarIdentifierCardOptionTypeHealth atIndex:5];
    
    DynamicMenuToolbarItem *optionTypeCollectibleItem = [[DynamicMenuToolbarItem alloc] initWithItemIdentifier:NSToolbarIdentifierCardOptionTypeCollecticle];
    optionTypeCollectibleItem.toolTip = [ResourcesService localizationForKey:LocalizableKeyCardCollectibleTooltipDescription];
    [self insertItemWithItemIdentifier:NSToolbarIdentifierCardOptionTypeCollecticle atIndex:6];
    
    DynamicMenuToolbarItem *optionTypeRarityItem = [[DynamicMenuToolbarItem alloc] initWithItemIdentifier:NSToolbarIdentifierCardOptionTypeRarity];
    optionTypeRarityItem.toolTip = [ResourcesService localizationForKey:LocalizableKeyCardRarityTooltipDescription];
    [self insertItemWithItemIdentifier:NSToolbarIdentifierCardOptionTypeRarity atIndex:7];
    
    DynamicMenuToolbarItem *optionTypeTypeItem = [[DynamicMenuToolbarItem alloc] initWithItemIdentifier:NSToolbarIdentifierCardOptionTypeType];
    optionTypeTypeItem.toolTip = [ResourcesService localizationForKey:LocalizableKeyCardTypeTooltipDescription];
    [self insertItemWithItemIdentifier:NSToolbarIdentifierCardOptionTypeType atIndex:8];
    
    DynamicMenuToolbarItem *optionTypeMinionTypeItem = [[DynamicMenuToolbarItem alloc] initWithItemIdentifier:NSToolbarIdentifierCardOptionTypeMinionType];
    optionTypeMinionTypeItem.toolTip = [ResourcesService localizationForKey:LocalizableKeyCardMinionTypeTooltipDescription];
    [self insertItemWithItemIdentifier:NSToolbarIdentifierCardOptionTypeMinionType atIndex:9];
    
    DynamicMenuToolbarItem *optionTypeSpellSchoolItem = [[DynamicMenuToolbarItem alloc] initWithItemIdentifier:NSToolbarIdentifierCardOptionTypeSpellSchool];
    optionTypeSpellSchoolItem.toolTip = [ResourcesService localizationForKey:LocalizableKeyCardSpellSchoolTooltipDescription];
    [self insertItemWithItemIdentifier:NSToolbarIdentifierCardOptionTypeSpellSchool atIndex:10];
    
    DynamicMenuToolbarItem *optionTypeKeyowrdItem = [[DynamicMenuToolbarItem alloc] initWithItemIdentifier:NSToolbarIdentifierCardOptionTypeKeyword];
    optionTypeKeyowrdItem.toolTip = [ResourcesService localizationForKey:LocalizableKeyCardKeywordTooltipDescription];
    [self insertItemWithItemIdentifier:NSToolbarIdentifierCardOptionTypeKeyword atIndex:11];
    
    DynamicMenuToolbarItem *optionTypeGameModeItem = [[DynamicMenuToolbarItem alloc] initWithItemIdentifier:NSToolbarIdentifierCardOptionTypeGameMode];
    optionTypeGameModeItem.toolTip = [ResourcesService localizationForKey:LocalizableKeyCardGameModeTooltipDescription];
    [self insertItemWithItemIdentifier:NSToolbarIdentifierCardOptionTypeGameMode atIndex:12];
    
    DynamicMenuToolbarItem *optionTypeSortItem = [[DynamicMenuToolbarItem alloc] initWithItemIdentifier:NSToolbarIdentifierCardOptionTypeSort];
    optionTypeSortItem.toolTip = [ResourcesService localizationForKey:LocalizableKeyCardSortTooltipDescription];
    [self insertItemWithItemIdentifier:NSToolbarIdentifierCardOptionTypeSort atIndex:13];
    
    //
    
    self.allOptionsItems = @[
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

- (void)updateWithSlugsAndNames:(NSDictionary<BlizzardHSAPIOptionType,NSDictionary<NSString *,NSString *> *> *)slugsAndNames slugsAndIds:(NSDictionary<BlizzardHSAPIOptionType,NSDictionary<NSString *,NSNumber *> *> *)slugsAndIds {
    self.factory.slugsAndNames = slugsAndNames;
    self.factory.slugsAndIds = slugsAndIds;
    
    [self.allOptionsItems enumerateObjectsUsingBlock:^(DynamicMenuToolbarItem * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSUserInterfaceItemIdentifier itemIdentifier = obj.itemIdentifier;
        BlizzardHSAPIOptionType optionType = BlizzardHSAPIOptionTypeFromNSToolbarIdentifierCardOptionType(itemIdentifier);
        
        obj.menu = [self.factory menuForOptionType:optionType target:self];
        obj.title = [self.factory titleForOptionType:optionType];
    }];
}

- (void)updateItemsWithOptions:(NSDictionary<NSString *, NSSet<NSString *> *> * _Nullable)options {
    NSMutableDictionary<NSString *, NSSet<NSString *> *> *mutableOptions = [options mutableCopy];
    self.options = mutableOptions;
    [mutableOptions release];
    
    [self.allOptionsItems enumerateObjectsUsingBlock:^(NSMenuToolbarItem * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
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
        
        obj.image = [self.factory imageForCardOptionTypeWithValues:values optionType:optionType];
        
        [self updateStateOfMenuToolbarItem:item];
    }];
}

- (void)updateStateOfMenuToolbarItem:(DynamicMenuToolbarItem *)menuToolbarItem {
    NSToolbarItemIdentifier itemIdentifier = menuToolbarItem.itemIdentifier;
    BlizzardHSAPIOptionType optionType = BlizzardHSAPIOptionTypeFromNSToolbarIdentifierCardOptionType(itemIdentifier);
    
    NSArray<NSString *> * _Nullable values = self.options[optionType].allObjects;
    BOOL shouldSelectEmptyValue = ((values == nil) || (values.count == 0));
    
    [menuToolbarItem.menu.itemArray enumerateObjectsUsingBlock:^(NSMenuItem * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
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

- (DynamicMenuToolbarItem * _Nullable)menuToolbarItemForOptionType:(BlizzardHSAPIOptionType)optionType {
    DynamicMenuToolbarItem * _Nullable __block result = nil;
    
    [self.allOptionsItems enumerateObjectsUsingBlock:^(DynamicMenuToolbarItem * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
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
    
    if (userInfo[DeckAddCardOptionsMenuFactoryStorableMenuItemShowsEmptyItemKey]) {
        showsEmptyItem = [(NSNumber *)userInfo[DeckAddCardOptionsMenuFactoryStorableMenuItemShowsEmptyItemKey] boolValue];
    } else {
        showsEmptyItem = NO;
    }
    
    if (userInfo[DeckAddCardOptionsMenuFactoryStorableMenuItemAllowsMultipleSelection]) {
        supportsMultipleSelection = [(NSNumber *)userInfo[DeckAddCardOptionsMenuFactoryStorableMenuItemAllowsMultipleSelection] boolValue];
    } else {
        supportsMultipleSelection = NO;
    }
    
    NSString *key = userInfo[DeckAddCardOptionsMenuFactoryStorableMenuItemOptionTypeKey];
    NSString *value = userInfo[DeckAddCardOptionsMenuFactoryStorableMenuItemValueKey];
    
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
    [self.deckAddCardOptionsToolbarDelegate deckAddCardOptionsToolbar:self changedOption:self.options];
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
        [self.deckAddCardOptionsToolbarDelegate deckAddCardOptionsToolbar:self changedOption:self.options];
    }
}

@end
