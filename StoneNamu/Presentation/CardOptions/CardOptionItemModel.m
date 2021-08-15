//
//  CardOptionItemModel.m
//  StoneNamu
//
//  Created by Jinwoo Kim on 7/24/21.
//

#import "CardOptionItemModel.h"
#import "BlizzardHSAPIKeys.h"
#import "HSCard.h"

NSString * NSStringFromCardOptionItemModelType(CardOptionItemModelType type) {
    switch (type) {
        case CardOptionItemModelTypeSet:
            return BlizzardHSAPIOptionTypeSet;
        case CardOptionItemModelTypeClass:
            return BlizzardHSAPIOptionTypeClass;
        case CardOptionItemModelTypeManaCost:
            return BlizzardHSAPIOptionTypeManaCost;
        case CardOptionItemModelTypeAttack:
            return BlizzardHSAPIOptionTypeAttack;
        case CardOptionItemModelTypeHealth:
            return BlizzardHSAPIOptionTypeHealth;
        case CardOptionItemModelTypeCollectible:
            return BlizzardHSAPIOptionTypeCollectible;
        case CardOptionItemModelTypeRarity:
            return BlizzardHSAPIOptionTypeRarity;
        case CardOptionItemModelTypeType:
            return BlizzardHSAPIOptionTypeType;
        case CardOptionItemModelTypeMinionType:
            return BlizzardHSAPIOptionTypeMinionType;
        case CardOptionItemModelTypeKeyword:
            return BlizzardHSAPIOptionTypeKeyword;
        case CardOptionItemModelTypeTextFilter:
            return BlizzardHSAPIOptionTypeTextFilter;
        case CardOptionItemModelTypeGameMode:
            return BlizzardHSAPIOptionTypeGameMode;
        case CardOptionItemModelTypeSort:
            return BlizzardHSAPIOptionTypeSort;
        default:
            return @"";
    }
}

@implementation CardOptionItemModel

- (instancetype)init {
    self = [super init];
    
    if (self) {
        _value = nil;
    }
    
    return self;
}

- (instancetype)initWithType:(CardOptionItemModelType)type {
    self = [self init];
    
    if (self) {
        _type = type;
        [self setDefaultValue];
    }
    
    return self;
}

- (void)dealloc {
    [_value release];
    [super dealloc];
}

- (BOOL)isEqual:(id)object {
    if (![object isKindOfClass:[CardOptionItemModel class]]) {
        return NO;
    }
    
    CardOptionItemModel *toCompare = (CardOptionItemModel *)object;
    
    return (self.type == toCompare.type) && ([self.value isEqualToString:toCompare.value]);
}

- (CardOptionItemModelValueSetType)valueSetType {
    switch (self.type) {
        case CardOptionItemModelTypeSet:
            return CardOptionItemModelValueSetTypePickerWithEmptyRow;
        case CardOptionItemModelTypeClass:
            return CardOptionItemModelValueSetTypePickerWithEmptyRow;
        case CardOptionItemModelTypeManaCost:
            return CardOptionItemModelValueSetTypeStepper;
        case CardOptionItemModelTypeAttack:
            return CardOptionItemModelValueSetTypeStepper;
        case CardOptionItemModelTypeHealth:
            return CardOptionItemModelValueSetTypeStepper;
        case CardOptionItemModelTypeCollectible:
            return CardOptionItemModelValueSetTypePicker;
        case CardOptionItemModelTypeRarity:
            return CardOptionItemModelValueSetTypePickerWithEmptyRow;
        case CardOptionItemModelTypeType:
            return CardOptionItemModelValueSetTypePickerWithEmptyRow;
        case CardOptionItemModelTypeMinionType:
            return CardOptionItemModelValueSetTypePickerWithEmptyRow;
        case CardOptionItemModelTypeKeyword:
            return CardOptionItemModelValueSetTypePickerWithEmptyRow;
        case CardOptionItemModelTypeTextFilter:
            return CardOptionItemModelValueSetTypeTextField;
        case CardOptionItemModelTypeGameMode:
            return CardOptionItemModelValueSetTypePicker;
        case CardOptionItemModelTypeSort:
            return CardOptionItemModelValueSetTypePicker;
        default:
            return CardOptionItemModelValueSetTypeTextField;
    }
}

