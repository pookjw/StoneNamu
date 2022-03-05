//
//  MainInterfaceController.m
//  StoneNamuWatch WatchKit Extension
//
//  Created by Jinwoo Kim on 3/5/22.
//

#import "MainInterfaceController.h"
#import "CardBacksViewController.h"

@interface MainInterfaceController () <WKCrownDelegate>
@end

@implementation MainInterfaceController

- (void)willActivate {
    [super willActivate];
    [self presentMainViewController];
}

- (void)presentMainViewController {
    id application = [NSClassFromString(@"SPApplication") sharedApplication];
    id delegate = [application delegate];
    id window = [delegate window];
    id rootViewController = [window rootViewController];
    
    CardBacksViewController *vc = [CardBacksViewController new];
    [rootViewController setViewControllers:@[vc] animated:NO];
    [vc release];
}

@end
