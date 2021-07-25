//
//  CardOptionsItemModel.h
//  StoneNamu
//
//  Created by Jinwoo Kim on 7/24/21.
//

#import <Foundation/Foundation.h>
#import "PickerItemModel.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, CardOptionsItemModelType) {
    CardOptionsItemModelTypeSet,
    CardOptionsItemModelTypeClass,
    CardOptionsItemModelTypeManaCost,
    CardOptionsItemModelTypeAttack,
    CardOptionsItemModelTypeHealth,
    CardOptionsItemModelTypeCollectible,
    CardOptionsItemModelTypeRarity,
    CardOptionsItemModelTypeType,
    CardOptionsItemModelTypeMinionType,
    CardOptionsItemModelTypeKeyword,
    CardOptionsItemModelTypeTextFilter,
    CardOptionsItemModelTypeGameMode,
    CardOptionsItemModelTypeSort
};

typedef NS_ENUM(NSUInteger, CardOptionsItemModelValueSetType) {
    CardOptionsItemModelValueSetTypeTextField,
    CardOptionsItemModelValueSetTypePicker,
    CardOptionsItemModelValueSetTypeStepper
};

NSString * NSStringFromCardOptionsItemModelType(CardOptionsItemModelType);

@interface CardOptionsItemModel : NSObject
@property (readonly) CardOptionsItemModelType type;
@property (copy) NSString * _Nullable value;
@property (readonly, nonatomic) CardOptionsItemModelValueSetType valueSetType;
@property (readonly, nonatomic) NSArray<PickerItemModel *> * _Nullable pickerDataSource;
@property (readonly, nonatomic) NSRange stepperRange;
@property (readonly, nonatomic) NSString *text;
@property (readonly, nonatomic) NSString * _Nullable secondaryText;
- (instancetype)initWithType:(CardOptionsItemModelType)type;
@end

NS_ASSUME_NONNULL_END