- (NSArray<PickerItemModel *> * _Nullable)pickerDataSource {
    switch (self.type) {
        case CardOptionItemModelTypeSet:
            return [self pickerItemModelsFromDic:hsCardSetsWithLocalizable()
                                     filterArray:nil
                                       converter:^NSUInteger(NSString * key) {
                return HSCardSetFromNSString(key);
            }
                                       ascending:NO];
        case CardOptionItemModelTypeClass: {
            return [self pickerItemModelsFromDic:hsCardClassesWithLocalizable()
                                     filterArray:@[NSStringFromHSCardClass(HSCardClassDeathKnight)]
                                       converter:^NSUInteger(NSString * key) {
                return HSCardClassFromNSString(key);
            }
                                       ascending:YES];
        }
        case CardOptionItemModelTypeCollectible: {
            return [self pickerItemModelsFromDic:hsCardCollectiblesWithLocalizable()
                                     filterArray:nil
                                       converter:^NSUInteger(NSString * key) {
                return HSCardCollectibleFromNSString(key);
            }
                                       ascending:YES];
        }
        case CardOptionItemModelTypeRarity: {
            return [self pickerItemModelsFromDic:hsCardRaritiesWithLocalizable()
                                     filterArray:@[NSStringFromHSCardRarity(HSCardRarityNull)]
                                       converter:^NSUInteger(NSString * key) {
                return HSCardRarityFromNSString(key);
            }
                                       ascending:YES];
        }
        case CardOptionItemModelTypeType:
            return [self pickerItemModelsFromDic:hsCardTypesWithLocalizable()
                                     filterArray:@[NSStringFromHSCardType(HSCardTypeHeroPower)]
                                       converter:^NSUInteger(NSString * key) {
                return HSCardTypeFromNSString(key);
            }
                                       ascending:YES];
        case CardOptionItemModelTypeMinionType:
            return [self pickerItemModelsFromDic:hsCardMinionTypesWithLocalizable()
                                     filterArray:nil
                                       converter:^NSUInteger(NSString * key) {
                return HSCardMinionTypeFromNSString(key);
            }
                                       ascending:YES];
        case CardOptionItemModelTypeKeyword:
            return [self pickerItemModelsFromDic:hsCardKeywordsWithLocalizable()
                                     filterArray:nil
                                       converter:^NSUInteger(NSString * key) {
                return HSCardKeywordFromNSString(key);
            }
                                       ascending:YES];
        case CardOptionItemModelTypeGameMode:
            return [self pickerItemModelsFromDic:hsCardGameModesWithLocalizable()
                                     filterArray:nil
                                       converter:^NSUInteger(NSString * key) {
                return HSCardGameModeFromNSString(key);
            }
                                       ascending:YES];
        case CardOptionItemModelTypeSort:
            return [self pickerItemModelsFromDic:hsCardSortsWithLocalizable()
                                     filterArray:nil
                                       converter:^NSUInteger(NSString * key) {
                return HSCardSortFromNSString(key);
            }
                                       ascending:YES];
        default:
            return nil;
    }
}

- (NSRange)stepperRange {
    switch (self.type) {
        case CardOptionItemModelTypeManaCost:
            return NSMakeRange(0, 50);
        case CardOptionItemModelTypeAttack:
            return NSMakeRange(0, 50);
        case CardOptionItemModelTypeHealth:
            return NSMakeRange(0, 50);
        default:
            return NSMakeRange(0, 0);
    }
}

