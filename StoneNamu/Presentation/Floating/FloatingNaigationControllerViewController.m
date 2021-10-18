//
//  FloatingNaigationControllerViewController.m
//  StoneNamu
//
//  Created by Jinwoo Kim on 10/18/21.
//

#import "FloatingNaigationControllerViewController.h"
#import "FloatingPresentationController.h"
#import "FloatingAnimatedTransitioning.h"

@interface FloatingNaigationControllerViewController () <UIViewControllerTransitioningDelegate>

@end

@implementation FloatingNaigationControllerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColor.clearColor;
    self.modalPresentationStyle = UIModalPresentationCustom;
    self.transitioningDelegate = self;
    self.modalPresentationCapturesStatusBarAppearance = YES;
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

#pragma mark - UIViewControllerTransitioningDelegate

- (UIPresentationController *)presentationControllerForPresentedViewController:(UIViewController *)presented presentingViewController:(UIViewController *)presenting sourceViewController:(UIViewController *)source {
    UIVisualEffectView *backgroundView = [[UIVisualEffectView alloc] initWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleDark]];
    
    FloatingPresentationController *pc = [[FloatingPresentationController alloc] initWithPresentedViewController:presented
                                                                                        presentingViewController:presenting
                                                                                                  backgroundView:backgroundView];
    
    [backgroundView release];
    [pc autorelease];
    
    return pc;
}

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source {
    FloatingAnimatedTransitioning *animator = [[FloatingAnimatedTransitioning alloc] initWithAnimateForPresenting:YES
                                                                                                         maxWidth:320
                                                                                                        maxHeight:200];
    
    [animator autorelease];
    
    return animator;
}

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed {
    FloatingAnimatedTransitioning *animator = [[FloatingAnimatedTransitioning alloc] initWithAnimateForPresenting:NO
                                                                                                         maxWidth:320
                                                                                                        maxHeight:200];
    
    [animator autorelease];
    
    return animator;
}

@end
