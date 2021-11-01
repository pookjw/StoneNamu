//
//  AppDelegate.m
//  StoneNamuMac
//
//  Created by Jinwoo Kim on 9/26/21.
//

#import "AppDelegate.h"
#import "MainWindow.h"

@interface AppDelegate ()
@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    NSApp.automaticCustomizeTouchBarMenuItemEnabled = YES;
    [self presentMainWindow];
}

- (void)presentMainWindow {
    MainWindow *mainWindow = [MainWindow new];
    [mainWindow makeKeyAndOrderFront:nil];
    [mainWindow release];
}

@end
