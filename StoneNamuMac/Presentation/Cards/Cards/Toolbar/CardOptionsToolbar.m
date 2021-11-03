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
#import "NSToolbarIdentifierCardOptions+BlizzardHSAPIOptionType.h"

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
@property (retain) DynamicMenuToolbarItem *optionTypeKeyowrdItem;
@property (retain) DynamicMenuToolbarItem *optionTypeGameModeItem;
@property (retain) DynamicMenuToolbarItem *optionTypeSortItem;
@property (retain) NSArray<DynamicMenuToolbarItem *> *optionTypeAllItems;
@property (retain) NSMutableDictionary<NSString *, NSString *> *options;
@end

@implementation CardOptionsToolbar

- (instancetype)initWithOptions:(NSDictionary<NSString *,NSString *> *)options cardOptionsToolbarDelegate:(nonnull id<CardOptionsToolbarDelegate>)cardOptionsToolbarDelegate {
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
    [self insertItemWithItemIdentifier:NSToolbarIdentifierCardOptionsTypeTextFilter atIndex:0];
    
    DynamicMenuToolbarItem *optionTypeSetItem = [[DynamicMenuToolbarItem alloc] initWithItemIdentifier:NSToolbarIdentifierCardOptionsTypeSet];
    self.optionTypeSetItem = optionTypeSetItem;
    [self insertItemWithItemIdentifier:NSToolbarIdentifierCardOptionsTypeSet atIndex:1];
    
    DynamicMenuToolbarItem *optionTypeClassItem = [[DynamicMenuToolbarItem alloc] initWithItemIdentifier:NSToolbarIdentifierCardOptionsTypeClass];
    self.optionTypeClassItem = optionTypeClassItem;
    [self insertItemWithItemIdentifier:NSToolbarIdentifierCardOptionsTypeClass atIndex:2];
    
    DynamicMenuToolbarItem *optionTypeManaCostItem = [[DynamicMenuToolbarItem alloc] initWithItemIdentifier:NSToolbarIdentifierCardOptionsTypeManaCost];
    self.optionTypeManaCostItem = optionTypeManaCostItem;
    [self insertItemWithItemIdentifier:NSToolbarIdentifierCardOptionsTypeManaCost atIndex:3];
    
    DynamicMenuToolbarItem *optionTypeAttackItem = [[DynamicMenuToolbarItem alloc] initWithItemIdentifier:NSToolbarIdentifierCardOptionsTypeAttack];
    self.optionTypeAttackItem = optionTypeAttackItem;
    [self insertItemWithItemIdentifier:NSToolbarIdentifierCardOptionsTypeAttack atIndex:4];
    
    DynamicMenuToolbarItem *optionTypeHealthItem = [[DynamicMenuToolbarItem alloc] initWithItemIdentifier:NSToolbarIdentifierCardOptionsTypeHealth];
    self.optionTypeHealthItem = optionTypeHealthItem;
    [self insertItemWithItemIdentifier:NSToolbarIdentifierCardOptionsTypeHealth atIndex:5];
    
    DynamicMenuToolbarItem *optionTypeCollectibleItem = [[DynamicMenuToolbarItem alloc] initWithItemIdentifier:NSToolbarIdentifierCardOptionsTypeCollecticle];
    self.optionTypeCollectibleItem = optionTypeCollectibleItem;
    [self insertItemWithItemIdentifier:NSToolbarIdentifierCardOptionsTypeCollecticle atIndex:6];
    
    DynamicMenuToolbarItem *optionTypeRarityItem = [[DynamicMenuToolbarItem alloc] initWithItemIdentifier:NSToolbarIdentifierCardOptionsTypeRarity];
    self.optionTypeRarityItem = optionTypeRarityItem;
    [self insertItemWithItemIdentifier:NSToolbarIdentifierCardOptionsTypeRarity atIndex:7];
    
    DynamicMenuToolbarItem *optionTypeTypeItem = [[DynamicMenuToolbarItem alloc] initWithItemIdentifier:NSToolbarIdentifierCardOptionsTypeType];
    self.optionTypeTypeItem = optionTypeTypeItem;
    [self insertItemWithItemIdentifier:NSToolbarIdentifierCardOptionsTypeType atIndex:8];
    
    DynamicMenuToolbarItem *optionTypeMinionTypeItem = [[DynamicMenuToolbarItem alloc] initWithItemIdentifier:NSToolbarIdentifierCardOptionsTypeMinionType];
    self.optionTypeMinionTypeItem = optionTypeMinionTypeItem;
    [self insertItemWithItemIdentifier:NSToolbarIdentifierCardOptionsTypeMinionType atIndex:9];
    
    DynamicMenuToolbarItem *optionTypeKeyowrdItem = [[DynamicMenuToolbarItem alloc] initWithItemIdentifier:NSToolbarIdentifierCardOptionsTypeKeyword];
    self.optionTypeKeyowrdItem = optionTypeKeyowrdItem;
    [self insertItemWithItemIdentifier:NSToolbarIdentifierCardOptionsTypeKeyword atIndex:10];
    
    DynamicMenuToolbarItem *optionTypeGameModeItem = [[DynamicMenuToolbarItem alloc] initWithItemIdentifier:NSToolbarIdentifierCardOptionsTypeGameMode];
    self.optionTypeGameModeItem = optionTypeGameModeItem;
    [self insertItemWithItemIdentifier:NSToolbarIdentifierCardOptionsTypeGameMode atIndex:11];
    
    DynamicMenuToolbarItem *optionTypeSortItem = [[DynamicMenuToolbarItem alloc] initWithItemIdentifier:NSToolbarIdentifierCardOptionsTypeSort];
    self.optionTypeSortItem = optionTypeSortItem;
    [self insertItemWithItemIdentifier:NSToolbarIdentifierCardOptionsTypeSort atIndex:12];
    
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
    [optionTypeKeyowrdItem release];
    [optionTypeGameModeItem release];
    [optionTypeSortItem release];
    
    [self validateVisibleItems];
    
    // TODO: tooltip
}

