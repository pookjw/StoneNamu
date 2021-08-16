//
//  CardsSplitViewController.m
//  CardsSplitViewController
//
//  Created by Jinwoo Kim on 8/16/21.
//

#import "CardsSplitViewController.h"
#import "CardsViewController.h"
#import "CardOptionsViewController.h"

@interface CardsSplitViewController () <UISplitViewControllerDelegate>
@end

@implementation CardsSplitViewController

- (instancetype)init {
    self = [super init];
    
    if (self) {
        self.delegate = self;
    }
    
    return self;
}

#pragma mark UISplitViewControllerDelegate

- (BOOL)splitViewController:(UISplitViewController *)splitViewController showDetailViewController:(UIViewController *)vc sender:(id)sender {
    return NO;
}

- (BOOL)splitViewController:(UISplitViewController *)splitViewController collapseSecondaryViewController:(UIViewController *)secondaryViewController ontoPrimaryViewController:(UIViewController *)primaryViewController {
    UINavigationController *primaryNavigationController = (UINavigationController *)primaryViewController;
    UINavigationController *secondaryNavigationController = (UINavigationController *)secondaryViewController;
    
    if (![primaryNavigationController isKindOfClass:[UINavigationController class]] || ![secondaryNavigationController isKindOfClass:[UINavigationController class]]) {
        return NO;
    }
    
    if (secondaryNavigationController.viewControllers.count < 1) return NO;
    
    CardsViewController *cardViewController = (CardsViewController *)secondaryNavigationController.viewControllers[0];
    if (![cardViewController isKindOfClass:[CardsViewController class]]) {
        return NO;
    }
    
    [cardViewController setOptionsBarButtonItemHidden:NO];
    primaryNavigationController.viewControllers = @[cardViewController];
    secondaryNavigationController.viewControllers = @[];
    
    return YES;
}

- (UIViewController *)splitViewController:(UISplitViewController *)splitViewController separateSecondaryViewControllerFromPrimaryViewController:(UIViewController *)primaryViewController {
    UINavigationController *primaryNavigationController = (UINavigationController *)primaryViewController;
    if (![primaryNavigationController isKindOfClass:[UINavigationController class]]) {
        return nil;
    }
    
    NSUInteger primaryNavigationControllersCount = primaryNavigationController.viewControllers.count;
    if (primaryNavigationControllersCount == 0) return nil;
    
    CardsViewController *cardsViewController = primaryNavigationController.viewControllers[0];
    if (![cardsViewController isKindOfClass:[CardsViewController class]]) return nil;
    NSDictionary<NSString *, NSString *> *options = [cardsViewController setOptionsBarButtonItemHidden:YES];
    
    UINavigationController *secondaryNavigationController = [UINavigationController new];
    CardOptionsViewController *cardOptionsViewController = [[CardOptionsViewController alloc] initWithOptions:options];
    [cardOptionsViewController setCancelButtonHidden:YES];
    
    cardOptionsViewController.delegate = cardsViewController;
    primaryNavigationController.viewControllers = @[cardOptionsViewController];
    secondaryNavigationController.viewControllers = @[cardsViewController];
    
    return secondaryNavigationController;
}

- (UISplitViewControllerColumn)splitViewController:(UISplitViewController *)svc topColumnForCollapsingToProposedTopColumn:(UISplitViewControllerColumn)proposedTopColumn {
    return UISplitViewControllerColumnPrimary;
}

@end
