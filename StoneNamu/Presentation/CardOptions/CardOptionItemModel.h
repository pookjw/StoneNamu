//
//  CardOptionItemModel.h
//  StoneNamu
//
//  Created by Jinwoo Kim on 7/24/21.
//

#import <Foundation/Foundation.h>
#import "PickerItemModel.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, CardOptionItemModelType) {
    CardOptionItemModelTypeSet,
    CardOptionItemModelTypeClass,
    CardOptionItemModelTypeManaCost,
    CardOptionItemModelTypeAttack,
    CardOptionItemModelTypeHealth,
    CardOptionItemModelTypeCollectible,
    CardOptionItemModelTypeRarity,
    CardOptionItemModelTypeType,
    CardOptionItemModelTypeMinionType,
    CardOptionItemModelTypeKeyword,
    CardOptionItemModelTypeTextFilter,
    CardOptionItemModelTypeGameMode,
    CardOptionItemModelTypeSort
};

typedef NS_ENUM(NSUInteger, CardOptionItemModelValueSetType) {
    CardOptionItemModelValueSetTypeTextField,
    CardOptionItemModelValueSetTypePicker,
    CardOptionItemModelValueSetTypePickerWithEmptyRow,
    CardOptionItemModelValueSetTypeStepper
};

NSString * NSStringFromCardOptionItemModelType(CardOptionItemModelType);
CardOptionItemModelType CardOptionItemModelTypeFromNSString(NSString *);

@interface CardOptionItemModel : NSObject
@property (readonly) CardOptionItemModelType type;
@property (copy) NSString * _Nullable value;
@property (readonly, nonatomic) NSString * _Nullable defaultValue;
@property (readonly, nonatomic) CardOptionItemModelValueSetType valueSetType;
@property (readonly, nonatomic) NSArray<PickerItemModel *> * _Nullable pickerDataSource;
@property (readonly, nonatomic) NSRange stepperRange;
@property (readonly, nonatomic) NSString *text;
@property (readonly, nonatomic) NSString * _Nullable accessoryText;
- (instancetype)initWithType:(CardOptionItemModelType)type;
@end

NS_ASSUME_NONNULL_END
