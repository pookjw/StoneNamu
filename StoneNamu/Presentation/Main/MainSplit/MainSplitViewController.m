//
//  MainSplitViewController.m
//  MainSplitViewController
//
//  Created by Jinwoo Kim on 10/15/21.
//

#import "MainSplitViewController.h"
#import "MainListViewController.h"
#import "CardOptionsViewController.h"
#import "BattlegroundsCardOptionsViewController.h"
#import <StoneNamuResources/StoneNamuResources.h>

@interface MainSplitViewController ()
@property (retain) MainListViewController *mainListViewController;
@end

@implementation MainSplitViewController

@synthesize cardsViewController = _cardsViewController;
@synthesize battlegroundsCardsViewController = _battlegroundsCardsViewController;
@synthesize decksViewController = _decksViewController;
@synthesize prefsViewController = _prefsViewController;

- (instancetype)init {
    self = [self initWithStyle:UISplitViewControllerStyleTripleColumn];
    
    if (self) {
        
    }
    
    return self;
}

- (void)dealloc {
    [_cardsViewController release];
    [_battlegroundsCardsViewController release];
    [_decksViewController release];
    [_prefsViewController release];
    [_mainListViewController release];
    [super dealloc];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setAttributes];
    [self configureViewControllers];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self updateSceneTitle];
}

- (void)setAttributes {
    self.primaryBackgroundStyle = UISplitViewControllerBackgroundStyleSidebar;
    self.preferredDisplayMode = UISplitViewControllerDisplayModeTwoBesideSecondary;
    self.view.backgroundColor = UIColor.systemBackgroundColor;
#if TARGET_OS_MACCATALYST
    self.displayModeButtonVisibility = UISplitViewControllerDisplayModeButtonVisibilityNever;
#endif
}

- (void)configureViewControllers {
    MainListViewController *mainListViewController = [MainListViewController new];
    [mainListViewController loadViewIfNeeded];
    
    [self setViewController:mainListViewController forColumn:UISplitViewControllerColumnPrimary];
    
    self.mainListViewController = mainListViewController;
    [mainListViewController release];
}

- (void)updateSceneTitle {
    UIViewController * _Nullable viewController = [self viewControllerForColumn:UISplitViewControllerColumnSupplementary];
    
    if (viewController) {
        if ([viewController isKindOfClass:[CardOptionsViewController class]]) {
            self.view.window.windowScene.title = [ResourcesService localizationForKey:LocalizableKeyCards];
        } else if ([viewController isEqual:self.decksViewController]) {
            self.view.window.windowScene.title = [ResourcesService localizationForKey:LocalizableKeyDecks];
        }
    }
}

#pragma mark - MainLayoutProtocol

- (NSArray<__kindof UIViewController *> *)currentViewControllers {
    NSMutableArray<__kindof UIViewController *> *currentViewControllers = [NSMutableArray<__kindof UIViewController *> new];
    
    __kindof UIViewController * _Nullable supplemetaryViewController = [self viewControllerForColumn:UISplitViewControllerColumnSupplementary];
    __kindof UIViewController * _Nullable secondaryViewController = [self viewControllerForColumn:UISplitViewControllerColumnSecondary];
    
    if (supplemetaryViewController != nil) {
        [currentViewControllers addObject:supplemetaryViewController];
    }
    
    if (secondaryViewController != nil) {
        [currentViewControllers addObject:secondaryViewController];
    }
    
    return [currentViewControllers autorelease];
}

- (void)activate {
    [self loadViewIfNeeded];
    [self.cardsViewController setOptionsBarButtonItemHidden:YES];
    [self.prefsViewController setDoneButtonHidden:NO];
}

- (void)deactivate {
    [self loadViewIfNeeded];
}

- (void)restoreViewControllers:(NSArray<__kindof UIViewController *> *)viewControllers {
    if (viewControllers.count < 1) return;
    
    if ([viewControllers[0] isEqual:self.cardsViewController]) {
        [self.cardsViewController setOptionsBarButtonItemHidden:YES];
        
        CardOptionsViewController *cardOptionsViewController = [[CardOptionsViewController alloc] initWithOptions:self.cardsViewController.options];
        cardOptionsViewController.delegate = self.cardsViewController;
        [cardOptionsViewController setCancelButtonHidden:YES];
        [self setViewController:cardOptionsViewController forColumn:UISplitViewControllerColumnSupplementary];
        [self setViewController:self.cardsViewController forColumn:UISplitViewControllerColumnSecondary];
        // setViewController:forColumn: will push the view controller, so prevent this
        [self.cardsViewController.navigationController setViewControllers:@[self.cardsViewController] animated:NO];
        
        [cardOptionsViewController release];
        [self.mainListViewController setSelectionStatusForType:MainListItemModelTypeCards];

    } else if ([viewControllers[0] isEqual:self.battlegroundsCardsViewController]) {
        [self.cardsViewController setOptionsBarButtonItemHidden:YES];
        
        BattlegroundsCardOptionsViewController *battlegroundsCardOptionsViewController = [[BattlegroundsCardOptionsViewController alloc] initWithOptions:self.battlegroundsCardsViewController.options];
        battlegroundsCardOptionsViewController.delegate = self.battlegroundsCardsViewController;
        [battlegroundsCardOptionsViewController setCancelButtonHidden:YES];
        [self setViewController:battlegroundsCardOptionsViewController forColumn:UISplitViewControllerColumnSupplementary];
        [self setViewController:self.battlegroundsCardsViewController forColumn:UISplitViewControllerColumnSecondary];
        // setViewController:forColumn: will push the view controller, so prevent this
        [self.cardsViewController.navigationController setViewControllers:@[self.battlegroundsCardsViewController] animated:NO];
        
        [battlegroundsCardOptionsViewController release];
        [self.mainListViewController setSelectionStatusForType:MainListItemModelTypeBattlegrounds];
    } else if ([viewControllers[0] isEqual:self.decksViewController]) {
        [self setViewController:self.decksViewController forColumn:UISplitViewControllerColumnSupplementary];
        
        if (viewControllers.count > 1) {
            [self setViewController:viewControllers[1] forColumn:UISplitViewControllerColumnSecondary];
        } else {
            [self setViewController:nil forColumn:UISplitViewControllerColumnSecondary];
        }
        
        [self.decksViewController.navigationController setViewControllers:@[self.decksViewController] animated:NO];
        [self.mainListViewController setSelectionStatusForType:MainListItemModelTypeDecks];
    }
    
    [self updateSceneTitle];
}

@end
