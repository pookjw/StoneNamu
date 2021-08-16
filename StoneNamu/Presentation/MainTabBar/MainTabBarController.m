//
//  MainTabBarController.m
//  MainTabBarController
//
//  Created by Jinwoo Kim on 8/16/21.
//

#import "MainTabBarController.h"
#import "CardsViewController.h"
#import "PrefsViewController.h"

@interface MainTabBarController ()
@property (retain) UINavigationController *cardsNavigationController;
@property (retain) UINavigationController *prefsNavigationController;
@end

@implementation MainTabBarController

- (void)dealloc {
    [_cardsNavigationController release];
    [_prefsNavigationController release];
    [super dealloc];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configureViewControllers];
}

- (void)configureViewControllers {
    CardsViewController *cardsViewController = [CardsViewController new];
    PrefsViewController *prefsViewController = [PrefsViewController new];
    
    UINavigationController *cardsNavigationController = [[UINavigationController alloc] initWithRootViewController:cardsViewController];
    UINavigationController *prefsNavigationController = [[UINavigationController alloc] initWithRootViewController:prefsViewController];
    self.cardsNavigationController = cardsNavigationController;
    self.prefsNavigationController = prefsNavigationController;
    
    [cardsViewController release];
    [prefsViewController release];
    
    UITabBarItem *cardsTabBarItem = [[UITabBarItem alloc] initWithTitle:NSLocalizedString(@"CARDS", @"")
                                                                  image:[UIImage systemImageNamed:@"menucard"]
                                                          selectedImage:[UIImage systemImageNamed:@"menucard.fill"]];
    UITabBarItem *prefsTabBarItem = [[UITabBarItem alloc] initWithTitle:NSLocalizedString(@"PREFERENCES", @"")
                                                                  image:[UIImage systemImageNamed:@"gearshape"]
                                                          selectedImage:[UIImage systemImageNamed:@"gearshape.fill"]];
    cardsNavigationController.tabBarItem = cardsTabBarItem;
    prefsNavigationController.tabBarItem = prefsTabBarItem;
    
    [cardsTabBarItem release];
    [prefsTabBarItem release];
    
    [self setViewControllers:@[cardsNavigationController, prefsNavigationController] animated:NO];
    
    
    [cardsNavigationController release];
    [prefsNavigationController release];
}

@end
