//
//  UIScrollView+scrollToTop.m
//  UIScrollView+scrollToTop
//
//  Created by Jinwoo Kim on 8/17/21.
//

#import "UIScrollView+scrollToTop.h"

@implementation UIScrollView (scrollToTop)

- (void)scrollToTopAnimated:(BOOL)animated {
    CGPoint offset = CGPointMake(-self.adjustedContentInset.left, -self.adjustedContentInset.top);
    [self setContentOffset:offset animated:animated];
}

@end
