//
//  PrefsWindow.m
//  StoneNamuMac
//
//  Created by Jinwoo Kim on 11/14/21.
//

#import "PrefsWindow.h"
#import "NSViewController+loadViewIfNeeded.h"
#import "PrefsTabViewController.h"
#import "NSProcessInfo+isEnabledRestoration.h"

static NSUserInterfaceItemIdentifier const NSUserInterfaceItemIdentifierPrefsWindow = @"NSUserInterfaceItemIdentifierPrefsWindow";

@interface PrefsWindow () <NSWindowDelegate>
@property (retain) PrefsTabViewController *prefsTabViewController;
@end

@implementation PrefsWindow

- (instancetype)init {
    self = [super init];
    
    if (self) {
        [self setAttributes];
        [self configurePrefsTabViewController];
    }
    
    return self;
}

- (void)dealloc {
    [_prefsTabViewController release];
    [super dealloc];
}

- (void)setAttributes {
    self.styleMask = NSWindowStyleMaskClosable | NSWindowStyleMaskTitled;
    self.movableByWindowBackground = NO;
    self.contentMinSize = NSMakeSize(500, 300);
    self.releasedWhenClosed = NO;
    self.titlebarAppearsTransparent = NO;
    self.titleVisibility = NSWindowTitleVisible;
    self.delegate = self;
    self.restorable = NSProcessInfo.processInfo.isEnabledRestoration;
//        self.restorationClass = [MainWindowRestoration class];
    self.identifier = NSUserInterfaceItemIdentifierPrefsWindow;
}

- (void)configurePrefsTabViewController {
    PrefsTabViewController *prefsTabViewController = [PrefsTabViewController new];
    [prefsTabViewController loadViewIfNeeded];
    self.contentViewController = prefsTabViewController;
    
    self.prefsTabViewController = prefsTabViewController;
    [prefsTabViewController release];
}

#pragma mark - NSWindowDelegate

- (void)window:(NSWindow *)window willEncodeRestorableState:(NSCoder *)state {
    
}

- (void)window:(NSWindow *)window didDecodeRestorableState:(NSCoder *)state {
    
}

@end
