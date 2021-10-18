//
//  UIView+floatingConstraints.m
//  StoneNamu
//
//  Created by Jinwoo Kim on 10/18/21.
//

#import "UIView+floatingConstraints.h"
#import <objc/runtime.h>

static NSString * const UIViewFloatingConstraintsKey = @"UIViewFloatingConstraintsKey";

@implementation UIView (floatingConstraints)

- (NSArray<NSLayoutConstraint *> *)floatingConstraints {
    id floatingConstraints = objc_getAssociatedObject(self, &UIViewFloatingConstraintsKey);
    
    if (floatingConstraints == NULL) {
        return nil;
    }
    
    return floatingConstraints;
}

- (void)setFloatingConstraints:(NSArray<NSLayoutConstraint *> *)floatingConstraints {
    objc_setAssociatedObject(self, &UIViewFloatingConstraintsKey, floatingConstraints, OBJC_ASSOCIATION_COPY);
}

@end
