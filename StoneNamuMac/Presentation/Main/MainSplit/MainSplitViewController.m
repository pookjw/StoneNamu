//
//  MainSplitViewController.m
//  MainSplitViewController
//
//  Created by Jinwoo Kim on 9/26/21.
//

#import "MainSplitViewController.h"
#import "MainListViewController.h"
#import "CardsViewController.h"
#import "NSViewController+loadViewIfNeeded.h"

@interface MainSplitViewController ()
@property (retain) MainListViewController *mainMenuViewController;
@property (retain) CardsViewController *cardsViewController;
@end

@implementation MainSplitViewController

- (void)dealloc {
    [_mainMenuViewController release];
    [_cardsViewController release];
    [super dealloc];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setAttributes];
    [self configureViewControllers];
}

- (void)restoreStateWithCoder:(NSCoder *)coder {
    [super restoreStateWithCoder:coder];
    [self.mainMenuViewController restoreStateWithCoder:coder];
    [self.cardsViewController restoreStateWithCoder:coder];
}

- (void)setAttributes {
//    self.preferredContentSize = NSMakeSize(300, 300);
}

- (void)configureViewControllers {
    MainListViewController *mainMenuViewController = [MainListViewController new];
    self.mainMenuViewController = mainMenuViewController;
    [mainMenuViewController loadViewIfNeeded];
    NSSplitViewItem *item = [NSSplitViewItem sidebarWithViewController:mainMenuViewController];
    [self addSplitViewItem:item];
    [mainMenuViewController release];
    
    CardsViewController *cardsViewController = [CardsViewController new];
    self.cardsViewController = cardsViewController;
    [cardsViewController loadViewIfNeeded];
    NSSplitViewItem *item2 = [NSSplitViewItem contentListWithViewController:cardsViewController];
    [self addSplitViewItem:item2];
    [cardsViewController release];
}

#pragma mark - NSSplitViewDelegate

- (BOOL)splitView:(NSSplitView *)splitView canCollapseSubview:(NSView *)subview {
    return NO;
}

@end
