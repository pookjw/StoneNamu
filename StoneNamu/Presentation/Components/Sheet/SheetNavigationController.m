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

- (instancetype)init {
    self = [super init];
    
    if (self) {
        self.detents = @[[UISheetPresentationControllerDetent mediumDetent]];
    }
    
    return self;
}

- (instancetype)initWithRootViewController:(UIViewController *)rootViewController {
    self = [super initWithRootViewController:rootViewController];
    
    if (self) {
        self.detents = @[[UISheetPresentationControllerDetent mediumDetent]];
    }
    
    return self;
}

- (void)dealloc {
    [_detents release];
    [super dealloc];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setAttributes];
}

- (void)setAttributes {
    self.modalPresentationStyle = UIModalPresentationCustom;
    self.transitioningDelegate = self;
}

#pragma mark - UIViewControllerTransitioningDelegate

- (UIPresentationController *)presentationControllerForPresentedViewController:(UIViewController *)presented presentingViewController:(UIViewController *)presenting sourceViewController:(UIViewController *)source {
    
    UISheetPresentationController *pc = [[UISheetPresentationController alloc] initWithPresentedViewController:presented presentingViewController:presenting];
    pc.detents = self.detents;
    
    pc.prefersGrabberVisible = YES;
    pc.selectedDetentIdentifier = UISheetPresentationControllerDetentIdentifierMedium;
    
    [pc autorelease];
    return pc;
}

@end
