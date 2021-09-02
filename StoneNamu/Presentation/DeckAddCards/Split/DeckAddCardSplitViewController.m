//
//  DeckAddCardSplitViewController.m
//  DeckAddCardSplitViewController
//
//  Created by Jinwoo Kim on 8/16/21.
//

#import "DeckAddCardSplitViewController.h"
#import "DeckAddCardsViewController.h"
#import "DeckDetailsViewController.h"

@interface DeckAddCardSplitViewController () <UISplitViewControllerDelegate>
@end

@implementation DeckAddCardSplitViewController

- (instancetype)initWithLocalDeck:(LocalDeck *)localDeck {
    self = [self init];
    
    if (self) {
        self.delegate = self;
        [self loadViewIfNeeded];
        self.modalPresentationStyle = UIModalPresentationFullScreen;
        
        DeckAddCardsViewController *deckAddCardsViewController = [[DeckAddCardsViewController alloc] initWithLocalDeck:localDeck];
        [deckAddCardsViewController loadViewIfNeeded];
        
        UINavigationController *primaryNavigationController = [UINavigationController new];
        UINavigationController *secondaryNavigationController = [UINavigationController new];
        
        primaryNavigationController.view.backgroundColor = UIColor.systemBackgroundColor;
        secondaryNavigationController.view.backgroundColor = UIColor.systemBackgroundColor;
        
        if (self.isCollapsed) {
            primaryNavigationController.viewControllers = @[deckAddCardsViewController];
            secondaryNavigationController.viewControllers = @[];
            self.viewControllers = @[primaryNavigationController, secondaryNavigationController];
        } else {
            LocalDeck *localDeck = [deckAddCardsViewController setDeckDetailsButtonHidden:YES];
            DeckDetailsViewController *deckDetailsViewController = [[DeckDetailsViewController alloc] initWithLocalDeck:localDeck presentEditorIfNoCards:NO];
            [deckDetailsViewController setRightBarButtons:0];
            primaryNavigationController.viewControllers = @[deckDetailsViewController];
            secondaryNavigationController.viewControllers = @[deckAddCardsViewController];
            self.viewControllers = @[primaryNavigationController, secondaryNavigationController];
            [deckDetailsViewController release];
        }
        
        [deckAddCardsViewController release];
        [primaryNavigationController release];
        [secondaryNavigationController release];
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
    
    DeckAddCardsViewController *deckAddCardsViewController = (DeckAddCardsViewController *)secondaryNavigationController.viewControllers[0];
    if (![deckAddCardsViewController isKindOfClass:[DeckAddCardsViewController class]]) {
        return NO;
    }
    
    [deckAddCardsViewController setDeckDetailsButtonHidden:NO];
    primaryNavigationController.viewControllers = @[deckAddCardsViewController];
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
    
    DeckAddCardsViewController *deckAddCardsViewController = primaryNavigationController.viewControllers[0];
    if (![deckAddCardsViewController isKindOfClass:[DeckAddCardsViewController class]]) return nil;
    
    //
    
    UINavigationController *presentedNavigationController = (UINavigationController *)deckAddCardsViewController.presentedViewController;
    if ([presentedNavigationController isKindOfClass:[UINavigationController class]] &&
        [presentedNavigationController.viewControllers.lastObject isKindOfClass:[DeckDetailsViewController class]]) {
        [presentedNavigationController dismissViewControllerAnimated:NO completion:^{}];
    }
    
    //
    
    LocalDeck *localDeck = [deckAddCardsViewController setDeckDetailsButtonHidden:YES];
    
    UINavigationController *secondaryNavigationController = [UINavigationController new];
    secondaryNavigationController.view.backgroundColor = UIColor.systemBackgroundColor;
    DeckDetailsViewController *deckDetailsViewController = [[DeckDetailsViewController alloc] initWithLocalDeck:localDeck presentEditorIfNoCards:NO];
    [deckDetailsViewController setRightBarButtons:0];
    
    primaryNavigationController.viewControllers = @[deckDetailsViewController];
    secondaryNavigationController.viewControllers = @[deckAddCardsViewController];
    
    [deckDetailsViewController release];
    
    return [secondaryNavigationController autorelease];
}

- (UISplitViewControllerColumn)splitViewController:(UISplitViewController *)svc topColumnForCollapsingToProposedTopColumn:(UISplitViewControllerColumn)proposedTopColumn {
    return UISplitViewControllerColumnPrimary;
}

@end