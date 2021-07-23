//
//  SceneDelegate.m
//  StoneNamu
//
//  Created by Jinwoo Kim on 7/17/21.
//

#import "SceneDelegate.h"
#import "CardsViewController.h"

@interface SceneDelegate ()
@property (assign) CardsViewController *cardViewController;
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
    
    CardsViewController *cardViewController = [CardsViewController new];
    self.cardViewController = cardViewController;
    self.window.rootViewController = cardViewController;
    [cardViewController release];
    [cardViewController loadViewIfNeeded];
    [self.window makeKeyAndVisible];
}

@end
