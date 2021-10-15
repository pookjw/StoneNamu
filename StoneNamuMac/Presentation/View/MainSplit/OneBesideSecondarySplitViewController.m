//
//  MainSplitViewController.m
//  MainSplitViewController
//
//  Created by Jinwoo Kim on 9/26/21.
//

#import "OneBesideSecondarySplitViewController.h"
#import "MainMenuViewController.h"
#import "CardsViewController.h"

@interface OneBesideSecondarySplitViewController ()
@end

@implementation OneBesideSecondarySplitViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setAttributes];
    [self configureViewControllers];
}

- (void)setAttributes {
//    self.preferredContentSize = NSMakeSize(300, 300);
}

- (void)configureViewControllers {
    MainMenuViewController *mainMenuViewController = [MainMenuViewController new];
    NSSplitViewItem *item = [NSSplitViewItem sidebarWithViewController:mainMenuViewController];
    [self addSplitViewItem:item];
    [mainMenuViewController release];
    
    CardsViewController *cardsViewController = [CardsViewController new];
    NSSplitViewItem *item2 = [NSSplitViewItem contentListWithViewController:cardsViewController];
    [self addSplitViewItem:item2];
    [cardsViewController release];
}

@end
