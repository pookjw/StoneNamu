//
//  CardOptionsToolbar.m
//  StoneNamuMac
//
//  Created by Jinwoo Kim on 10/30/21.
//

#import "CardOptionsToolbar.h"
#import <StoneNamuCore/StoneNamuCore.h>
#import "CardOptionsMenuItem.h"
#import "CardOptionsTextField.h"
#import "DynamicMenuToolbarItem.h"

static NSToolbarIdentifier const NSToolbarIdentifierCardOptionsTypeTextFilter = @"NSToolbarIdentifierCardOptionsTextFilter";
static NSToolbarIdentifier const NSToolbarIdentifierCardOptionsTypeSet = @"NSToolbarIdentifierCardOptionsTypeSet";
static NSToolbarIdentifier const NSToolbarIdentifierCardOptionsTypeClass = @"NSToolbarIdentifierCardOptionsTypeClass";
static NSToolbarIdentifier const NSToolbarIdentifierCardOptionsTypeManaCost = @"NSToolbarIdentifierCardOptionsTypeManaCost";
static NSToolbarIdentifier const NSToolbarIdentifierCardOptionsTypeAttack = @"NSToolbarIdentifierCardOptionsTypeAttack";
static NSToolbarIdentifier const NSToolbarIdentifierCardOptionsTypeHealth = @"NSToolbarIdentifierCardOptionsTypeHealth";
static NSToolbarIdentifier const NSToolbarIdentifierCardOptionsTypeCollecticle = @"NSToolbarIdentifierCardOptionsTypeCollecticle";
static NSToolbarIdentifier const NSToolbarIdentifierCardOptionsTypeRarity = @"NSToolbarIdentifierCardOptionsTypeRarity";
static NSToolbarIdentifier const NSToolbarIdentifierCardOptionsTypeType = @"NSToolbarIdentifierCardOptionsTypeType";
static NSToolbarIdentifier const NSToolbarIdentifierCardOptionsTypeMinionType = @"NSToolbarIdentifierCardOptionsTypeMinionType";
static NSToolbarIdentifier const NSToolbarIdentifierCardOptionsTypeKeyword = @"NSToolbarIdentifierCardOptionsTypeKeyword";
static NSToolbarIdentifier const NSToolbarIdentifierCardOptionsTypeGameMode = @"NSToolbarIdentifierCardOptionsTypeGameMode";
static NSToolbarIdentifier const NSToolbarIdentifierCardOptionsTypeSort = @"NSToolbarIdentifierCardOptionsTypeSort";

NSToolbarIdentifier NSToolbarIdentifierFromBlizzardHSAPIOptionType(BlizzardHSAPIOptionType type) {
    if ([type isEqualToString:BlizzardHSAPIOptionTypeSet]) {
        return NSToolbarIdentifierCardOptionsTypeSet;
    } else if ([type isEqualToString:BlizzardHSAPIOptionTypeClass]) {
        return NSToolbarIdentifierCardOptionsTypeClass;
    } else if ([type isEqualToString:BlizzardHSAPIOptionTypeManaCost]) {
        return NSToolbarIdentifierCardOptionsTypeManaCost;
    } else if ([type isEqualToString:BlizzardHSAPIOptionTypeAttack]) {
        return NSToolbarIdentifierCardOptionsTypeAttack;
    } else if ([type isEqualToString:BlizzardHSAPIOptionTypeHealth]) {
        return NSToolbarIdentifierCardOptionsTypeHealth;
    } else if ([type isEqualToString:BlizzardHSAPIOptionTypeCollectible]) {
        return NSToolbarIdentifierCardOptionsTypeCollecticle;
    } else if ([type isEqualToString:BlizzardHSAPIOptionTypeRarity]) {
        return NSToolbarIdentifierCardOptionsTypeRarity;
    } else if ([type isEqualToString:BlizzardHSAPIOptionTypeType]) {
        return NSToolbarIdentifierCardOptionsTypeType;
    } else if ([type isEqualToString:BlizzardHSAPIOptionTypeMinionType]) {
        return NSToolbarIdentifierCardOptionsTypeMinionType;
    } else if ([type isEqualToString:BlizzardHSAPIOptionTypeKeyword]) {
        return NSToolbarIdentifierCardOptionsTypeKeyword;
    } else if ([type isEqualToString:BlizzardHSAPIOptionTypeTextFilter]) {
        return NSToolbarIdentifierCardOptionsTypeTextFilter;
    } else if ([type isEqualToString:BlizzardHSAPIOptionTypeGameMode]) {
        return NSToolbarIdentifierCardOptionsTypeGameMode;
    } else if ([type isEqualToString:BlizzardHSAPIOptionTypeSort]) {
        return NSToolbarIdentifierCardOptionsTypeSort;
    } else {
        return @"";
    }
}

