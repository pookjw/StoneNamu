//
//  CardOptionItemModel.m
//  StoneNamu
//
//  Created by Jinwoo Kim on 7/24/21.
//

#import "CardOptionItemModel.h"
#import <StoneNamuCore/StoneNamuCore.h>
#import <StoneNamuResources/StoneNamuResources.h>
#import "ImageService.h"

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

CardOptionItemModelType CardOptionItemModelTypeFromNSString(NSString * key) {
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
            return [self pickerItemModelsFromDic:localizablesWithHSCardSet()
                                     filterArray:nil
                                     imageSource:^UIImage * _Nullable(NSString * key) {
                return [ImageService.sharedInstance imageOfCardSet:HSCardSetFromNSString(key)];
            }
                                       converter:^NSUInteger(NSString * key) {
                return HSCardSetFromNSString(key);
            }
                                       ascending:NO];
        case CardOptionItemModelTypeClass: {
            return [self pickerItemModelsFromDic:localizablesWithHSCardClass()
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
            return [self pickerItemModelsFromDic:localizablesWithHSCardCollectible()
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
            return [self pickerItemModelsFromDic:localizablesWithHSCardRarity()
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
            return [self pickerItemModelsFromDic:localizableWithHSCardType()
                                     filterArray:@[NSStringFromHSCardType(HSCardTypeHeroPower)]
                                     imageSource:^UIImage * _Nullable(NSString * key) {
                return nil;
            }
                                       converter:^NSUInteger(NSString * key) {
                return HSCardTypeFromNSString(key);
            }
                                       ascending:YES];
        case CardOptionItemModelTypeMinionType:
            return [self pickerItemModelsFromDic:localizablesWithHSCardMinionType()
                                     filterArray:nil
                                     imageSource:^UIImage * _Nullable(NSString * key) {
                return nil;
            }
                                       converter:^NSUInteger(NSString * key) {
                return HSCardMinionTypeFromNSString(key);
            }
                                       ascending:YES];
        case CardOptionItemModelTypeSpellSchool:
            return [self pickerItemModelsFromDic:localizablesWithHSCardSpellSchool()
                                     filterArray:nil
                                     imageSource:^UIImage * _Nullable(NSString * key) {
                return nil;
            }
                                       converter:^NSUInteger(NSString * key) {
                return HSCardSpellSchoolFromNSString(key);
            }
                                       ascending:YES];
        case CardOptionItemModelTypeKeyword:
            return [self pickerItemModelsFromDic:localizablesWithHSCardKeyword()
                                     filterArray:nil
                                     imageSource:^UIImage * _Nullable(NSString * key) {
                return nil;
            }
                                       converter:^NSUInteger(NSString * key) {
                return HSCardKeywordFromNSString(key);
            }
                                       ascending:YES];
        case CardOptionItemModelTypeGameMode:
            return [self pickerItemModelsFromDic:localizablesWithHSCardGameMode()
                                     filterArray:nil
                                     imageSource:^UIImage * _Nullable(NSString * key) {
                return nil;
            }
                                       converter:^NSUInteger(NSString * key) {
                return HSCardGameModeFromNSString(key);
            }
                                       ascending:YES];
        case CardOptionItemModelTypeSort:
            return [self pickerItemModelsFromDic:localizablesWithHSCardSort()
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
            return [ResourcesService localizaedStringForKey:LocalizableKeyCardSet];
        case CardOptionItemModelTypeClass:
            return [ResourcesService localizaedStringForKey:LocalizableKeyCardClass];
        case CardOptionItemModelTypeManaCost:
            return [ResourcesService localizaedStringForKey:LocalizableKeyCardManaCost];
        case CardOptionItemModelTypeAttack:
            return [ResourcesService localizaedStringForKey:LocalizableKeyCardAttack];
        case CardOptionItemModelTypeHealth:
            return [ResourcesService localizaedStringForKey:LocalizableKeyCardHealth];
        case CardOptionItemModelTypeCollectible:
            return [ResourcesService localizaedStringForKey:LocalizableKeyCardCollectible];
        case CardOptionItemModelTypeRarity:
            return [ResourcesService localizaedStringForKey:LocalizableKeyCardRarity];
        case CardOptionItemModelTypeType:
            return [ResourcesService localizaedStringForKey:LocalizableKeyCardType];
        case CardOptionItemModelTypeMinionType:
            return[ResourcesService localizaedStringForKey:LocalizableKeyCardMinionType];
        case CardOptionItemModelTypeSpellSchool:
            return [ResourcesService localizaedStringForKey:LocalizableKeyCardSpellSchool];
        case CardOptionItemModelTypeKeyword:
            return [ResourcesService localizaedStringForKey:LocalizableKeyCardKeyword];
        case CardOptionItemModelTypeTextFilter:
            return [ResourcesService localizaedStringForKey:LocalizableKeyCardTextFilter];
        case CardOptionItemModelTypeGameMode:
            return [ResourcesService localizaedStringForKey:LocalizableKeyCardGameMode];
        case CardOptionItemModelTypeSort:
            return [ResourcesService localizaedStringForKey:LocalizableKeyCardSort];
        default:
            return @"";
    }
}

- (NSString * _Nullable)accessoryText {
    switch (self.type) {
        case CardOptionItemModelTypeSet:
            return localizableFromHSCardSet(HSCardSetFromNSString(self.value));
        case CardOptionItemModelTypeClass:
            return localizableFromHSCardClass(HSCardClassFromNSString(self.value));
        case CardOptionItemModelTypeCollectible:
            return localizableFromHSCardCollectible(HSCardCollectibleFromNSString(self.value));
        case CardOptionItemModelTypeRarity:
            return localizableFromHSCardRarity(HSCardRarityFromNSString(self.value));
        case CardOptionItemModelTypeType:
            return localizableFromHSCardType(HSCardTypeFromNSString(self.value));
        case CardOptionItemModelTypeMinionType:
            return localizableFromHSCardMinionType(HSCardMinionTypeFromNSString(self.value));
        case CardOptionItemModelTypeSpellSchool:
            return localizableFromHSCardSpellSchool(HSCardSpellSchoolFromNSString(self.value));
        case CardOptionItemModelTypeKeyword:
            return localizableFromHSCardKeyword(HSCardKeywordFromNSString(self.value));
        case CardOptionItemModelTypeGameMode:
            return localizableFromHSCardGameMode(HSCardGameModeFromNSString(self.value));
        case CardOptionItemModelTypeSort:
            return localizableFromHSCardSort(HSCardSortFromNSString(self.value));
        default:
            return self.value;
    }
}

- (NSString * _Nullable)toolTip {
    switch (self.type) {
        case CardOptionItemModelTypeSet:
            return [ResourcesService localizaedStringForKey:LocalizableKeyCardSetTooltipDescription];
        case CardOptionItemModelTypeClass:
            return [ResourcesService localizaedStringForKey:LocalizableKeyCardClassTooltipDescription];
        case CardOptionItemModelTypeManaCost:
            return [ResourcesService localizaedStringForKey:LocalizableKeyCardManaCostTooltipDescription];
        case CardOptionItemModelTypeAttack:
            return [ResourcesService localizaedStringForKey:LocalizableKeyCardAttack];
        case CardOptionItemModelTypeHealth:
            return [ResourcesService localizaedStringForKey:LocalizableKeyCardHealthTooltipDescription];
        case CardOptionItemModelTypeCollectible:
            return [ResourcesService localizaedStringForKey:LocalizableKeyCardCollectibleTooltipDescription];
        case CardOptionItemModelTypeRarity:
            return [ResourcesService localizaedStringForKey:LocalizableKeyCardRarityTooltipDescription];
        case CardOptionItemModelTypeType:
            return [ResourcesService localizaedStringForKey:LocalizableKeyCardTypeTooltipDescription];
        case CardOptionItemModelTypeMinionType:
            return [ResourcesService localizaedStringForKey:LocalizableKeyCardMinionTypeTooltipDescription];
        case CardOptionItemModelTypeSpellSchool:
            return [ResourcesService localizaedStringForKey:LocalizableKeyCardSpellSchoolTooltipDescription];
        case CardOptionItemModelTypeKeyword:
            return [ResourcesService localizaedStringForKey:LocalizableKeyCardKeywordTooltipDescription];
        case CardOptionItemModelTypeTextFilter:
            return [ResourcesService localizaedStringForKey:LocalizableKeyCardTextFilterTooltipDescription];
        case CardOptionItemModelTypeGameMode:
            return [ResourcesService localizaedStringForKey:LocalizableKeyCardGameModeTooltipDescription];
        case CardOptionItemModelTypeSort:
            return [ResourcesService localizaedStringForKey:LocalizableKeyCardSortTooltipDescription];
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
