//
//  UIViewController+SpinnerView.m
//  UIViewController+SpinnerView
//
//  Created by Jinwoo Kim on 8/29/21.
//

#import "UIViewController+SpinnerView.h"
#define ANIMATION_DURATION 0.2f

@interface _SpinnerBlurView : UIVisualEffectView
@end

@implementation _SpinnerBlurView
@end

@implementation UIViewController (SpinnerView)

- (void)addSpinnerView {
    for (UIView *subview in self.view.subviews) {
        if ([subview isKindOfClass:[_SpinnerBlurView class]]) {
            return;
        }
    }
    
    _SpinnerBlurView *visualEffectView = [[_SpinnerBlurView alloc] initWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleSystemChromeMaterial]];
    SpinnerView *spinnerView = [SpinnerView new];
    
    [self.view addSubview:visualEffectView];
    [visualEffectView.contentView addSubview:spinnerView];
    
    visualEffectView.translatesAutoresizingMaskIntoConstraints = NO;
    [NSLayoutConstraint activateConstraints:@[
        [visualEffectView.centerXAnchor constraintEqualToAnchor:self.view.centerXAnchor],
        [visualEffectView.centerYAnchor constraintEqualToAnchor:self.view.centerYAnchor],
        [visualEffectView.widthAnchor constraintEqualToConstant:100.0f],
        [visualEffectView.heightAnchor constraintEqualToConstant:100.0f]
    ]];
    
    spinnerView.translatesAutoresizingMaskIntoConstraints = NO;
    [NSLayoutConstraint activateConstraints:@[
        [spinnerView.topAnchor constraintEqualToAnchor:visualEffectView.contentView.topAnchor constant:15.0f],
        [spinnerView.leadingAnchor constraintEqualToAnchor:visualEffectView.contentView.leadingAnchor constant:15.0f],
        [spinnerView.trailingAnchor constraintEqualToAnchor:visualEffectView.contentView.trailingAnchor constant:-15.0f],
        [spinnerView.bottomAnchor constraintEqualToAnchor:visualEffectView.contentView.bottomAnchor constant:-15.0f]
    ]];
    
    [spinnerView startAnimating];
    [spinnerView release];
    
    visualEffectView.clipsToBounds = YES;
    visualEffectView.layer.cornerRadius = 25.0f;
    visualEffectView.layer.cornerCurve = kCACornerCurveContinuous;
    
    visualEffectView.alpha = 0;
    [UIView animateWithDuration:ANIMATION_DURATION animations:^{
        visualEffectView.alpha = 1;
    } completion:^(BOOL finished) {
        [visualEffectView release];
    }];
    
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
    UIApplication.sharedApplication.networkActivityIndicatorVisible = YES;
}

- (void)removeAllSpinnerview {
    for (UIView *subview in self.view.subviews) {
        if ([subview isKindOfClass:[_SpinnerBlurView class]]) {
            [UIView animateWithDuration:ANIMATION_DURATION animations:^{
                subview.alpha = 0.0f;
            } completion:^(BOOL finished) {
                [subview removeFromSuperview];
            }];
        }
    }
    
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
    UIApplication.sharedApplication.networkActivityIndicatorVisible = NO;
}

@end
