//
//  UIView+removeAllSubviews.m
//  UIView+removeAllSubviews
//
//  Created by Jinwoo Kim on 9/8/21.
//

#import "UIView+removeAllSubviews.h"

@implementation UIView (removeAllSubviews)

- (void)removeAllSubviews {
    NSArray<UIView *> *subviews = self.subviews;
    
    for (UIView *subview in subviews) {
        [subview removeFromSuperview];
    }
}

@end