- (void)updateItemsWithOptions:(NSDictionary<NSString *, NSString *> *)options {
    if ([options isEqualToDictionary:self.options]) return;
    
    NSMutableDictionary<NSString *, NSString *> *mutableOptions = [options mutableCopy];
    self.options = mutableOptions;
    [mutableOptions release];
    
    [self.optionTypeAllItems enumerateObjectsUsingBlock:^(NSMenuToolbarItem * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSToolbarItemIdentifier itemIdentifier = obj.itemIdentifier;
        BlizzardHSAPIOptionType optionType = BlizzardHSAPIOptionTypeFromNSToolbarIdentifierCardOptions(itemIdentifier);
        NSString * _Nullable value = options[optionType];
        BOOL hasValue = ((value != nil) && (![value isEqualToString:@""]));
        
        NSImage * _Nullable image = nil;
        NSString * _Nullable title = nil;
        
        if (hasValue) {
            image = [NSImage imageWithSystemSymbolName:[NSString stringWithFormat:@"%@.fill", PrefferedSystemSymbolFromBlizzardHSAPIDefaultOptions(optionType)] accessibilityDescription:nil];
        } else {
            image = [NSImage imageWithSystemSymbolName:PrefferedSystemSymbolFromBlizzardHSAPIDefaultOptions(optionType) accessibilityDescription:nil];
        }
        
        if ([itemIdentifier isEqualToString:NSToolbarIdentifierCardOptionsTypeTextFilter]) {
            if (hasValue) {
                title = [NSString stringWithFormat:@"%@ : %@", NSLocalizedString(@"CARD_TEXT_FILTER", @""), value];
            } else {
                title = NSLocalizedString(@"CARD_TEXT_FILTER", @"");
            }
        } else if ([itemIdentifier isEqualToString:NSToolbarIdentifierCardOptionsTypeSet]) {
            if (hasValue) {
                title = [NSString stringWithFormat:@"%@ : %@", NSLocalizedString(@"CARD_SET", @""), value];
            } else {
                title = NSLocalizedString(@"CARD_SET", @"");
            }
        } else if ([itemIdentifier isEqualToString:NSToolbarIdentifierCardOptionsTypeClass]) {
            if (hasValue) {
                title = [NSString stringWithFormat:@"%@ : %@", NSLocalizedString(@"CARD_CLASS", @""), value];
            } else {
                title = NSLocalizedString(@"CARD_CLASS", @"");
            }
        } else if ([itemIdentifier isEqualToString:NSToolbarIdentifierCardOptionsTypeManaCost]) {
            if (hasValue) {
                title = [NSString stringWithFormat:@"%@ : %@", NSLocalizedString(@"CARD_MANA_COST", @""), value];
            } else {
                title = NSLocalizedString(@"CARD_MANA_COST", @"");
            }
        } else if ([itemIdentifier isEqualToString:NSToolbarIdentifierCardOptionsTypeAttack]) {
            if (hasValue) {
                title = [NSString stringWithFormat:@"%@ : %@", NSLocalizedString(@"CARD_ATTACK", @""), value];
            } else {
                title = NSLocalizedString(@"CARD_ATTACK", @"");
            }
        } else if ([itemIdentifier isEqualToString:NSToolbarIdentifierCardOptionsTypeHealth]) {
            if (hasValue) {
                title = [NSString stringWithFormat:@"%@ : %@", NSLocalizedString(@"CARD_HEALTH", @""), value];
            } else {
                title = NSLocalizedString(@"CARD_HEALTH", @"");
            }
        } else if ([itemIdentifier isEqualToString:NSToolbarIdentifierCardOptionsTypeCollecticle]) {
            if (hasValue) {
                title = [NSString stringWithFormat:@"%@ : %@", NSLocalizedString(@"CARD_COLLECTIBLE", @""), value];
            } else {
                title = NSLocalizedString(@"CARD_COLLECTIBLE", @"");
            }
        } else if ([itemIdentifier isEqualToString:NSToolbarIdentifierCardOptionsTypeRarity]) {
            if (hasValue) {
                title = [NSString stringWithFormat:@"%@ : %@", NSLocalizedString(@"CARD_RARITY", @""), value];
            } else {
                title = NSLocalizedString(@"CARD_RARITY", @"");
            }
        } else if ([itemIdentifier isEqualToString:NSToolbarIdentifierCardOptionsTypeType]) {
            if (hasValue) {
                title = [NSString stringWithFormat:@"%@ : %@", NSLocalizedString(@"CARD_TYPE", @""), value];
            } else {
                title = NSLocalizedString(@"CARD_TYPE", @"");
            }
        } else if ([itemIdentifier isEqualToString:NSToolbarIdentifierCardOptionsTypeMinionType]) {
            if (hasValue) {
                title = [NSString stringWithFormat:@"%@ : %@", NSLocalizedString(@"CARD_MINION_TYPE", @""), value];
            } else {
                title = NSLocalizedString(@"CARD_MINION_TYPE", @"");
            }
        } else if ([itemIdentifier isEqualToString:NSToolbarIdentifierCardOptionsTypeKeyword]) {
            if (hasValue) {
                title = [NSString stringWithFormat:@"%@ : %@", NSLocalizedString(@"CARD_KEYWORD", @""), value];
            } else {
                title = NSLocalizedString(@"CARD_KEYWORD", @"");
            }
        } else if ([itemIdentifier isEqualToString:NSToolbarIdentifierCardOptionsTypeGameMode]) {
            if (hasValue) {
                title = [NSString stringWithFormat:@"%@ : %@", NSLocalizedString(@"CARD_GAME_MODE", @""), value];
            } else {
                title = NSLocalizedString(@"CARD_GAME_MODE", @"");
            }
        } else if ([itemIdentifier isEqualToString:NSToolbarIdentifierCardOptionsTypeSort]) {
            if (hasValue) {
                title = [NSString stringWithFormat:@"%@ : %@", NSLocalizedString(@"CARD_SORT", @""), value];
            } else {
                title = NSLocalizedString(@"CARD_SORT", @"");
            }
        }
        
        //
        
        if (image != nil) {
            obj.image = image;
        }
        if (title != nil) {
            obj.title = title;
        }
        
        //
        
        NSMenu *menu = [self menuForMenuToolbarItem:obj];
        obj.menu = menu;
    }];
}

