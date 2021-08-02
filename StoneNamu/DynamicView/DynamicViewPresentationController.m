//
//  DynamicViewPresentationController.m
//  DynamicViewPresentationController
//
//  Created by Jinwoo Kim on 8/2/21.
//

#import "DynamicViewPresentationController.h"

@interface DynamicViewPresentationController ()
@property (retain) UIVisualEffectView *visualEffectView;
@property (retain) UIView *dynamicView;
@property CGRect destinationRect;
@property CGRect originalRect;
@end

@implementation DynamicViewPresentationController

- (instancetype)initWithPresentedViewController:(UIViewController *)presentedViewController
                       presentingViewController:(UIViewController *)presentingViewController
                                    dynamicView:(UIView *)dynamicView
                                destinationRect:(CGRect)destinationRect {
    self = [self initWithPresentedViewController:presentedViewController presentingViewController:presentingViewController];
    
    if (self) {
        self.dynamicView = dynamicView;
        self.destinationRect = destinationRect;
    }
    
    return self;
}

- (void)dealloc {
    [_visualEffectView release];
    [_dynamicView release];
    [super dealloc];
}

- (void)presentationTransitionWillBegin {
    [super presentationTransitionWillBegin];
    [self configureVisualEffectView];
    [self configureDynamicViewRect];
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
    
    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(triggeredVisualEffectViewGesgure:)];
    [visualEffectView addGestureRecognizer:gesture];
    visualEffectView.userInteractionEnabled = YES;
    
    [visualEffectView release];
    [gesture release];
}

- (void)triggeredVisualEffectViewGesgure:(UITapGestureRecognizer *)sender {
    [self.presentedViewController dismissViewControllerAnimated:YES completion:^{}];
}

- (void)animateVisualEffectViewPresenting:(BOOL)presenting {
    CGFloat destination = presenting ? 1 : 0;
    self.visualEffectView.alpha = 1 - destination;
    [self.presentedViewController.transitionCoordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext> _Nonnull context) {
        self.visualEffectView.alpha = destination;
    } completion:^(id<UIViewControllerTransitionCoordinatorContext>  _Nonnull context) {}];
}

- (void)configureDynamicViewRect {
    UIWindow *window = self.dynamicView.window;
    self.originalRect = [self.dynamicView.superview convertRect:self.dynamicView.frame toView:window];
}

- (void)animateDynamicViewPresenting:(BOOL)presenting {
    if (presenting) {
        [self.dynamicView removeFromSuperview];
        [self.containerView addSubview:self.dynamicView];
        self.dynamicView.translatesAutoresizingMaskIntoConstraints = YES;
        self.dynamicView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleLeftMargin;
        self.dynamicView.frame = self.originalRect;
    }
    
    CGRect destination = presenting ? self.destinationRect : self.originalRect;
    
    [self.presentedViewController.transitionCoordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext> _Nonnull context) {
        self.dynamicView.frame = destination;
    } completion:^(id<UIViewControllerTransitionCoordinatorContext>  _Nonnull context) {}];
}

@end
