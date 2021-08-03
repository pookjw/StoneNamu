//
//  SheetNavigationController.m
//  SheetNavigationController
//
//  Created by Jinwoo Kim on 7/25/21.
//

#import "SheetNavigationController.h"

@interface SheetNavigationController () <UIViewControllerTransitioningDelegate>
@end

@implementation SheetNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setAttributes];
}

- (void)setAttributes {
    self.modalPresentationStyle = UIModalPresentationCustom;
    self.transitioningDelegate = self;
}

#pragma mark UIViewControllerTransitioningDelegate

- (UIPresentationController *)presentationControllerForPresentedViewController:(UIViewController *)presented presentingViewController:(UIViewController *)presenting sourceViewController:(UIViewController *)source {

    UISheetPresentationController *pc = [[UISheetPresentationController alloc] initWithPresentedViewController:presented presentingViewController:presenting];

    pc.detents = @[
        [UISheetPresentationControllerDetent mediumDetent]
    ];
    pc.prefersGrabberVisible = YES;

    [pc autorelease];
    return pc;
}

@end
