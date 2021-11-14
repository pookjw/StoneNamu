//
//  PrefsWindow.m
//  StoneNamuMac
//
//  Created by Jinwoo Kim on 11/14/21.
//

#import "PrefsWindow.h"
#import "NSViewController+loadViewIfNeeded.h"
#import "PrefsViewController.h"
#import <StoneNamuResources/StoneNamuResources.h>

@interface PrefsWindow () <NSWindowDelegate>
@property (retain) PrefsViewController *prefsViewController;
@end

@implementation PrefsWindow

- (instancetype)init {
    self = [super init];
    
    if (self) {
        [self setAttributes];
        
        PrefsViewController *prefsViewController = [PrefsViewController new];
        self.prefsViewController = prefsViewController;
        [prefsViewController loadViewIfNeeded];
        self.contentViewController = prefsViewController;
        [prefsViewController release];
    }
    
    return self;
}

- (void)dealloc {
    [_prefsViewController release];
    [super dealloc];
}

- (void)setAttributes {
    self.styleMask = NSWindowStyleMaskClosable | NSWindowStyleMaskTitled;
    self.movableByWindowBackground = NO;
    self.contentMinSize = NSMakeSize(800, 600);
    self.releasedWhenClosed = NO;
    self.titlebarAppearsTransparent = NO;
    self.titleVisibility = NSWindowTitleVisible;
    self.delegate = self;
    self.restorable = YES;
//    self.restorationClass = [MainWindowRestoration class];
    self.identifier = NSUserInterfaceItemIdentifierPrefsWindow;
}

#pragma mark - NSWindowDelegate

- (void)window:(NSWindow *)window willEncodeRestorableState:(NSCoder *)state {
    
}

- (void)window:(NSWindow *)window didDecodeRestorableState:(NSCoder *)state {
    
}

@end
