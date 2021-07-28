//
//  CardOptionsItemModel.m
//  StoneNamu
//
//  Created by Jinwoo Kim on 7/24/21.
//

#import "CardOptionsItemModel.h"
#import "BlizzardHSAPIKeys.h"
#import "HSCardSet.h"
#import "HSCardClass.h"

NSString * NSStringFromCardOptionsItemModelType(CardOptionsItemModelType type) {
    switch (type) {
        case CardOptionsItemModelTypeSet:
            return BlizzardHSAPIOptionTypeSet;
        case CardOptionsItemModelTypeClass:
            return BlizzardHSAPIOptionTypeClass;
        case CardOptionsItemModelTypeManaCost:
            return BlizzardHSAPIOptionTypeManaCost;
        case CardOptionsItemModelTypeAttack:
            return BlizzardHSAPIOptionTypeAttack;
        case CardOptionsItemModelTypeHealth:
            return BlizzardHSAPIOptionTypeHealth;
        case CardOptionsItemModelTypeCollectible:
            return BlizzardHSAPIOptionTypeCollectible;
        case CardOptionsItemModelTypeRarity:
            return BlizzardHSAPIOptionTypeRarity;
        case CardOptionsItemModelTypeType:
            return BlizzardHSAPIOptionTypeType;
        case CardOptionsItemModelTypeMinionType:
            return BlizzardHSAPIOptionTypeMinionType;
        case CardOptionsItemModelTypeKeyword:
            return BlizzardHSAPIOptionTypeKeyword;
        case CardOptionsItemModelTypeTextFilter:
            return BlizzardHSAPIOptionTypeTextFilter;
        case CardOptionsItemModelTypeGameMode:
            return BlizzardHSAPIOptionTypeGameMode;
        case CardOptionsItemModelTypeSort:
            return BlizzardHSAPIOptionTypeSort;
        default:
            return @"";
    }
}

@implementation CardOptionsItemModel

- (instancetype)init {
    self = [super init];
    
    if (self) {
        _value = nil;
    }
    
    return self;
}

- (instancetype)initWithType:(CardOptionsItemModelType)type {
    self = [self init];
    
    if (self) {
        _type = type;
    }
    
    return self;
}

- (void)dealloc {
    [_value release];
    [super dealloc];
}

- (BOOL)isEqual:(id)object {
    if (![object isKindOfClass:[CardOptionsItemModel class]]) {
        return NO;
    }
    
    CardOptionsItemModel *toCompare = (CardOptionsItemModel *)object;
    
    return (self.type == toCompare.type) && ([self.value isEqualToString:toCompare.value]);
}

- (CardOptionsItemModelValueSetType)valueSetType {
    switch (self.type) {
        case CardOptionsItemModelTypeSet:
            return CardOptionsItemModelValueSetTypePicker;
        case CardOptionsItemModelTypeClass:
            return CardOptionsItemModelValueSetTypePicker;
        case CardOptionsItemModelTypeManaCost:
            return CardOptionsItemModelValueSetTypeStepper;
        case CardOptionsItemModelTypeAttack:
            return CardOptionsItemModelValueSetTypeStepper;
        case CardOptionsItemModelTypeHealth:
            return CardOptionsItemModelValueSetTypeStepper;
        case CardOptionsItemModelTypeCollectible:
            return CardOptionsItemModelValueSetTypePicker;
        case CardOptionsItemModelTypeRarity:
            return CardOptionsItemModelValueSetTypePicker;
        case CardOptionsItemModelTypeType:
            return CardOptionsItemModelValueSetTypePicker;
        case CardOptionsItemModelTypeMinionType:
            return CardOptionsItemModelValueSetTypePicker;
        case CardOptionsItemModelTypeKeyword:
            return CardOptionsItemModelValueSetTypePicker;
        case CardOptionsItemModelTypeTextFilter:
            return CardOptionsItemModelValueSetTypeTextField;
        case CardOptionsItemModelTypeGameMode:
            return CardOptionsItemModelValueSetTypeTextField;
        case CardOptionsItemModelTypeSort:
            return CardOptionsItemModelValueSetTypePicker;
        default:
            return CardOptionsItemModelValueSetTypeTextField;
    }
}

