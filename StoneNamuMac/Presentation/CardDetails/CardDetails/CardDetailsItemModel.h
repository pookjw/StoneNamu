//
//  CardDetailsItemModel.h
//  StoneNamuMac
//
//  Created by Jinwoo Kim on 11/22/21.
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
@property (readonly, copy) HSCardGameModeSlugType _Nullable hsCardGameModeSlugType;
@property (readonly) BOOL isGold;
@property (readonly, copy) NSURL * _Nullable imageURL;
+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithType:(CardDetailsItemModelType)type value:(NSString * _Nullable)value;
- (instancetype)initWithType:(CardDetailsItemModelType)type childHSCard:(HSCard *)childHSCard hsCardGameModeSlugType:(HSCardGameModeSlugType)hsCardGameModeSlugType isGold:(BOOL)isGold imageURL:(NSURL * _Nullable)imageURL;
@end

NS_ASSUME_NONNULL_END
