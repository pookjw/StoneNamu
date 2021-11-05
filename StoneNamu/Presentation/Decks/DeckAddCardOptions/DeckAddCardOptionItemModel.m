//
//  DeckAddCardOptionItemModel.m
//  StoneNamu
//
//  Created by Jinwoo Kim on 7/24/21.
//

#import "DeckAddCardOptionItemModel.h"
#import <StoneNamuCore/StoneNamuCore.h>
#import "ImageService.h"

NSString * NSStringFromDeckAddCardOptionItemModelType(DeckAddCardOptionItemModelType type) {
    switch (type) {
        case DeckAddCardOptionItemModelTypeSet:
            return BlizzardHSAPIOptionTypeSet;
        case DeckAddCardOptionItemModelTypeClass:
            return BlizzardHSAPIOptionTypeClass;
        case DeckAddCardOptionItemModelTypeManaCost:
            return BlizzardHSAPIOptionTypeManaCost;
        case DeckAddCardOptionItemModelTypeAttack:
            return BlizzardHSAPIOptionTypeAttack;
        case DeckAddCardOptionItemModelTypeHealth:
            return BlizzardHSAPIOptionTypeHealth;
        case DeckAddCardOptionItemModelTypeCollectible:
            return BlizzardHSAPIOptionTypeCollectible;
        case DeckAddCardOptionItemModelTypeRarity:
            return BlizzardHSAPIOptionTypeRarity;
        case DeckAddCardOptionItemModelTypeType:
            return BlizzardHSAPIOptionTypeType;
        case DeckAddCardOptionItemModelTypeMinionType:
            return BlizzardHSAPIOptionTypeMinionType;
        case DeckAddCardOptionItemModelTypeSpellSchool:
            return BlizzardHSAPIOptionTypeSpellSchool;
        case DeckAddCardOptionItemModelTypeKeyword:
            return BlizzardHSAPIOptionTypeKeyword;
        case DeckAddCardOptionItemModelTypeTextFilter:
            return BlizzardHSAPIOptionTypeTextFilter;
        case DeckAddCardOptionItemModelTypeGameMode:
            return BlizzardHSAPIOptionTypeGameMode;
        case DeckAddCardOptionItemModelTypeSort:
            return BlizzardHSAPIOptionTypeSort;
        default:
            return @"";
    }
}

DeckAddCardOptionItemModelType DeckAddCardOptionItemModelTypeFromNSString(NSString * key) {
    if ([key isEqualToString:BlizzardHSAPIOptionTypeSet]) {
        return DeckAddCardOptionItemModelTypeSet;
    } else if ([key isEqualToString:BlizzardHSAPIOptionTypeClass]) {
        return DeckAddCardOptionItemModelTypeClass;
    } else if ([key isEqualToString:BlizzardHSAPIOptionTypeManaCost]) {
        return DeckAddCardOptionItemModelTypeManaCost;
    } else if ([key isEqualToString:BlizzardHSAPIOptionTypeAttack]) {
        return DeckAddCardOptionItemModelTypeAttack;
    } else if ([key isEqualToString:BlizzardHSAPIOptionTypeHealth]) {
        return DeckAddCardOptionItemModelTypeHealth;
    } else if ([key isEqualToString:BlizzardHSAPIOptionTypeCollectible]) {
        return DeckAddCardOptionItemModelTypeCollectible;
    } else if ([key isEqualToString:BlizzardHSAPIOptionTypeRarity]) {
        return DeckAddCardOptionItemModelTypeRarity;
    } else if ([key isEqualToString:BlizzardHSAPIOptionTypeType]) {
        return DeckAddCardOptionItemModelTypeType;
    } else if ([key isEqualToString:BlizzardHSAPIOptionTypeMinionType]) {
        return DeckAddCardOptionItemModelTypeMinionType;
    } else if ([key isEqualToString:BlizzardHSAPIOptionTypeSpellSchool]) {
        return DeckAddCardOptionItemModelTypeSpellSchool;
    } else if ([key isEqualToString:BlizzardHSAPIOptionTypeKeyword]) {
        return DeckAddCardOptionItemModelTypeKeyword;
    } else if ([key isEqualToString:BlizzardHSAPIOptionTypeTextFilter]) {
        return DeckAddCardOptionItemModelTypeTextFilter;
    } else if ([key isEqualToString:BlizzardHSAPIOptionTypeGameMode]) {
        return DeckAddCardOptionItemModelTypeGameMode;
    } else if ([key isEqualToString:BlizzardHSAPIOptionTypeSort]) {
        return DeckAddCardOptionItemModelTypeSort;
    } else {
        NSLog(@"unknown key: @%@", key);
        return DeckAddCardOptionItemModelTypeSet;
    }
}

@implementation DeckAddCardOptionItemModel

