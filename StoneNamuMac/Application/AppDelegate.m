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
    [self presentNewMainWindowIfNeeded];
}

- (BOOL)applicationSupportsSecureRestorableState:(NSApplication *)app {
    // macOS 12.0 or later
    return YES;
}

- (BOOL)applicationShouldHandleReopen:(NSApplication *)sender hasVisibleWindows:(BOOL)flag {
    BOOL __block hasMainWindow = NO;
    
    [sender.windows enumerateObjectsUsingBlock:^(NSWindow * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:[MainWindow class]]) {
            hasMainWindow = YES;
            *stop = YES;
        }
    }];
    
    if (!hasMainWindow) {
        [self presentNewMainWindow];
        return YES;
    } else {
        return NO;
    }
}

- (void)presentNewMainWindow {
    MainWindow *mainWindow = [MainWindow new];
    [mainWindow makeKeyAndOrderFront:nil];
    [mainWindow release];
}

- (void)presentNewMainWindowIfNeeded {
    BOOL __block hasMainWindow = NO;
    
    [NSApp.windows enumerateObjectsUsingBlock:^(NSWindow * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:[MainWindow class]]) {
            hasMainWindow = YES;
            *stop = YES;
        }
    }];
    
    if (!hasMainWindow) {
        [self presentNewMainWindow];
    }
}

- (void)presentPrefsWindow {
    
}

@end