BlizzardHSAPIOptionType BlizzardHSAPIOptionTypeFromNSToolbarIdentifier(NSToolbarIdentifier itemIdentifier) {
    if ([itemIdentifier isEqualToString:NSToolbarIdentifierCardOptionsTypeTextFilter]) {
        return BlizzardHSAPIOptionTypeTextFilter;
    } else if ([itemIdentifier isEqualToString:NSToolbarIdentifierCardOptionsTypeSet]) {
        return BlizzardHSAPIOptionTypeSet;
    } else if ([itemIdentifier isEqualToString:NSToolbarIdentifierCardOptionsTypeClass]) {
        return BlizzardHSAPIOptionTypeClass;
    } else if ([itemIdentifier isEqualToString:NSToolbarIdentifierCardOptionsTypeManaCost]) {
        return BlizzardHSAPIOptionTypeManaCost;
    } else if ([itemIdentifier isEqualToString:NSToolbarIdentifierCardOptionsTypeAttack]) {
        return BlizzardHSAPIOptionTypeAttack;
    } else if ([itemIdentifier isEqualToString:NSToolbarIdentifierCardOptionsTypeHealth]) {
        return BlizzardHSAPIOptionTypeHealth;
    } else if ([itemIdentifier isEqualToString:NSToolbarIdentifierCardOptionsTypeCollecticle]) {
        return BlizzardHSAPIOptionTypeCollectible;
    } else if ([itemIdentifier isEqualToString:NSToolbarIdentifierCardOptionsTypeRarity]) {
        return BlizzardHSAPIOptionTypeRarity;
    } else if ([itemIdentifier isEqualToString:NSToolbarIdentifierCardOptionsTypeType]) {
        return BlizzardHSAPIOptionTypeType;
    } else if ([itemIdentifier isEqualToString:NSToolbarIdentifierCardOptionsTypeMinionType]) {
        return BlizzardHSAPIOptionTypeMinionType;
    } else if ([itemIdentifier isEqualToString:NSToolbarIdentifierCardOptionsTypeKeyword]) {
        return BlizzardHSAPIOptionTypeKeyword;
    } else if ([itemIdentifier isEqualToString:NSToolbarIdentifierCardOptionsTypeGameMode]) {
        return BlizzardHSAPIOptionTypeGameMode;
    } else if ([itemIdentifier isEqualToString:NSToolbarIdentifierCardOptionsTypeSort]) {
        return BlizzardHSAPIOptionTypeSort;
    } else {
        return @"";
    }
}

@interface CardOptionsToolbar () <NSToolbarDelegate, NSTextFieldDelegate>
@property (weak) id<CardOptionsToolbarDelegate> cardOptionsToolbarDelegate;
@property (retain) DynamicMenuToolbarItem *textFilterItem;
@property (retain) DynamicMenuToolbarItem *setItem;
@property (retain) DynamicMenuToolbarItem *classItem;
@property (retain) DynamicMenuToolbarItem *manaCostItem;
@property (retain) DynamicMenuToolbarItem *attackItem;
@property (retain) DynamicMenuToolbarItem *healthItem;
@property (retain) DynamicMenuToolbarItem *collectibleItem;
@property (retain) DynamicMenuToolbarItem *rarityItem;
@property (retain) DynamicMenuToolbarItem *typeItem;
@property (retain) DynamicMenuToolbarItem *minionTypeItem;
@property (retain) DynamicMenuToolbarItem *keyowrdItem;
@property (retain) DynamicMenuToolbarItem *gameModeItem;
@property (retain) DynamicMenuToolbarItem *sortItem;
@property (retain) NSArray<DynamicMenuToolbarItem *> *allItems;
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
    [_textFilterItem release];
    [_setItem release];
    [_classItem release];
    [_manaCostItem release];
    [_attackItem release];
    [_healthItem release];
    [_collectibleItem release];
    [_rarityItem release];
    [_typeItem release];
    [_minionTypeItem release];
    [_keyowrdItem release];
    [_gameModeItem release];
    [_sortItem release];
    [_allItems release];
    [_options release];
    [super dealloc];
}

