//
//  MainSplitViewController.m
//  MainSplitViewController
//
//  Created by Jinwoo Kim on 9/26/21.
//

#import "MainSplitViewController.h"
#import "MainListViewController.h"
#import "CardsViewController.h"
#import "DecksViewController.h"
#import "NSViewController+loadViewIfNeeded.h"

@interface MainSplitViewController () <MainListViewControllerDelegate>
@property (retain) MainListViewController *mainListViewController;
@property (retain) CardsViewController *cardsViewController;
@property (retain) DecksViewController *decksViewController;
@end

@implementation MainSplitViewController

- (void)dealloc {
    [_mainListViewController release];
    [_cardsViewController release];
    [_decksViewController release];
    [super dealloc];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setAttributes];
    [self configureViewControllers];
    [self presentCardViewController];
}

- (void)restoreStateWithCoder:(NSCoder *)coder {
    [super restoreStateWithCoder:coder];
    [self.mainListViewController restoreStateWithCoder:coder];
    [self.cardsViewController restoreStateWithCoder:coder];
}

- (void)setAttributes {
//    self.preferredContentSize = NSMakeSize(300, 300);
}

- (void)configureViewControllers {
    MainListViewController *mainMenuViewController = [[MainListViewController alloc] initWithDelegate:self];
    self.mainListViewController = mainMenuViewController;
    [mainMenuViewController loadViewIfNeeded];
    NSSplitViewItem *mainMenuItem = [NSSplitViewItem sidebarWithViewController:mainMenuViewController];
    [self addSplitViewItem:mainMenuItem];
    
    CardsViewController *cardsViewController = [CardsViewController new];
    self.cardsViewController = cardsViewController;
    [cardsViewController loadViewIfNeeded];
    
    DecksViewController *decksViewController = [DecksViewController new];
    self.decksViewController = decksViewController;
    [decksViewController loadViewIfNeeded];
    
    //
    
    [mainMenuViewController selectItemModelType:MainListItemModelTypeCards];
    
    //
    
    [mainMenuViewController release];
    [cardsViewController release];
    [decksViewController release];
}

- (void)presentCardViewController {
    [self removeAllContentListSplitViewItems];
    
    NSSplitViewItem *cardsMenuItem = [NSSplitViewItem contentListWithViewController:self.cardsViewController];
    [self addSplitViewItem:cardsMenuItem];
}

- (void)presentDecksViewController {
    [self removeAllContentListSplitViewItems];
    
    NSSplitViewItem *decksMenuItem = [NSSplitViewItem contentListWithViewController:self.decksViewController];
    [self addSplitViewItem:decksMenuItem];
}

- (void)removeAllContentListSplitViewItems {
    [self.splitViewItems enumerateObjectsUsingBlock:^(__kindof NSSplitViewItem * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj.behavior == NSSplitViewItemBehaviorContentList) {
            [self removeSplitViewItem:obj];
        }
    }];
}

#pragma mark - NSSplitViewDelegate

- (BOOL)splitView:(NSSplitView *)splitView canCollapseSubview:(NSView *)subview {
    return NO;
}

#pragma mark - MainListViewControllerDelegate

- (void)mainListViewController:(MainListViewController *)mainListViewController didChangeSelectedItemModelType:(MainListItemModelType)type {
    switch (type) {
        case MainListItemModelTypeCards:
            [self presentCardViewController];
            break;
        case MainListItemModelTypeDecks:
            [self presentDecksViewController];
            break;
        default:
            break;
    }
}

@end
