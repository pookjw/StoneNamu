//
//  PrefsCardsViewController.m
//  StoneNamuMac
//
//  Created by Jinwoo Kim on 11/14/21.
//

#import "PrefsCardsViewController.h"
#import "NSTextField+setLabelStyle.h"
#import <StoneNamuResources/StoneNamuResources.h>
#import "PrefsCardsViewModel.h"
#import "PrefsCardsMenuItem.h"

@interface PrefsCardsViewController ()
@property (retain) NSGridView *gridView;
@property (retain) NSTextField *localeLabel;
@property (retain) NSPopUpButton *localeMenuButton;
@property (retain) NSMenu *localeMenu;
@property (retain) NSTextField *regionLabel;
@property (retain) NSPopUpButton *regionMenuButton;
@property (retain) NSMenu *regionMenu;
@property (retain) PrefsCardsViewModel *viewModel;
@end

@implementation PrefsCardsViewController

- (void)dealloc {
    [_gridView release];
    [_localeLabel release];
    [_localeMenuButton release];
    [_localeMenu release];
    [_regionLabel release];
    [_regionMenuButton release];
    [_regionMenu release];
    [_viewModel release];
    [super dealloc];
}

- (void)loadView {
    NSView *view = [NSView new];
    self.view = view;
    [view release];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configureGridView];
    [self configureLocaleViews];
    [self configureRegionViews];
    [self configureViewModel];
    [self bind];
    [self.viewModel requestPrefs];
}

- (void)configureGridView {
    NSGridView *gridView = [NSGridView new];
    self.gridView = gridView;
    
    [self.view addSubview:gridView];
    gridView.translatesAutoresizingMaskIntoConstraints = NO;
    [NSLayoutConstraint activateConstraints:@[
        [gridView.topAnchor constraintEqualToAnchor:self.view.topAnchor constant:25.0f],
        [gridView.centerXAnchor constraintEqualToAnchor:self.view.centerXAnchor]
    ]];
    
    // https://stackoverflow.com/questions/52045470/nsgridview-difficulties
    gridView.rowAlignment = NSGridRowAlignmentLastBaseline;
    gridView.xPlacement = NSGridCellPlacementCenter;
    gridView.yPlacement = NSGridCellPlacementTop;
    
    [gridView release];
}

- (void)configureLocaleViews {
    NSTextField *localeLabel = [NSTextField new];
    self.localeLabel = localeLabel;
    [localeLabel setLabelStyle];
    localeLabel.font = [NSFont preferredFontForTextStyle:NSFontTextStyleBody options:@{}];
    localeLabel.stringValue = [NSString stringWithFormat:@"%@:", [ResourcesService localizationForKey:LocalizableKeyLocale]];
    
    NSPopUpButton *localeMenuButton = [NSPopUpButton new];
    self.localeMenuButton = localeMenuButton;
    localeMenuButton.pullsDown = NO;
    
    [self.gridView addRowWithViews:@[localeLabel, localeMenuButton]];
    
    //
    
    NSMenu *localeMenu = [NSMenu new];
    self.localeMenu = localeMenu;
    localeMenuButton.menu = localeMenu;
    
    NSMutableArray<PrefsCardsMenuItem *> *itemArray = [@[] mutableCopy];
    
    [blizzardHSAPILocales() enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        PrefsCardsMenuItem *menuItem = [[PrefsCardsMenuItem alloc] initWithKey:obj];
        menuItem.title = [ResourcesService localizationForBlizzardHSAPILocale:obj];
        menuItem.target = self;
        menuItem.action = @selector(didTriggerLocaleItem:);
        
        [itemArray addObject:menuItem];
        [menuItem release];
    }];
    
    [itemArray sortUsingComparator:^NSComparisonResult(NSMenuItem *obj1, NSMenuItem *obj2) {
        return [obj1.title compare:obj2.title];
    }];
    
    PrefsCardsMenuItem *autoItem = [[PrefsCardsMenuItem alloc] initWithKey:nil];
    autoItem.title = [ResourcesService localizationForKey:LocalizableKeyAuto];
    autoItem.target = self;
    autoItem.action = @selector(didTriggerLocaleItem:);
    [itemArray insertObject:autoItem atIndex:0];
    [autoItem release];
    
    localeMenu.itemArray = itemArray;
    [itemArray release];
    
    //
    
    [localeLabel release];
    [localeMenuButton release];
    [localeMenu release];
}

