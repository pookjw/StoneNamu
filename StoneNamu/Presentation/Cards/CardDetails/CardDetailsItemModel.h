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
    CardDetailsItemModelTypeInfo,
    CardDetailsItemModelTypeChild
};

@interface CardDetailsItemModel : NSObject
@property (readonly) CardDetailsItemModelType type;
@property (readonly, copy) NSString * _Nullable primaryText;
@property (readonly, copy) NSString * _Nullable secondaryText;
@property (readonly, copy) HSCard * _Nullable childHSCard;
+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithPrimaryText:(NSString *)primaryText secondaryText:(NSString * _Nullable)secondaryText;
- (instancetype)initWithChildHSCard:(HSCard *)childHSCard;
@end

NS_ASSUME_NONNULL_END
