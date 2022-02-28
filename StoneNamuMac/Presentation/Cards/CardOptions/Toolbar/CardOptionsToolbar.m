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
@property (retain) CardOptionsMenuFactory *factory;
@property (retain) NSOperationQueue *queue;
@property (retain) NSDictionary<BlizzardHSAPIOptionType, DynamicMenuToolbarItem *> *allOptionItems;
@property (retain) NSMutableDictionary<NSString *, NSSet<NSString *> *> *options;
@end

@implementation CardOptionsToolbar

- (instancetype)initWithIdentifier:(NSToolbarIdentifier)identifier options:(NSDictionary<NSString *, NSSet<NSString *> *> * _Nullable)options cardOptionsToolbarDelegate:(id<CardOptionsToolbarDelegate>)cardOptionsToolbarDelegate {
    self = [self initWithIdentifier:identifier];
    
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
        
        self.cardOptionsToolbarDelegate = cardOptionsToolbarDelegate;
        
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
    [_queue release];
    [_allOptionItems release];
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
    
    NSDictionary<BlizzardHSAPIOptionType, DynamicMenuToolbarItem *> *allOptionItems = @{
        BlizzardHSAPIOptionTypeTextFilter: optionTypeTextFilterItem,
        BlizzardHSAPIOptionTypeSet: optionTypeSetItem,
        BlizzardHSAPIOptionTypeClass: optionTypeClassItem,
        BlizzardHSAPIOptionTypeManaCost: optionTypeManaCostItem,
        BlizzardHSAPIOptionTypeAttack: optionTypeAttackItem,
        BlizzardHSAPIOptionTypeHealth: optionTypeHealthItem,
        BlizzardHSAPIOptionTypeCollectible: optionTypeCollectibleItem,
        BlizzardHSAPIOptionTypeRarity: optionTypeRarityItem,
        BlizzardHSAPIOptionTypeType: optionTypeTypeItem,
        BlizzardHSAPIOptionTypeMinionType: optionTypeMinionTypeItem,
        BlizzardHSAPIOptionTypeSpellSchool: optionTypeSpellSchoolItem,
        BlizzardHSAPIOptionTypeKeyword: optionTypeKeyowrdItem,
        BlizzardHSAPIOptionTypeGameMode: optionTypeGameModeItem,
        BlizzardHSAPIOptionTypeSort: optionTypeSortItem
    };
    
    self.allOptionItems = allOptionItems;
    
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
    [self updateItemsWithOptions:options force:NO];
}

- (void)updateItemsWithOptions:(NSDictionary<NSString *, NSSet<NSString *> *> * _Nullable)options force:(BOOL)force {
    [self.queue addBarrierBlock:^{
        if (!force) {
            if (compareNullableValues(self.options, options, @selector(isEqualToDictionary:))) {
                return;
            }
        }
        
        NSMutableDictionary<NSString *, NSSet<NSString *> *> *mutableOptions = [options mutableCopy];
        self.options = mutableOptions;
        [mutableOptions release];
        
        [self.allOptionItems enumerateKeysAndObjectsUsingBlock:^(BlizzardHSAPIOptionType  _Nonnull key, DynamicMenuToolbarItem * _Nonnull obj, BOOL * _Nonnull stop) {
            DynamicMenuToolbarItem *item = (DynamicMenuToolbarItem *)obj;
            if (![item isKindOfClass:[DynamicMenuToolbarItem class]]) return;
            
            NSSet<NSString *> * _Nullable values = options[key];
            
            //
            
            [NSOperationQueue.mainQueue addOperationWithBlock:^{
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
                
                obj.image = [self.factory imageForCardOptionTypeWithValues:values optionType:key];
            }];
            
            [self updateStateOfMenuToolbarItem:item];
        }];
    }];
}

