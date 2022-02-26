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
#import "OneBesideSecondarySplitViewController.h"
#import <StoneNamuCore/StoneNamuCore.h>

@interface MainViewController ()
@property (retain) MainSplitViewController * _Nullable splitViewController;
@property (retain) MainTabBarController * _Nullable tabBarController;

@property (retain) CardsViewController *cardsViewController;
@property (retain) CardsViewController *battlegroundsCardsViewController;
@property (retain) DecksViewController *decksViewController;
@property (retain) PrefsViewController *prefsViewController;
@end

@implementation MainViewController

- (instancetype)init {
    self = [super init];
    
    if (self) {
        self.splitViewController = nil;
        self.tabBarController = nil;
    }
    
    return self;
}

- (void)dealloc {
    [_splitViewController release];
    [_tabBarController release];
    
    [_cardsViewController release];
    [_battlegroundsCardsViewController release];
    [_decksViewController release];
    [_prefsViewController release];
    [super dealloc];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configureViewControllers];
    [self setViewControllerForTraitCollection:self.traitCollection previous:nil];
}

- (void)willTransitionToTraitCollection:(UITraitCollection *)newCollection withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator {
    [super willTransitionToTraitCollection:newCollection withTransitionCoordinator:coordinator];
    [self dismissPrefsViewControllerIfNeeded];
}

- (void)traitCollectionDidChange:(UITraitCollection *)previousTraitCollection {
    [super traitCollectionDidChange:previousTraitCollection];
    
    if ([self shouldChangeLayoutForTraitCollection:self.traitCollection previous:previousTraitCollection]) {
        [self setViewControllerForTraitCollection:self.traitCollection previous:previousTraitCollection];
    }
}

- (void)configureViewControllers {
    CardsViewController *cardsViewController = [[CardsViewController alloc] initWithHSGameModeSlugType:HSCardGameModeSlugTypeConstructed];
    [cardsViewController requestWithOptions:nil];
    self.cardsViewController = cardsViewController;
    [cardsViewController release];
    
    CardsViewController *battlegroundsCardsViewController = [[CardsViewController alloc] initWithHSGameModeSlugType:HSCardGameModeSlugTypeBattlegrounds];
    [battlegroundsCardsViewController requestWithOptions:nil];
    self.battlegroundsCardsViewController = battlegroundsCardsViewController;
    [battlegroundsCardsViewController release];
    
    DecksViewController *decksViewController = [DecksViewController new];
    self.decksViewController = decksViewController;
    [decksViewController release];
    
    PrefsViewController *prefsViewController = [PrefsViewController new];
    self.prefsViewController = prefsViewController;
    [prefsViewController release];
}

- (BOOL)shouldChangeLayoutForTraitCollection:(UITraitCollection *)traitCollection previous:(UITraitCollection * _Nullable)previousTraitCollection {
    UIUserInterfaceSizeClass sizeClass = traitCollection.horizontalSizeClass;
    
    if (sizeClass == UIUserInterfaceSizeClassUnspecified) return NO;
    if ((previousTraitCollection != nil) && (sizeClass == previousTraitCollection.horizontalSizeClass)) return NO;
    
    return YES;
}

- (void)setViewControllerForTraitCollection:(UITraitCollection *)traitCollection previous:(UITraitCollection * _Nullable)previousTraitCollection {
    NSArray<__kindof UIViewController *> * previousViewControllers = @[];
    
    if (self.tabBarController != nil) {
        previousViewControllers = self.tabBarController.currentViewControllers;
        [self.tabBarController willMoveToParentViewController:self];
        [self.tabBarController deactivate];
        [self.tabBarController.view removeFromSuperview];
        [self.tabBarController removeFromParentViewController];
        [self.tabBarController didMoveToParentViewController:nil];
        self.tabBarController = nil;
    }

    if (self.splitViewController != nil) {
        previousViewControllers = self.splitViewController.currentViewControllers;
        [self.splitViewController willMoveToParentViewController:self];
        [self.splitViewController deactivate];
        [self.splitViewController.view removeFromSuperview];
        [self.splitViewController removeFromParentViewController];
        [self.splitViewController didMoveToParentViewController:self];
        self.splitViewController = nil;
    }
    
    //
    
    UIViewController<MainLayoutProtocol> * _Nullable targetViewController = nil;
    UIUserInterfaceSizeClass sizeClass = traitCollection.horizontalSizeClass;
    
    switch (sizeClass) {
        case UIUserInterfaceSizeClassCompact: {
            MainTabBarController *tabBarController = [MainTabBarController new];
            targetViewController = tabBarController;
            self.tabBarController = tabBarController;
            [tabBarController autorelease];
            break;
        }
        case UIUserInterfaceSizeClassRegular: {
            MainSplitViewController *splitViewController = [MainSplitViewController new];
            targetViewController = splitViewController;
            self.splitViewController = splitViewController;
            [splitViewController autorelease];
            break;
        }
        default:
            break;
    }
    
    //
    
    if (targetViewController != nil) {
        [targetViewController willMoveToParentViewController:self];
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
        targetViewController.battlegroundsCardsViewController = self.battlegroundsCardsViewController;
        targetViewController.decksViewController = self.decksViewController;
        targetViewController.prefsViewController = self.prefsViewController;
        [targetViewController activate];
        [targetViewController restoreViewControllers:previousViewControllers];
        [targetViewController didMoveToParentViewController:self];
    }
}

- (void)dismissPrefsViewControllerIfNeeded {
    if (self.presentedViewController == nil) return;
    
    OneBesideSecondarySplitViewController *splitViewController = (OneBesideSecondarySplitViewController *)self.presentedViewController;
    
    if (![splitViewController isKindOfClass:[OneBesideSecondarySplitViewController class]]) return;
    
    if (splitViewController.viewControllers.count == 0) return;
    
    UINavigationController *firstNavigationController = (UINavigationController *)splitViewController.viewControllers.firstObject;
    
    if (![firstNavigationController isKindOfClass:[UINavigationController class]]) return;
    
    if (firstNavigationController.viewControllers.count == 0) return;
    
    PrefsViewController *prefsViewController = (PrefsViewController *)firstNavigationController.viewControllers.firstObject;
    
    if (![prefsViewController isKindOfClass:[PrefsViewController class]]) return;
    
    [prefsViewController dismissViewControllerAnimated:NO completion:^{}];
}

@end
