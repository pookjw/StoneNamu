//
//  CardsViewController.m
//  CardsViewController
//
//  Created by Jinwoo Kim on 9/26/21.
//

#import "CardsViewController.h"
#import "NSWindow+presentErrorAlert.h"
#import "CardsViewModel.h"

@interface CardsViewController ()
@property (retain) CardsViewModel *viewModel;
@end

@implementation CardsViewController

- (instancetype)init {
    self = [super init];
    
    if (self) {
        
    }
    
    return self;
}

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
    [self configureViewModel];
}

- (void)configureViewModel {
//    CardsViewModel *viewModel = [CardsViewModel new];
//    self.viewModel = viewModel;
//    [viewModel release];
}

@end
