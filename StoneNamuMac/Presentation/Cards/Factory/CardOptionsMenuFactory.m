//
//  CardOptionsMenuFactory.m
//  StoneNamuMac
//
//  Created by Jinwoo Kim on 11/9/21.
//

#import "CardOptionsMenuFactory.h"
#import "StorableMenuItem.h"
#import "StorableSearchField.h"
#import <StoneNamuResources/StoneNamuResources.h>

@implementation CardOptionsMenuFactory

+ (SEL)keyMenuItemTriggeredSelector {
    return NSSelectorFromString(@"keyMenuItemTriggered:");
}

+ (BOOL)hasEmptyItemAtOptionType:(BlizzardHSAPIOptionType)optionType {
    if ([optionType isEqualToString:BlizzardHSAPIOptionTypeSet]) {
        return YES;
    } else if ([optionType isEqualToString:BlizzardHSAPIOptionTypeClass]) {
        return YES;
    } else if ([optionType isEqualToString:BlizzardHSAPIOptionTypeManaCost]) {
        return YES;
    } else if ([optionType isEqualToString:BlizzardHSAPIOptionTypeAttack]) {
        return YES;
    } else if ([optionType isEqualToString:BlizzardHSAPIOptionTypeHealth]) {
        return YES;
    } else if ([optionType isEqualToString:BlizzardHSAPIOptionTypeCollectible]) {
        return NO;
    } else if ([optionType isEqualToString:BlizzardHSAPIOptionTypeRarity]) {
        return YES;
    } else if ([optionType isEqualToString:BlizzardHSAPIOptionTypeType]) {
        return YES;
    } else if ([optionType isEqualToString:BlizzardHSAPIOptionTypeMinionType]) {
        return YES;
    } else if ([optionType isEqualToString:BlizzardHSAPIOptionTypeSpellSchool]) {
        return YES;
    } else if ([optionType isEqualToString:BlizzardHSAPIOptionTypeKeyword]) {
        return YES;
    } else if ([optionType isEqualToString:BlizzardHSAPIOptionTypeGameMode]) {
        return NO;
    } else if ([optionType isEqualToString:BlizzardHSAPIOptionTypeSort]) {
        return NO;
    } else {
        return NO;
    }
}

+ (BOOL)supportsMultipleSelectionFromOptionType:(BlizzardHSAPIOptionType)optionType {
    if ([optionType isEqualToString:BlizzardHSAPIOptionTypeSet]) {
        return NO;
    } else if ([optionType isEqualToString:BlizzardHSAPIOptionTypeCollectible]) {
        return NO;
    } else if ([optionType isEqualToString:BlizzardHSAPIOptionTypeGameMode]) {
        return NO;
    } else {
        return YES;
    }
}

+ (NSString * _Nullable)titleForOptionType:(BlizzardHSAPIOptionType)optionType {
    return [ResourcesService localizationForBlizzardHSAPIOptionType:optionType];
}

+ (NSImage *)imageForCardOptionTypeWithValues:(NSSet<NSString *> *)values optionType:(BlizzardHSAPIOptionType)optionType {
    BOOL hasValue;
    
    if (values == nil) {
        hasValue = NO;
    } else {
        hasValue = values.hasValuesWhenStringType;
    }
    return [ResourcesService imageForBlizzardHSAPIOptionType:optionType fill:hasValue];
}