- (void)configureRegionViews {
    NSTextField *regionLabel = [NSTextField new];
    self.regionLabel = regionLabel;
    [regionLabel setLabelStyle];
    regionLabel.font = [NSFont preferredFontForTextStyle:NSFontTextStyleBody options:@{}];
    regionLabel.stringValue = [NSString stringWithFormat:@"%@:", [ResourcesService localizationForKey:LocalizableKeyRegion]];
    
    NSPopUpButton *regionMenuButton = [NSPopUpButton new];
    self.regionMenuButton = regionMenuButton;
    regionMenuButton.pullsDown = NO;
    
    [self.gridView addRowWithViews:@[regionLabel, regionMenuButton]];
    
    //
    
    NSMenu *regionMenu = [NSMenu new];
    self.regionMenu = regionMenu;
    regionMenuButton.menu = regionMenu;
    
    NSMutableArray<PrefsCardsMenuItem *> *itemArray = [@[] mutableCopy];
    
    [blizzardHSAPIRegionsForAPI() enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        PrefsCardsMenuItem *menuItem = [[PrefsCardsMenuItem alloc] initWithKey:obj];
        menuItem.title = [ResourcesService localizationForBlizzardAPIRegionHost:BlizzardAPIRegionHostFromNSStringForAPI(obj)];
        menuItem.target = self;
        menuItem.action = @selector(didTriggerRegionItem:);
        
        [itemArray addObject:menuItem];
        [menuItem release];
    }];
    
    [itemArray sortUsingComparator:^NSComparisonResult(NSMenuItem *obj1, NSMenuItem *obj2) {
        return [obj1.title compare:obj2.title];
    }];
    
    PrefsCardsMenuItem *autoItem = [[PrefsCardsMenuItem alloc] initWithKey:nil];
    autoItem.title = [ResourcesService localizationForKey:LocalizableKeyAuto];
    autoItem.target = self;
    autoItem.action = @selector(didTriggerRegionItem:);
    [itemArray insertObject:autoItem atIndex:0];
    [autoItem release];
    
    regionMenu.itemArray = itemArray;
    [itemArray release];
    
    //
    
    [regionLabel release];
    [regionMenuButton release];
    [regionMenu release];
}

- (void)configureViewModel {
    PrefsCardsViewModel *viewModel = [PrefsCardsViewModel new];
    self.viewModel = viewModel;
    [viewModel release];
}

- (void)bind {
    [NSNotificationCenter.defaultCenter addObserver:self
                                           selector:@selector(didReceivePrefsChanged:)
                                               name:PrefsCardsViewModelDidChangeDataNotificationName
                                             object:self.viewModel];
}

- (void)didReceivePrefsChanged:(NSNotification *)notification {
    Prefs * _Nullable prefs = (Prefs *)notification.userInfo[PrefsCardsViewModelDidChangeDataNotificationPrefsItemKey];
    
    if (prefs == nil) return;
    
    [NSOperationQueue.mainQueue addOperationWithBlock:^{
        [self updateLocaleMenuWithPrefs:prefs];
        [self updateRegionMenuWithPrefs:prefs];
    }];
}

- (void)updateLocaleMenuWithPrefs:(Prefs *)prefs {
    [self.localeMenu.itemArray enumerateObjectsUsingBlock:^(NSMenuItem * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        PrefsCardsMenuItem *item = (PrefsCardsMenuItem *)obj;
        
        if (![item isKindOfClass:[PrefsCardsMenuItem class]]) return;
        
        if (item.key == nil) {
            if (prefs.locale == nil) {
                [self.localeMenuButton selectItem:item];
            }
        } else {
            if ([item.key isEqualToString:prefs.locale]) {
                [self.localeMenuButton selectItem:item];
            }
        }
    }];
}

- (void)updateRegionMenuWithPrefs:(Prefs *)prefs {
    [self.regionMenu.itemArray enumerateObjectsUsingBlock:^(NSMenuItem * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        PrefsCardsMenuItem *item = (PrefsCardsMenuItem *)obj;
        
        if (![item isKindOfClass:[PrefsCardsMenuItem class]]) return;
        
        if (item.key == nil) {
            if (prefs.locale == nil) {
                [self.regionMenuButton selectItem:item];
            }
        } else {
            if ([item.key isEqualToString:prefs.apiRegionHost]) {
                [self.regionMenuButton selectItem:item];
            }
        }
    }];
}

- (void)didTriggerLocaleItem:(PrefsCardsMenuItem *)sender {
    [self.viewModel updateLocale:sender.key];
}

- (void)didTriggerRegionItem:(PrefsCardsMenuItem *)sender {
    [self.viewModel updateRegionHost:sender.key];
}

@end
