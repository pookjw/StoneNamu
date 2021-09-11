//
//  UIView+imageRendered.m
//  UIView+imageRendered
//
//  Created by Jinwoo Kim on 9/10/21.
//

#import "UIView+imageRendered.h"

@implementation UIView (imageRendered)

- (UIImage *)imageRendered {
    UIGraphicsImageRenderer *renderer = [[UIGraphicsImageRenderer alloc] initWithBounds:self.bounds];
    UIImage *imageRendered = [renderer imageWithActions:^(UIGraphicsImageRendererContext * _Nonnull rendererContext) {
        [self.layer renderInContext:rendererContext.CGContext];
    }];
    [renderer release];
    return imageRendered;
}

@end
