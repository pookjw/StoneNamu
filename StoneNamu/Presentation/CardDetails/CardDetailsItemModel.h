//
//  CardDetailsItemModel.h
//  CardDetailsItemModel
//
//  Created by Jinwoo Kim on 8/4/21.
//

#import <Foundation/Foundation.h>
#import "HSCard.h"

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
@property (readonly, nonatomic) NSString * _Nullable primaryText;
@property (readonly, nonatomic) NSString * _Nullable secondaryText;
@property (readonly, nonatomic, copy) NSArray<HSCard *> * _Nullable childCards;
+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithType:(CardDetailsItemModelType)type value:(NSString * _Nullable)value;
- (instancetype)initWithType:(CardDetailsItemModelType)type childCards:(NSArray<HSCard *> *)childCards;
@end

NS_ASSUME_NONNULL_END
