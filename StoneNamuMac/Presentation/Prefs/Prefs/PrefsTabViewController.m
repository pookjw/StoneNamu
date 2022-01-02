//
//  PrefsTabViewController.m
//  StoneNamuMac
//
//  Created by Jinwoo Kim on 11/14/21.
//

#import "PrefsTabViewController.h"
#import "PrefsCardsViewController.h"
#import "PrefsDataViewController.h"
#import "NSViewController+loadViewIfNeeded.h"
#import <StoneNamuResources/StoneNamuResources.h>
#import "NSTabViewController+selectTabViewItem.h"

@interface PrefsTabViewController ()
@property (retain) PrefsCardsViewController *prefsCardsViewController;
@property (retain) PrefsDataViewController *prefsDataViewController;
@property (retain) NSTabViewItem *prefsCardsItem;
@property (retain) NSTabViewItem *prefsDataItem;
@end

@implementation PrefsTabViewController

- (void)dealloc {
    [_prefsCardsViewController release];
    [_prefsDataViewController release];
    [_prefsCardsItem release];
    [_prefsDataItem release];
    [super dealloc];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setAttributes];
    [self configureViewControllers];
    [self configureItems];
}

- (void)viewWillAppear {
    [super viewWillAppear];
    self.view.window.title = self.tabViewItems[self.selectedTabViewItemIndex].label;
}

- (void)setAttributes {
    self.preferredContentSize = NSMakeSize(500, 300);
    self.tabStyle = NSTabViewControllerTabStyleToolbar;
}

- (void)configureViewControllers {
    PrefsCardsViewController *prefsCardsViewController = [PrefsCardsViewController new];
    [prefsCardsViewController loadViewIfNeeded];
    self.prefsCardsViewController = prefsCardsViewController;
    [prefsCardsViewController release];
    
    PrefsDataViewController *prefsDataViewController = [PrefsDataViewController new];
    [prefsDataViewController loadViewIfNeeded];
    self.prefsDataViewController = prefsDataViewController;
    [prefsDataViewController release];
}

- (void)configureItems {
    NSTabViewItem *prefsCardsItem = [NSTabViewItem tabViewItemWithViewController:self.prefsCardsViewController];
    prefsCardsItem.image = [NSImage imageWithSystemSymbolName:@"menucard" accessibilityDescription:nil];
    prefsCardsItem.label = [ResourcesService localizationForKey:LocalizableKeyCards];
    [self addTabViewItem:prefsCardsItem];
    self.prefsCardsItem = prefsCardsItem;
    
    NSTabViewItem *prefsDataItem = [NSTabViewItem tabViewItemWithViewController:self.prefsDataViewController];
    prefsDataItem.image = [NSImage imageWithSystemSymbolName:@"tray.full" accessibilityDescription:nil];
    prefsDataItem.label = [ResourcesService localizationForKey:LocalizableKeyData];
    [self addTabViewItem:prefsDataItem];
    self.prefsDataItem = prefsDataItem;
}

- (void)tabView:(NSTabView *)tabView didSelectTabViewItem:(NSTabViewItem *)tabViewItem {
    [super tabView:tabView didSelectTabViewItem:tabViewItem];
    self.view.window.title = tabViewItem.label;
}

@end
