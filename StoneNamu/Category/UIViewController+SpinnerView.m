//
//  UIViewController+SpinnerView.m
//  UIViewController+SpinnerView
//
//  Created by Jinwoo Kim on 8/29/21.
//

#import "UIViewController+SpinnerView.h"
#define ANIMATION_DURATION 0.2

@implementation UIViewController (SpinnerView)

- (SpinnerView *)addSpinnerView {
    return [self addSpinnerViewWithPreventTouch:NO];
}

- (SpinnerView *)addSpinnerViewWithPreventTouch:(BOOL)preventTouch {
    SpinnerView *spinnerView = [SpinnerView new];
    
    spinnerView.userInteractionEnabled = preventTouch;

    [self.view addSubview:spinnerView];

    spinnerView.translatesAutoresizingMaskIntoConstraints = NO;
    [NSLayoutConstraint activateConstraints:@[
        [spinnerView.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor],
        [spinnerView.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor],
        [spinnerView.topAnchor constraintEqualToAnchor:self.view.topAnchor],
        [spinnerView.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor]
    ]];
    
    spinnerView.alpha = 0;
    [UIView animateWithDuration:ANIMATION_DURATION animations:^{
        spinnerView.alpha = 1;
    }];
    
    UIApplication.sharedApplication.networkActivityIndicatorVisible = YES;

    return [spinnerView autorelease];
}

- (void)removeAllSpinnerview {
    for (UIView *subview in self.view.subviews) {
        if ([subview isKindOfClass:[SpinnerView class]]) {
            [UIView animateWithDuration:ANIMATION_DURATION animations:^{
                subview.alpha = 0;
            } completion:^(BOOL finished) {
                [subview removeFromSuperview];
            }];
        }
    }
    
    UIApplication.sharedApplication.networkActivityIndicatorVisible = NO;
}

@end
