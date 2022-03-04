//
//  CardDetailsItemModel.h
//  CardDetailsItemModel
//
//  Created by Jinwoo Kim on 8/4/21.
//

#import <Foundation/Foundation.h>
#import <StoneNamuCore/StoneNamuCore.h>

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
    CardDetailsItemModelTypeChild
};

@interface CardDetailsItemModel : NSObject
@property (readonly) CardDetailsItemModelType type;
@property (readonly, copy) NSString * _Nullable primaryText;
@property (readonly, copy) NSString * _Nullable secondaryText;
@property (readonly, copy) HSCard * _Nullable childHSCard;
@property (readonly, copy) NSURL * _Nullable imageURL;
@property (readonly) BOOL isGold;
+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithType:(CardDetailsItemModelType)type secondaryText:(NSString * _Nullable)secondaryText;
- (instancetype)initWithType:(CardDetailsItemModelType)type childHSCard:(HSCard *)childHSCard imageURL:(NSURL * _Nullable)imageURL isGold:(BOOL)isGold;
@end

NS_ASSUME_NONNULL_END
