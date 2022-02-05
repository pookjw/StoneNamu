//
//  CardOptionItemModel.m
//  StoneNamu
//
//  Created by Jinwoo Kim on 7/24/21.
//

#import "CardOptionItemModel.h"
#import <StoneNamuResources/StoneNamuResources.h>

BlizzardHSAPIOptionType BlizzardHSAPIOptionTypeFromCardOptionItemModelType(CardOptionItemModelType type) {
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
        case CardOptionItemModelTypeSpellSchool:
            return BlizzardHSAPIOptionTypeSpellSchool;
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

CardOptionItemModelType CardOptionItemModelTypeFromBlizzardHSAPIOptionType(BlizzardHSAPIOptionType key) {
    if ([key isEqualToString:BlizzardHSAPIOptionTypeSet]) {
        return CardOptionItemModelTypeSet;
    } else if ([key isEqualToString:BlizzardHSAPIOptionTypeClass]) {
        return CardOptionItemModelTypeClass;
    } else if ([key isEqualToString:BlizzardHSAPIOptionTypeManaCost]) {
        return CardOptionItemModelTypeManaCost;
    } else if ([key isEqualToString:BlizzardHSAPIOptionTypeAttack]) {
        return CardOptionItemModelTypeAttack;
    } else if ([key isEqualToString:BlizzardHSAPIOptionTypeHealth]) {
        return CardOptionItemModelTypeHealth;
    } else if ([key isEqualToString:BlizzardHSAPIOptionTypeCollectible]) {
        return CardOptionItemModelTypeCollectible;
    } else if ([key isEqualToString:BlizzardHSAPIOptionTypeRarity]) {
        return CardOptionItemModelTypeRarity;
    } else if ([key isEqualToString:BlizzardHSAPIOptionTypeType]) {
        return CardOptionItemModelTypeType;
    } else if ([key isEqualToString:BlizzardHSAPIOptionTypeMinionType]) {
        return CardOptionItemModelTypeMinionType;
    } else if ([key isEqualToString:BlizzardHSAPIOptionTypeSpellSchool]) {
        return CardOptionItemModelTypeSpellSchool;
    } else if ([key isEqualToString:BlizzardHSAPIOptionTypeKeyword]) {
        return CardOptionItemModelTypeKeyword;
    } else if ([key isEqualToString:BlizzardHSAPIOptionTypeTextFilter]) {
        return CardOptionItemModelTypeTextFilter;
    } else if ([key isEqualToString:BlizzardHSAPIOptionTypeGameMode]) {
        return CardOptionItemModelTypeGameMode;
    } else if ([key isEqualToString:BlizzardHSAPIOptionTypeSort]) {
        return CardOptionItemModelTypeSort;
    } else {
        NSLog(@"unknown key: @%@", key);
        return CardOptionItemModelTypeSet;
    }
}

@implementation CardOptionItemModel

- (instancetype)initWithType:(CardOptionItemModelType)type {
    self = [self init];
    
    if (self) {
        self->_type = type;
    }
    
    return self;
}

- (void)dealloc {
    [_values release];
    [super dealloc];
}

- (BOOL)isEqual:(id)object {
    if (![object isKindOfClass:[CardOptionItemModel class]]) {
        return NO;
    }
    
    CardOptionItemModel *toCompare = (CardOptionItemModel *)object;
    
    return (self.type == toCompare.type);
}

- (NSUInteger)hash {
    return self.type;
}

- (CardOptionItemModelValueSetType)valueSetType {
    switch (self.type) {
        case CardOptionItemModelTypeSet:
            return CardOptionItemModelValueSetTypePickerWithEmptyRow;
        case CardOptionItemModelTypeClass:
            return CardOptionItemModelValueSetTypePickerWithEmptyRow;
        case CardOptionItemModelTypeManaCost:
            return CardOptionItemModelValueSetTypePickerWithEmptyRow;
        case CardOptionItemModelTypeAttack:
            return CardOptionItemModelValueSetTypePickerWithEmptyRow;
        case CardOptionItemModelTypeHealth:
            return CardOptionItemModelValueSetTypePickerWithEmptyRow;
        case CardOptionItemModelTypeCollectible:
            return CardOptionItemModelValueSetTypePicker;
        case CardOptionItemModelTypeRarity:
            return CardOptionItemModelValueSetTypePickerWithEmptyRow;
        case CardOptionItemModelTypeType:
            return CardOptionItemModelValueSetTypePickerWithEmptyRow;
        case CardOptionItemModelTypeMinionType:
            return CardOptionItemModelValueSetTypePickerWithEmptyRow;
        case CardOptionItemModelTypeSpellSchool:
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
            return [self pickerItemModelsFromDic:[ResourcesService localizationsForHSCardSet]
                                     filterArray:nil
                                     imageSource:^UIImage * _Nullable(NSString * key) {
                return [ResourcesService imageForCardSet:HSCardSetFromNSString(key)];
            }
                                       converter:^NSUInteger(NSString * key) {
                return HSCardSetFromNSString(key);
            }
                                       ascending:NO];
        case CardOptionItemModelTypeClass: {
            return [self pickerItemModelsFromDic:[ResourcesService localizationsForHSCardClass]
                                     filterArray:@[NSStringFromHSCardClass(HSCardClassDeathKnight)]
                                     imageSource:^UIImage * _Nullable(NSString * key) {
                return nil;
            }
                                       converter:^NSUInteger(NSString * key) {
                return HSCardClassFromNSString(key);
            }
                                       ascending:YES];
        }
        case CardOptionItemModelTypeCollectible: {
            return [self pickerItemModelsFromDic:[ResourcesService localizationsForHSCardCollectible]
                                     filterArray:nil
                                     imageSource:^UIImage * _Nullable(NSString * key) {
                return nil;
            }
                                       converter:^NSUInteger(NSString * key) {
                return HSCardCollectibleFromNSString(key);
            }
                                       ascending:YES];
        }
        case CardOptionItemModelTypeRarity: {
            return [self pickerItemModelsFromDic:[ResourcesService localizationsForHSCardRarity]
                                     filterArray:@[NSStringFromHSCardRarity(HSCardRarityNull)]
                                     imageSource:^UIImage * _Nullable(NSString * key) {
                return nil;
            }
                                       converter:^NSUInteger(NSString * key) {
                return HSCardRarityFromNSString(key);
            }
                                       ascending:YES];
        }
        case CardOptionItemModelTypeType:
            return [self pickerItemModelsFromDic:[ResourcesService localizationsForHSCardType]
                                     filterArray:@[NSStringFromHSCardType(HSCardTypeHeroPower)]
                                     imageSource:^UIImage * _Nullable(NSString * key) {
                return nil;
            }
                                       converter:^NSUInteger(NSString * key) {
                return HSCardTypeFromNSString(key);
            }
                                       ascending:YES];
        case CardOptionItemModelTypeMinionType:
            return [self pickerItemModelsFromDic:[ResourcesService localizationsForHSCardMinionType]
                                     filterArray:nil
                                     imageSource:^UIImage * _Nullable(NSString * key) {
                return nil;
            }
                                       converter:^NSUInteger(NSString * key) {
                return HSCardMinionTypeFromNSString(key);
            }
                                       ascending:YES];
        case CardOptionItemModelTypeSpellSchool:
            return [self pickerItemModelsFromDic:[ResourcesService localizationsForHSCardSpellSchool]
                                     filterArray:nil
                                     imageSource:^UIImage * _Nullable(NSString * key) {
                return nil;
            }
                                       converter:^NSUInteger(NSString * key) {
                return HSCardSpellSchoolFromNSString(key);
            }
                                       ascending:YES];
        case CardOptionItemModelTypeKeyword:
            return [self pickerItemModelsFromDic:[ResourcesService localizationsForHSCardKeyword]
                                     filterArray:nil
                                     imageSource:^UIImage * _Nullable(NSString * key) {
                return nil;
            }
                                       converter:^NSUInteger(NSString * key) {
                return HSCardKeywordFromNSString(key);
            }
                                       ascending:YES];
        case CardOptionItemModelTypeGameMode:
            return [self pickerItemModelsFromDic:[ResourcesService localizationsForHSCardGameMode]
                                     filterArray:nil
                                     imageSource:^UIImage * _Nullable(NSString * key) {
                return nil;
            }
                                       converter:^NSUInteger(NSString * key) {
                return HSCardGameModeFromNSString(key);
            }
                                       ascending:YES];
        case CardOptionItemModelTypeSort:
            return [self pickerItemModelsFromDic:[ResourcesService localizationsForHSCardSort]
                                     filterArray:nil
                                     imageSource:^UIImage * _Nullable(NSString * key) {
                return nil;
            }
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
            return NSMakeRange(0, 10);
        case CardOptionItemModelTypeAttack:
            return NSMakeRange(0, 10);
        case CardOptionItemModelTypeHealth:
            return NSMakeRange(0, 10);
        default:
            return NSMakeRange(0, 0);
    }
}

- (BOOL)showPlusMarkWhenReachedToMaxOnStepper {
    switch (self.type) {
        case CardOptionItemModelTypeManaCost:
            return YES;
        case CardOptionItemModelTypeAttack:
            return YES;
        case CardOptionItemModelTypeHealth:
            return YES;
        default:
            return NO;
    }
}

- (NSString *)text {
    switch (self.type) {
        case CardOptionItemModelTypeSet:
            return [ResourcesService localizationForBlizzardHSAPIOptionType:BlizzardHSAPIOptionTypeSet];
        case CardOptionItemModelTypeClass:
            return [ResourcesService localizationForBlizzardHSAPIOptionType:BlizzardHSAPIOptionTypeClass];
        case CardOptionItemModelTypeManaCost:
            return [ResourcesService localizationForBlizzardHSAPIOptionType:BlizzardHSAPIOptionTypeManaCost];
        case CardOptionItemModelTypeAttack:
            return [ResourcesService localizationForBlizzardHSAPIOptionType:BlizzardHSAPIOptionTypeAttack];
        case CardOptionItemModelTypeHealth:
            return [ResourcesService localizationForBlizzardHSAPIOptionType:BlizzardHSAPIOptionTypeHealth];
        case CardOptionItemModelTypeCollectible:
            return [ResourcesService localizationForBlizzardHSAPIOptionType:BlizzardHSAPIOptionTypeCollectible];
        case CardOptionItemModelTypeRarity:
            return [ResourcesService localizationForBlizzardHSAPIOptionType:BlizzardHSAPIOptionTypeRarity];
        case CardOptionItemModelTypeType:
            return [ResourcesService localizationForBlizzardHSAPIOptionType:BlizzardHSAPIOptionTypeType];
        case CardOptionItemModelTypeMinionType:
            return[ResourcesService localizationForBlizzardHSAPIOptionType:BlizzardHSAPIOptionTypeMinionType];
        case CardOptionItemModelTypeSpellSchool:
            return [ResourcesService localizationForBlizzardHSAPIOptionType:BlizzardHSAPIOptionTypeSpellSchool];
        case CardOptionItemModelTypeKeyword:
            return [ResourcesService localizationForBlizzardHSAPIOptionType:BlizzardHSAPIOptionTypeKeyword];
        case CardOptionItemModelTypeTextFilter:
            return [ResourcesService localizationForBlizzardHSAPIOptionType:BlizzardHSAPIOptionTypeTextFilter];
        case CardOptionItemModelTypeGameMode:
            return [ResourcesService localizationForBlizzardHSAPIOptionType:BlizzardHSAPIOptionTypeGameMode];
        case CardOptionItemModelTypeSort:
            return [ResourcesService localizationForBlizzardHSAPIOptionType:BlizzardHSAPIOptionTypeSort];
        default:
            return @"";
    }
}

- (NSString * _Nullable)accessoryText {
    NSString *(^ converter)(NSString *);
    
    switch (self.type) {
        case CardOptionItemModelTypeSet: {
            converter = ^NSString * (NSString *value) {
                return [ResourcesService localizationForHSCardSet:HSCardSetFromNSString(value)];
            };
            break;
        }
        case CardOptionItemModelTypeClass: {
            converter = ^NSString * (NSString *value) {
                return [ResourcesService localizationForHSCardClass:HSCardClassFromNSString(value)];
            };
            break;
        }
        case CardOptionItemModelTypeCollectible: {
            converter = ^NSString * (NSString *value) {
                return [ResourcesService localizationForHSCardCollectible:HSCardCollectibleFromNSString(value)];
            };
            break;
        }
        case CardOptionItemModelTypeRarity: {
            converter = ^NSString * (NSString *value) {
                return [ResourcesService localizationForHSCardRarity:HSCardRarityFromNSString(value)];
            };
            break;
        }
        case CardOptionItemModelTypeType: {
            converter = ^NSString * (NSString *value) {
                return [ResourcesService localizationForHSCardType:HSCardTypeFromNSString(value)];
            };
            break;
        }
        case CardOptionItemModelTypeMinionType: {
            converter = ^NSString * (NSString *value) {
                return [ResourcesService localizationForHSCardMinionType:HSCardMinionTypeFromNSString(value)];
            };
            break;
        }
        case CardOptionItemModelTypeSpellSchool: {
            converter = ^NSString * (NSString *value) {
                return [ResourcesService localizationForHSCardSpellSchool:HSCardSpellSchoolFromNSString(value)];
            };
            break;
        }
        case CardOptionItemModelTypeKeyword: {
            converter = ^NSString * (NSString *value) {
                return [ResourcesService localizationForHSCardKeyword:HSCardKeywordFromNSString(value)];
            };
            break;
        }
        case CardOptionItemModelTypeGameMode: {
            converter = ^NSString * (NSString *value) {
                return [ResourcesService localizationForHSCardGameMode:HSCardGameModeFromNSString(value)];
            };
            break;
        }
        case CardOptionItemModelTypeSort: {
            converter = ^NSString * (NSString *value) {
                return [ResourcesService localizationForHSCardSort:HSCardSortFromNSString(value)];
            };
            break;
        }
        default: {
            converter = ^NSString * (NSString *value) {
                return value;
            };
            break;
        }
    }
    
    NSMutableArray<NSString *> *texts = [NSMutableArray<NSString *> new];
    
    [self.values enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, BOOL * _Nonnull stop) {
        [texts addObject:converter(obj)];
    }];
    
    NSString *text = [texts componentsJoinedByString:@", "];
    [texts release];
    
    return text;
}

- (NSString * _Nullable)toolTip {
    switch (self.type) {
        case CardOptionItemModelTypeSet:
            return [ResourcesService localizationForKey:LocalizableKeyCardSetTooltipDescription];
        case CardOptionItemModelTypeClass:
            return [ResourcesService localizationForKey:LocalizableKeyCardClassTooltipDescription];
        case CardOptionItemModelTypeManaCost:
            return [ResourcesService localizationForKey:LocalizableKeyCardManaCostTooltipDescription];
        case CardOptionItemModelTypeAttack:
            return [ResourcesService localizationForKey:LocalizableKeyCardAttackTooltipDescription];
        case CardOptionItemModelTypeHealth:
            return [ResourcesService localizationForKey:LocalizableKeyCardHealthTooltipDescription];
        case CardOptionItemModelTypeCollectible:
            return [ResourcesService localizationForKey:LocalizableKeyCardCollectibleTooltipDescription];
        case CardOptionItemModelTypeRarity:
            return [ResourcesService localizationForKey:LocalizableKeyCardRarityTooltipDescription];
        case CardOptionItemModelTypeType:
            return [ResourcesService localizationForKey:LocalizableKeyCardTypeTooltipDescription];
        case CardOptionItemModelTypeMinionType:
            return [ResourcesService localizationForKey:LocalizableKeyCardMinionTypeTooltipDescription];
        case CardOptionItemModelTypeSpellSchool:
            return [ResourcesService localizationForKey:LocalizableKeyCardSpellSchoolTooltipDescription];
        case CardOptionItemModelTypeKeyword:
            return [ResourcesService localizationForKey:LocalizableKeyCardKeywordTooltipDescription];
        case CardOptionItemModelTypeTextFilter:
            return [ResourcesService localizationForKey:LocalizableKeyCardTextFilterTooltipDescription];
        case CardOptionItemModelTypeGameMode:
            return [ResourcesService localizationForKey:LocalizableKeyCardGameModeTooltipDescription];
        case CardOptionItemModelTypeSort:
            return [ResourcesService localizationForKey:LocalizableKeyCardSortTooltipDescription];
        default:
            return @"";
    }
}

#pragma mark - Helper

- (NSArray<PickerItemModel *> *)pickerItemModelsFromDic:(NSDictionary<NSString *, NSString *> *)dic
                                            filterArray:(NSArray<NSString *> * _Nullable)filterArray
                                            imageSource:(UIImage * _Nullable (^)(NSString *))imageSource
                                              converter:(NSUInteger (^)(NSString *))converter
                                              ascending:(BOOL)ascending {
    
    NSMutableArray<PickerItemModel *> *arr = [@[] mutableCopy];
    
    [dic enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull key, NSString * _Nonnull obj, BOOL * _Nonnull stop) {
        if (![filterArray containsObject:key]) {
            PickerItemModel *itemModel = [[PickerItemModel alloc] initWithImage:imageSource(key)
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
    
    return [arr autorelease];
}

@end
