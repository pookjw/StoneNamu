//
//  SceneDelegate.m
//  StoneNamu
//
//  Created by Jinwoo Kim on 7/17/21.
//

#import "SceneDelegate.h"

@interface SceneDelegate ()
@end

@implementation SceneDelegate

- (void)dealloc {
    [_window release];
    [_mainViewController release];
    [super dealloc];
}

- (void)scene:(UIScene *)scene willConnectToSession:(UISceneSession *)session options:(UISceneConnectionOptions *)connectionOptions {
    UIWindowScene *windowScene = (UIWindowScene *)scene;
    
    if (![windowScene isKindOfClass:[UIWindowScene class]]) return;
    
#if TARGET_OS_MACCATALYST
    if (windowScene.titlebar != nil) {
        windowScene.titlebar.titleVisibility = UITitlebarTitleVisibilityHidden;
        windowScene.titlebar.toolbar = nil;
    }
#endif
    
    UIWindow *window = [[UIWindow alloc] initWithWindowScene:windowScene];
//    [self.window setTintColor:UIColor.redColor];
    
    MainViewController *mainViewController = [MainViewController new];
    self.mainViewController = mainViewController;
    [mainViewController loadViewIfNeeded];
    
    window.rootViewController = mainViewController;
    [mainViewController release];
    [window makeKeyAndVisible];
    
    self.window = window;
    [window release];
}

@end
