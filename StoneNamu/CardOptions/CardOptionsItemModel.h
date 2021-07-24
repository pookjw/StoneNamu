//
//  CardOptionsItemModel.h
//  StoneNamu
//
//  Created by Jinwoo Kim on 7/24/21.
//

#import <Foundation/Foundation.h>

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

@interface CardOptionsItemModel : NSObject
@property (readonly) CardOptionsItemModelType type;
@property (copy) NSString *value;
@property (readonly) NSString * _Nullable text;
@property (readonly) NSString * _Nullable secondaryText;
- (instancetype)initWithType:(CardOptionsItemModelType)type;
@end

NS_ASSUME_NONNULL_END
