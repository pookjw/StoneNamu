//
//  MainTabBarController.m
//  MainTabBarController
//
//  Created by Jinwoo Kim on 8/16/21.
//

#import "MainTabBarController.h"
#import "CardsViewController.h"
#import "PrefsViewController.h"
#import "CardsSplitViewController.h"
#import "MainSplitViewController.h"
#import "CardOptionsViewController.h"
#import "UIView+scrollToTopForRecursiveView.h"
#import "DecksViewController.h"

@interface MainTabBarController () <UITabBarControllerDelegate>
@property (retain) CardsSplitViewController *cardsSplitViewController;
@property (retain) MainSplitViewController *decksSplitViewController;
@property (retain) MainSplitViewController *prefsSplitViewController;
@end

@implementation MainTabBarController

- (void)dealloc {
    [_cardsSplitViewController release];
    [_decksSplitViewController release];
    [_prefsSplitViewController release];
    [super dealloc];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setAttributes];
    [self configureViewControllers];
}

- (void)setAttributes {
    self.delegate = self;
}

- (void)configureViewControllers {
    CardsViewController *cardsViewController = [CardsViewController new];
    DecksViewController *decksViewController = [DecksViewController new];
    PrefsViewController *prefsViewController = [PrefsViewController new];
    
    [cardsViewController loadViewIfNeeded];
    [decksViewController loadViewIfNeeded];
    [prefsViewController loadViewIfNeeded];
    
    UINavigationController *cardsPrimaryNavigationController = [UINavigationController new];
    UINavigationController *cardsSecondaryNavigationController = [UINavigationController new];
    UINavigationController *decksPrimaryNavigationController = [[UINavigationController alloc] initWithRootViewController:decksViewController];
    UINavigationController *decksSecondaryNavigationController = [UINavigationController new];
    UINavigationController *prefsPrimaryNavigationController = [[UINavigationController alloc] initWithRootViewController:prefsViewController];
    UINavigationController *prefsSecondaryNavigationController = [UINavigationController new];
    
    CardsSplitViewController *cardsSplitViewController = [CardsSplitViewController new];
    MainSplitViewController *decksSplitViewController = [MainSplitViewController new];
    MainSplitViewController *prefsSplitViewController = [MainSplitViewController new];
    self.cardsSplitViewController = cardsSplitViewController;
    self.decksSplitViewController = decksSplitViewController;
    self.prefsSplitViewController = prefsSplitViewController;
    
    [cardsSplitViewController loadViewIfNeeded];
    [decksSplitViewController loadViewIfNeeded];
    [prefsSplitViewController loadViewIfNeeded];
    
    cardsPrimaryNavigationController.view.backgroundColor = UIColor.systemBackgroundColor;
    cardsSecondaryNavigationController.view.backgroundColor = UIColor.systemBackgroundColor;
    decksPrimaryNavigationController.view.backgroundColor = UIColor.systemBackgroundColor;
    decksSecondaryNavigationController.view.backgroundColor = UIColor.systemBackgroundColor;
    prefsPrimaryNavigationController.view.backgroundColor = UIColor.systemBackgroundColor;
    prefsSecondaryNavigationController.view.backgroundColor = UIColor.systemBackgroundColor;
    
    if (cardsSplitViewController.isCollapsed) {
        cardsPrimaryNavigationController.viewControllers = @[cardsViewController];
        cardsSecondaryNavigationController.viewControllers = @[];
        cardsSplitViewController.viewControllers = @[cardsPrimaryNavigationController, cardsSecondaryNavigationController];
    } else {
        NSDictionary<NSString *, NSString *> *options = [cardsViewController setOptionsBarButtonItemHidden:YES];
        CardOptionsViewController *cardOptionsViewController = [[CardOptionsViewController alloc] initWithOptions:options];
        [cardOptionsViewController setCancelButtonHidden:YES];
        cardOptionsViewController.delegate = cardsViewController;
        cardsPrimaryNavigationController.viewControllers = @[cardOptionsViewController];
        cardsSecondaryNavigationController.viewControllers = @[cardsViewController];
        cardsSplitViewController.viewControllers = @[cardsPrimaryNavigationController, cardsSecondaryNavigationController];
    }
    
    decksSplitViewController.viewControllers = @[decksPrimaryNavigationController, decksSecondaryNavigationController];
    prefsSplitViewController.viewControllers = @[prefsPrimaryNavigationController, prefsSecondaryNavigationController];
    
    [cardsViewController release];
    [decksViewController release];
    [prefsViewController release];
    [cardsPrimaryNavigationController release];
    [prefsPrimaryNavigationController release];
    [decksPrimaryNavigationController release];
    [decksSecondaryNavigationController release];
    [cardsSecondaryNavigationController release];
    [prefsSecondaryNavigationController release];
    
    UITabBarItem *cardsTabBarItem = [[UITabBarItem alloc] initWithTitle:NSLocalizedString(@"CARDS", @"")
                                                                  image:[UIImage systemImageNamed:@"text.book.closed"]
                                                          selectedImage:[UIImage systemImageNamed:@"text.book.closed.fill"]];
    UITabBarItem *decksTabBarItem = [[UITabBarItem alloc] initWithTitle:NSLocalizedString(@"DECKS", @"")
                                                                  image:[UIImage systemImageNamed:@"books.vertical"]
                                                          selectedImage:[UIImage systemImageNamed:@"books.vertical.fill"]];
    UITabBarItem *prefsTabBarItem = [[UITabBarItem alloc] initWithTitle:NSLocalizedString(@"PREFERENCES", @"")
                                                                  image:[UIImage systemImageNamed:@"gearshape"]
                                                          selectedImage:[UIImage systemImageNamed:@"gearshape.fill"]];
    cardsSplitViewController.tabBarItem = cardsTabBarItem;
    decksSplitViewController.tabBarItem = decksTabBarItem;
    prefsSplitViewController.tabBarItem = prefsTabBarItem;
    
    [cardsTabBarItem release];
    [decksTabBarItem release];
    [prefsTabBarItem release];
    
    [self setViewControllers:@[cardsSplitViewController, decksSplitViewController, prefsSplitViewController] animated:NO];
    self.selectedViewController = cardsSplitViewController;
    
    [cardsSplitViewController release];
    [decksSplitViewController release];
    [prefsSplitViewController release];
}

