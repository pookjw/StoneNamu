//
//  SceneDelegate.m
//  StoneNamu
//
//  Created by Jinwoo Kim on 7/17/21.
//

#import "SceneDelegate.h"
#import "MainViewController.h"

@interface SceneDelegate ()
@property (assign) MainViewController *mainViewController;
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
    
    MainViewController *mainViewController = [MainViewController new];
    self.mainViewController = mainViewController;
    self.window.rootViewController = mainViewController;
    [mainViewController release];
    [mainViewController loadViewIfNeeded];
    [self.window makeKeyAndVisible];
}

@end
