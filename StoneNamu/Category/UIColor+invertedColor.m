//
//  UIColor+invertedColor.m
//  UIColor+invertedColor
//
//  Created by Jinwoo Kim on 8/23/21.
//

#import "UIColor+invertedColor.h"

@implementation UIColor (invertedColor)

- (UIColor *)invertedColor {
    CIColor *ciColor = [CIColor colorWithCGColor:self.CGColor];
    CGFloat red = 1 - ciColor.red;
    CGFloat green = 1 - ciColor.green;
    CGFloat blue = 1 - ciColor.blue;
    
    return [UIColor colorWithRed:red green:green blue:blue alpha:ciColor.alpha];
}

@end
