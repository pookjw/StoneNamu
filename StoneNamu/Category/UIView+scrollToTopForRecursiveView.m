//
//  UIView+scrollToTopForRecursiveView.m
//  UIView+scrollToTopForRecursiveView
//
//  Created by Jinwoo Kim on 8/17/21.
//

#import "UIView+scrollToTopForRecursiveView.h"
#import "UIScrollView+scrollToTop.h"

@implementation UIView (scrollToTopForRecursiveView)

- (void)scrollToTopWithRecursiveAnimated:(BOOL)animated {
    if ([self isKindOfClass:[UIScrollView class]]) {
        UIScrollView *scrollView = (UIScrollView *)self;
        [scrollView scrollToTopAnimated:animated];
    } else {
        for (UIView *subview in self.subviews) {
            [subview scrollToTopWithRecursiveAnimated:animated];
        }
    }
}

@end
