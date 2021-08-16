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
        self.supportsLargeDetent = NO;
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setAttributes];
}

- (void)setAttributes {
    if (@available(iOS 15.0, *)) {
        self.modalPresentationStyle = UIModalPresentationCustom;
        self.transitioningDelegate = self;
    }
}

#pragma mark UIViewControllerTransitioningDelegate

- (UIPresentationController *)presentationControllerForPresentedViewController:(UIViewController *)presented presentingViewController:(UIViewController *)presenting sourceViewController:(UIViewController *)source {

    if (@available(iOS 15.0, *)) {
        UISheetPresentationController *pc = [[UISheetPresentationController alloc] initWithPresentedViewController:presented presentingViewController:presenting];

        if (self.supportsLargeDetent) {
            pc.detents = @[
                [UISheetPresentationControllerDetent largeDetent],
                [UISheetPresentationControllerDetent mediumDetent]
            ];
        } else {
            pc.detents = @[
                [UISheetPresentationControllerDetent mediumDetent]
            ];
        }
        
        pc.prefersGrabberVisible = YES;
        pc.selectedDetentIdentifier = UISheetPresentationControllerDetentIdentifierMedium;

        [pc autorelease];
        return pc;
    } else {
        return nil;
    }
}

@end
