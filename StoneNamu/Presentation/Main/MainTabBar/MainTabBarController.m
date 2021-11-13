//
//  MainTabBarController.m
//  MainTabBarController
//
//  Created by Jinwoo Kim on 8/16/21.
//

#import "MainTabBarController.h"
#import "UIView+scrollToTopForRecursiveView.h"
#import <StoneNamuResources/StoneNamuResources.h>

@interface MainTabBarController () <UITabBarControllerDelegate>
@property (retain) UINavigationController *cardsNavigationController;
@property (retain) UINavigationController *decksNavigationController;
@property (retain) UINavigationController *prefsNavigationController;
@end

@implementation MainTabBarController

@synthesize cardsViewController = _cardsViewController;
@synthesize decksViewController = _decksViewController;
@synthesize prefsViewController = _prefsViewController;

- (void)dealloc {
    [_cardsViewController release];
    [_decksViewController release];
    [_prefsViewController release];
    [_cardsNavigationController release];
    [_decksNavigationController release];
    [_prefsNavigationController release];
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
    UINavigationController *cardsNavigationController = [UINavigationController new];
    UINavigationController *decksNavigationController = [UINavigationController new];
    UINavigationController *prefsNavigationController = [UINavigationController new];
    
    self.cardsNavigationController = cardsNavigationController;
    self.decksNavigationController = decksNavigationController;
    self.prefsNavigationController = prefsNavigationController;
    
    [cardsNavigationController loadViewIfNeeded];
    [decksNavigationController loadViewIfNeeded];
    [prefsNavigationController loadViewIfNeeded];
    
    cardsNavigationController.view.backgroundColor = UIColor.systemBackgroundColor;
    decksNavigationController.view.backgroundColor = UIColor.systemBackgroundColor;
    prefsNavigationController.view.backgroundColor = UIColor.systemBackgroundColor;
    
    UITabBarItem *cardsTabBarItem = [[UITabBarItem alloc] initWithTitle:[ResourcesService localizationForKey:LocalizableKeyCards]
                                                                  image:[UIImage systemImageNamed:@"text.book.closed"]
                                                          selectedImage:[UIImage systemImageNamed:@"text.book.closed.fill"]];
    UITabBarItem *decksTabBarItem = [[UITabBarItem alloc] initWithTitle:[ResourcesService localizationForKey:LocalizableKeyDecks]
                                                                  image:[UIImage systemImageNamed:@"books.vertical"]
                                                          selectedImage:[UIImage systemImageNamed:@"books.vertical.fill"]];
    UITabBarItem *prefsTabBarItem = [[UITabBarItem alloc] initWithTitle:[ResourcesService localizationForKey:LocalizableKeyPreferences]
                                                                  image:[UIImage systemImageNamed:@"gearshape"]
                                                          selectedImage:[UIImage systemImageNamed:@"gearshape.fill"]];
    cardsNavigationController.tabBarItem = cardsTabBarItem;
    decksNavigationController.tabBarItem = decksTabBarItem;
    prefsNavigationController.tabBarItem = prefsTabBarItem;
    
    [cardsTabBarItem release];
    [decksTabBarItem release];
    [prefsTabBarItem release];
    
    [self setViewControllers:@[cardsNavigationController, decksNavigationController, prefsNavigationController] animated:NO];
    
    [cardsNavigationController release];
    [decksNavigationController release];
    [prefsNavigationController release];
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

#pragma mark - MainLayoutProtocol

- (NSArray<__kindof UIViewController *> *)currentViewControllers {
    return ((UINavigationController *)self.selectedViewController).viewControllers;
}

- (void)activate {
    [self loadViewIfNeeded];
    
    [self.cardsNavigationController setViewControllers:@[self.cardsViewController] animated:NO];
    [self.decksNavigationController setViewControllers:@[self.decksViewController] animated:NO];
    [self.prefsNavigationController setViewControllers:@[self.prefsViewController] animated:NO];
    
    [self.cardsViewController setOptionsBarButtonItemHidden:NO];
    [self.prefsViewController setDoneButtonHidden:YES];
}

- (void)deactivate {
    [self loadViewIfNeeded];
    
    [self.cardsNavigationController setViewControllers:@[] animated:NO];
    [self.decksNavigationController setViewControllers:@[] animated:NO];
    [self.prefsNavigationController setViewControllers:@[] animated:NO];
}

- (void)restoreViewControllers:(NSArray<__kindof UIViewController *> *)viewControllers {
    if (viewControllers.count < 1) return;
    
    if ([viewControllers[0] isEqual:self.cardsViewController]) {
        self.selectedViewController = self.cardsNavigationController;
    } else if ([viewControllers[0] isEqual:self.decksViewController]) {
        [self.decksNavigationController setViewControllers:viewControllers animated:NO];
        self.selectedViewController = self.decksNavigationController;
    }
}

@end
