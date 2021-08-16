//
//  MainTabBarController.m
//  MainTabBarController
//
//  Created by Jinwoo Kim on 8/16/21.
//

#import "MainTabBarController.h"
#import "CardsViewController.h"
#import "PrefsViewController.h"
#import "MainSplitViewController.h"

@interface MainTabBarController ()
@property (retain) MainSplitViewController *cardsSplitViewController;
@property (retain) MainSplitViewController *prefsSplitViewController;
@end

@implementation MainTabBarController

- (void)dealloc {
    [_cardsSplitViewController release];
    [_prefsSplitViewController release];
    [super dealloc];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configureViewControllers];
}

- (void)configureViewControllers {
    CardsViewController *cardsViewController = [CardsViewController new];
    PrefsViewController *prefsViewController = [PrefsViewController new];
    UINavigationController *cardsPrimaryNavigationController = [[UINavigationController alloc] initWithRootViewController:cardsViewController];
    UINavigationController *prefsPrimaryNavigationController = [[UINavigationController alloc] initWithRootViewController:prefsViewController];
    UINavigationController *cardsSecondaryNavigationController = [UINavigationController new];
    UINavigationController *prefsSecondaryNavigationController = [UINavigationController new];
    MainSplitViewController *cardsSplitViewController = [MainSplitViewController new];
    MainSplitViewController *prefsSplitViewController = [MainSplitViewController new];
    self.cardsSplitViewController = cardsSplitViewController;
    self.prefsSplitViewController = prefsSplitViewController;
    
    cardsSecondaryNavigationController.view.backgroundColor = UIColor.systemBackgroundColor;
    prefsSecondaryNavigationController.view.backgroundColor = UIColor.systemBackgroundColor;
    
    cardsSplitViewController.viewControllers = @[cardsPrimaryNavigationController, cardsSecondaryNavigationController];
    cardsSplitViewController.preferredDisplayMode = UISplitViewControllerDisplayModeOneBesideSecondary;
    prefsSplitViewController.viewControllers = @[prefsPrimaryNavigationController, prefsSecondaryNavigationController];
    prefsSplitViewController.preferredDisplayMode = UISplitViewControllerDisplayModeOneBesideSecondary;
    
    [cardsPrimaryNavigationController release];
    [prefsPrimaryNavigationController release];
    [cardsSecondaryNavigationController release];
    [prefsSecondaryNavigationController release];
    [cardsViewController release];
    [prefsViewController release];
    
    UITabBarItem *cardsTabBarItem = [[UITabBarItem alloc] initWithTitle:NSLocalizedString(@"CARDS", @"")
                                                                  image:[UIImage systemImageNamed:@"menucard"]
                                                          selectedImage:[UIImage systemImageNamed:@"menucard.fill"]];
    UITabBarItem *prefsTabBarItem = [[UITabBarItem alloc] initWithTitle:NSLocalizedString(@"PREFERENCES", @"")
                                                                  image:[UIImage systemImageNamed:@"gearshape"]
                                                          selectedImage:[UIImage systemImageNamed:@"gearshape.fill"]];
    cardsSplitViewController.tabBarItem = cardsTabBarItem;
    prefsSplitViewController.tabBarItem = prefsTabBarItem;
    
    [cardsTabBarItem release];
    [prefsTabBarItem release];
    
    [self setViewControllers:@[cardsSplitViewController, prefsSplitViewController] animated:NO];
    
    [cardsSplitViewController release];
    [prefsSplitViewController release];
}

@end
