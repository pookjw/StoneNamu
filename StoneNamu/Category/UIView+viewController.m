//
//  UIView+viewController.m
//  UIView+viewController
//
//  Created by Jinwoo Kim on 8/16/21.
//

#import "UIView+viewController.h"

@implementation UIView (viewController)

- (UIViewController * _Nullable)viewController {
    id nextResponder = self.nextResponder;
    
    if ([nextResponder isKindOfClass:[UIViewController class]]) {
        return nextResponder;
    } else if ([nextResponder isKindOfClass:[UIView class]]) {
        return [nextResponder viewController];
    } else {
        return nil;
    }
}

@end
