//
//  WindowsService.m
//  StoneNamuMac
//
//  Created by Jinwoo Kim on 1/12/22.
//

#import "WindowsService.h"
#import "BaseMenu.h"
#import "MainWindow.h"
#import "CardDetailsWindow.h"
#import "PrefsWindow.h"
#import "DeckDetailsWindow.h"
#import "NSApplication+actualWindows.h"

@interface WindowsService ()
@property (retain) BaseMenu *baseMenu;
@end

@implementation WindowsService

+ (WindowsService *)sharedInstance {
    static WindowsService *sharedInstance = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        sharedInstance = [WindowsService new];
    });
    
    return sharedInstance;
}

- (instancetype)init {
    self = [super init];
    
    if (self) {
        [self configureBaseMenu];
    }
    
    return self;
}

- (void)dealloc {
    [NSApp removeObserver:self forKeyPath:@"self.mainWindow"];
    [_baseMenu release];
    [super dealloc];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if (([object isEqual:NSApp]) && ([keyPath isEqualToString:@"self.mainWindow"])) {
        [NSOperationQueue.mainQueue addOperationWithBlock:^{
            [self replaceBaseMenuIfNeeded];
        }];
    } else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

- (void)configureBaseMenu {
    BaseMenu *baseMenu = [BaseMenu new];
    self.baseMenu = baseMenu;
    [baseMenu release];
}

- (void)startWindowsObserving {
    if (self.observationInfo == NULL) {
        [NSApp addObserver:self forKeyPath:@"self.mainWindow" options:NSKeyValueObservingOptionInitial | NSKeyValueObservingOptionNew context:nil];
    }
}

- (void)presentNewMainWindow {
    MainWindow *mainWindow = [MainWindow new];
    [mainWindow makeKeyAndOrderFront:nil];
    [mainWindow center];
    [mainWindow release];
}

- (BOOL)presentNewMainWindowIfNeeded {
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

- (BOOL)presentNewPrefsWindowIfNeeded {
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

- (void)replaceBaseMenuIfNeeded {
    if (NSApp.actualWindows.count == 0) {
        NSApp.mainMenu = self.baseMenu;
    }
}

@end