- (void)setAttributes {
    self.delegate = self;
    self.allowsUserCustomization = YES;
    self.autosavesConfiguration = YES;
}

- (void)configureToolbarItems {
    DynamicMenuToolbarItem *textFilterItem = [[DynamicMenuToolbarItem alloc] initWithItemIdentifier:NSToolbarIdentifierCardOptionsTypeTextFilter];
    self.textFilterItem = textFilterItem;
    [self insertItemWithItemIdentifier:NSToolbarIdentifierCardOptionsTypeTextFilter atIndex:0];
    
    DynamicMenuToolbarItem *setItem = [[DynamicMenuToolbarItem alloc] initWithItemIdentifier:NSToolbarIdentifierCardOptionsTypeSet];
    self.setItem = setItem;
    [self insertItemWithItemIdentifier:NSToolbarIdentifierCardOptionsTypeSet atIndex:1];
    
    DynamicMenuToolbarItem *classItem = [[DynamicMenuToolbarItem alloc] initWithItemIdentifier:NSToolbarIdentifierCardOptionsTypeClass];
    self.classItem = classItem;
    [self insertItemWithItemIdentifier:NSToolbarIdentifierCardOptionsTypeClass atIndex:2];
    
    DynamicMenuToolbarItem *manaCostItem = [[DynamicMenuToolbarItem alloc] initWithItemIdentifier:NSToolbarIdentifierCardOptionsTypeManaCost];
    self.manaCostItem = manaCostItem;
    [self insertItemWithItemIdentifier:NSToolbarIdentifierCardOptionsTypeManaCost atIndex:3];
    
    DynamicMenuToolbarItem *attackItem = [[DynamicMenuToolbarItem alloc] initWithItemIdentifier:NSToolbarIdentifierCardOptionsTypeAttack];
    self.attackItem = attackItem;
    [self insertItemWithItemIdentifier:NSToolbarIdentifierCardOptionsTypeAttack atIndex:4];
    
    DynamicMenuToolbarItem *healthItem = [[DynamicMenuToolbarItem alloc] initWithItemIdentifier:NSToolbarIdentifierCardOptionsTypeHealth];
    self.healthItem = healthItem;
    [self insertItemWithItemIdentifier:NSToolbarIdentifierCardOptionsTypeHealth atIndex:5];
    
    DynamicMenuToolbarItem *collectibleItem = [[DynamicMenuToolbarItem alloc] initWithItemIdentifier:NSToolbarIdentifierCardOptionsTypeCollecticle];
    self.collectibleItem = collectibleItem;
    [self insertItemWithItemIdentifier:NSToolbarIdentifierCardOptionsTypeCollecticle atIndex:6];
    
    DynamicMenuToolbarItem *rarityItem = [[DynamicMenuToolbarItem alloc] initWithItemIdentifier:NSToolbarIdentifierCardOptionsTypeRarity];
    self.rarityItem = rarityItem;
    [self insertItemWithItemIdentifier:NSToolbarIdentifierCardOptionsTypeRarity atIndex:7];
    
    DynamicMenuToolbarItem *typeItem = [[DynamicMenuToolbarItem alloc] initWithItemIdentifier:NSToolbarIdentifierCardOptionsTypeType];
    self.typeItem = typeItem;
    [self insertItemWithItemIdentifier:NSToolbarIdentifierCardOptionsTypeType atIndex:8];
    
    DynamicMenuToolbarItem *minionTypeItem = [[DynamicMenuToolbarItem alloc] initWithItemIdentifier:NSToolbarIdentifierCardOptionsTypeMinionType];
    self.minionTypeItem = minionTypeItem;
    [self insertItemWithItemIdentifier:NSToolbarIdentifierCardOptionsTypeMinionType atIndex:9];
    
    DynamicMenuToolbarItem *keyowrdItem = [[DynamicMenuToolbarItem alloc] initWithItemIdentifier:NSToolbarIdentifierCardOptionsTypeKeyword];
    self.keyowrdItem = keyowrdItem;
    [self insertItemWithItemIdentifier:NSToolbarIdentifierCardOptionsTypeKeyword atIndex:10];
    
    DynamicMenuToolbarItem *gameModeItem = [[DynamicMenuToolbarItem alloc] initWithItemIdentifier:NSToolbarIdentifierCardOptionsTypeGameMode];
    self.gameModeItem = gameModeItem;
    [self insertItemWithItemIdentifier:NSToolbarIdentifierCardOptionsTypeGameMode atIndex:11];
    
    DynamicMenuToolbarItem *sortItem = [[DynamicMenuToolbarItem alloc] initWithItemIdentifier:NSToolbarIdentifierCardOptionsTypeSort];
    self.sortItem = sortItem;
    [self insertItemWithItemIdentifier:NSToolbarIdentifierCardOptionsTypeSort atIndex:12];
    
    //
    
    self.allItems = @[
        textFilterItem,
        setItem,
        classItem,
        manaCostItem,
        attackItem,
        healthItem,
        collectibleItem,
        rarityItem,
        typeItem,
        minionTypeItem,
        keyowrdItem,
        gameModeItem,
        sortItem
    ];
    
    [textFilterItem release];
    [setItem release];
    [classItem release];
    [manaCostItem release];
    [attackItem release];
    [healthItem release];
    [collectibleItem release];
    [rarityItem release];
    [typeItem release];
    [minionTypeItem release];
    [keyowrdItem release];
    [gameModeItem release];
    [sortItem release];
    
    [self validateVisibleItems];
    
    // TODO: tooltip
}

