//
//  AppDelegate.m
//  StoneNamuMac
//
//  Created by Jinwoo Kim on 9/26/21.
//

#import "AppDelegate.h"
#import "WindowsService.h"
#import "NSApplication+actualWindows.h"

@interface AppDelegate ()
@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    NSApp.automaticCustomizeTouchBarMenuItemEnabled = YES;
    [WindowsService.sharedInstance startWindowsObserving];
    [WindowsService.sharedInstance presentNewMainWindowIfNeeded];
}

- (BOOL)applicationSupportsSecureRestorableState:(NSApplication *)app {
    // macOS 12.0 or later
    return YES;
}

- (BOOL)applicationShouldHandleReopen:(NSApplication *)sender hasVisibleWindows:(BOOL)flag {
    if (NSApp.actualWindows.count > 0) {
        return NO;
    }
    
    return [WindowsService.sharedInstance presentNewMainWindowIfNeeded];
}

@end
