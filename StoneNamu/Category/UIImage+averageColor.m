//
//  UIImage+averageColor.m
//  UIImage+averageColor
//
//  Created by Jinwoo Kim on 8/23/21.
//

#import "UIImage+averageColor.h"

/*
 https://gist.github.com/ygit/ff8b591b7373ba740a04
 */

@implementation UIImage (averageColor)

- (UIColor * _Nullable)averageColor {
    CGSize size = {1, 1};
    UIGraphicsBeginImageContext(size);
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextSetInterpolationQuality(ctx, kCGInterpolationMedium);
    [self drawInRect:(CGRect){.size = size} blendMode:kCGBlendModeCopy alpha:1];
    uint8_t *data = CGBitmapContextGetData(ctx);
    UIColor *color = [UIColor colorWithRed:data[2] / 255.0f
                                     green:data[1] / 255.0f
                                      blue:data[0] / 255.0f
                                     alpha:1];
    UIGraphicsEndImageContext();
    return color;
}

@end