- (void)updateItemsWithOptions:(NSDictionary<NSString *, NSString *> *)options {
    [self.allItems enumerateObjectsUsingBlock:^(NSMenuToolbarItem * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSToolbarItemIdentifier itemIdentifier = obj.itemIdentifier;
        BlizzardHSAPIOptionType optionType = BlizzardHSAPIOptionTypeFromNSToolbarIdentifier(itemIdentifier);
        NSString * _Nullable value = options[optionType];
        BOOL hasValue = ((value != nil) && (![value isEqualToString:@""]));
        
        if ([itemIdentifier isEqualToString:NSToolbarIdentifierCardOptionsTypeTextFilter]) {
            if (hasValue) {
                obj.image = [NSImage imageWithSystemSymbolName:@"a.circle.fill" accessibilityDescription:nil];
                obj.title = [NSString stringWithFormat:@"%@ : %@", NSLocalizedString(@"CARD_TEXT_FILTER", @""), value];
            } else {
                obj.image = [NSImage imageWithSystemSymbolName:@"a.circle" accessibilityDescription:nil];
                obj.title = NSLocalizedString(@"CARD_TEXT_FILTER", @"");
            }
        } else if ([itemIdentifier isEqualToString:NSToolbarIdentifierCardOptionsTypeSet]) {
            if (hasValue) {
                obj.image = [NSImage imageWithSystemSymbolName:@"book.circle.fill" accessibilityDescription:nil];
                obj.title = [NSString stringWithFormat:@"%@ : %@", NSLocalizedString(@"CARD_SET", @""), value];
            } else {
                obj.image = [NSImage imageWithSystemSymbolName:@"book.circle" accessibilityDescription:nil];
                obj.title = NSLocalizedString(@"CARD_SET", @"");
            }
        } else if ([itemIdentifier isEqualToString:NSToolbarIdentifierCardOptionsTypeClass]) {
            if (hasValue) {
                obj.image = [NSImage imageWithSystemSymbolName:@"person.circle.fill" accessibilityDescription:nil];
                obj.title = [NSString stringWithFormat:@"%@ : %@", NSLocalizedString(@"CARD_CLASS", @""), value];
            } else {
                obj.image = [NSImage imageWithSystemSymbolName:@"person.circle" accessibilityDescription:nil];
                obj.title = NSLocalizedString(@"CARD_CLASS", @"");
            }
        } else if ([itemIdentifier isEqualToString:NSToolbarIdentifierCardOptionsTypeManaCost]) {
            if (hasValue) {
                obj.image = [NSImage imageWithSystemSymbolName:@"dollarsign.circle.fill" accessibilityDescription:nil];
                obj.title = [NSString stringWithFormat:@"%@ : %@", NSLocalizedString(@"CARD_MANA_COST", @""), value];
            } else {
                obj.image = [NSImage imageWithSystemSymbolName:@"dollarsign.circle" accessibilityDescription:nil];
                obj.title = NSLocalizedString(@"CARD_MANA_COST", @"");
            }
        } else if ([itemIdentifier isEqualToString:NSToolbarIdentifierCardOptionsTypeAttack]) {
            if (hasValue) {
                obj.image = [NSImage imageWithSystemSymbolName:@"staroflife.circle.fill" accessibilityDescription:nil];
                obj.title = [NSString stringWithFormat:@"%@ : %@", NSLocalizedString(@"CARD_ATTACK", @""), value];
            } else {
                obj.image = [NSImage imageWithSystemSymbolName:@"staroflife.circle" accessibilityDescription:nil];
                obj.title = NSLocalizedString(@"CARD_ATTACK", @"");
            }
        } else if ([itemIdentifier isEqualToString:NSToolbarIdentifierCardOptionsTypeHealth]) {
            if (hasValue) {
                obj.image = [NSImage imageWithSystemSymbolName:@"heart.circle.fill" accessibilityDescription:nil];
                obj.title = [NSString stringWithFormat:@"%@ : %@", NSLocalizedString(@"CARD_HEALTH", @""), value];
            } else {
                obj.image = [NSImage imageWithSystemSymbolName:@"heart.circle" accessibilityDescription:nil];
                obj.title = NSLocalizedString(@"CARD_HEALTH", @"");
            }
        } else if ([itemIdentifier isEqualToString:NSToolbarIdentifierCardOptionsTypeCollecticle]) {
            if (hasValue) {
                obj.image = [NSImage imageWithSystemSymbolName:@"tray.circle.fill" accessibilityDescription:nil];
                obj.title = [NSString stringWithFormat:@"%@ : %@", NSLocalizedString(@"CARD_COLLECTIBLE", @""), value];
            } else {
                obj.image = [NSImage imageWithSystemSymbolName:@"tray.circle" accessibilityDescription:nil];
                obj.title = NSLocalizedString(@"CARD_COLLECTIBLE", @"");
            }
        } else if ([itemIdentifier isEqualToString:NSToolbarIdentifierCardOptionsTypeRarity]) {
            if (hasValue) {
                obj.image = [NSImage imageWithSystemSymbolName:@"star.circle.fill" accessibilityDescription:nil];
                obj.title = [NSString stringWithFormat:@"%@ : %@", NSLocalizedString(@"CARD_RARITY", @""), value];
            } else {
                obj.image = [NSImage imageWithSystemSymbolName:@"star.circle" accessibilityDescription:nil];
                obj.title = NSLocalizedString(@"CARD_RARITY", @"");
            }
        } else if ([itemIdentifier isEqualToString:NSToolbarIdentifierCardOptionsTypeType]) {
            if (hasValue) {
                obj.image = [NSImage imageWithSystemSymbolName:@"list.bullet.circle.fill" accessibilityDescription:nil];
                obj.title = [NSString stringWithFormat:@"%@ : %@", NSLocalizedString(@"CARD_TYPE", @""), value];
            } else {
                obj.image = [NSImage imageWithSystemSymbolName:@"list.bullet.circle" accessibilityDescription:nil];
                obj.title = NSLocalizedString(@"CARD_TYPE", @"");
            }
        } else if ([itemIdentifier isEqualToString:NSToolbarIdentifierCardOptionsTypeMinionType]) {
            if (hasValue) {
                obj.image = [NSImage imageWithSystemSymbolName:@"list.bullet.circle.fill" accessibilityDescription:nil];
                obj.title = [NSString stringWithFormat:@"%@ : %@", NSLocalizedString(@"CARD_MINION_TYPE", @""), value];
            } else {
                obj.image = [NSImage imageWithSystemSymbolName:@"list.bullet.circle" accessibilityDescription:nil];
                obj.title = NSLocalizedString(@"CARD_MINION_TYPE", @"");
            }
        } else if ([itemIdentifier isEqualToString:NSToolbarIdentifierCardOptionsTypeKeyword]) {
            if (hasValue) {
                obj.image = [NSImage imageWithSystemSymbolName:@"list.bullet.circle.fill" accessibilityDescription:nil];
                obj.title = [NSString stringWithFormat:@"%@ : %@", NSLocalizedString(@"CARD_KEYWORD", @""), value];
            } else {
                obj.image = [NSImage imageWithSystemSymbolName:@"list.bullet.circle" accessibilityDescription:nil];
                obj.title = NSLocalizedString(@"CARD_KEYWORD", @"");
            }
        } else if ([itemIdentifier isEqualToString:NSToolbarIdentifierCardOptionsTypeGameMode]) {
            if (hasValue) {
                obj.image = [NSImage imageWithSystemSymbolName:@"flag.circle.fill" accessibilityDescription:nil];
                obj.title = [NSString stringWithFormat:@"%@ : %@", NSLocalizedString(@"CARD_GAME_MODE", @""), value];
            } else {
                obj.image = [NSImage imageWithSystemSymbolName:@"flag.circle" accessibilityDescription:nil];
                obj.title = NSLocalizedString(@"CARD_GAME_MODE", @"");
            }
        } else if ([itemIdentifier isEqualToString:NSToolbarIdentifierCardOptionsTypeSort]) {
            if (hasValue) {
                obj.image = [NSImage imageWithSystemSymbolName:@"arrow.up.arrow.down.circle.fill" accessibilityDescription:nil];
                obj.title = [NSString stringWithFormat:@"%@ : %@", NSLocalizedString(@"CARD_SORT", @""), value];
            } else {
                obj.image = [NSImage imageWithSystemSymbolName:@"arrow.up.arrow.down.circle" accessibilityDescription:nil];
                obj.title = NSLocalizedString(@"CARD_SORT", @"");
            }
        }
        
        //
        
        NSMenu *menu = [self menuForMenuToolbarItem:obj];
        obj.menu = menu;
    }];
}

