//
//  PrefsDataViewController.m
//  StoneNamuMac
//
//  Created by Jinwoo Kim on 11/14/21.
//

#import "PrefsDataViewController.h"
#import "PrefsDataViewModel.h"

@interface PrefsDataViewController ()
@property (retain) PrefsDataViewModel *viewModel;
@end

@implementation PrefsDataViewController

- (void)dealloc {
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
    [self configureviewModel];
    [self bind];
    [self.viewModel requestFormattedFileSize];
}

- (void)configureviewModel {
    PrefsDataViewModel *viewModel = [PrefsDataViewModel new];
    self.viewModel = viewModel;
    [viewModel release];
}

- (void)bind {
    [NSNotificationCenter.defaultCenter addObserver:self
                                           selector:@selector(didChangeFormattedFileSize:)
                                               name:PrefsDataViewModelDidChangeFormattedFileSizeNotificationName
                                             object:self.viewModel];
}

- (void)didChangeFormattedFileSize:(NSNotification *)notification {
    NSString *fileSize = notification.userInfo[PrefsDataViewModelDidChangeFormattedFileSizeNotificationItemKey];
    
    [NSOperationQueue.mainQueue addOperationWithBlock:^{
        NSLog(@"fileSize: %@", fileSize);
    }];
}

@end
