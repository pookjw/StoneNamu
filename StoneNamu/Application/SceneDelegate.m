//
//  SceneDelegate.m
//  StoneNamu
//
//  Created by Jinwoo Kim on 7/17/21.
//

#import "SceneDelegate.h"
#import "MainTabBarController.h"

@interface SceneDelegate ()
@property (retain) MainTabBarController *tabBarController;
@end

@implementation SceneDelegate

- (void)dealloc {
    [_window release];
    [_tabBarController release];
    [super dealloc];
}


- (void)scene:(UIScene *)scene willConnectToSession:(UISceneSession *)session options:(UISceneConnectionOptions *)connectionOptions {
    UIWindowScene *windowScene = (UIWindowScene *)scene;
    
    if (![windowScene isKindOfClass:[UIWindowScene class]]) return;
    
    UIWindow *window = [[UIWindow alloc] initWithWindowScene:windowScene];
    self.window = window;
    [window release];
    
    [self.window setTintColor:UIColor.redColor];
    
    MainTabBarController *tabBarController = [MainTabBarController new];
    self.tabBarController = tabBarController;
    
    [tabBarController loadViewIfNeeded];
    self.window.rootViewController = tabBarController;
    [tabBarController release];
    [self.window makeKeyAndVisible];
}

@end
