//
//  FloatingPresentationController.m
//  StoneNamu
//
//  Created by Jinwoo Kim on 10/18/21.
//

#import "FloatingPresentationController.h"
#import "UIView+floatingConstraints.h"

@interface FloatingPresentationController ()
@property (retain) UIView *backgroundView;
@end

@implementation FloatingPresentationController

- (instancetype)initWithPresentedViewController:(UIViewController *)presentedViewController
                       presentingViewController:(UIViewController *)presentingViewController
                                 backgroundView:(UIView *)backgroundView {
    self = [self initWithPresentedViewController:presentedViewController presentingViewController:presentingViewController];
    
    if (self) {
        self.backgroundView = backgroundView;
        
        [self bind];
    }
    
    return self;
}

- (void)dealloc {
    [_backgroundView release];
    [super dealloc];
}

- (void)presentationTransitionWillBegin {
    [super presentationTransitionWillBegin];
    
    //
    
    [self.backgroundView removeFromSuperview];
    [self.containerView addSubview:self.backgroundView];
    self.backgroundView.translatesAutoresizingMaskIntoConstraints = NO;
    
    [NSLayoutConstraint activateConstraints:@[
        [self.backgroundView.topAnchor constraintEqualToAnchor:self.containerView.topAnchor],
        [self.backgroundView.leadingAnchor constraintEqualToAnchor:self.containerView.leadingAnchor],
        [self.backgroundView.trailingAnchor constraintEqualToAnchor:self.containerView.trailingAnchor],
        [self.backgroundView.bottomAnchor constraintEqualToAnchor:self.containerView.bottomAnchor]
    ]];
    
    self.backgroundView.alpha = 0.0f;
    
    [self.presentedViewController.transitionCoordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext>  _Nonnull context) {
        self.backgroundView.alpha = 1.0f;
    } completion:^(id<UIViewControllerTransitionCoordinatorContext>  _Nonnull context) {
        
    }];
    
    //
    
    self.presentedView.layer.cornerRadius = FLOATINGPRESENTATIONCONTROLLER_CORNERRADIUS;
    self.presentedView.layer.cornerCurve = kCACornerCurveContinuous;
    self.presentedView.layer.masksToBounds = YES;
}

- (void)dismissalTransitionWillBegin {
    [super dismissalTransitionWillBegin];
    
    [self.presentedViewController.transitionCoordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext>  _Nonnull context) {
        self.backgroundView.alpha = 0.0f;
    } completion:^(id<UIViewControllerTransitionCoordinatorContext>  _Nonnull context) {
        if (!context.isCancelled) {
            [self.backgroundView removeFromSuperview];
        }
    }];
}

- (void)bind {
    [NSNotificationCenter.defaultCenter addObserver:self
                                           selector:@selector(keyboardWillShowReceived:)
                                               name:UIKeyboardWillShowNotification
                                             object:nil];
    
    [NSNotificationCenter.defaultCenter addObserver:self
                                           selector:@selector(keyboardWillHideReceived:)
                                               name:UIKeyboardWillHideNotification
                                             object:nil];
    
    [NSNotificationCenter.defaultCenter addObserver:self
                                           selector:@selector(keyboardWillChangeFrameReceived:)
                                               name:UIKeyboardDidChangeFrameNotification
                                             object:nil];
}

- (void)keyboardWillShowReceived:(NSNotification *)notification {
    [self handleKeyboardEvent:notification];
}

- (void)keyboardWillHideReceived:(NSNotification *)notification {
    [self handleKeyboardEvent:notification];
}

- (void)keyboardWillChangeFrameReceived:(NSNotification *)notification {
    [self handleKeyboardEvent:notification];
}

- (void)handleKeyboardEvent:(NSNotification *)notification {
    [NSOperationQueue.mainQueue addOperationWithBlock:^{
        NSLayoutConstraint * _Nullable bottomLayout = nil;
        NSLayoutConstraint * _Nullable centerYLayout = nil;
        
        for (NSLayoutConstraint *constraint in self.presentedView.floatingConstraints) {
            if ((bottomLayout != nil) && (centerYLayout != nil)) {
                break;
            }
            
            if ((constraint.firstAttribute == NSLayoutAttributeBottom) || (constraint.secondAttribute == NSLayoutAttributeBottom)) {
                bottomLayout = constraint;
                continue;
            } else if ((constraint.firstAttribute == NSLayoutAttributeCenterY) || (constraint.secondAttribute == NSLayoutAttributeCenterY)) {
                centerYLayout = constraint;
                continue;
            }
        }
        
        //
        
        UIViewAnimationCurve curve = [(NSNumber *)notification.userInfo[UIKeyboardAnimationCurveUserInfoKey] integerValue];
        double duration = [(NSNumber *)notification.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
        CGRect endFrame = [(NSValue *)notification.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
        
        // getting height from frame is not accurate because it's not actually height of presented on current window.
        CGFloat height = self.presentedView.window.bounds.size.height - endFrame.origin.y;
        
        if (height < 0) {
            height = 0;
        }
        
        centerYLayout.constant = -(height) / 2;
        bottomLayout.constant = -(height);
        
        [UIView animateWithDuration:duration
                              delay:0
                            options:curve << 16
                         animations:^{
            [self.presentedView.superview layoutIfNeeded];
        } completion:^(BOOL finished) {
            
        }];
    }];
}

@end
