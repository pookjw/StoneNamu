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
#import "NSSplitViewController+removeSplitViewItemAtIndex.h"

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
    [self.mainListViewController selectItemModelType:MainListItemModelTypeCards];
}

- (void)encodeRestorableStateWithCoder:(NSCoder *)coder backgroundQueue:(NSOperationQueue *)queue {
    [super encodeRestorableStateWithCoder:coder backgroundQueue:queue];
    [self.mainListViewController encodeRestorableStateWithCoder:coder backgroundQueue:queue];
    [self.cardsViewController encodeRestorableStateWithCoder:coder backgroundQueue:queue];
}

- (void)restoreStateWithCoder:(NSCoder *)coder {
    [super restoreStateWithCoder:coder];
    [self.mainListViewController restoreStateWithCoder:coder];
    [self.cardsViewController restoreStateWithCoder:coder];
}

- (void)setAttributes {
    
}

- (void)configureViewControllers {
    MainListViewController *mainListViewController = [[MainListViewController alloc] initWithDelegate:self];
    [mainListViewController loadViewIfNeeded];
    NSSplitViewItem *mainMenuItem = [NSSplitViewItem sidebarWithViewController:mainListViewController];
    [self addSplitViewItem:mainMenuItem];
    
    CardsViewController *cardsViewController = [CardsViewController new];
    [cardsViewController loadViewIfNeeded];
    
    DecksViewController *decksViewController = [DecksViewController new];
    [decksViewController loadViewIfNeeded];
    
    //
    
    self.mainListViewController = mainListViewController;
    self.cardsViewController = cardsViewController;
    self.decksViewController = decksViewController;
    
    [mainListViewController release];
    [cardsViewController release];
    [decksViewController release];
}

- (void)presentCardViewController {
    [self removeAllSplitViewItemWithoutSidebar];
    
    NSSplitViewItem *cardsSplitViewItem = [NSSplitViewItem splitViewItemWithViewController:self.cardsViewController];
    [self addSplitViewItem:cardsSplitViewItem];
}

- (void)presentDecksViewController {
    [self removeAllSplitViewItemWithoutSidebar];
    
    NSSplitViewItem *decksSplitViewItem = [NSSplitViewItem splitViewItemWithViewController:self.decksViewController];
    [self addSplitViewItem:decksSplitViewItem];
}

- (void)removeAllSplitViewItemWithoutSidebar {
    [self.splitViewItems enumerateObjectsUsingBlock:^(__kindof NSSplitViewItem * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj.behavior != NSSplitViewItemBehaviorSidebar) {
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
