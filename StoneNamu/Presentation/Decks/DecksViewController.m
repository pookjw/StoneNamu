//
//  DecksViewController.m
//  DecksViewController
//
//  Created by Jinwoo Kim on 8/17/21.
//

#import "DecksViewController.h"

@interface DecksViewController ()

@end

@implementation DecksViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self configureNavigation];
}

- (void)setAttributes {
    self.view.backgroundColor = UIColor.systemBackgroundColor;
}

- (void)configureNavigation {
    self.title = NSLocalizedString(@"DECKS", @"");
    self.navigationItem.largeTitleDisplayMode = UINavigationItemLargeTitleDisplayModeAlways;
    self.navigationController.navigationBar.prefersLargeTitles = YES;
}

@end
