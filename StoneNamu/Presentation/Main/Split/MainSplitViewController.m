//
//  MainSplitViewController.m
//  MainSplitViewController
//
//  Created by Jinwoo Kim on 10/15/21.
//

#import "MainSplitViewController.h"
#import "MainViewController.h"

@interface MainSplitViewController ()
@property (retain) MainViewController *mainViewController;
@end

@implementation MainSplitViewController

- (instancetype)init {
    self = [self initWithStyle:UISplitViewControllerStyleTripleColumn];
    
    if (self) {
        
    }
    
    return self;
}

- (void)dealloc {
    [_mainViewController release];
    [super dealloc];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setAttributes];
    [self configureViewControllers];
}

- (void)setAttributes {
    self.primaryBackgroundStyle = UISplitViewControllerBackgroundStyleSidebar;
    self.preferredDisplayMode = UISplitViewControllerDisplayModeTwoBesideSecondary;
    self.view.backgroundColor = UIColor.systemBackgroundColor;
    self.displayModeButtonVisibility = UISplitViewControllerDisplayModeButtonVisibilityNever;
}

- (void)configureViewControllers {
    MainViewController *mainViewController = [MainViewController new];
    self.mainViewController = mainViewController;
    [mainViewController loadViewIfNeeded];
    
    [self setViewController:mainViewController forColumn:UISplitViewControllerColumnPrimary];
    
    [mainViewController release];
}

@end
