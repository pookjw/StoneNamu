//
//  NSCollectionView+setOrthogonalScrollViewBackgroundColor.m
//  StoneNamuMac
//
//  Created by Jinwoo Kim on 1/19/22.
//

#import "NSCollectionView+setOrthogonalScrollViewDrawsBackground.h"
#import <objc/runtime.h>

@implementation NSCollectionView (setOrthogonalScrollViewBackgroundColor)

+ (void)setOrthogonalScrollViewDrawsBackground:(BOOL)drawsBackground {
    Class _NSScrollViewContentBackgroundViewClass = NSClassFromString(@"_NSScrollViewContentBackgroundView");
    
    Method setBackgroundColorMethod = class_getInstanceMethod(_NSScrollViewContentBackgroundViewClass, NSSelectorFromString(@"setBackgroundColor:"));
    
    IMP originalSetBackgroundColorImp = method_getImplementation(setBackgroundColorMethod);
    
    void(^newSetBackgroundColorBlock)(id, NSColor *) = ^(id object, NSColor *backgroundColor) {
        typedef void (*fn)(id, SEL, NSColor *);
        fn f = (fn)originalSetBackgroundColorImp;
        f(object, NSSelectorFromString(@"setBackgroundColor:"), backgroundColor);
        
        if (([object isKindOfClass:_NSScrollViewContentBackgroundViewClass]) && ([[(NSView *)object superview] isKindOfClass:[NSScrollView class]])) {
            [(NSScrollView *)[(NSView *)object superview] setDrawsBackground:drawsBackground];
        }
    };
    
    IMP newSetBackgroundColorImp = imp_implementationWithBlock(newSetBackgroundColorBlock);
    
    method_setImplementation(setBackgroundColorMethod, newSetBackgroundColorImp);
}

@end
