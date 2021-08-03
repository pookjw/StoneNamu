//
//  SceneDelegate.m
//  StoneNamu
//
//  Created by Jinwoo Kim on 7/17/21.
//

#import "SceneDelegate.h"
#import "CardOptionsViewController.h"

@interface SceneDelegate ()
@property (assign) CardOptionsViewController *cardOptionsViewController;
@end

@implementation SceneDelegate

- (void)dealloc {
    [_window release];
    [super dealloc];
}


- (void)scene:(UIScene *)scene willConnectToSession:(UISceneSession *)session options:(UISceneConnectionOptions *)connectionOptions {
    UIWindowScene *windowScene = (UIWindowScene *)scene;
    
    if (![windowScene isKindOfClass:[UIWindowScene class]]) return;
    
    UIWindow *window = [[UIWindow alloc] initWithWindowScene:windowScene];
    self.window = window;
    [window release];
    
    [self.window setTintColor:UIColor.redColor];
    
    CardOptionsViewController *cardOptionsViewController = [CardOptionsViewController new];
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:cardOptionsViewController];
    self.cardOptionsViewController = cardOptionsViewController;
    
    [cardOptionsViewController release];
    self.window.rootViewController = navigationController;
    [navigationController release];
    [navigationController loadViewIfNeeded];
    [self.window makeKeyAndVisible];
}

@end
