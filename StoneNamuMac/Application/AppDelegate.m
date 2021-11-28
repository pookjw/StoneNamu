//
//  AppDelegate.m
//  StoneNamuMac
//
//  Created by Jinwoo Kim on 9/26/21.
//

#import "AppDelegate.h"
#import "MainWindow.h"
#import "CardDetailsWindow.h"
#import "PrefsWindow.h"
#import "DeckDetailsWindow.h"

@interface AppDelegate ()
@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    NSApp.automaticCustomizeTouchBarMenuItemEnabled = YES;
    [self presentNewMainWindow];
}

- (BOOL)applicationSupportsSecureRestorableState:(NSApplication *)app {
    // macOS 12.0 or later
    return YES;
}

- (BOOL)applicationShouldHandleReopen:(NSApplication *)sender hasVisibleWindows:(BOOL)flag {
    [self presentNewMainWindowIfNeeded];
    return YES;
}

- (void)presentNewMainWindow {
    MainWindow *mainWindow = [MainWindow new];
    [mainWindow makeKeyAndOrderFront:nil];
    [mainWindow center];
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

- (void)presentCardDetailsWindowWithHSCard:(HSCard *)hsCard {
    CardDetailsWindow *cardDetailsWindow = [[CardDetailsWindow alloc] initWithHSCard:hsCard];
    [cardDetailsWindow makeKeyAndOrderFront:nil];
    [cardDetailsWindow center];
    [cardDetailsWindow release];
}

- (void)presentDeckDetailsWindowWithLocalDeck:(LocalDeck *)localDeck {
    DeckDetailsWindow *deckDetailsWindow = [[DeckDetailsWindow alloc] initWithLocalDeck:localDeck];
    [deckDetailsWindow makeKeyAndOrderFront:nil];
    [deckDetailsWindow center];
    [deckDetailsWindow release];
}

- (void)presentNewPrefsWindow {
    PrefsWindow *prefsWindow = [PrefsWindow new];
    [prefsWindow makeKeyAndOrderFront:nil];
    [prefsWindow center];
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
