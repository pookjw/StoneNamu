//
//  MainInterfaceController.m
//  StoneNamuWatch WatchKit Extension
//
//  Created by Jinwoo Kim on 3/9/22.
//

#import "MainInterfaceController.h"
#import "CardBacksController.h"

@implementation MainInterfaceController

- (void)willActivate {
    [super willActivate];
    
    id application = [NSClassFromString(@"SPApplication") sharedApplication];
    id delegate = [application delegate];
    id window = [delegate window];
    id rootViewController = [window rootViewController];
    
    [rootViewController setViewControllers:@[] animated:NO];
    
    CardBacksController *cardBacksController = [CardBacksController new];
    [cardBacksController push];
    [cardBacksController release];
}

@end
