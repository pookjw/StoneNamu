//
//  ZoomAnimatedTransitioning.m
//  ZoomAnimatedTransitioning
//
//  Created by Jinwoo Kim on 9/8/21.
//

#import "ZoomAnimatedTransitioning.h"

#define ZOOMANIMATEDTRANSITIONING_DURATION 0.3

@interface ZoomAnimatedTransitioning ()
@property BOOL animateForPresenting;
@end

@implementation ZoomAnimatedTransitioning

- (instancetype)initWithAnimateForPresenting:(BOOL)animateForPresenting {
    self = [self init];
    
    if (self) {
        self.animateForPresenting = animateForPresenting;
    }
    
    return self;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
    UIViewController *fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    UIView *fromView = fromViewController.view;
    UIView *toView = toViewController.view;
    UIView *containerView = transitionContext.containerView;
    
    //
    
    if (self.animateForPresenting) {
        [containerView addSubview:toView];
        toView.translatesAutoresizingMaskIntoConstraints = NO;
        [NSLayoutConstraint activateConstraints:@[
            [toView.topAnchor constraintEqualToAnchor:containerView.topAnchor],
            [toView.leadingAnchor constraintEqualToAnchor:containerView.leadingAnchor],
            [toView.bottomAnchor constraintEqualToAnchor:containerView.bottomAnchor],
            [toView.trailingAnchor constraintEqualToAnchor:containerView.trailingAnchor]
        ]];
        
        //
        
        fromView.transform = CGAffineTransformIdentity;
        toView.transform = CGAffineTransformMakeScale(1.3, 1.3);
        toView.alpha = 0.0;
        
        [UIView animateWithDuration:ZOOMANIMATEDTRANSITIONING_DURATION
                              delay:0
                            options:UIViewAnimationOptionCurveEaseInOut
                         animations:^{
            fromView.transform = CGAffineTransformMakeScale(0.9, 0.9);
            toView.alpha = 1;
            toView.transform = CGAffineTransformIdentity;
            toView.frame = [transitionContext finalFrameForViewController:toViewController];
        } completion:^(BOOL finished) {
            [transitionContext completeTransition:finished];
        }];
    } else {
        fromView.transform = CGAffineTransformIdentity;
        toView.transform = CGAffineTransformMakeScale(0.9, 0.9);
        
        [UIView animateWithDuration:ZOOMANIMATEDTRANSITIONING_DURATION
                              delay:0
                            options:UIViewAnimationOptionCurveEaseInOut
                         animations:^{
            fromView.transform = CGAffineTransformMakeScale(1.1, 1.1);
            fromView.alpha = 0;
            toView.transform = CGAffineTransformIdentity;
            toView.frame = [transitionContext finalFrameForViewController:toViewController];
        } completion:^(BOOL finished) {
            [transitionContext completeTransition:finished];
        }];
    }
}

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext {
    return ZOOMANIMATEDTRANSITIONING_DURATION;
}

@end