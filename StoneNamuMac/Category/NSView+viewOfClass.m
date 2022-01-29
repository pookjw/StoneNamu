//
//  NSView+viewOfClass.m
//  StoneNamuMac
//
//  Created by Jinwoo Kim on 1/30/22.
//

#import "NSView+viewOfClass.h"

@implementation NSView (viewOfClass)

- (__kindof NSView *)subviewOfClass:(Class)class {
    for (NSView *subview in self.subviews) {
        if ([subview isKindOfClass:class]) {
            return subview;
        } else {
            return [subview subviewOfClass:class];
        }
    }
    
    return nil;
}

- (__kindof NSView *)superviewOfClass:(Class)class {
    if (self.superview == nil) {
        return nil;
    } else if ([self.superview isKindOfClass:class]) {
        return self.superview;
    } else {
        return [self.superview superviewOfClass:class];
    }
}

@end