- (void)makeFirstPageForNavigationController:(UINavigationController *)navigationController {
    if (navigationController.viewControllers.count < 1) return;
    
    UIViewController *firstViewController = navigationController.viewControllers[0];
    [navigationController setViewControllers:@[firstViewController] animated:YES];
}

#pragma mark - UITabBarControllerDelegate

- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController {
    // if not selected
    if (![viewController isEqual:tabBarController.selectedViewController]) {
        return YES;
    }
    
    if ([viewController isKindOfClass:[UISplitViewController class]]) {
        UISplitViewController *splitViewController = (UISplitViewController *)viewController;
        
        if (splitViewController.viewControllers.count < 1) {
            return YES;
        }
        
        UIViewController *firstViewController = splitViewController.viewControllers[0];
        
        if ([firstViewController isKindOfClass:[UINavigationController class]]) {
            // same
            UINavigationController *navigationController = (UINavigationController *)firstViewController;
            
            if (navigationController.viewControllers.count == 1) {
                UIViewController *firstViewController = navigationController.viewControllers[0];
                [firstViewController.view scrollToTopWithRecursiveAnimated:YES];
            } else {
                [self makeFirstPageForNavigationController:navigationController];
            }
        } else {
            [firstViewController.view scrollToTopWithRecursiveAnimated:YES];
        }
    } else if ([viewController isKindOfClass:[UINavigationController class]]) {
        // same
        UINavigationController *navigationController = (UINavigationController *)viewController;
        
        if (navigationController.viewControllers.count == 1) {
            UIViewController *firstViewController = navigationController.viewControllers[0];
            [firstViewController.view scrollToTopWithRecursiveAnimated:YES];
        } else {
            [self makeFirstPageForNavigationController:navigationController];
        }
    } else {
        [viewController.view scrollToTopWithRecursiveAnimated:YES];
    }
    
    return YES;
}

@end
