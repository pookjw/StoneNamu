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
#import "StorableMenuItem.h"

@interface PrefsCardsViewController ()
@property (retain) NSGridView *gridView;
@property (retain) NSTextField *localeLabel;
@property (retain) NSPopUpButton *localeMenuButton;
@property (retain) NSMenu *localeMenu;
@property (retain) NSTextField *regionLabel;
@property (retain) NSPopUpButton *regionMenuButton;
@property (retain) NSMenu *regionMenu;
@property (retain) NSTextField *descriptionLabel;
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
    [_descriptionLabel release];
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
    [self configureDescriptionLabel];
    [self bind];
    [self.viewModel requestPrefs];
}

- (void)configureGridView {
    NSGridView *gridView = [NSGridView new];
    
    [self.view addSubview:gridView];
    gridView.translatesAutoresizingMaskIntoConstraints = NO;
    [NSLayoutConstraint activateConstraints:@[
        [gridView.topAnchor constraintEqualToAnchor:self.view.topAnchor constant:25.0f],
        [gridView.centerXAnchor constraintEqualToAnchor:self.view.centerXAnchor]
    ]];
    
    // https://stackoverflow.com/questions/52045470/nsgridview-difficulties
    gridView.rowAlignment = NSGridRowAlignmentLastBaseline;
    gridView.xPlacement = NSGridCellPlacementTrailing;
    gridView.yPlacement = NSGridCellPlacementTop;
    
    self.gridView = gridView;
    [gridView release];
}

- (void)configureLocaleViews {
    NSTextField *localeLabel = [NSTextField new];
    [localeLabel setLabelStyle];
    localeLabel.font = [NSFont preferredFontForTextStyle:NSFontTextStyleBody options:@{}];
    localeLabel.stringValue = [NSString stringWithFormat:@"%@ :", [ResourcesService localizationForKey:LocalizableKeyLocale]];
    
    NSPopUpButton *localeMenuButton = [NSPopUpButton new];
    localeMenuButton.pullsDown = NO;
    localeMenuButton.translatesAutoresizingMaskIntoConstraints = NO;
    [NSLayoutConstraint activateConstraints:@[
        [localeMenuButton.widthAnchor constraintEqualToConstant:150.0f]
    ]];
    
    [self.gridView addRowWithViews:@[localeLabel, localeMenuButton]];
    
    //
    
    NSMenu *localeMenu = [NSMenu new];
    localeMenuButton.menu = localeMenu;
    
    NSMutableArray<StorableMenuItem *> *itemArray = [NSMutableArray<StorableMenuItem *> new];
    
    [blizzardHSAPILocales() enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        StorableMenuItem *item = [[StorableMenuItem alloc] initWithTitle:[ResourcesService localizationForBlizzardHSAPILocale:obj]
                                                                  action:@selector(didTriggerLocaleItem:)
                                                           keyEquivalent:@""
                                                                userInfo:@{@"key": obj}];
        item.target = self;
        
        [itemArray addObject:item];
        [item release];
    }];
    
    [itemArray sortUsingComparator:^NSComparisonResult(NSMenuItem *obj1, NSMenuItem *obj2) {
        return [obj1.title compare:obj2.title];
    }];
    
    StorableMenuItem *autoItem = [[StorableMenuItem alloc] initWithTitle:[ResourcesService localizationForKey:LocalizableKeyAuto]
                                                                  action:@selector(didTriggerLocaleItem:)
                                                           keyEquivalent:@""
                                                                userInfo:nil];
    autoItem.target = self;
    
    [itemArray insertObject:autoItem atIndex:0];
    [autoItem release];
    
    localeMenu.itemArray = itemArray;
    [itemArray release];
    
    //
    
    self.localeLabel = localeLabel;
    self.localeMenuButton = localeMenuButton;
    self.localeMenu = localeMenu;
    
    [localeLabel release];
    [localeMenuButton release];
    [localeMenu release];
}

