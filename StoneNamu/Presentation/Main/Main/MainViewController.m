//
//  MainViewController.m
//  StoneNamu
//
//  Created by Jinwoo Kim on 10/22/21.
//

#import "MainViewController.h"
#import "MainSplitViewController.h"
#import "MainTabBarController.h"
#import "MainLayoutProtocol.h"
#import "CardsViewController.h"
#import "DecksViewController.h"
#import "PrefsViewController.h"
#import "BlizzardHSAPIKeys.h"
#import "HSCardGameMode.h"

@interface MainViewController ()
@property (retain) MainSplitViewController * _Nullable splitViewController;
@property (retain) MainTabBarController * _Nullable tabBarController;

@property (retain) CardsViewController *cardsViewController;
@property (retain) DecksViewController *decksViewController;
@property (retain) PrefsViewController *prefsViewController;

@property (retain) UIViewController * _Nullable tmpPresentedViewController;
@end

@implementation MainViewController

- (instancetype)init {
    self = [super init];
    
    if (self) {
        self.splitViewController = nil;
        self.tabBarController = nil;
        self.tmpPresentedViewController = nil;
    }
    
    return self;
}

- (void)dealloc {
    [_splitViewController release];
    [_tabBarController release];
    
    [_cardsViewController release];
    [_decksViewController release];
    [_prefsViewController release];
    
    [_tmpPresentedViewController release];
    [super dealloc];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configureViewControllers];
    [self setViewControllerForTraitCollection:self.traitCollection previous:nil];
}

- (void)willTransitionToTraitCollection:(UITraitCollection *)newCollection withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator {
    [super willTransitionToTraitCollection:newCollection withTransitionCoordinator:coordinator];
    
    if (self.presentedViewController != nil) {
        self.tmpPresentedViewController = self.presentedViewController;
        [self.tmpPresentedViewController dismissViewControllerAnimated:NO completion:^{}];
    } else {
        self.tmpPresentedViewController = nil;
    }
}

- (void)traitCollectionDidChange:(UITraitCollection *)previousTraitCollection {
    [super traitCollectionDidChange:previousTraitCollection];
    [self setViewControllerForTraitCollection:self.traitCollection previous:previousTraitCollection];
    
    if ((self.tmpPresentedViewController != nil)) {
        if ((self.tmpPresentedViewController.presentingViewController == nil) && (![self.tmpPresentedViewController isKindOfClass:[UISplitViewController class]])) {
            [self presentViewController:self.tmpPresentedViewController animated:YES completion:^{}];
        }
        self.tmpPresentedViewController = nil;
    }
}

- (void)configureViewControllers {
    CardsViewController *cardsViewController = [CardsViewController new];
    self.cardsViewController = cardsViewController;
    [cardsViewController requestWithOptions:@{BlizzardHSAPIOptionTypeGameMode: NSStringFromHSCardGameMode(HSCardGameModeConstructed)}];
    [cardsViewController release];
    
    DecksViewController *decksViewController = [DecksViewController new];
    self.decksViewController = decksViewController;
    [decksViewController release];
    
    PrefsViewController *prefsViewController = [PrefsViewController new];
    self.prefsViewController = prefsViewController;
    [prefsViewController release];
}

- (void)setViewControllerForTraitCollection:(UITraitCollection *)traitCollection previous:(UITraitCollection * _Nullable)previousTraitCollection {
    UIUserInterfaceSizeClass sizeClass = traitCollection.horizontalSizeClass;
    
    if (sizeClass == UIUserInterfaceSizeClassUnspecified) return;
    if ((previousTraitCollection != nil) && (sizeClass == previousTraitCollection.horizontalSizeClass)) return;
    
    //
    
    NSArray<__kindof UIViewController *> * previousViewControllers = @[];
    
    if (self.tabBarController != nil) {
        previousViewControllers = self.tabBarController.currentViewControllers;
        [self.tabBarController deactivate];
        [self.tabBarController.view removeFromSuperview];
        [self.tabBarController removeFromParentViewController];
        self.tabBarController = nil;
    }

    if (self.splitViewController != nil) {
        previousViewControllers = self.splitViewController.currentViewControllers;
        [self.splitViewController deactivate];
        [self.splitViewController.view removeFromSuperview];
        [self.splitViewController removeFromParentViewController];
        self.splitViewController = nil;
    }
    
    //
    
    UIViewController<MainLayoutProtocol> * _Nullable targetViewController = nil;
    
    switch (sizeClass) {
        case UIUserInterfaceSizeClassCompact: {
            MainTabBarController *tabBarController = [MainTabBarController new];
            self.tabBarController = tabBarController;
            targetViewController = tabBarController;
            [tabBarController autorelease];
            break;
        }
        case UIUserInterfaceSizeClassRegular: {
            MainSplitViewController *splitViewController = [MainSplitViewController new];
            self.splitViewController = splitViewController;
            targetViewController = splitViewController;
            [splitViewController autorelease];
            break;
        }
        default:
            break;
    }
    
    //
    
    if (targetViewController != nil) {
        [self addChildViewController:targetViewController];
        [self.view addSubview:targetViewController.view];
        targetViewController.view.translatesAutoresizingMaskIntoConstraints = NO;
        [NSLayoutConstraint activateConstraints:@[
            [targetViewController.view.topAnchor constraintEqualToAnchor:self.view.topAnchor],
            [targetViewController.view.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor],
            [targetViewController.view.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor],
            [targetViewController.view.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor]
        ]];
        
        targetViewController.cardsViewController = self.cardsViewController;
        targetViewController.decksViewController = self.decksViewController;
        targetViewController.prefsViewController = self.prefsViewController;
        [targetViewController activate];
        [targetViewController restoreViewControllers:previousViewControllers];
    }
}

@end
