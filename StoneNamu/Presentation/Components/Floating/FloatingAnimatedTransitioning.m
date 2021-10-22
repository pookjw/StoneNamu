//
//  FloatingAnimatedTransitioning.m
//  FloatingAnimatedTransitioning
//
//  Created by Jinwoo Kim on 9/8/21.
//

#import "FloatingAnimatedTransitioning.h"
#import "UIView+floatingConstraints.h"

#define FLOATINGANIMATEDTRANSITIONING_DURATION 0.3f

@interface FloatingAnimatedTransitioning ()
@property BOOL animateForPresenting;
@property (retain) NSNumber * _Nullable maxWidth;
@property (retain) NSNumber * _Nullable maxHeight;
@end

@implementation FloatingAnimatedTransitioning

- (instancetype)initWithAnimateForPresenting:(BOOL)animateForPresenting maxWidth:(CGFloat)maxWidth {
    self = [self init];
    
    if (self) {
        self.animateForPresenting = animateForPresenting;
        self.maxWidth = [NSNumber numberWithFloat:maxWidth];
        self.maxHeight = nil;
    }
    
    return self;
}

- (instancetype)initWithAnimateForPresenting:(BOOL)animateForPresenting maxHeight:(CGFloat)maxHeight {
    self = [self init];
    
    if (self) {
        self.animateForPresenting = animateForPresenting;
        self.maxWidth = nil;
        self.maxHeight = [NSNumber numberWithFloat:maxHeight];
    }
    
    return self;
}

- (instancetype)initWithAnimateForPresenting:(BOOL)animateForPresenting maxWidth:(CGFloat)maxWidth maxHeight:(CGFloat)maxHeight {
    self = [self init];
    
    if (self) {
        self.animateForPresenting = animateForPresenting;
        self.maxWidth = [NSNumber numberWithFloat:maxWidth];
        self.maxHeight = [NSNumber numberWithFloat:maxHeight];
    }
    
    return self;
}

- (void)dealloc {
    [_maxWidth release];
    [_maxHeight release];
    [super dealloc];
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
        
        //
        
        NSMutableArray<NSLayoutConstraint *> *allConstraints = [@[] mutableCopy];
        
        NSLayoutConstraint *topLayout = [toView.topAnchor constraintEqualToAnchor:containerView.safeAreaLayoutGuide.topAnchor];
        NSLayoutConstraint *leadingLayout = [toView.leadingAnchor constraintEqualToAnchor:containerView.safeAreaLayoutGuide.leadingAnchor];
        NSLayoutConstraint *trailingLayout = [toView.trailingAnchor constraintEqualToAnchor:containerView.safeAreaLayoutGuide.trailingAnchor];
        NSLayoutConstraint *bottomLayout = [toView.bottomAnchor constraintEqualToAnchor:containerView.safeAreaLayoutGuide.bottomAnchor];
        NSLayoutConstraint *centerXLayout = [toView.centerXAnchor constraintEqualToAnchor:containerView.safeAreaLayoutGuide.centerXAnchor];
        NSLayoutConstraint *centerYLayout = [toView.centerYAnchor constraintEqualToAnchor:containerView.safeAreaLayoutGuide.centerYAnchor];
        
        topLayout.priority = UILayoutPriorityDefaultHigh;
        leadingLayout.priority = UILayoutPriorityDefaultHigh;
        trailingLayout.priority = UILayoutPriorityDefaultHigh;
        bottomLayout.priority = UILayoutPriorityDefaultHigh;
        centerXLayout.priority = UILayoutPriorityDefaultHigh;
        centerYLayout.priority = UILayoutPriorityDefaultHigh;
        
        [allConstraints addObjectsFromArray:@[
            topLayout,
            leadingLayout,
            trailingLayout,
            bottomLayout,
            centerXLayout,
            centerYLayout
        ]];
        
        if (self.maxWidth != nil) {
            NSLayoutConstraint *widthLayout = [toView.widthAnchor constraintLessThanOrEqualToConstant:self.maxWidth.floatValue];
            widthLayout.priority = UILayoutPriorityRequired;
            [allConstraints addObject:widthLayout];
        }
        
        if (self.maxHeight != nil) {
            NSLayoutConstraint *heightLayout = [toView.heightAnchor constraintLessThanOrEqualToConstant:self.maxHeight.floatValue];
            heightLayout.priority = UILayoutPriorityRequired;
            [allConstraints addObject:heightLayout];
        }
        
        [NSLayoutConstraint activateConstraints:allConstraints];
        toView.floatingConstraints = allConstraints;
        [allConstraints release];
        
        [toView layoutIfNeeded];
        
        //
        
        fromView.transform = CGAffineTransformIdentity;
        toView.transform = CGAffineTransformMakeScale(1.2f, 1.2f);
        toView.alpha = 0.0f;
        
        [UIView animateWithDuration:FLOATINGANIMATEDTRANSITIONING_DURATION
                              delay:0
                            options:UIViewAnimationOptionCurveEaseInOut
                         animations:^{
            fromView.transform = CGAffineTransformMakeScale(0.9f, 0.9f);
            toView.alpha = 1.0f;
            toView.transform = CGAffineTransformIdentity;
            //            toView.frame = [transitionContext finalFrameForViewController:toViewController];
        } completion:^(BOOL finished) {
            [transitionContext completeTransition:finished];
        }];
    } else {
        UIView *fromView = fromViewController.view;
        fromView.transform = CGAffineTransformIdentity;
        toView.transform = CGAffineTransformMakeScale(0.9f, 0.9f);
        
        [UIView animateWithDuration:FLOATINGANIMATEDTRANSITIONING_DURATION
                              delay:0
                            options:UIViewAnimationOptionCurveEaseInOut
                         animations:^{
            fromView.transform = CGAffineTransformMakeScale(0.9f, 0.9f);
            fromView.alpha = 0.0f;
            toView.transform = CGAffineTransformIdentity;
            toView.frame = [transitionContext finalFrameForViewController:toViewController];
        } completion:^(BOOL finished) {
            [fromView removeFromSuperview];
            [transitionContext completeTransition:finished];
        }];
    }
}

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext {
    return FLOATINGANIMATEDTRANSITIONING_DURATION;
}

@end