- (instancetype)initWithType:(DeckAddCardOptionItemModelType)type deckFormat:(HSDeckFormat)deckFormat classId:(HSCardClass)classId {
    self = [self init];
    
    if (self) {
        self->_type = type;
        self.deckFormat = deckFormat;
        self.classId = classId;
    }
    
    return self;
}

- (void)dealloc {
    [_deckFormat release];
    [_value release];
    [super dealloc];
}

- (BOOL)isEqual:(id)object {
    if (![object isKindOfClass:[DeckAddCardOptionItemModel class]]) {
        return NO;
    }
    
    DeckAddCardOptionItemModel *toCompare = (DeckAddCardOptionItemModel *)object;
    
    return (self.type == toCompare.type) &&
    [self.deckFormat isEqualToString:toCompare.deckFormat] &&
    (self.classId == toCompare.classId) &&
    ([self.value isEqualToString:toCompare.value]);
}

- (NSUInteger)hash {
    return self.type;
}

- (DeckAddCardOptionItemModelValueSetType)valueSetType {
    switch (self.type) {
        case DeckAddCardOptionItemModelTypeSet:
            return DeckAddCardOptionItemModelValueSetTypePicker;
        case DeckAddCardOptionItemModelTypeClass:
            return DeckAddCardOptionItemModelValueSetTypePicker;
        case DeckAddCardOptionItemModelTypeManaCost:
            return DeckAddCardOptionItemModelValueSetTypeStepper;
        case DeckAddCardOptionItemModelTypeAttack:
            return DeckAddCardOptionItemModelValueSetTypeStepper;
        case DeckAddCardOptionItemModelTypeHealth:
            return DeckAddCardOptionItemModelValueSetTypeStepper;
        case DeckAddCardOptionItemModelTypeCollectible:
            return DeckAddCardOptionItemModelValueSetTypePicker;
        case DeckAddCardOptionItemModelTypeRarity:
            return DeckAddCardOptionItemModelValueSetTypePickerWithEmptyRow;
        case DeckAddCardOptionItemModelTypeType:
            return DeckAddCardOptionItemModelValueSetTypePickerWithEmptyRow;
        case DeckAddCardOptionItemModelTypeMinionType:
            return DeckAddCardOptionItemModelValueSetTypePickerWithEmptyRow;
        case DeckAddCardOptionItemModelTypeSpellSchool:
            return DeckAddCardOptionItemModelValueSetTypePickerWithEmptyRow;
        case DeckAddCardOptionItemModelTypeKeyword:
            return DeckAddCardOptionItemModelValueSetTypePickerWithEmptyRow;
        case DeckAddCardOptionItemModelTypeTextFilter:
            return DeckAddCardOptionItemModelValueSetTypeTextField;
        case DeckAddCardOptionItemModelTypeGameMode:
            return DeckAddCardOptionItemModelValueSetTypePicker;
        case DeckAddCardOptionItemModelTypeSort:
            return DeckAddCardOptionItemModelValueSetTypePicker;
        default:
            return DeckAddCardOptionItemModelValueSetTypeTextField;
    }
}

