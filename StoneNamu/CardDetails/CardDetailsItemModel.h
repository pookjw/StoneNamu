//
//  CardDetailsItemModel.h
//  CardDetailsItemModel
//
//  Created by Jinwoo Kim on 8/4/21.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, CardDetailsItemModelType) {
    CardDetailsItemModelTypeName,
    CardDetailsItemModelTypeFlavorText,
    CardDetailsItemModelTypeText,
    CardDetailsItemModelTypeType,
    CardDetailsItemModelTypeRarity,
    CardDetailsItemModelTypeSet,
    CardDetailsItemModelTypeClass,
    CardDetailsItemModelTypeArtist,
    CardDetailsItemModelTypeCollectible,
    CardDetailsItemModelTypeChildren
};

@interface CardDetailsItemModel : NSObject
@property (readonly) CardDetailsItemModelType type;
@property (readonly, nonatomic) NSString * _Nullable text;
@property (readonly, nonatomic) NSString * _Nullable accessoryText;
- (instancetype)initWithType:(CardDetailsItemModelType)type value:(NSString * _Nullable)value;
@end

NS_ASSUME_NONNULL_END