- (void)configureRegionViews {
    NSTextField *regionLabel = [NSTextField new];
    [regionLabel setLabelStyle];
    regionLabel.font = [NSFont preferredFontForTextStyle:NSFontTextStyleBody options:@{}];
    regionLabel.stringValue = [NSString stringWithFormat:@"%@ :", [ResourcesService localizationForKey:LocalizableKeyRegion]];
    
    NSPopUpButton *regionMenuButton = [NSPopUpButton new];
    regionMenuButton.pullsDown = NO;
    regionMenuButton.translatesAutoresizingMaskIntoConstraints = NO;
    [NSLayoutConstraint activateConstraints:@[
        [regionMenuButton.widthAnchor constraintEqualToConstant:150.0f]
    ]];
    
    [self.gridView addRowWithViews:@[regionLabel, regionMenuButton]];
    
    //
    
    NSMenu *regionMenu = [NSMenu new];
    regionMenuButton.menu = regionMenu;
    
    NSMutableArray<StorableMenuItem *> *itemArray = [SMutableArray<StorableMenuItem *> new];
    
    [blizzardHSAPIRegionsForAPI() enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        StorableMenuItem *menuItem = [[StorableMenuItem alloc] initWithTitle:[ResourcesService localizationForBlizzardAPIRegionHost:BlizzardAPIRegionHostFromNSStringForAPI(obj)]
                                                                      action:@selector(didTriggerRegionItem:)
                                                               keyEquivalent:@""
                                                                    userInfo:@{@"key": obj}];
        menuItem.target = self;
        
        [itemArray addObject:menuItem];
        [menuItem release];
    }];
    
    [itemArray sortUsingComparator:^NSComparisonResult(NSMenuItem *obj1, NSMenuItem *obj2) {
        return [obj1.title compare:obj2.title];
    }];
    
    StorableMenuItem *autoItem = [[StorableMenuItem alloc] initWithTitle:[ResourcesService localizationForKey:LocalizableKeyAuto]
                                                                  action:@selector(didTriggerRegionItem:)
                                                           keyEquivalent:@""
                                                                userInfo:nil];
    autoItem.target = self;
    
    [itemArray insertObject:autoItem atIndex:0];
    [autoItem release];
    
    regionMenu.itemArray = itemArray;
    [itemArray release];
    
    //
    
    self.regionLabel = regionLabel;
    self.regionMenuButton = regionMenuButton;
    self.regionMenu = regionMenu;
    
    [regionLabel release];
    [regionMenuButton release];
    [regionMenu release];
}

- (void)configureDescriptionLabel {
    NSTextField *descriptionLabel = [NSTextField new];

    [descriptionLabel setLabelStyle];
    descriptionLabel.stringValue = [ResourcesService localizationForKey:LocalizableKeyAutoDescription];
    
    [self.view addSubview:descriptionLabel];
    descriptionLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [NSLayoutConstraint activateConstraints:@[
        [descriptionLabel.topAnchor constraintEqualToAnchor:self.gridView.bottomAnchor constant:25.0f],
        [descriptionLabel.centerXAnchor constraintEqualToAnchor:self.gridView.centerXAnchor]
    ]];
    
    self.descriptionLabel = descriptionLabel;
    [descriptionLabel release];
}

- (void)configureViewModel {
    PrefsCardsViewModel *viewModel = [PrefsCardsViewModel new];
    self.viewModel = viewModel;
    [viewModel release];
}

- (void)bind {
    [NSNotificationCenter.defaultCenter addObserver:self
                                           selector:@selector(didReceivePrefsChanged:)
                                               name:NSNotificationNamePrefsCardsViewModelDidChangeData
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
        StorableMenuItem *item = (StorableMenuItem *)obj;
        
        if (![item isKindOfClass:[StorableMenuItem class]]) return;
        
        NSString * _Nullable key = item.userInfo.allValues.firstObject;
        
        if (key == nil) {
            if (prefs.locale == nil) {
                [self.localeMenuButton selectItem:item];
            }
        } else {
            if ([key isEqualToString:prefs.locale]) {
                [self.localeMenuButton selectItem:item];
            }
        }
    }];
}

- (void)updateRegionMenuWithPrefs:(Prefs *)prefs {
    [self.regionMenu.itemArray enumerateObjectsUsingBlock:^(NSMenuItem * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        StorableMenuItem *item = (StorableMenuItem *)obj;
        
        if (![item isKindOfClass:[StorableMenuItem class]]) return;
        
        NSString * _Nullable key = item.userInfo.allValues.firstObject;
        
        if (key == nil) {
            if (prefs.locale == nil) {
                [self.regionMenuButton selectItem:item];
            }
        } else {
            if ([key isEqualToString:prefs.apiRegionHost]) {
                [self.regionMenuButton selectItem:item];
            }
        }
    }];
}

- (void)didTriggerLocaleItem:(StorableMenuItem *)sender {
    [self.viewModel updateLocale:sender.userInfo.allValues.firstObject];
}

- (void)didTriggerRegionItem:(StorableMenuItem *)sender {
    [self.viewModel updateRegionHost:sender.userInfo.allValues.firstObject];
}

@end
