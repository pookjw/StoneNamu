//
//  NSViewController+SpinnerView.m
//  StoneNamuMac
//
//  Created by Jinwoo Kim on 10/27/21.
//

#import "NSViewController+SpinnerView.h"
#import <QuartzCore/QuartzCore.h>

#define ANIMATION_DURATION 0.2f

@interface _SpinnerBlurView : NSVisualEffectView
@end

@implementation _SpinnerBlurView
@end

@implementation NSViewController (SpinnerView)

- (void)addSpinnerView {
    [self removeAllSpinnerview];
    
    _SpinnerBlurView *visualEffectView = [_SpinnerBlurView new];
    SpinnerView *spinnerView = [SpinnerView new];
    
    [self.view addSubview:visualEffectView];
    [visualEffectView addSubview:spinnerView];
    
    visualEffectView.translatesAutoresizingMaskIntoConstraints = NO;
    [NSLayoutConstraint activateConstraints:@[
        [visualEffectView.centerXAnchor constraintEqualToAnchor:self.view.centerXAnchor],
        [visualEffectView.centerYAnchor constraintEqualToAnchor:self.view.centerYAnchor],
        [visualEffectView.widthAnchor constraintEqualToConstant:100.0f],
        [visualEffectView.heightAnchor constraintEqualToConstant:100.0f]
    ]];
    
    spinnerView.translatesAutoresizingMaskIntoConstraints = NO;
    [NSLayoutConstraint activateConstraints:@[
        [spinnerView.topAnchor constraintEqualToAnchor:visualEffectView.topAnchor constant:15.0f],
        [spinnerView.leadingAnchor constraintEqualToAnchor:visualEffectView.leadingAnchor constant:15.0f],
        [spinnerView.trailingAnchor constraintEqualToAnchor:visualEffectView.trailingAnchor constant:-15.0f],
        [spinnerView.bottomAnchor constraintEqualToAnchor:visualEffectView.bottomAnchor constant:-15.0f]
    ]];
    
    visualEffectView.blendingMode = NSVisualEffectBlendingModeWithinWindow;
    visualEffectView.wantsLayer = YES;
    visualEffectView.layer.cornerRadius = 25.0f;
    visualEffectView.layer.cornerCurve = kCACornerCurveContinuous;
    
    [visualEffectView release];
    
    spinnerView.wantsLayer = YES;
    
    [CATransaction begin];
    CABasicAnimation *fade = [CABasicAnimation animationWithKeyPath:@"opacity"];
    fade.duration = ANIMATION_DURATION;
    fade.fromValue = [NSNumber numberWithFloat:0.0f];
    fade.toValue = [NSNumber numberWithFloat:1.0f];
    fade.removedOnCompletion = YES;
    [CATransaction setCompletionBlock:^{
        
    }];
    [spinnerView.layer addAnimation:fade forKey:@"fadeIn"];
    [CATransaction commit];
    
    spinnerView.layer.opacity = 1.0f;
    [spinnerView startAnimating];
    
    [spinnerView release];
}

- (void)removeAllSpinnerview {
    for (NSView *subview in self.view.subviews) {
        if ([subview isKindOfClass:[_SpinnerBlurView class]]) {
            subview.wantsLayer = YES;

            [CATransaction begin];
            CABasicAnimation *fade = [CABasicAnimation animationWithKeyPath:@"opacity"];
            fade.duration = ANIMATION_DURATION;
            fade.fromValue = [NSNumber numberWithFloat:1.0f];
            fade.toValue = [NSNumber numberWithFloat:0.0f];
            fade.removedOnCompletion = YES;
            [CATransaction setCompletionBlock:^{
                [subview removeFromSuperview];
            }];
            [subview.layer addAnimation:fade forKey:@"fadeOut"];
            [CATransaction commit];

            subview.layer.opacity = 0.0f;
        }
    }
}

@end
