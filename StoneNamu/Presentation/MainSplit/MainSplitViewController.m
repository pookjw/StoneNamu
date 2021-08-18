//
//  MainSplitViewController.m
//  MainSplitViewController
//
//  Created by Jinwoo Kim on 8/16/21.
//

#import "MainSplitViewController.h"

@interface MainSplitViewController () <UISplitViewControllerDelegate>
@end

@implementation MainSplitViewController

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

#pragma mark UISplitViewControllerDelegate

- (BOOL)splitViewController:(UISplitViewController *)splitViewController showDetailViewController:(UIViewController *)vc sender:(id)sender {
    if (splitViewController.isCollapsed) return NO;
    if (splitViewController.viewControllers.count <= 1) return NO;
    
    UINavigationController *secondaryNavigationController = (UINavigationController *)splitViewController.viewControllers[1];
    
    if (![secondaryNavigationController isKindOfClass:[UINavigationController class]]) return NO;
    
    secondaryNavigationController.viewControllers = @[vc];
    
    return YES;
}

- (BOOL)splitViewController:(UISplitViewController *)splitViewController collapseSecondaryViewController:(UIViewController *)secondaryViewController ontoPrimaryViewController:(UIViewController *)primaryViewController {
    UINavigationController *primaryNavigationController = (UINavigationController *)primaryViewController;
    UINavigationController *secondaryNavigationController = (UINavigationController *)secondaryViewController;
    
    if (![primaryNavigationController isKindOfClass:[UINavigationController class]] || ![secondaryNavigationController isKindOfClass:[UINavigationController class]]) {
        return NO;
    }
    
    NSMutableArray<UIViewController *> *viewControllers = [primaryNavigationController.viewControllers mutableCopy];
    [viewControllers addObjectsFromArray:secondaryNavigationController.viewControllers];
    primaryNavigationController.viewControllers = viewControllers;
    [viewControllers release];
    
    secondaryNavigationController.viewControllers = @[];
    
    return YES;
}

- (UIViewController *)splitViewController:(UISplitViewController *)splitViewController separateSecondaryViewControllerFromPrimaryViewController:(UIViewController *)primaryViewController {
    UINavigationController *primaryNavigationController = (UINavigationController *)primaryViewController;
    if (![primaryNavigationController isKindOfClass:[UINavigationController class]]) return nil;
    
    NSUInteger primaryNavigationControllersCount = primaryNavigationController.viewControllers.count;
    
    if (primaryNavigationControllersCount <= 1) {
        UINavigationController *secondaryNavigationController = [UINavigationController new];
        secondaryNavigationController.view.backgroundColor = UIColor.systemBackgroundColor;
        return [secondaryNavigationController autorelease];
    }
    
    NSRange range = NSMakeRange(1, primaryNavigationControllersCount - 1);
    NSArray<UIViewController *> *secondaryViewControllers = [primaryNavigationController.viewControllers subarrayWithRange:range];
    
    primaryNavigationController.viewControllers = @[primaryNavigationController.viewControllers[0]];
    
    UINavigationController *secondaryNavigationController = [UINavigationController new];
    secondaryNavigationController.view.backgroundColor = UIColor.systemBackgroundColor;
    secondaryNavigationController.viewControllers = secondaryViewControllers;
    
    return [secondaryNavigationController autorelease];
}

- (UISplitViewControllerColumn)splitViewController:(UISplitViewController *)svc topColumnForCollapsingToProposedTopColumn:(UISplitViewControllerColumn)proposedTopColumn {
    return UISplitViewControllerColumnPrimary;
}

@end
