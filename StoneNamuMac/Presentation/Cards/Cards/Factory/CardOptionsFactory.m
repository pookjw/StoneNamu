//
//  CardOptionsFactory.m
//  StoneNamuMac
//
//  Created by Jinwoo Kim on 11/9/21.
//

#import "CardOptionsFactory.h"
#import "CardOptionsMenuItem.h"
#import "CardOptionsTextField.h"
#import <StoneNamuResources/StoneNamuResources.h>

@implementation CardOptionsFactory

+ (SEL)keyMenuItemTriggeredSelector {
    return NSSelectorFromString(@"keyMenuItemTriggered:");
}

+ (BOOL)hasValueForValue:(NSString *)value {
    return ((value != nil) && (![value isEqualToString:@""]));
}

+ (NSString *)titleForCardOptionsWithValue:(NSString *)value optionType:(BlizzardHSAPIOptionType)optionType {
    
    BOOL hasValue = [self hasValueForValue:value];
    
    if ([optionType isEqualToString:BlizzardHSAPIOptionTypeTextFilter]) {
        if (hasValue) {
            return [NSString stringWithFormat:@"%@ : %@", [ResourcesService localizationForKey:LocalizableKeyCardTextFilter], value];
        } else {
            return [ResourcesService localizationForKey:LocalizableKeyCardTextFilter];
        }
    } else if ([optionType isEqualToString:BlizzardHSAPIOptionTypeSet]) {
        if (hasValue) {
            return [NSString stringWithFormat:@"%@ : %@", [ResourcesService localizationForKey:LocalizableKeyCardSet], [ResourcesService localizationForHSCardSet:HSCardSetFromNSString(value)]];
        } else {
            return [ResourcesService localizationForKey:LocalizableKeyCardSet];
        }
    } else if ([optionType isEqualToString:BlizzardHSAPIOptionTypeClass]) {
        if (hasValue) {
            return [NSString stringWithFormat:@"%@ : %@", [ResourcesService localizationForKey:LocalizableKeyCardClass], [ResourcesService localizationForHSCardClass:HSCardClassFromNSString(value)]];
        } else {
            return [ResourcesService localizationForKey:LocalizableKeyCardClass];
        }
    } else if ([optionType isEqualToString:BlizzardHSAPIOptionTypeManaCost]) {
        if (hasValue) {
            return [NSString stringWithFormat:@"%@ : %@", [ResourcesService localizationForKey:LocalizableKeyCardManaCost], value];
        } else {
            return [ResourcesService localizationForKey:LocalizableKeyCardManaCost];
        }
    } else if ([optionType isEqualToString:BlizzardHSAPIOptionTypeSpellSchool]) {
        if (hasValue) {
            return [NSString stringWithFormat:@"%@ : %@", [ResourcesService localizationForKey:LocalizableKeyCardSpellSchool], [ResourcesService localizationForHSCardSpellSchool:HSCardSpellSchoolFromNSString(value)]];
        } else {
            return [ResourcesService localizationForKey:LocalizableKeyCardSpellSchool];
        }
    } else if ([optionType isEqualToString:BlizzardHSAPIOptionTypeAttack]) {
        if (hasValue) {
            return [NSString stringWithFormat:@"%@ : %@", [ResourcesService localizationForKey:LocalizableKeyCardAttack], value];
        } else {
            return [ResourcesService localizationForKey:LocalizableKeyCardAttack];
        }
    } else if ([optionType isEqualToString:BlizzardHSAPIOptionTypeHealth]) {
        if (hasValue) {
            return [NSString stringWithFormat:@"%@ : %@", [ResourcesService localizationForKey:LocalizableKeyCardHealth], value];
        } else {
            return [ResourcesService localizationForKey:LocalizableKeyCardHealth];
        }
    } else if ([optionType isEqualToString:BlizzardHSAPIOptionTypeCollectible]) {
        if (hasValue) {
            return [NSString stringWithFormat:@"%@ : %@", [ResourcesService localizationForKey:LocalizableKeyCardCollectible], [ResourcesService localizationForHSCardCollectible:HSCardCollectibleFromNSString(value)]];
        } else {
            return [ResourcesService localizationForKey:LocalizableKeyCardCollectible];
        }
    } else if ([optionType isEqualToString:BlizzardHSAPIOptionTypeRarity]) {
        if (hasValue) {
            return [NSString stringWithFormat:@"%@ : %@", [ResourcesService localizationForKey:LocalizableKeyCardRarity], [ResourcesService localizationForHSCardRarity:HSCardRarityFromNSString(value)]];
        } else {
            return [ResourcesService localizationForKey:LocalizableKeyCardRarity];
        }
    } else if ([optionType isEqualToString:BlizzardHSAPIOptionTypeType]) {
        if (hasValue) {
            return [NSString stringWithFormat:@"%@ : %@", [ResourcesService localizationForKey:LocalizableKeyCardType], [ResourcesService localizationForHSCardType:HSCardTypeFromNSString(value)]];
        } else {
            return [ResourcesService localizationForKey:LocalizableKeyCardType];
        }
    } else if ([optionType isEqualToString:BlizzardHSAPIOptionTypeMinionType]) {
        if (hasValue) {
            return [NSString stringWithFormat:@"%@ : %@", [ResourcesService localizationForKey:LocalizableKeyCardMinionType], [ResourcesService localizationForHSCardMinionType:HSCardMinionTypeFromNSString(value)]];
        } else {
            return [ResourcesService localizationForKey:LocalizableKeyCardMinionType];
        }
    } else if ([optionType isEqualToString:BlizzardHSAPIOptionTypeKeyword]) {
        if (hasValue) {
            return [NSString stringWithFormat:@"%@ : %@", [ResourcesService localizationForKey:LocalizableKeyCardKeyword], [ResourcesService localizationForHSCardKeyword:HSCardKeywordFromNSString(value)]];
        } else {
            return [ResourcesService localizationForKey:LocalizableKeyCardKeyword];
        }
    } else if ([optionType isEqualToString:BlizzardHSAPIOptionTypeGameMode]) {
        if (hasValue) {
            return [NSString stringWithFormat:@"%@ : %@", [ResourcesService localizationForKey:LocalizableKeyCardGameMode], [ResourcesService localizationForHSCardGameMode:HSCardGameModeFromNSString(value)]];
        } else {
            return [ResourcesService localizationForKey:LocalizableKeyCardGameMode];
        }
    } else if ([optionType isEqualToString:BlizzardHSAPIOptionTypeSort]) {
        if (hasValue) {
            return [NSString stringWithFormat:@"%@ : %@", [ResourcesService localizationForKey:LocalizableKeyCardSort], [ResourcesService localizationForHSCardSort:HSCardSortFromNSString(value)]];
        } else {
            return [ResourcesService localizationForKey:LocalizableKeyCardSort];
        }
    } else {
        return @"";
    }
}

