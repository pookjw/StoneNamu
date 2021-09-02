//
//  DeckAddCardSplitViewController.m
//  DeckAddCardSplitViewController
//
//  Created by Jinwoo Kim on 8/16/21.
//

#import "DeckAddCardSplitViewController.h"
#import "DeckAddCardsViewController.h"
#import "DeckAddCardOptionsViewController.h"

@interface DeckAddCardSplitViewController () <UISplitViewControllerDelegate>
@end

@implementation DeckAddCardSplitViewController

- (instancetype)init {
    self = [super init];
    
    if (self) {
        self.delegate = self;
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
    
    DeckAddCardsViewController *cardViewController = (DeckAddCardsViewController *)secondaryNavigationController.viewControllers[0];
    if (![cardViewController isKindOfClass:[DeckAddCardsViewController class]]) {
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
    
    DeckAddCardsViewController *cardsViewController = primaryNavigationController.viewControllers[0];
    if (![cardsViewController isKindOfClass:[DeckAddCardsViewController class]]) return nil;
    [cardsViewController.presentedViewController dismissViewControllerAnimated:NO completion:^{}];
    NSDictionary<NSString *, NSString *> *options = [cardsViewController setOptionsBarButtonItemHidden:YES];
    
    UINavigationController *secondaryNavigationController = [UINavigationController new];
    secondaryNavigationController.view.backgroundColor = UIColor.systemBackgroundColor;
    DeckAddCardOptionsViewController *cardOptionsViewController = [[DeckAddCardOptionsViewController alloc] initWithOptions:options];
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
