//
//  PrefsItemModel.h
//  PrefsItemModel
//
//  Created by Jinwoo Kim on 8/14/21.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, PrefsItemModelType) {
    PrefsItemModelTypeLocaleSelection,
    PrefsItemModelTypeRegionSelection,
    PrefsItemModelTypeJinwooKimContributor,
    PrefsItemModelTypePnamuContributor
};

@interface PrefsItemModel : NSObject
@property (readonly) PrefsItemModelType type;
@property (readonly, nonatomic) UIImage * _Nullable primaryImage;
@property (readonly, nonatomic) NSString * _Nullable primaryText;
@property (readonly, nonatomic) NSString * _Nullable secondaryText;
@property (copy) NSString * _Nullable accessoryText;
@property (readonly, nonatomic) BOOL hasDisclosure;
- (instancetype)initWithType:(PrefsItemModelType)type;
@end

NS_ASSUME_NONNULL_END
