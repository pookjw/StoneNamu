//
//  MainTabBarController.m
//  MainTabBarController
//
//  Created by Jinwoo Kim on 8/16/21.
//

#import "MainTabBarController.h"
#import "CardsViewController.h"
#import "PrefsViewController.h"
#import "CardsOneBesideSecondarySplitViewController.h"
#import "OneBesideSecondarySplitViewController.h"
#import "CardOptionsViewController.h"
#import "UIView+scrollToTopForRecursiveView.h"
#import "DecksViewController.h"
#import "MoreViewController.h"

@interface MainTabBarController () <UITabBarControllerDelegate>
@property (retain) CardsOneBesideSecondarySplitViewController *cardsSplitViewController;
@property (retain) OneBesideSecondarySplitViewController *decksSplitViewController;
@property (retain) OneBesideSecondarySplitViewController *prefsSplitViewController;
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
    self.view.backgroundColor = UIColor.systemBackgroundColor;
}

- (void)configureViewControllers {
    DecksViewController *decksViewController = [DecksViewController new];
    PrefsViewController *prefsViewController = [PrefsViewController new];
    MoreViewController *moreViewController = [MoreViewController new];
    
    [decksViewController loadViewIfNeeded];
    [prefsViewController loadViewIfNeeded];
    [moreViewController loadViewIfNeeded];
    
    UINavigationController *decksPrimaryNavigationController = [[UINavigationController alloc] initWithRootViewController:decksViewController];
    UINavigationController *decksSecondaryNavigationController = [UINavigationController new];
    UINavigationController *prefsPrimaryNavigationController = [[UINavigationController alloc] initWithRootViewController:prefsViewController];
    UINavigationController *prefsSecondaryNavigationController = [UINavigationController new];
    UINavigationController *moreNavigationController = [[UINavigationController alloc] initWithRootViewController:moreViewController];
    
    CardsOneBesideSecondarySplitViewController *cardsSplitViewController = [[CardsOneBesideSecondarySplitViewController alloc] initWithHSCardGameMode:HSCardGameModeConstructed];
    OneBesideSecondarySplitViewController *decksSplitViewController = [OneBesideSecondarySplitViewController new];
    OneBesideSecondarySplitViewController *prefsSplitViewController = [OneBesideSecondarySplitViewController new];
    self.cardsSplitViewController = cardsSplitViewController;
    self.decksSplitViewController = decksSplitViewController;
    self.prefsSplitViewController = prefsSplitViewController;
    
    [cardsSplitViewController loadViewIfNeeded];
    [decksSplitViewController loadViewIfNeeded];
    [prefsSplitViewController loadViewIfNeeded];
    
    decksPrimaryNavigationController.view.backgroundColor = UIColor.systemBackgroundColor;
    decksSecondaryNavigationController.view.backgroundColor = UIColor.systemBackgroundColor;
    prefsPrimaryNavigationController.view.backgroundColor = UIColor.systemBackgroundColor;
    prefsSecondaryNavigationController.view.backgroundColor = UIColor.systemBackgroundColor;
    moreNavigationController.view.backgroundColor = UIColor.systemBackgroundColor;
    
    decksSplitViewController.viewControllers = @[decksPrimaryNavigationController, decksSecondaryNavigationController];
    prefsSplitViewController.viewControllers = @[prefsPrimaryNavigationController, prefsSecondaryNavigationController];
    
    [decksViewController release];
    [prefsViewController release];
    [decksPrimaryNavigationController release];
    [decksSecondaryNavigationController release];
    [prefsPrimaryNavigationController release];
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
    UITabBarItem *moreTabBarItem = [[UITabBarItem alloc] initWithTitle:NSLocalizedString(@"MORE", @"")
                                                                 image:[UIImage systemImageNamed:@"ellipsis"]
                                                         selectedImage:[UIImage systemImageNamed:@"ellipsis"]];
    cardsSplitViewController.tabBarItem = cardsTabBarItem;
    decksSplitViewController.tabBarItem = decksTabBarItem;
    prefsSplitViewController.tabBarItem = prefsTabBarItem;
    moreViewController.tabBarItem = moreTabBarItem;
    
    [cardsTabBarItem release];
    [decksTabBarItem release];
    [prefsTabBarItem release];
    [moreTabBarItem release];
    
    [self setViewControllers:@[cardsSplitViewController, decksSplitViewController, prefsSplitViewController, moreNavigationController] animated:NO];
    self.selectedViewController = cardsSplitViewController;
    
    [cardsSplitViewController release];
    [decksSplitViewController release];
    [prefsSplitViewController release];
    [moreNavigationController release];
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