- (NSMenu *)menuForMenuToolbarItem:(NSMenuToolbarItem *)menuToolbarItem {
    NSToolbarItemIdentifier itemIdentifier = menuToolbarItem.itemIdentifier;
    BlizzardHSAPIOptionType optionType = BlizzardHSAPIOptionTypeFromNSToolbarIdentifierCardOptions(itemIdentifier);
    NSString * _Nullable selectedKey = self.options[optionType];
    NSMenu *menu = [[NSMenu alloc] initWithTitle:menuToolbarItem.title];
    
    NSArray<NSMenuItem *> *itemArray;
    
    if ([optionType isEqualToString:BlizzardHSAPIOptionTypeSet]) {
        itemArray = [self itemArrayFromDic:hsCardSetsWithLocalizable()
                                optionType:optionType
                             showEmptyItem:YES
                               selectedKey:selectedKey
                               filterArray:nil
                               imageSource:nil
                                 converter:^NSUInteger(NSString * key) {
            return HSCardSetFromNSString(key);
        }
                                 ascending:NO];
    } else if ([optionType isEqualToString:BlizzardHSAPIOptionTypeClass]) {
        itemArray = [self itemArrayFromDic:hsCardClassesWithLocalizable()
                                optionType:optionType
                             showEmptyItem:YES
                               selectedKey:selectedKey
                               filterArray:@[NSStringFromHSCardClass(HSCardClassDeathKnight)]
                               imageSource:nil
                                 converter:^NSUInteger(NSString * key) {
            return HSCardClassFromNSString(key);
        }
                                 ascending:YES];
    } else if ([optionType isEqualToString:BlizzardHSAPIOptionTypeManaCost] || ([optionType isEqualToString:BlizzardHSAPIOptionTypeAttack] || ([optionType isEqualToString:BlizzardHSAPIOptionTypeHealth]))) {
        itemArray = [self itemArrayFromDic:@{@"1": @"1",
                                             @"2": @"2",
                                             @"3": @"3",
                                             @"4": @"4",
                                             @"5": @"5",
                                             @"6": @"6",
                                             @"7": @"7",
                                             @"8": @"8",
                                             @"9": @"9",
                                             @"10": @"10+"}
                                optionType:optionType
                             showEmptyItem:YES
                               selectedKey:selectedKey
                               filterArray:nil
                               imageSource:nil
                                 converter:^NSUInteger(NSString * key) {
            NSNumberFormatter *formatter = [NSNumberFormatter new];
            formatter.numberStyle = NSNumberFormatterDecimalStyle;
            NSUInteger value = [formatter numberFromString:key].unsignedIntegerValue;
            [formatter release];
            return value;
        }
                                 ascending:YES];
    } else if ([optionType isEqualToString:BlizzardHSAPIOptionTypeCollectible]) {
        itemArray = [self itemArrayFromDic:hsCardCollectiblesWithLocalizable()
                                optionType:optionType
                             showEmptyItem:NO
                               selectedKey:selectedKey
                               filterArray:nil
                               imageSource:nil
                                 converter:^NSUInteger(NSString * key) {
            return HSCardCollectibleFromNSString(key);
        }
                                 ascending:YES];
        
    } else if ([optionType isEqualToString:BlizzardHSAPIOptionTypeRarity]) {
        itemArray = [self itemArrayFromDic:hsCardRaritiesWithLocalizable()
                                optionType:optionType
                             showEmptyItem:YES
                               selectedKey:selectedKey
                               filterArray:@[NSStringFromHSCardRarity(HSCardRarityNull)]
                               imageSource:nil
                                 converter:^NSUInteger(NSString * key) {
            return HSCardRarityFromNSString(key);
        }
                                 ascending:YES];
        
    } else if ([optionType isEqualToString:BlizzardHSAPIOptionTypeType]) {
        itemArray = [self itemArrayFromDic:hsCardTypesWithLocalizable()
                                optionType:optionType
                             showEmptyItem:YES
                               selectedKey:selectedKey
                               filterArray:nil
                               imageSource:nil
                                 converter:^NSUInteger(NSString * key) {
            return HSCardTypeFromNSString(key);
        }
                                 ascending:YES];
    } else if ([optionType isEqualToString:BlizzardHSAPIOptionTypeMinionType]) {
        itemArray = [self itemArrayFromDic:hsCardMinionTypesWithLocalizable()
                                optionType:optionType
                             showEmptyItem:YES
                               selectedKey:selectedKey
                               filterArray:nil
                               imageSource:nil
                                 converter:^NSUInteger(NSString * key) {
            return HSCardMinionTypeFromNSString(key);
        }
                                 ascending:YES];
    } else if ([optionType isEqualToString:BlizzardHSAPIOptionTypeKeyword]) {
        itemArray = [self itemArrayFromDic:hsCardKeywordsWithLocalizable()
                                optionType:optionType
                             showEmptyItem:YES
                               selectedKey:selectedKey
                               filterArray:nil
                               imageSource:nil
                                 converter:^NSUInteger(NSString * key) {
            return HSCardKeywordFromNSString(key);
        }
                                 ascending:YES];
    } else if ([optionType isEqualToString:BlizzardHSAPIOptionTypeTextFilter]) {
        itemArray = @[[self textFieldItemWithOptionType:optionType selectedKey:selectedKey]];
    } else if ([optionType isEqualToString:BlizzardHSAPIOptionTypeGameMode]) {
        itemArray = [self itemArrayFromDic:hsCardGameModesWithLocalizable()
                                optionType:optionType
                             showEmptyItem:NO
                               selectedKey:selectedKey
                               filterArray:nil
                               imageSource:nil
                                 converter:^NSUInteger(NSString * key) {
            return HSCardGameModeFromNSString(key);
        }
                                 ascending:YES];
    } else if ([optionType isEqualToString:BlizzardHSAPIOptionTypeSort]) {
        itemArray = [self itemArrayFromDic:hsCardSortsWithLocalizable()
                                optionType:optionType
                             showEmptyItem:NO
                               selectedKey:selectedKey
                               filterArray:nil
                               imageSource:nil
                                 converter:^NSUInteger(NSString * key) {
            return HSCardSortFromNSString(key);
        }
                                 ascending:YES];
    } else {
        itemArray = @[];
    }
    
    menu.itemArray = itemArray;
    
    return [menu autorelease];
}

