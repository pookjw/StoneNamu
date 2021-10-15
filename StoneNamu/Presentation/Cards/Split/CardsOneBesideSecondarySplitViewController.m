//
//  CardsSplitViewController.m
//  CardsSplitViewController
//
//  Created by Jinwoo Kim on 8/16/21.
//

#import "CardsOneBesideSecondarySplitViewController.h"
#import "CardsViewController.h"
#import "CardOptionsViewController.h"
#import "BlizzardHSAPIKeys.h"

@interface CardsOneBesideSecondarySplitViewController () <UISplitViewControllerDelegate>
@property HSCardGameMode hsCardGameMode;
@end

@implementation CardsOneBesideSecondarySplitViewController

- (instancetype)initWithHSCardGameMode:(HSCardGameMode)hsCardGameMode {
    self = [self init];
    
    if (self) {
        self->_hsCardGameMode = hsCardGameMode;
        self.delegate = self;
        [self loadViewIfNeeded];
        
        CardsViewController *cardsViewController = [CardsViewController new];
        [cardsViewController loadViewIfNeeded];
        [cardsViewController requestWithOptions:@{BlizzardHSAPIOptionTypeGameMode: NSStringFromHSCardGameMode(hsCardGameMode)}];
        
        UINavigationController *cardsPrimaryNavigationController = [UINavigationController new];
        UINavigationController *cardsSecondaryNavigationController = [UINavigationController new];
        
        cardsPrimaryNavigationController.view.backgroundColor = UIColor.systemBackgroundColor;
        cardsSecondaryNavigationController.view.backgroundColor = UIColor.systemBackgroundColor;
        
        if (self.isCollapsed) {
            cardsPrimaryNavigationController.viewControllers = @[cardsViewController];
            cardsSecondaryNavigationController.viewControllers = @[];
            self.viewControllers = @[cardsPrimaryNavigationController, cardsSecondaryNavigationController];
        } else {
            [cardsViewController setOptionsBarButtonItemHidden:YES];
            NSDictionary<NSString *, NSString *> *options = cardsViewController.options;
            CardOptionsViewController *cardOptionsViewController = [[CardOptionsViewController alloc] initWithOptions:options];
            [cardOptionsViewController setCancelButtonHidden:YES];
            cardOptionsViewController.delegate = cardsViewController;
            cardsPrimaryNavigationController.viewControllers = @[cardOptionsViewController];
            cardsSecondaryNavigationController.viewControllers = @[cardsViewController];
            self.viewControllers = @[cardsPrimaryNavigationController, cardsSecondaryNavigationController];
            [cardOptionsViewController release];
        }
        
        [cardsViewController release];
        [cardsPrimaryNavigationController release];
        [cardsSecondaryNavigationController release];
    }
    
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [self setAttributes];
}

- (void)setAttributes {
    self.preferredDisplayMode = UISplitViewControllerDisplayModeOneBesideSecondary;
}

#pragma mark - UISplitViewControllerDelegate

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
    
    //
    
    UINavigationController *presentedNavigationController = (UINavigationController *)cardsViewController.presentedViewController;
    if ([presentedNavigationController isKindOfClass:[UINavigationController class]] &&
        [presentedNavigationController.viewControllers.lastObject isKindOfClass:[CardOptionsViewController class]]) {
        [presentedNavigationController dismissViewControllerAnimated:NO completion:^{}];
    }
    
    //
    
    [cardsViewController setOptionsBarButtonItemHidden:YES];
    NSDictionary<NSString *, NSString *> *options = cardsViewController.options;
    
    UINavigationController *secondaryNavigationController = [UINavigationController new];
    secondaryNavigationController.view.backgroundColor = UIColor.systemBackgroundColor;
    CardOptionsViewController *cardOptionsViewController = [[CardOptionsViewController alloc] initWithOptions:options];
    [cardOptionsViewController setCancelButtonHidden:YES];
    
    cardOptionsViewController.delegate = cardsViewController;
    primaryNavigationController.viewControllers = @[cardOptionsViewController];
    secondaryNavigationController.viewControllers = @[cardsViewController];
    
    return [secondaryNavigationController autorelease];
}

- (UISplitViewControllerColumn)splitViewController:(UISplitViewController *)svc topColumnForCollapsingToProposedTopColumn:(UISplitViewControllerColumn)proposedTopColumn {
    return UISplitViewControllerColumnPrimary;
}

@end