- (NSArray<PickerItemModel *> * _Nullable)pickerDataSource {
    switch (self.type) {
        case CardOptionsItemModelTypeSet: {
            NSComparator comparator = ^NSComparisonResult(PickerItemModel *lhs, PickerItemModel *rhs) {
                HSCardSet lhsSet = HSCardSetFromNSString(lhs.identity);
                HSCardSet rhsSet = HSCardSetFromNSString(rhs.identity);
                
                if (lhsSet > rhsSet) {
                    return NSOrderedDescending;
                } else if (lhsSet < rhsSet) {
                    return NSOrderedAscending;
                } else {
                    return NSOrderedSame;
                }
            };
            return [self pickerItemModelsFromDic:hsCardSetsWithLocalizable()
                                      comparator:comparator];
        }
        case CardOptionsItemModelTypeClass: {
            NSComparator comparator = ^NSComparisonResult(PickerItemModel *lhs, PickerItemModel *rhs) {
                HSCardClass lhsClass = HSCardClassFromNSString(lhs.identity);
                HSCardClass rhsClass = HSCardClassFromNSString(rhs.identity);
                
                if (lhsClass > rhsClass) {
                    return NSOrderedDescending;
                } else if (lhsClass < rhsClass) {
                    return NSOrderedAscending;
                } else {
                    return NSOrderedSame;
                }
            };
            return [self pickerItemModelsFromDic:hsCardClassesWithLocalizable()
                                      comparator:comparator];
        }
        case CardOptionsItemModelTypeCollectible:
            return @[];
        case CardOptionsItemModelTypeRarity:
            return @[];
        case CardOptionsItemModelTypeType:
            return @[];
        case CardOptionsItemModelTypeMinionType:
            return @[];
        case CardOptionsItemModelTypeKeyword:
            return @[];
        case CardOptionsItemModelTypeSort:
            return @[];
        default:
            return nil;
    }
}

- (NSRange)stepperRange {
    switch (self.type) {
        case CardOptionsItemModelTypeManaCost:
            return NSMakeRange(0, 50);
        case CardOptionsItemModelTypeAttack:
            return NSMakeRange(0, 50);
        case CardOptionsItemModelTypeHealth:
            return NSMakeRange(0, 50);
        default:
            return NSMakeRange(0, 0);
    }
}

- (NSString *)text {
    switch (self.type) {
        case CardOptionsItemModelTypeSet:
            return @"확장팩 (번역)";
        case CardOptionsItemModelTypeClass:
            return @"직업 (번역)";
        case CardOptionsItemModelTypeManaCost:
            return @"카드 비용 (번역)";
        case CardOptionsItemModelTypeAttack:
            return @"하수인 공격력 (번역)";
        case CardOptionsItemModelTypeHealth:
            return @"하수인 체력 (번역)";
        case CardOptionsItemModelTypeCollectible:
            return @"수집 가능 (번역)";
        case CardOptionsItemModelTypeRarity:
            return @"카드 등급 (번역)";
        case CardOptionsItemModelTypeType:
            return @"카드 종류 (번역)";
        case CardOptionsItemModelTypeMinionType:
            return @"하수인 종류 (번역)";
        case CardOptionsItemModelTypeKeyword:
            return @"카드 키워드 (번역)";
        case CardOptionsItemModelTypeTextFilter:
            return @"카드 텍스트 (번역)";
        case CardOptionsItemModelTypeGameMode:
            return @"게임 모드 (번역)";
        case CardOptionsItemModelTypeSort:
            return @"결과 정렬 (번역)";
        default:
            return @"";
    }
}

- (NSString *)secondaryText {
    switch (self.type) {
        case CardOptionsItemModelTypeKeyword:
            return @"예시: 죽음의 메아리, 전투의 함성... (번역)";
        default:
            return nil;
    }
}

#pragma mark Helper

- (NSArray<PickerItemModel *> *)pickerItemModelsFromDic:(NSDictionary<NSString *, NSString *> *)dic
                                             comparator:(NSComparator)comparator {
    NSMutableArray<PickerItemModel *> *arr = [@[] mutableCopy];
    
    [dic enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull key, NSString * _Nonnull obj, BOOL * _Nonnull stop) {
        PickerItemModel *itemModel = [[PickerItemModel alloc] initWithImage:[UIImage imageNamed:key]
                                                                      title:obj
                                                                   identity:key];
        [arr addObject:itemModel];
        [itemModel release];
    }];
    
    [arr sortUsingComparator:comparator];
    
    NSArray<PickerItemModel *> *result = [[arr copy] autorelease];
    [arr release];
    return result;
}

@end