- (NSMenu *)menuForMenuToolbarItem:(NSMenuToolbarItem *)menuToolbarItem {
    NSToolbarItemIdentifier itemIdentifier = menuToolbarItem.itemIdentifier;
    BlizzardHSAPIOptionType optionType = BlizzardHSAPIOptionTypeFromNSToolbarIdentifier(itemIdentifier);
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
    
    [self.allItems enumerateObjectsUsingBlock:^(NSMenuToolbarItem * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([itemIdentifier isEqualToString:obj.itemIdentifier]) {
            resultItem = obj;
            *stop = YES;
        }
    }];
    
    return resultItem;
}

- (NSArray<NSToolbarItemIdentifier> *)toolbarDefaultItemIdentifiers:(NSToolbar *)toolbar {
    NSMutableArray<NSToolbarItemIdentifier> *itemIdentifiers = [@[] mutableCopy];
    
    [self.allItems enumerateObjectsUsingBlock:^(NSMenuToolbarItem * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [itemIdentifiers addObject:obj.itemIdentifier];
    }];
    
    return [itemIdentifiers autorelease];
}

- (NSArray<NSToolbarItemIdentifier> *)toolbarAllowedItemIdentifiers:(NSToolbar *)toolbar {
    NSMutableArray<NSToolbarItemIdentifier> *itemIdentifiers = [@[] mutableCopy];
    
    [self.allItems enumerateObjectsUsingBlock:^(NSMenuToolbarItem * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [itemIdentifiers addObject:obj.itemIdentifier];
    }];
    
    return [itemIdentifiers autorelease];
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