- (NSArray<PickerItemModel *> * _Nullable)pickerDataSource {
    switch (self.type) {
        case DeckAddCardOptionItemModelTypeSet:
            return [self pickerItemModelsFromDic:localizablesWithHSCardSetFromHSDeckFormat(self.deckFormat)
                                     filterArray:nil
                                     imageSource:^UIImage * _Nullable(NSString * key) {
                return [ImageService.sharedInstance imageOfCardSet:HSCardSetFromNSString(key)];
            }
                                       converter:^NSUInteger(NSString * key) {
                return HSCardSetFromNSString(key);
            }
                                       ascending:NO];
        case DeckAddCardOptionItemModelTypeClass: {
            NSDictionary<NSString *, NSString *> *oldLocalizables = localizablesWithHSCardClass();
            NSDictionary<NSString *, NSString *> *newLocalizables = @{
                NSStringFromHSCardClass(self.classId): oldLocalizables[NSStringFromHSCardClass(self.classId)],
                NSStringFromHSCardClass(HSCardClassNeutral): oldLocalizables[NSStringFromHSCardClass(HSCardClassNeutral)]
            };
            
            return [self pickerItemModelsFromDic:newLocalizables
                                     filterArray:@[NSStringFromHSCardClass(HSCardClassDeathKnight)]
                                     imageSource:^UIImage * _Nullable(NSString * key) {
                return nil;
            }
                                       converter:^NSUInteger(NSString * key) {
                return HSCardClassFromNSString(key);
            }
                                       ascending:YES];
        }
        case DeckAddCardOptionItemModelTypeCollectible: {
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
        case DeckAddCardOptionItemModelTypeRarity: {
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
        case DeckAddCardOptionItemModelTypeType:
            return [self pickerItemModelsFromDic:localizableWithHSCardType()
                                     filterArray:@[NSStringFromHSCardType(HSCardTypeHeroPower)]
                                     imageSource:^UIImage * _Nullable(NSString * key) {
                return nil;
            }
                                       converter:^NSUInteger(NSString * key) {
                return HSCardTypeFromNSString(key);
            }
                                       ascending:YES];
        case DeckAddCardOptionItemModelTypeMinionType:
            return [self pickerItemModelsFromDic:localizablesWithHSCardMinionType()
                                     filterArray:nil
                                     imageSource:^UIImage * _Nullable(NSString * key) {
                return nil;
            }
                                       converter:^NSUInteger(NSString * key) {
                return HSCardMinionTypeFromNSString(key);
            }
                                       ascending:YES];
        case DeckAddCardOptionItemModelTypeSpellSchool:
            return [self pickerItemModelsFromDic:localizablesWithHSCardSpellSchool()
                                     filterArray:nil
                                     imageSource:^UIImage * _Nullable(NSString * key) {
                return nil;
            }
                                       converter:^NSUInteger(NSString * key) {
                return HSCardSpellSchoolFromNSString(key);
            }
                                       ascending:YES];
        case DeckAddCardOptionItemModelTypeKeyword:
            return [self pickerItemModelsFromDic:localizablesWithHSCardKeyword()
                                     filterArray:nil
                                     imageSource:^UIImage * _Nullable(NSString * key) {
                return nil;
            }
                                       converter:^NSUInteger(NSString * key) {
                return HSCardKeywordFromNSString(key);
            }
                                       ascending:YES];
        case DeckAddCardOptionItemModelTypeGameMode:
            return [self pickerItemModelsFromDic:localizablesWithHSCardGameMode()
                                     filterArray:nil
                                     imageSource:^UIImage * _Nullable(NSString * key) {
                return nil;
            }
                                       converter:^NSUInteger(NSString * key) {
                return HSCardGameModeFromNSString(key);
            }
                                       ascending:YES];
        case DeckAddCardOptionItemModelTypeSort:
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
        case DeckAddCardOptionItemModelTypeManaCost:
            return NSMakeRange(0, 10);
        case DeckAddCardOptionItemModelTypeAttack:
            return NSMakeRange(0, 10);
        case DeckAddCardOptionItemModelTypeHealth:
            return NSMakeRange(0, 10);
        default:
            return NSMakeRange(0, 0);
    }
}

- (BOOL)showPlusMarkWhenReachedToMaxOnStepper {
    switch (self.type) {
        case DeckAddCardOptionItemModelTypeManaCost:
            return YES;
        case DeckAddCardOptionItemModelTypeAttack:
            return YES;
        case DeckAddCardOptionItemModelTypeHealth:
            return YES;
        default:
            return NO;
    }
}

- (NSString *)text {
    switch (self.type) {
        case DeckAddCardOptionItemModelTypeSet:
            return NSLocalizedString(@"CARD_SET", @"");
        case DeckAddCardOptionItemModelTypeClass:
            return NSLocalizedString(@"CARD_CLASS", @"");
        case DeckAddCardOptionItemModelTypeManaCost:
            return NSLocalizedString(@"CARD_MANA_COST", @"");
        case DeckAddCardOptionItemModelTypeAttack:
            return NSLocalizedString(@"CARD_ATTACK", @"");
        case DeckAddCardOptionItemModelTypeHealth:
            return NSLocalizedString(@"CARD_HEALTH", @"");
        case DeckAddCardOptionItemModelTypeCollectible:
            return NSLocalizedString(@"CARD_COLLECTIBLE", @"");
        case DeckAddCardOptionItemModelTypeRarity:
            return NSLocalizedString(@"CARD_RARITY", @"");
        case DeckAddCardOptionItemModelTypeType:
            return NSLocalizedString(@"CARD_TYPE", @"");
        case DeckAddCardOptionItemModelTypeMinionType:
            return NSLocalizedString(@"CARD_MINION_TYPE", @"");
        case DeckAddCardOptionItemModelTypeSpellSchool:
            return NSLocalizedString(@"CARD_SPELL_SCHOOL", @"");
        case DeckAddCardOptionItemModelTypeKeyword:
            return NSLocalizedString(@"CARD_KEYWORD", @"");
        case DeckAddCardOptionItemModelTypeTextFilter:
            return NSLocalizedString(@"CARD_TEXT_FILTER", @"");
        case DeckAddCardOptionItemModelTypeGameMode:
            return NSLocalizedString(@"CARD_GAME_MODE", @"");
        case DeckAddCardOptionItemModelTypeSort:
            return NSLocalizedString(@"CARD_SORT", @"");
        default:
            return @"";
    }
}

- (NSString * _Nullable)accessoryText {
    switch (self.type) {
        case DeckAddCardOptionItemModelTypeSet:
            return localizableFromHSCardSet(HSCardSetFromNSString(self.value));
        case DeckAddCardOptionItemModelTypeClass:
            return localizableFromHSCardClass(HSCardClassFromNSString(self.value));
        case DeckAddCardOptionItemModelTypeCollectible:
            return localizableFromHSCardCollectible(HSCardCollectibleFromNSString(self.value));
        case DeckAddCardOptionItemModelTypeRarity:
            return localizableFromHSCardRarity(HSCardRarityFromNSString(self.value));
        case DeckAddCardOptionItemModelTypeType:
            return localizableFromHSCardType(HSCardTypeFromNSString(self.value));
        case DeckAddCardOptionItemModelTypeMinionType:
            return localizableFromHSCardMinionType(HSCardMinionTypeFromNSString(self.value));
        case DeckAddCardOptionItemModelTypeSpellSchool:
            return localizableFromHSCardSpellSchool(HSCardSpellSchoolFromNSString(self.value));
        case DeckAddCardOptionItemModelTypeKeyword:
            return localizableFromHSCardKeyword(HSCardKeywordFromNSString(self.value));
        case DeckAddCardOptionItemModelTypeGameMode:
            return localizableFromHSCardGameMode(HSCardGameModeFromNSString(self.value));
        case DeckAddCardOptionItemModelTypeSort:
            return localizableFromHSCardSort(HSCardSortFromNSString(self.value));
        default:
            return self.value;
    }
}

- (NSString * _Nullable)toolTip {
    switch (self.type) {
        case DeckAddCardOptionItemModelTypeSet:
            return NSLocalizedString(@"CARD_SET_TOOLTIP_DESCRIPTION", @"");
        case DeckAddCardOptionItemModelTypeClass:
            return NSLocalizedString(@"CARD_CLASS_TOOLTIP_DESCRIPTION", @"");
        case DeckAddCardOptionItemModelTypeManaCost:
            return NSLocalizedString(@"CARD_MANA_COST_TOOLTIP_DESCRIPTION", @"");
        case DeckAddCardOptionItemModelTypeAttack:
            return NSLocalizedString(@"CARD_ATTACK_TOOLTIP_DESCRIPTION", @"");
        case DeckAddCardOptionItemModelTypeHealth:
            return NSLocalizedString(@"CARD_HEALTH_TOOLTIP_DESCRIPTION", @"");
        case DeckAddCardOptionItemModelTypeCollectible:
            return NSLocalizedString(@"CARD_COLLECTIBLE_TOOLTIP_DESCRIPTION", @"");
        case DeckAddCardOptionItemModelTypeRarity:
            return NSLocalizedString(@"CARD_RARITY_TOOLTIP_DESCRIPTION", @"");
        case DeckAddCardOptionItemModelTypeType:
            return NSLocalizedString(@"CARD_TYPE_TOOLTIP_DESCRIPTION", @"");
        case DeckAddCardOptionItemModelTypeMinionType:
            return NSLocalizedString(@"CARD_MINION_TYPE_TOOLTIP_DESCRIPTION", @"");
        case DeckAddCardOptionItemModelTypeSpellSchool:
            return NSLocalizedString(@"CARD_SPELL_SCHOOL_TOOLTIP_DESCRIPTION", @"");
        case DeckAddCardOptionItemModelTypeKeyword:
            return NSLocalizedString(@"CARD_KEYWORD_TOOLTIP_DESCRIPTION", @"");
        case DeckAddCardOptionItemModelTypeTextFilter:
            return NSLocalizedString(@"CARD_TEXT_FILTER_TOOLTIP_DESCRIPTION", @"");
        case DeckAddCardOptionItemModelTypeGameMode:
            return NSLocalizedString(@"CARD_GAME_MODE_TOOLTIP_DESCRIPTION", @"");
        case DeckAddCardOptionItemModelTypeSort:
            return NSLocalizedString(@"CARD_SORT_TOOLTIP_DESCRIPTION", @"");
        default:
            return @"";
    }
}

#pragma mark - Helper

- (NSArray<PickerItemModel *> *)pickerItemModelsFromDic:(NSDictionary<NSString *, NSString *> *)dic
                                            filterArray:(NSArray<NSString *> * _Nullable)filterArray
                                            imageSource:(UIImage * _Nullable (^)(NSString *))imageSource
                                              converter:(NSUInteger (^)(NSString *))converter
                                              ascending:(BOOL)ascending{
    
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
    
    NSArray<PickerItemModel *> *result = [[arr copy] autorelease];
    [arr release];
    return result;
}

@end