- (void)updateStateOfMenuToolbarItem:(DynamicMenuToolbarItem *)menuToolbarItem {
    NSToolbarItemIdentifier itemIdentifier = menuToolbarItem.itemIdentifier;
    
    [self.queue addBarrierBlock:^{
        BlizzardHSAPIOptionType optionType = BlizzardHSAPIOptionTypeFromNSToolbarIdentifierCardOptionType(itemIdentifier);
        
        NSArray<NSString *> * _Nullable values = self.options[optionType].allObjects;
        BOOL shouldSelectEmptyValue = ((values == nil) || (values.count == 0));
        
        [menuToolbarItem.menu.itemArray enumerateObjectsUsingBlock:^(NSMenuItem * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
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

- (void)bind {
    [NSNotificationCenter.defaultCenter addObserver:self
                                           selector:@selector(shouldUpdateReceived:)
                                               name:NSNotificationNameCardOptionsMenuFactoryShouldUpdateItems
                                             object:self.factory];
}

- (void)shouldUpdateReceived:(NSNotification *)notification {
    [NSOperationQueue.mainQueue addOperationWithBlock:^{
        [self.allOptionItems enumerateKeysAndObjectsUsingBlock:^(BlizzardHSAPIOptionType  _Nonnull key, DynamicMenuToolbarItem * _Nonnull obj, BOOL * _Nonnull stop) {
            obj.menu = [self.factory menuForOptionType:key target:self];
            obj.title = [self.factory titleForOptionType:key];
        }];
    }];
    
    [self updateItemsWithOptions:self.options force:YES];
}

- (void)keyMenuItemTriggered:(StorableMenuItem *)sender {
    [self.queue addBarrierBlock:^{
        NSDictionary<NSString *, id> *userInfo = sender.userInfo;
        
        BOOL showsEmptyItem;
        BOOL supportsMultipleSelection;
        
        if (userInfo[CardOptionsMenuFactoryStorableMenuItemShowsEmptyItemKey]) {
            showsEmptyItem = [(NSNumber *)userInfo[CardOptionsMenuFactoryStorableMenuItemShowsEmptyItemKey] boolValue];
        } else {
            showsEmptyItem = NO;
        }
        
        if (userInfo[CardOptionsMenuFactoryStorableMenuItemAllowsMultipleSelection]) {
            supportsMultipleSelection = [(NSNumber *)userInfo[CardOptionsMenuFactoryStorableMenuItemAllowsMultipleSelection] boolValue];
        } else {
            supportsMultipleSelection = NO;
        }
        
        NSString *key = userInfo[CardOptionsMenuFactoryStorableMenuItemOptionTypeKey];
        NSString *value = userInfo[CardOptionsMenuFactoryStorableMenuItemValueKey];
        
        //
        
        NSMutableDictionary<NSString *, NSSet<NSString *> *> *newOptions = [self.options mutableCopy];
        
        if ([value isEqualToString:@""]) {
            [newOptions removeObjectForKey:key];
        } else if (!supportsMultipleSelection) {
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
        [self.cardOptionsToolbarDelegate cardOptionsToolbar:self changedOption:newOptions];
        
        [newOptions release];
    }];
}

#pragma mark - NSToolbarDelegate

- (NSToolbarItem *)toolbar:(NSToolbar *)toolbar itemForItemIdentifier:(NSToolbarItemIdentifier)itemIdentifier willBeInsertedIntoToolbar:(BOOL)flag {
    NSMenuToolbarItem * _Nullable __block resultItem = nil;
    
    [self.allOptionItems.allValues enumerateObjectsUsingBlock:^(NSMenuToolbarItem * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
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
        
        [self.allOptionItems[key].menu cancelTracking];
        
        NSMutableDictionary<NSString *, NSSet<NSString *> *> *newOptions = [self.options mutableCopy];
        
        if ([value isEqualToString:@""]) {
            [newOptions removeObjectForKey:key];
        } else {
            newOptions[key] = [NSSet setWithObject:value];
        }
        
        [self updateItemsWithOptions:newOptions];
        [self.cardOptionsToolbarDelegate cardOptionsToolbar:self changedOption:newOptions];
        
        [newOptions release];
    }
}

@end
