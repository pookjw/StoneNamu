//
//  UIFont+customFonts.h
//  UIFont+customFonts
//
//  Created by Jinwoo Kim on 9/15/21.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, UIFontCustomFontType) {
    UIFontCustomFontTypeGmarketSansBold,
    UIFontCustomFontTypeGmarketSansLight,
    UIFontCustomFontTypeGmarketSansMedium,
};

@interface UIFont (customFonts)
+ (UIFont *)customFontWithType:(UIFontCustomFontType)type size:(CGFloat)size;
@end

NS_ASSUME_NONNULL_END
