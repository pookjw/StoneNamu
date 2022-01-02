//
//  PrefsDataViewController.m
//  StoneNamuMac
//
//  Created by Jinwoo Kim on 11/14/21.
//

#import "PrefsDataViewController.h"
#import "PrefsDataViewModel.h"
#import "NSTextField+setLabelStyle.h"
#import <StoneNamuResources/StoneNamuResources.h>

@interface PrefsDataViewController ()
@property (retain) NSButton *deleteAllDataCacheButton;
@property (retain) NSTextField *dataCacheSizeLabel;
@property (retain) NSButton *deleteAllLocalDeckButton;
@property (retain) PrefsDataViewModel *viewModel;
@end

@implementation PrefsDataViewController

- (void)dealloc {
    [_deleteAllDataCacheButton release];
    [_dataCacheSizeLabel release];
    [_deleteAllLocalDeckButton release];
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
    [self configureDeleteAllDataCacheButton];
    [self configureDataCacheSizeLabel];
#if DEBUG
    [self configureDeleteAllLocalDeckButton];
#endif
    [self configureViewModel];
    [self bind];
    [self.viewModel requestFormattedFileSize];
}

- (void)configureDeleteAllDataCacheButton {
    NSButton *deleteAllDataCacheButton = [NSButton new];
    
    deleteAllDataCacheButton.title = [ResourcesService localizationForKey:LocalizableKeyDeleteAllCaches];
    deleteAllDataCacheButton.bezelStyle = NSBezelStyleRounded;
    deleteAllDataCacheButton.target = self;
    deleteAllDataCacheButton.action = @selector(didTriggerDeleteAllDataCacheButton:);
    deleteAllDataCacheButton.translatesAutoresizingMaskIntoConstraints = NO;
    
    [self.view addSubview:deleteAllDataCacheButton];
    [NSLayoutConstraint activateConstraints:@[
        [deleteAllDataCacheButton.topAnchor constraintEqualToAnchor:self.view.topAnchor constant:25.0f],
        [deleteAllDataCacheButton.centerXAnchor constraintEqualToAnchor:self.view.centerXAnchor]
    ]];
    
    self.deleteAllDataCacheButton = deleteAllDataCacheButton;
    [deleteAllDataCacheButton release];
}

- (void)configureDataCacheSizeLabel {
    NSTextField *dataCacheSizeLabel = [NSTextField new];
    [dataCacheSizeLabel setLabelStyle];
    
    dataCacheSizeLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:dataCacheSizeLabel];
    [NSLayoutConstraint activateConstraints:@[
        [dataCacheSizeLabel.topAnchor constraintEqualToAnchor:self.deleteAllDataCacheButton.bottomAnchor constant:25.0f],
        [dataCacheSizeLabel.centerXAnchor constraintEqualToAnchor:self.deleteAllDataCacheButton.centerXAnchor]
    ]];
    
    self.dataCacheSizeLabel = dataCacheSizeLabel;
    [dataCacheSizeLabel release];
}

- (void)configureDeleteAllLocalDeckButton {
    NSButton *deleteAllLocalDeckButton = [NSButton new];
    
    deleteAllLocalDeckButton.title = @"Remove All LocalDecks";
    deleteAllLocalDeckButton.bezelStyle = NSBezelStyleRounded;
    deleteAllLocalDeckButton.target = self;
    deleteAllLocalDeckButton.action = @selector(didTriggerDeleteAllLocalDeckButton:);
    deleteAllLocalDeckButton.translatesAutoresizingMaskIntoConstraints = NO;
    
    [self.view addSubview:deleteAllLocalDeckButton];
    [NSLayoutConstraint activateConstraints:@[
        [deleteAllLocalDeckButton.topAnchor constraintEqualToAnchor:self.dataCacheSizeLabel.bottomAnchor constant:25.0f],
        [deleteAllLocalDeckButton.centerXAnchor constraintEqualToAnchor:self.dataCacheSizeLabel.centerXAnchor]
    ]];
    
    self.deleteAllLocalDeckButton = deleteAllLocalDeckButton;
    [deleteAllLocalDeckButton release];
}

- (void)configureViewModel {
    PrefsDataViewModel *viewModel = [PrefsDataViewModel new];
    self.viewModel = viewModel;
    [viewModel release];
}

- (void)bind {
    [NSNotificationCenter.defaultCenter addObserver:self
                                           selector:@selector(didChangeFormattedFileSize:)
                                               name:NSNotificationNamePrefsDataViewModelDidChangeFormattedFileSize
                                             object:self.viewModel];
}

- (void)didChangeFormattedFileSize:(NSNotification *)notification {
    NSString *fileSize = notification.userInfo[PrefsDataViewModelDidChangeFormattedFileSizeNotificationItemKey];
    
    [NSOperationQueue.mainQueue addOperationWithBlock:^{
        self.dataCacheSizeLabel.stringValue = [NSString stringWithFormat:[ResourcesService localizationForKey:LocalizableKeyCacheSize], fileSize];
    }];
}

- (void)didTriggerDeleteAllDataCacheButton:(NSButton *)sender {
    [self.viewModel deleteAllCahces];
}

- (void)didTriggerDeleteAllLocalDeckButton:(NSButton *)sender {
    [self.viewModel deleteAllLocalDecks];
}

@end