#pragma mark - Helper

- (NSMenuItem *)textFieldItemWithOptionType:(BlizzardHSAPIOptionType)type
                                selectedKey:(NSString * _Nullable)selectedKey {
    CardOptionsMenuItem *item = [[CardOptionsMenuItem alloc] initWithTitle:@"Test" action:nil keyEquivalent:@"" key:@{type: @""}];
    CardOptionsTextField *textField = [[CardOptionsTextField alloc] initWithKey:@{type: @""}];
    
    if (selectedKey) {
        textField.stringValue = selectedKey;
    } else {
        textField.stringValue = @"";
    }
    textField.frame = CGRectMake(0, 0, 100, 20);
    textField.weakObject = item;
    textField.delegate = self;
    
    item.view = textField;
    
    [textField release];
    return [item autorelease];
}

- (NSArray<NSMenuItem *> *)itemArrayFromDic:(NSDictionary<NSString *, NSString *> *)dic
                                 optionType:(BlizzardHSAPIOptionType)type
                              showEmptyItem:(BOOL)showEmptyItem
                                selectedKey:(NSString * _Nullable)selectedKey
                                filterArray:(NSArray<NSString *> * _Nullable)filterArray
                                imageSource:(NSImage * _Nullable (^)(NSString *))imageSource
                                  converter:(NSUInteger (^)(NSString *))converter
                                  ascending:(BOOL)ascending {
    
    NSMutableArray<NSMenuItem *> *arr = [@[] mutableCopy];
    
    [dic enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull key, NSString * _Nonnull obj, BOOL * _Nonnull stop) {
        if (![filterArray containsObject:key]) {
            CardOptionsMenuItem *item = [[CardOptionsMenuItem alloc] initWithTitle:obj
                                                            action:@selector(keyMenuItemTriggered:)
                                                     keyEquivalent:@""
                                                               key:@{type: key}];
            item.target = self;
            
            if ([key isEqualToString:selectedKey]) {
                item.state = NSControlStateValueOn;
            } else {
                item.state = NSControlStateValueOff;
            }
            
            [arr addObject:item];
            [item release];
        }
    }];
    
    NSComparator comparator = ^NSComparisonResult(CardOptionsMenuItem *lhsItem, CardOptionsMenuItem *rhsItem) {
        NSUInteger lhs = converter(lhsItem.key[type]);
        NSUInteger rhs = converter(rhsItem.key[type]);
        
        if (ascending) {
            if (lhs > rhs) {
                return NSOrderedDescending;
            } else if (lhs < rhs) {
                return NSOrderedAscending;
            } else {
                return NSOrderedSame;
            }
        } else {
            if (lhs > rhs) {
                return NSOrderedAscending;
            } else if (lhs < rhs) {
                return NSOrderedDescending;
            } else {
                return NSOrderedSame;
            }
        }
    };
    
    [arr sortUsingComparator:comparator];
    
    if (showEmptyItem) {
        CardOptionsMenuItem *emptyItem = [[CardOptionsMenuItem alloc] initWithTitle:NSLocalizedString(@"ALL", @"")
                                                             action:@selector(keyMenuItemTriggered:)
                                                      keyEquivalent:@""
                                                                key:@{type: @""}];
        emptyItem.target = self;
        
        if (selectedKey == nil) {
            emptyItem.state = NSControlStateValueOn;
        } else {
            emptyItem.state = NSControlStateValueOff;
        }
        
        [arr insertObject:emptyItem atIndex:0];
        [emptyItem release];
        
        NSMenuItem *separatorItem = [NSMenuItem separatorItem];
        [arr insertObject:separatorItem atIndex:1];
    }
    
    return [arr autorelease];
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
    return AllNSToolbarIdentifierCardOptionsType();
}

- (NSArray<NSToolbarItemIdentifier> *)toolbarAllowedItemIdentifiers:(NSToolbar *)toolbar {
    return AllNSToolbarIdentifierCardOptionsType();
}

#pragma mark - NSTextFieldDelegate

- (void)controlTextDidEndEditing:(NSNotification *)notification {
    CardOptionsTextField *textField = (CardOptionsTextField *)notification.object;
    
    if (![textField isKindOfClass:[CardOptionsTextField class]]) {
        return;
    }
    
    if ([[notification.userInfo objectForKey:@"NSTextMovement"] integerValue] == NSReturnTextMovement) {
        if ([textField.weakObject isKindOfClass:[CardOptionsMenuItem class]]) {
            CardOptionsMenuItem *item = (CardOptionsMenuItem *)textField.weakObject;
            [item.menu cancelTracking];
        }
        
        NSString *key = textField.key.allKeys.firstObject;
        NSString *value = textField.stringValue;
        
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
