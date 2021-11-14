//
//  PrefsViewController.m
//  StoneNamuMac
//
//  Created by Jinwoo Kim on 11/14/21.
//

#import "PrefsViewController.h"

@interface PrefsViewController ()

@end

@implementation PrefsViewController

- (void)loadView {
    NSView *view = [NSView new];
    self.view = view;
    [view release];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.preferredContentSize = NSMakeSize(300, 300);
}

@end
