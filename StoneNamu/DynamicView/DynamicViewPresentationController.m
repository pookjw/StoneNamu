//
//  DynamicViewPresentationController.m
//  DynamicViewPresentationController
//
//  Created by Jinwoo Kim on 8/2/21.
//

#import "DynamicViewPresentationController.h"

@interface DynamicViewPresentationController ()
@property CGRect destinationRect;
@property (nonatomic) CGRect sourceViewRect;
@property (nonatomic) CGRect targetViewRect;
@property (retain) UIVisualEffectView *visualEffectView;
@property (retain) UIView *sourceView;
@property (retain) UIView *targetView;
@end

@implementation DynamicViewPresentationController

- (instancetype)initWithPresentedViewController:(UIViewController *)presentedViewController
                       presentingViewController:(UIViewController *)presentingViewController
                                     sourceView:(UIView *)sourceView
                                    targetView:(UIView *)targetView
                                destinationRect:(CGRect)destinationRect {
    self = [self initWithPresentedViewController:presentedViewController presentingViewController:presentingViewController];
    
    if (self) {
        self.sourceView = sourceView;
        self.targetView = targetView;
        self.destinationRect = destinationRect;
    }
    
    return self;
}

- (void)dealloc {
    [_visualEffectView release];
    [_sourceView release];
    [_targetView release];
    [super dealloc];
}

- (void)presentationTransitionWillBegin {
    [super presentationTransitionWillBegin];
    [self configureVisualEffectView];
    [self animateVisualEffectViewPresenting:YES];
    [self animateDynamicViewPresenting:YES];
}

- (void)presentationTransitionDidEnd:(BOOL)completed {
    [super presentationTransitionDidEnd:completed];
}

- (void)dismissalTransitionWillBegin {
    [super dismissalTransitionWillBegin];
    [self animateVisualEffectViewPresenting:NO];
    [self animateDynamicViewPresenting:NO];
}

- (void)dismissalTransitionDidEnd:(BOOL)completed {
    [super dismissalTransitionDidEnd:completed];
}

- (CGRect)sourceViewRect {
    UIWindow *window = self.sourceView.window;
    CGRect rect = [self.sourceView.superview convertRect:self.sourceView.frame toView:window];
    return rect;
}

- (CGRect)targetViewRect {
    UIWindow *window = self.targetView.window;
    CGRect rect = [self.targetView.superview convertRect:self.targetView.frame toView:window];
    return rect;
}

- (void)configureVisualEffectView {
    UIVisualEffectView *visualEffectView = [[UIVisualEffectView alloc] initWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleDark]];
    self.visualEffectView = visualEffectView;
    
    [self.containerView addSubview:visualEffectView];
    visualEffectView.translatesAutoresizingMaskIntoConstraints = NO;
    [NSLayoutConstraint activateConstraints:@[
        [visualEffectView.topAnchor constraintEqualToAnchor:self.containerView.topAnchor],
        [visualEffectView.trailingAnchor constraintEqualToAnchor:self.containerView.trailingAnchor],
        [visualEffectView.leadingAnchor constraintEqualToAnchor:self.containerView.leadingAnchor],
        [visualEffectView.bottomAnchor constraintEqualToAnchor:self.containerView.bottomAnchor]
    ]];
    
    [visualEffectView release];
}

- (void)animateVisualEffectViewPresenting:(BOOL)presenting {
    CGFloat destination = presenting ? 1 : 0;
    self.visualEffectView.alpha = 1 - destination;
    [self.presentedViewController.transitionCoordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext> _Nonnull context) {
        self.visualEffectView.alpha = destination;
    } completion:^(id<UIViewControllerTransitionCoordinatorContext>  _Nonnull context) {}];
}

- (void)animateDynamicViewPresenting:(BOOL)presenting {
    BOOL dynamicAnimating = (self.sourceView.hidden && !self.targetView.hidden) || presenting;
    
    if (dynamicAnimating) {
        CGRect departure = presenting ? self.sourceViewRect : self.targetViewRect;
        CGRect destination = presenting ? self.destinationRect : self.sourceViewRect;
        
        self.sourceView.hidden = YES;
        self.targetView.hidden = NO;
        
        [self.targetView removeFromSuperview];
        [self.containerView addSubview:self.targetView];
        self.targetView.translatesAutoresizingMaskIntoConstraints = YES;
        self.targetView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleLeftMargin;
        self.targetView.frame = departure;
        
        [self.presentedViewController.transitionCoordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext> _Nonnull context) {
            self.targetView.frame = destination;
        } completion:^(id<UIViewControllerTransitionCoordinatorContext>  _Nonnull context) {
            if (presenting) {
                self.sourceView.hidden = YES;
                self.targetView.hidden = NO;
            } else {
                self.sourceView.hidden = NO;
                self.targetView.hidden = YES;
            }
        }];
    } else {
        self.targetView.hidden = NO;
        
        CGFloat destination = presenting ? 1 : 0;
        self.targetView.alpha = 1 - destination;
        [self.presentedViewController.transitionCoordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext> _Nonnull context) {
            self.targetView.alpha = destination;
        } completion:^(id<UIViewControllerTransitionCoordinatorContext>  _Nonnull context) {}];
    }
}

@end