- (NSString *)text {
    switch (self.type) {
        case CardOptionItemModelTypeSet:
            return NSLocalizedString(@"CARD_SET", @"");
        case CardOptionItemModelTypeClass:
            return NSLocalizedString(@"CARD_CLASS", @"");
        case CardOptionItemModelTypeManaCost:
            return NSLocalizedString(@"CARD_MANA_COST", @"");
        case CardOptionItemModelTypeAttack:
            return NSLocalizedString(@"CARD_ATTACK", @"");
        case CardOptionItemModelTypeHealth:
            return NSLocalizedString(@"CARD_HEALTH", @"");
        case CardOptionItemModelTypeCollectible:
            return NSLocalizedString(@"CARD_COLLECTIBLE", @"");
        case CardOptionItemModelTypeRarity:
            return NSLocalizedString(@"CARD_RARITY", @"");
        case CardOptionItemModelTypeType:
            return NSLocalizedString(@"CARD_TYPE", @"");
        case CardOptionItemModelTypeMinionType:
            return NSLocalizedString(@"CARD_MINION_TYPE", @"");
        case CardOptionItemModelTypeKeyword:
            return NSLocalizedString(@"CARD_KEYWORD", @"");
        case CardOptionItemModelTypeTextFilter:
            return NSLocalizedString(@"CARD_TEXT_FILTER", @"");
        case CardOptionItemModelTypeGameMode:
            return NSLocalizedString(@"CARD_GAME_MODE", @"");
        case CardOptionItemModelTypeSort:
            return NSLocalizedString(@"CARD_SORT", @"");
        default:
            return @"";
    }
}

- (NSString * _Nullable)accessoryText {
    switch (self.type) {
        case CardOptionItemModelTypeSet:
            return hsCardSetsWithLocalizable()[self.value];
        case CardOptionItemModelTypeClass:
            return hsCardClassesWithLocalizable()[self.value];
        case CardOptionItemModelTypeCollectible:
            return hsCardCollectiblesWithLocalizable()[self.value];
        case CardOptionItemModelTypeRarity:
            return hsCardRaritiesWithLocalizable()[self.value];
        case CardOptionItemModelTypeType:
            return hsCardTypesWithLocalizable()[self.value];
        case CardOptionItemModelTypeMinionType:
            return hsCardMinionTypesWithLocalizable()[self.value];
        case CardOptionItemModelTypeKeyword:
            return hsCardKeywordsWithLocalizable()[self.value];
        case CardOptionItemModelTypeGameMode:
            return hsCardGameModesWithLocalizable()[self.value];
        case CardOptionItemModelTypeSort:
            return hsCardSortsWithLocalizable()[self.value];
        default:
            return self.value;
    }
}

- (void)setDefaultValue {
    switch (self.type) {
        case CardOptionItemModelTypeCollectible:
            self.value = NSStringFromHSCardCollectible(HSCardCollectibleYES);
            break;
        case CardOptionItemModelTypeGameMode:
            self.value = NSStringFromHSCardGameMode(HSCardGameModeConstructed);
            break;
        case CardOptionItemModelTypeSort:
            self.value = NSStringFromHSCardSort(HSCardSortNameAsc);
            break;
        default:
            self.value = nil;
            break;
    }
}

#pragma mark Helper

- (NSArray<PickerItemModel *> *)pickerItemModelsFromDic:(NSDictionary<NSString *, NSString *> *)dic
                                            filterArray:(NSArray<NSString *> * _Nullable)filterArray
                                              converter:(NSUInteger (^)(NSString *))converter
                                              ascending:(BOOL)ascending{
    
    NSMutableArray<PickerItemModel *> *arr = [@[] mutableCopy];
    
    [dic enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull key, NSString * _Nonnull obj, BOOL * _Nonnull stop) {
        if (![filterArray containsObject:key]) {
            PickerItemModel *itemModel = [[PickerItemModel alloc] initWithImage:[UIImage imageNamed:key]
                                                                          title:obj
                                                                       identity:key];
            [arr addObject:itemModel];
            [itemModel release];
        }
    }];
    
    NSComparator comparator = ^NSComparisonResult(PickerItemModel *lhsModel, PickerItemModel *rhsModel) {
        NSUInteger lhs = converter(lhsModel.identity);
        NSUInteger rhs = converter(rhsModel.identity);
        
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
    
    NSArray<PickerItemModel *> *result = [[arr copy] autorelease];
    [arr release];
    return result;
}

@end