+ (NSMenu *)menuForOptionType:(BlizzardHSAPIOptionType)optionType target:(nonnull id<NSSearchFieldDelegate>)target {
    NSMenu *menu = [NSMenu new];
    
    NSArray<NSMenuItem *> *itemArray;
    
    if ([optionType isEqualToString:BlizzardHSAPIOptionTypeSet]) {
        itemArray = [self itemArrayFromDic:[ResourcesService localizationsForHSCardSet]
                                optionType:optionType
                             showEmptyItem:[self hasEmptyItemAtOptionType:optionType]
                               filterArray:nil
                               imageSource:nil
                                 converter:^NSUInteger(NSString * key) {
            return HSCardSetFromNSString(key);
        }
                                 ascending:NO
                                    target:target];
    } else if ([optionType isEqualToString:BlizzardHSAPIOptionTypeClass]) {
        itemArray = [self itemArrayFromDic:[ResourcesService localizationsForHSCardClass]
                                optionType:optionType
                             showEmptyItem:[self hasEmptyItemAtOptionType:optionType]
                               filterArray:@[NSStringFromHSCardClass(HSCardClassDeathKnight)]
                               imageSource:nil
                                 converter:^NSUInteger(NSString * key) {
            return HSCardClassFromNSString(key);
        }
                                 ascending:YES
                                    target:target];
    } else if ([optionType isEqualToString:BlizzardHSAPIOptionTypeManaCost] || ([optionType isEqualToString:BlizzardHSAPIOptionTypeAttack] || ([optionType isEqualToString:BlizzardHSAPIOptionTypeHealth]))) {
        itemArray = [self itemArrayFromDic:@{@"0": @"0",
                                             @"1": @"1",
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
                             showEmptyItem:[self hasEmptyItemAtOptionType:optionType]
                               filterArray:nil
                               imageSource:nil
                                 converter:^NSUInteger(NSString * key) {
            NSNumberFormatter *formatter = [NSNumberFormatter new];
            formatter.numberStyle = NSNumberFormatterDecimalStyle;
            NSUInteger value = [formatter numberFromString:key].unsignedIntegerValue;
            [formatter release];
            return value;
        }
                                 ascending:YES
                                    target:target];
    } else if ([optionType isEqualToString:BlizzardHSAPIOptionTypeCollectible]) {
        itemArray = [self itemArrayFromDic:[ResourcesService localizationsForHSCardCollectible]
                                optionType:optionType
                             showEmptyItem:[self hasEmptyItemAtOptionType:optionType]
                               filterArray:nil
                               imageSource:nil
                                 converter:^NSUInteger(NSString * key) {
            return HSCardCollectibleFromNSString(key);
        }
                                 ascending:YES
                                    target:target];
        
    } else if ([optionType isEqualToString:BlizzardHSAPIOptionTypeRarity]) {
        itemArray = [self itemArrayFromDic:[ResourcesService localizationsForHSCardRarity]
                                optionType:optionType
                             showEmptyItem:[self hasEmptyItemAtOptionType:optionType]
                               filterArray:@[NSStringFromHSCardRarity(HSCardRarityNull)]
                               imageSource:nil
                                 converter:^NSUInteger(NSString * key) {
            return HSCardRarityFromNSString(key);
        }
                                 ascending:YES
                                    target:target];
        
    } else if ([optionType isEqualToString:BlizzardHSAPIOptionTypeType]) {
        itemArray = [self itemArrayFromDic:[ResourcesService localizationsForHSCardType]
                                optionType:optionType
                             showEmptyItem:[self hasEmptyItemAtOptionType:optionType]
                               filterArray:nil
                               imageSource:nil
                                 converter:^NSUInteger(NSString * key) {
            return HSCardTypeFromNSString(key);
        }
                                 ascending:YES
                                    target:target];
    } else if ([optionType isEqualToString:BlizzardHSAPIOptionTypeMinionType]) {
        itemArray = [self itemArrayFromDic:[ResourcesService localizationsForHSCardMinionType]
                                optionType:optionType
                             showEmptyItem:[self hasEmptyItemAtOptionType:optionType]
                               filterArray:nil
                               imageSource:nil
                                 converter:^NSUInteger(NSString * key) {
            return HSCardMinionTypeFromNSString(key);
        }
                                 ascending:YES
                                    target:target];
    } else if ([optionType isEqualToString:BlizzardHSAPIOptionTypeSpellSchool]) {
        itemArray = [self itemArrayFromDic:[ResourcesService localizationsForHSCardSpellSchool]
                                optionType:optionType
                             showEmptyItem:[self hasEmptyItemAtOptionType:optionType]
                               filterArray:nil
                               imageSource:nil
                                 converter:^NSUInteger(NSString * key) {
            return HSCardSpellSchoolFromNSString(key);
        }
                                 ascending:YES
                                    target:target];
    } else if ([optionType isEqualToString:BlizzardHSAPIOptionTypeKeyword]) {
        itemArray = [self itemArrayFromDic:[ResourcesService localizationsForHSCardKeyword]
                                optionType:optionType
                             showEmptyItem:[self hasEmptyItemAtOptionType:optionType]
                               filterArray:nil
                               imageSource:nil
                                 converter:^NSUInteger(NSString * key) {
            return HSCardKeywordFromNSString(key);
        }
                                 ascending:YES
                                    target:target];
    } else if ([optionType isEqualToString:BlizzardHSAPIOptionTypeTextFilter]) {
        itemArray = @[[self searchFieldItemWithOptionType:optionType searchFieldDelegate:target]];
    } else if ([optionType isEqualToString:BlizzardHSAPIOptionTypeGameMode]) {
        itemArray = [self itemArrayFromDic:[ResourcesService localizationsForHSCardGameMode]
                                optionType:optionType
                             showEmptyItem:[self hasEmptyItemAtOptionType:optionType]
                               filterArray:nil
                               imageSource:nil
                                 converter:^NSUInteger(NSString * key) {
            return HSCardGameModeFromNSString(key);
        }
                                 ascending:YES
                                    target:target];
    } else if ([optionType isEqualToString:BlizzardHSAPIOptionTypeSort]) {
        itemArray = [self itemArrayFromDic:[ResourcesService localizationsForHSCardSort]
                                optionType:optionType
                             showEmptyItem:[self hasEmptyItemAtOptionType:optionType]
                               filterArray:nil
                               imageSource:nil
                                 converter:^NSUInteger(NSString * key) {
            return HSCardSortFromNSString(key);
        }
                                 ascending:YES
                                    target:target];
    } else {
        itemArray = @[];
    }
    
    menu.itemArray = itemArray;
    
    return [menu autorelease];
}

+ (NSArray<NSMenuItem *> *)itemArrayFromDic:(NSDictionary<NSString *, NSString *> *)dic
                                 optionType:(BlizzardHSAPIOptionType)type
                              showEmptyItem:(BOOL)showEmptyItem
                                filterArray:(NSArray<NSString *> * _Nullable)filterArray
                                imageSource:(NSImage * _Nullable (^)(NSString *))imageSource
                                  converter:(NSUInteger (^)(NSString *))converter
                                  ascending:(BOOL)ascending
                                     target:(id)target {
    
    NSMutableArray<NSMenuItem *> *arr = [@[] mutableCopy];
    
    [dic enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull key, NSString * _Nonnull obj, BOOL * _Nonnull stop) {
        if (![filterArray containsObject:key]) {
            StorableMenuItem *item = [[StorableMenuItem alloc] initWithTitle:obj
                                                                      action:CardOptionsMenuFactory.keyMenuItemTriggeredSelector
                                                               keyEquivalent:@""
                                                                    userInfo:@{CardOptionsMenuFactoryStorableMenuItemOptionTypeKey: type,
                                                                               CardOptionsMenuFactoryStorableMenuItemValueKey: key,
                                                                               CardOptionsMenuFactoryStorableMenuItemShowsEmptyItemKey: [NSNumber numberWithBool:showEmptyItem],
                                                                               CardOptionsMenuFactoryStorableMenuItemSuppoertsMultipleSelection: [NSNumber numberWithBool:[self supportsMultipleSelectionFromOptionType:type]]}];
            item.target = target;
            
            [arr addObject:item];
            [item release];
        }
    }];
    
    NSComparator comparator = ^NSComparisonResult(StorableMenuItem *lhsItem, StorableMenuItem *rhsItem) {
        NSUInteger lhs = converter(lhsItem.userInfo[CardOptionsMenuFactoryStorableMenuItemValueKey]);
        NSUInteger rhs = converter(rhsItem.userInfo[CardOptionsMenuFactoryStorableMenuItemValueKey]);
        
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
        StorableMenuItem *emptyItem = [[StorableMenuItem alloc] initWithTitle:[ResourcesService localizationForKey:LocalizableKeyAll]
                                                                       action:CardOptionsMenuFactory.keyMenuItemTriggeredSelector
                                                                keyEquivalent:@""
                                                                     userInfo:@{CardOptionsMenuFactoryStorableMenuItemOptionTypeKey: type,
                                                                                CardOptionsMenuFactoryStorableMenuItemValueKey: @"",
                                                                                CardOptionsMenuFactoryStorableMenuItemShowsEmptyItemKey: [NSNumber numberWithBool:showEmptyItem],
                                                                                CardOptionsMenuFactoryStorableMenuItemSuppoertsMultipleSelection: [NSNumber numberWithBool:[self supportsMultipleSelectionFromOptionType:type]]}];
        emptyItem.target = target;
        
        [arr insertObject:emptyItem atIndex:0];
        [emptyItem release];
        
        NSMenuItem *separatorItem = [NSMenuItem separatorItem];
        [arr insertObject:separatorItem atIndex:1];
    }
    
    return [arr autorelease];
}

+ (NSMenuItem *)searchFieldItemWithOptionType:(BlizzardHSAPIOptionType)optionType
                          searchFieldDelegate:(nonnull id<NSSearchFieldDelegate>)searchFieldDelegate {
    StorableMenuItem *item = [[StorableMenuItem alloc] initWithTitle:@"" action:nil keyEquivalent:@"" userInfo:@{CardOptionsMenuFactoryStorableMenuItemOptionTypeKey: optionType,
                                                                                                                 CardOptionsMenuFactoryStorableMenuItemValueKey: @"",
                                                                                                                 CardOptionsMenuFactoryStorableMenuItemShowsEmptyItemKey: @NO,
                                                                                                                 CardOptionsMenuFactoryStorableMenuItemSuppoertsMultipleSelection: [NSNumber numberWithBool:[self supportsMultipleSelectionFromOptionType:optionType]]}];
    StorableSearchField *searchField = [[StorableSearchField alloc] initWithUserInfo:@{optionType: @""}];
    
    searchField.frame = CGRectMake(0, 0, 300, 20);
    searchField.delegate = searchFieldDelegate;
    
    item.view = searchField;
    
    [searchField release];
    return [item autorelease];
}

@end
