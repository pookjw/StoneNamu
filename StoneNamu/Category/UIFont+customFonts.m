//
//  UIFont+customFonts.m
//  UIFont+customFonts
//
//  Created by Jinwoo Kim on 9/15/21.
//

#import "UIFont+customFonts.h"

NSString * _Nullable NSStringFromUIFontCustomFontType(UIFontCustomFontType type) {
    switch (type) {
        case UIFontCustomFontTypeGmarketSansBold:
            return @"GmarketSansTTFBold";
        case UIFontCustomFontTypeGmarketSansLight:
            return @"GmarketSansTTFLight";
        case UIFontCustomFontTypeGmarketSansMedium:
            return @"GmarketSansTTFMedium";
        default:
            return nil;
    }
}

@implementation UIFont (customFonts)

+ (UIFont *)customFontWithType:(UIFontCustomFontType)type size:(CGFloat)size {
    UIFont *customFont = [UIFont fontWithName:NSStringFromUIFontCustomFontType(type) size:size];
    UIFont *result = [UIFontMetrics.defaultMetrics scaledFontForFont:customFont];
    return result;
}

@end
