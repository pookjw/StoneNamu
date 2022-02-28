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
#import "NSToolbarIdentifierDeckAddCardOptionType+BlizzardHSAPIOptionType.h"
#import "DeckAddCardOptionsMenuFactory.h"
#import <StoneNamuResources/StoneNamuResources.h>

@interface DeckAddCardOptionsToolbar () <NSToolbarDelegate, NSSearchFieldDelegate>
@property (assign) id<DeckAddCardOptionsToolbarDelegate> deckAddCardOptionsToolbarDelegate;
@property (retain) DeckAddCardOptionsMenuFactory *factory;
@property (retain) NSOperationQueue *queue;
@property (retain) NSDictionary<BlizzardHSAPIOptionType, DynamicMenuToolbarItem *> *allOptionItems;
@property (retain) NSMutableDictionary<NSString *, NSSet<NSString *> *> *options;
@end

@implementation DeckAddCardOptionsToolbar

- (instancetype)initWithIdentifier:(NSToolbarIdentifier)identifier options:(NSDictionary<NSString *, NSSet<NSString *> *> * _Nullable)options localDeck:(LocalDeck * _Nullable)localDeck deckAddCardOptionsToolbarDelegate:(id<DeckAddCardOptionsToolbarDelegate>)deckAddCardOptionsToolbarDelegate {
    self = [self initWithIdentifier:identifier];
    
    if (self) {
        NSMutableDictionary<NSString *, NSSet<NSString *> *> *mutableOptions = [options mutableCopy];
        self.options = mutableOptions;
        [mutableOptions release];
        
        DeckAddCardOptionsMenuFactory *factory = [[DeckAddCardOptionsMenuFactory alloc] initWithLocalDeck:localDeck];
        self.factory = factory;
        [factory release];
        
        NSOperationQueue *queue = [NSOperationQueue new];
        queue.qualityOfService = NSQualityOfServiceUserInitiated;
        self.queue = queue;
        [queue release];
        
        self.deckAddCardOptionsToolbarDelegate = deckAddCardOptionsToolbarDelegate;
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
    DynamicMenuToolbarItem *optionTypeTextFilterItem = [[DynamicMenuToolbarItem alloc] initWithItemIdentifier:NSToolbarIdentifierDeckAddCardOptionTypeTextFilter];
    optionTypeTextFilterItem.toolTip = [ResourcesService localizationForKey:LocalizableKeyCardTextFilterTooltipDescription];
    [self insertItemWithItemIdentifier:NSToolbarIdentifierDeckAddCardOptionTypeTextFilter atIndex:0];
    
    DynamicMenuToolbarItem *optionTypeSetItem = [[DynamicMenuToolbarItem alloc] initWithItemIdentifier:NSToolbarIdentifierDeckAddCardOptionTypeSet];
    optionTypeSetItem.toolTip = [ResourcesService localizationForKey:LocalizableKeyCardSetTooltipDescription];
    [self insertItemWithItemIdentifier:NSToolbarIdentifierDeckAddCardOptionTypeSet atIndex:1];
    
    DynamicMenuToolbarItem *optionTypeClassItem = [[DynamicMenuToolbarItem alloc] initWithItemIdentifier:NSToolbarIdentifierDeckAddCardOptionTypeClass];
    optionTypeClassItem.toolTip = [ResourcesService localizationForKey:LocalizableKeyCardClassTooltipDescription];
    [self insertItemWithItemIdentifier:NSToolbarIdentifierDeckAddCardOptionTypeClass atIndex:2];
    
    DynamicMenuToolbarItem *optionTypeManaCostItem = [[DynamicMenuToolbarItem alloc] initWithItemIdentifier:NSToolbarIdentifierDeckAddCardOptionTypeManaCost];
    optionTypeManaCostItem.toolTip = [ResourcesService localizationForKey:LocalizableKeyCardManaCostTooltipDescription];
    [self insertItemWithItemIdentifier:NSToolbarIdentifierDeckAddCardOptionTypeManaCost atIndex:3];
    
    DynamicMenuToolbarItem *optionTypeAttackItem = [[DynamicMenuToolbarItem alloc] initWithItemIdentifier:NSToolbarIdentifierDeckAddCardOptionTypeAttack];
    optionTypeAttackItem.toolTip = [ResourcesService localizationForKey:LocalizableKeyCardAttackTooltipDescription];
    [self insertItemWithItemIdentifier:NSToolbarIdentifierDeckAddCardOptionTypeAttack atIndex:4];
    
    DynamicMenuToolbarItem *optionTypeHealthItem = [[DynamicMenuToolbarItem alloc] initWithItemIdentifier:NSToolbarIdentifierDeckAddCardOptionTypeHealth];
    optionTypeHealthItem.toolTip = [ResourcesService localizationForKey:LocalizableKeyCardHealthTooltipDescription];
    [self insertItemWithItemIdentifier:NSToolbarIdentifierDeckAddCardOptionTypeHealth atIndex:5];
    
    DynamicMenuToolbarItem *optionTypeCollectibleItem = [[DynamicMenuToolbarItem alloc] initWithItemIdentifier:NSToolbarIdentifierDeckAddCardOptionTypeCollecticle];
    optionTypeCollectibleItem.toolTip = [ResourcesService localizationForKey:LocalizableKeyCardCollectibleTooltipDescription];
    [self insertItemWithItemIdentifier:NSToolbarIdentifierDeckAddCardOptionTypeCollecticle atIndex:6];
    
    DynamicMenuToolbarItem *optionTypeRarityItem = [[DynamicMenuToolbarItem alloc] initWithItemIdentifier:NSToolbarIdentifierDeckAddCardOptionTypeRarity];
    optionTypeRarityItem.toolTip = [ResourcesService localizationForKey:LocalizableKeyCardRarityTooltipDescription];
    [self insertItemWithItemIdentifier:NSToolbarIdentifierDeckAddCardOptionTypeRarity atIndex:7];
    
    DynamicMenuToolbarItem *optionTypeTypeItem = [[DynamicMenuToolbarItem alloc] initWithItemIdentifier:NSToolbarIdentifierDeckAddCardOptionTypeType];
    optionTypeTypeItem.toolTip = [ResourcesService localizationForKey:LocalizableKeyCardTypeTooltipDescription];
    [self insertItemWithItemIdentifier:NSToolbarIdentifierDeckAddCardOptionTypeType atIndex:8];
    
    DynamicMenuToolbarItem *optionTypeMinionTypeItem = [[DynamicMenuToolbarItem alloc] initWithItemIdentifier:NSToolbarIdentifierDeckAddCardOptionTypeMinionType];
    optionTypeMinionTypeItem.toolTip = [ResourcesService localizationForKey:LocalizableKeyCardMinionTypeTooltipDescription];
    [self insertItemWithItemIdentifier:NSToolbarIdentifierDeckAddCardOptionTypeMinionType atIndex:9];
    
    DynamicMenuToolbarItem *optionTypeSpellSchoolItem = [[DynamicMenuToolbarItem alloc] initWithItemIdentifier:NSToolbarIdentifierDeckAddCardOptionTypeSpellSchool];
    optionTypeSpellSchoolItem.toolTip = [ResourcesService localizationForKey:LocalizableKeyCardSpellSchoolTooltipDescription];
    [self insertItemWithItemIdentifier:NSToolbarIdentifierDeckAddCardOptionTypeSpellSchool atIndex:10];
    
    DynamicMenuToolbarItem *optionTypeKeyowrdItem = [[DynamicMenuToolbarItem alloc] initWithItemIdentifier:NSToolbarIdentifierDeckAddCardOptionTypeKeyword];
    optionTypeKeyowrdItem.toolTip = [ResourcesService localizationForKey:LocalizableKeyCardKeywordTooltipDescription];
    [self insertItemWithItemIdentifier:NSToolbarIdentifierDeckAddCardOptionTypeKeyword atIndex:11];
    
    DynamicMenuToolbarItem *optionTypeGameModeItem = [[DynamicMenuToolbarItem alloc] initWithItemIdentifier:NSToolbarIdentifierDeckAddCardOptionTypeGameMode];
    optionTypeGameModeItem.toolTip = [ResourcesService localizationForKey:LocalizableKeyCardGameModeTooltipDescription];
    [self insertItemWithItemIdentifier:NSToolbarIdentifierDeckAddCardOptionTypeGameMode atIndex:12];
    
    DynamicMenuToolbarItem *optionTypeSortItem = [[DynamicMenuToolbarItem alloc] initWithItemIdentifier:NSToolbarIdentifierDeckAddCardOptionTypeSort];
    optionTypeSortItem.toolTip = [ResourcesService localizationForKey:LocalizableKeyCardSortTooltipDescription];
    [self insertItemWithItemIdentifier:NSToolbarIdentifierDeckAddCardOptionTypeSort atIndex:13];
    
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

- (void)updateItemsWithOptions:(NSDictionary<NSString *,NSSet<NSString *> *> *)options {
    [self updateItemsWithOptions:options force:NO];
}

- (void)updateItemsWithOptions:(NSDictionary<NSString *,NSSet<NSString *> *> *)options force:(BOOL)force {
    [self.queue addBarrierBlock:^{
        if (!force) {
            if (compareNullableValues(self.options, options, @selector(isEqualToDictionary:))) return;
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
        BlizzardHSAPIOptionType optionType = BlizzardHSAPIOptionTypeFromNSToolbarIdentifierDeckAddCardOptionType(itemIdentifier);
        
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
    }];
}

- (void)setLocalDeck:(LocalDeck *)localDeck {
    [self.factory setLocalDeck:localDeck];
}

- (void)bind {
    [NSNotificationCenter.defaultCenter addObserver:self
                                           selector:@selector(shouldUpdateReceived:)
                                               name:NSNotificationNameDeckAddCardOptionsMenuFactoryShouldUpdateItems
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
        [self.deckAddCardOptionsToolbarDelegate deckAddCardOptionsToolbar:self changedOption:newOptions];
        
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
    return allNSToolbarIdentifierDeckAddCardOptionTypes();
}

- (NSArray<NSToolbarItemIdentifier> *)toolbarAllowedItemIdentifiers:(NSToolbar *)toolbar {
    return allNSToolbarIdentifierDeckAddCardOptionTypes();
}

#pragma mark - NSSearchFieldDelegate

- (void)controlTextDidEndEditing:(NSNotification *)notification {
    [self.queue addBarrierBlock:^{
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
            [self.deckAddCardOptionsToolbarDelegate deckAddCardOptionsToolbar:self changedOption:newOptions];
            
            [newOptions release];
        }
    }];
}

@end
