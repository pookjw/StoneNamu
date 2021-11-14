//
//  AppDelegate.m
//  StoneNamuMac
//
//  Created by Jinwoo Kim on 9/26/21.
//

#import "AppDelegate.h"
#import "MainWindow.h"
#import "PrefsWindow.h"

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
    MainWindow * _Nullable __block mainWindow = nil;
    
    [NSApp.windows enumerateObjectsUsingBlock:^(NSWindow * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:[MainWindow class]]) {
            mainWindow = (MainWindow *)obj;
            *stop = YES;
        }
    }];
    
    if (mainWindow) {
        [mainWindow makeKeyAndOrderFront:nil];
    } else {
        [self presentNewMainWindow];
    }
}

- (void)presentNewPrefsWindow {
    PrefsWindow *prefsWindow = [PrefsWindow new];
    [prefsWindow makeKeyAndOrderFront:nil];
    [prefsWindow release];
}

- (void)presentNewPrefsWindowIfNeeded {
    PrefsWindow * _Nullable __block prefsWindow = nil;
    
    [NSApp.windows enumerateObjectsUsingBlock:^(NSWindow * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:[PrefsWindow class]]) {
            prefsWindow = (PrefsWindow *)obj;
            *stop = YES;
        }
    }];
    
    if (prefsWindow) {
        [prefsWindow makeKeyAndOrderFront:nil];
    } else {
        [self presentNewPrefsWindow];
    }
}

@end