+ (NSImage *)imageForCardOptionsWithValue:(NSString *)value optionType:(BlizzardHSAPIOptionType)optionType {
    BOOL hasValue = [self hasValueForValue:value];
    return [ResourcesService imageForBlizzardHSAPIOptionType:optionType fill:hasValue];
}

+ (NSMenu *)menuForOptionType:(BlizzardHSAPIOptionType)optionType target:(nonnull id<NSTextFieldDelegate>)target {
    NSMenu *menu = [NSMenu new];
    
    NSArray<NSMenuItem *> *itemArray;
    
    if ([optionType isEqualToString:BlizzardHSAPIOptionTypeSet]) {
        itemArray = [self itemArrayFromDic:[ResourcesService localizationsForHSCardSet]
                                optionType:optionType
                             showEmptyItem:YES
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
                             showEmptyItem:YES
                               filterArray:@[NSStringFromHSCardClass(HSCardClassDeathKnight)]
                               imageSource:nil
                                 converter:^NSUInteger(NSString * key) {
            return HSCardClassFromNSString(key);
        }
                                 ascending:YES
                                    target:target];
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
                             showEmptyItem:NO
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
                             showEmptyItem:YES
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
                             showEmptyItem:YES
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
                             showEmptyItem:YES
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
                             showEmptyItem:YES
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
                             showEmptyItem:YES
                               filterArray:nil
                               imageSource:nil
                                 converter:^NSUInteger(NSString * key) {
            return HSCardKeywordFromNSString(key);
        }
                                 ascending:YES
                                    target:target];
    } else if ([optionType isEqualToString:BlizzardHSAPIOptionTypeTextFilter]) {
        itemArray = @[[self textFieldItemWithOptionType:optionType textFieldDelegate:target]];
    } else if ([optionType isEqualToString:BlizzardHSAPIOptionTypeGameMode]) {
        itemArray = [self itemArrayFromDic:[ResourcesService localizationsForHSCardGameMode]
                                optionType:optionType
                             showEmptyItem:NO
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
                             showEmptyItem:NO
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
            CardOptionsMenuItem *item = [[CardOptionsMenuItem alloc] initWithTitle:obj
                                                                            action:CardOptionsFactory.keyMenuItemTriggeredSelector
                                                                     keyEquivalent:@""
                                                                               key:@{type: key}];
            item.target = target;
            
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
        CardOptionsMenuItem *emptyItem = [[CardOptionsMenuItem alloc] initWithTitle:[ResourcesService localizationForKey:LocalizableKeyAll]
                                                                             action:CardOptionsFactory.keyMenuItemTriggeredSelector
                                                                      keyEquivalent:@""
                                                                                key:@{type: @""}];
        emptyItem.target = target;
        
        [arr insertObject:emptyItem atIndex:0];
        [emptyItem release];
        
        NSMenuItem *separatorItem = [NSMenuItem separatorItem];
        [arr insertObject:separatorItem atIndex:1];
    }
    
    return [arr autorelease];
}

+ (NSMenuItem *)textFieldItemWithOptionType:(BlizzardHSAPIOptionType)type
                          textFieldDelegate:(nonnull id<NSTextFieldDelegate>)textFieldDelegate {
    CardOptionsMenuItem *item = [[CardOptionsMenuItem alloc] initWithTitle:@"" action:nil keyEquivalent:@"" key:@{type: @""}];
    CardOptionsTextField *textField = [[CardOptionsTextField alloc] initWithKey:@{type: @""}];
    
    textField.frame = CGRectMake(0, 0, 100, 20);
    textField.delegate = textFieldDelegate;
    
    item.view = textField;
    
    [textField release];
    return [item autorelease];
}

@end
