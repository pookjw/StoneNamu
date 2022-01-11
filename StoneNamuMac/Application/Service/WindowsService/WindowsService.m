//
//  WindowsService.m
//  StoneNamuMac
//
//  Created by Jinwoo Kim on 1/12/22.
//

#import "WindowsService.h"
#import "MainWindow.h"
#import "CardDetailsWindow.h"
#import "PrefsWindow.h"
#import "DeckDetailsWindow.h"

@implementation WindowsService

+ (void)presentNewMainWindow {
    MainWindow *mainWindow = [MainWindow new];
    [mainWindow makeKeyAndOrderFront:nil];
    [mainWindow center];
    [mainWindow release];
}

+ (BOOL)presentNewMainWindowIfNeeded {
    MainWindow * _Nullable __block mainWindow = nil;

    [NSApp.windows enumerateObjectsUsingBlock:^(NSWindow * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:[MainWindow class]]) {
            mainWindow = (MainWindow *)obj;
            *stop = YES;
        }
    }];

    if (mainWindow) {
        [mainWindow makeKeyAndOrderFront:nil];
        return NO;
    } else {
        [self presentNewMainWindow];
        return YES;
    }
}

+ (void)presentCardDetailsWindowWithHSCard:(HSCard *)hsCard {
    CardDetailsWindow *cardDetailsWindow = [[CardDetailsWindow alloc] initWithHSCard:hsCard];
    [cardDetailsWindow makeKeyAndOrderFront:nil];
    [cardDetailsWindow center];
    [cardDetailsWindow release];
}

+ (void)presentDeckDetailsWindowWithLocalDeck:(LocalDeck *)localDeck {
    DeckDetailsWindow *deckDetailsWindow = [[DeckDetailsWindow alloc] initWithLocalDeck:localDeck];
    [deckDetailsWindow makeKeyAndOrderFront:nil];
    [deckDetailsWindow center];
    [deckDetailsWindow release];
}

+ (void)presentNewPrefsWindow {
    PrefsWindow *prefsWindow = [PrefsWindow new];
    [prefsWindow makeKeyAndOrderFront:nil];
    [prefsWindow center];
    [prefsWindow release];
}

+ (BOOL)presentNewPrefsWindowIfNeeded {
    PrefsWindow * _Nullable __block prefsWindow = nil;
    
    [NSApp.windows enumerateObjectsUsingBlock:^(NSWindow * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:[PrefsWindow class]]) {
            prefsWindow = (PrefsWindow *)obj;
            *stop = YES;
        }
    }];
    
    if (prefsWindow) {
        [prefsWindow makeKeyAndOrderFront:nil];
        return NO;
    } else {
        [self presentNewPrefsWindow];
        return YES;
    }
}

@end
