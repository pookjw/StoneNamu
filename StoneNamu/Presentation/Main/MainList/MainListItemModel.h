//
//  MainItemModel.h
//  MainItemModel
//
//  Created by Jinwoo Kim on 10/15/21.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, MainItemModelType) {
    MainItemModelTypeCards,
    MainItemModelTypeDecks
};

@interface MainListItemModel : NSObject
@property (readonly) MainItemModelType type;
@property (readonly, nonatomic) UIImage * _Nullable primaryImage;
@property (readonly, nonatomic) NSString * _Nullable primaryText;
@property (readonly, nonatomic) NSString * _Nullable secondaryText;
+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithType:(MainItemModelType)type;
@end

NS_ASSUME_NONNULL_END
