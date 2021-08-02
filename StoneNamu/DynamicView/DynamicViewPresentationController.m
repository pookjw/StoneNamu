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
@end

@implementation DynamicViewPresentationController

- (instancetype)initWithPresentedViewController:(UIViewController *)presentedViewController
                       presentingViewController:(UIViewController *)presentingViewController
                                    dynamicView:(UIView *)dynamicView
                                  departureRect:(CGRect)departureRect
                                destinationRect:(CGRect)destinationRect {
    self = [self initWithPresentedViewController:presentedViewController presentingViewController:presentingViewController];
    
    if (self) {
        self.dynamicView = dynamicView;
        self.departureRect = departureRect;
        self.destinationRect = destinationRect;
        self.dynamicAnimating = YES;
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
    if (self.dynamicAnimating) {
        CGRect departure = presenting ? self.departureRect : self.destinationRect;
        CGRect destination = presenting ? self.destinationRect : self.departureRect;
        
        [self.dynamicView removeFromSuperview];
        [self.containerView addSubview:self.dynamicView];
        self.dynamicView.translatesAutoresizingMaskIntoConstraints = YES;
        self.dynamicView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleLeftMargin;
        self.dynamicView.frame = departure;
        
        [self.presentedViewController.transitionCoordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext> _Nonnull context) {
            self.dynamicView.frame = destination;
        } completion:^(id<UIViewControllerTransitionCoordinatorContext>  _Nonnull context) {}];
    } else {
        CGFloat destination = presenting ? 1 : 0;
        self.dynamicView.alpha = 1 - destination;
        [self.presentedViewController.transitionCoordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext> _Nonnull context) {
            self.dynamicView.alpha = destination;
        } completion:^(id<UIViewControllerTransitionCoordinatorContext>  _Nonnull context) {}];
    }
}

@end
