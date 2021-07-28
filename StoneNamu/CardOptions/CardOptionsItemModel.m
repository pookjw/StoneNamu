//
//  CardOptionsItemModel.m
//  StoneNamu
//
//  Created by Jinwoo Kim on 7/24/21.
//

#import "CardOptionsItemModel.h"
#import "BlizzardHSAPIKeys.h"
#import "HSCardSet.h"

NSString * NSStringFromCardOptionsItemModelType(CardOptionsItemModelType type) {
    switch (type) {
        case CardOptionsItemModelTypeSet:
            return NSStringFromOptionType(BlizzardHSAPIOptionTypeSet);
        case CardOptionsItemModelTypeClass:
            return NSStringFromOptionType(BlizzardHSAPIOptionTypeClass);
        case CardOptionsItemModelTypeManaCost:
            return NSStringFromOptionType(BlizzardHSAPIOptionTypeManaCost);
        case CardOptionsItemModelTypeAttack:
            return NSStringFromOptionType(BlizzardHSAPIOptionTypeAttack);
        case CardOptionsItemModelTypeHealth:
            return NSStringFromOptionType(BlizzardHSAPIOptionTypeHealth);
        case CardOptionsItemModelTypeCollectible:
            return NSStringFromOptionType(BlizzardHSAPIOptionTypeCollectible);
        case CardOptionsItemModelTypeRarity:
            return NSStringFromOptionType(BlizzardHSAPIOptionTypeRarity);
        case CardOptionsItemModelTypeType:
            return NSStringFromOptionType(BlizzardHSAPIOptionTypeType);
        case CardOptionsItemModelTypeMinionType:
            return NSStringFromOptionType(BlizzardHSAPIOptionTypeMinionType);
        case CardOptionsItemModelTypeKeyword:
            return NSStringFromOptionType(BlizzardHSAPIOptionTypeKeyword);
        case CardOptionsItemModelTypeTextFilter:
            return NSStringFromOptionType(BlizzardHSAPIOptionTypeTextFilter);
        case CardOptionsItemModelTypeGameMode:
            return NSStringFromOptionType(BlizzardHSAPIOptionTypeGameMode);
        case CardOptionsItemModelTypeSort:
            return NSStringFromOptionType(BlizzardHSAPIOptionTypeSort);
        default:
            return @"";
    }
}

@interface CardOptionsItemModel ()
@property (readonly, nonatomic) NSArray<PickerItemModel *> *hsCardSetsPickerItemModels;
@end

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
        case CardOptionsItemModelTypeSet:
            return self.hsCardSetsPickerItemModels;
        case CardOptionsItemModelTypeClass:
            return @[];
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

- (NSArray<PickerItemModel *> *)hsCardSetsPickerItemModels {
    NSMutableArray<PickerItemModel *> *arr = [@[] mutableCopy];
    
    [hsCardSetsWithLocalizable() enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull key, NSString * _Nonnull obj, BOOL * _Nonnull stop) {
        PickerItemModel *itemModel = [[PickerItemModel alloc] initWithImage:[UIImage imageNamed:key]
                                                                      title:obj
                                                                   identity:key];
        [arr addObject:itemModel];
        [itemModel release];
    }];
    
    NSArray<PickerItemModel *> *result = [[arr copy] autorelease];
    [arr release];
    return result;
}

@end
