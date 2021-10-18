//
//  DynamicAnimatedTransitioning.m
//  DynamicAnimatedTransitioning
//
//  Created by Jinwoo Kim on 10/19/21.
//

#import "DynamicAnimatedTransitioning.h"

#define DYNAMICANIMATEDTRANSITIONING_DURATION 0.3f

@interface DynamicAnimatedTransitioning ()
@property BOOL isPresenting;
@end

@implementation DynamicAnimatedTransitioning

- (instancetype)initWithIsPresenting:(BOOL)isPresenting {
    self = [self init];
    
    if (self) {
        self.isPresenting = isPresenting;
    }
    
    return self;
}

- (void)animateTransition:(nonnull id<UIViewControllerContextTransitioning>)transitionContext {
    UIViewController *fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    UIView *fromView = fromViewController.view;
    UIView *toView = toViewController.view;
    UIView *containerView = transitionContext.containerView;
    
    if (self.isPresenting) {
        [containerView addSubview:toView];
        toView.translatesAutoresizingMaskIntoConstraints = NO;
        
        [NSLayoutConstraint activateConstraints:@[
            [toView.topAnchor constraintEqualToAnchor:containerView.topAnchor],
            [toView.leadingAnchor constraintEqualToAnchor:containerView.leadingAnchor],
            [toView.trailingAnchor constraintEqualToAnchor:containerView.trailingAnchor],
            [toView.bottomAnchor constraintEqualToAnchor:containerView.bottomAnchor]
        ]];
        
        [containerView layoutIfNeeded];
        
        toView.alpha = 0.0f;
        
        [UIView animateWithDuration:DYNAMICANIMATEDTRANSITIONING_DURATION
                              delay:0
                            options:UIViewAnimationOptionCurveEaseOut
                         animations:^{
            
        } completion:^(BOOL finished) {
            [transitionContext completeTransition:finished];
            
            [UIView animateWithDuration:DYNAMICANIMATEDTRANSITIONING_DURATION
                                  delay:0
                                options:UIViewAnimationOptionCurveEaseOut
                             animations:^{
                toView.alpha = 1.0f;
            } completion:^(BOOL finished) {
                
            }];
        }];
    } else {
        [UIView animateWithDuration:DYNAMICANIMATEDTRANSITIONING_DURATION
                              delay:0
                            options:UIViewAnimationOptionCurveEaseOut
                         animations:^{
            fromView.alpha = 0.0f;
        } completion:^(BOOL finished) {
            [fromView removeFromSuperview];
            [transitionContext completeTransition:finished];
        }];
    }
}

- (NSTimeInterval)transitionDuration:(nullable id<UIViewControllerContextTransitioning>)transitionContext {
    return DYNAMICANIMATEDTRANSITIONING_DURATION;
}

@end
