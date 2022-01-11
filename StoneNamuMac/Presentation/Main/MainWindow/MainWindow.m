//
//  MainWindow.m
//  MainWindow
//
//  Created by Jinwoo Kim on 9/26/21.
//

#import "MainWindow.h"
#import "MainSplitViewController.h"
#import "MainWindowRestoration.h"
#import "NSViewController+loadViewIfNeeded.h"
#import <StoneNamuResources/StoneNamuResources.h>
#import "NSProcessInfo+isEnabledRestoration.h"

static NSUserInterfaceItemIdentifier const NSUserInterfaceItemIdentifierMainWindow = @"NSUserInterfaceItemIdentifierMainWindow";

@interface MainWindow () <NSWindowDelegate>
@property (retain) MainSplitViewController *mainSplitViewController;
@end

@implementation MainWindow

- (instancetype)init {
    self = [super init];
    
    if (self) {
        [self setAttributes];
        [self configureMainSplitViewController];
    }
    
    return self;
}

- (void)dealloc {
    [_mainSplitViewController release];
    [super dealloc];
}

- (void)encodeRestorableStateWithCoder:(NSCoder *)coder backgroundQueue:(NSOperationQueue *)queue {
    [super encodeRestorableStateWithCoder:coder backgroundQueue:queue];
    [self.mainSplitViewController encodeRestorableStateWithCoder:coder backgroundQueue:queue];
}

- (void)restoreStateWithCoder:(NSCoder *)coder {
    [super restoreStateWithCoder:coder];
    [self.mainSplitViewController restoreStateWithCoder:coder];
}

- (void)setAttributes {
    self.styleMask = NSWindowStyleMaskClosable | NSWindowStyleMaskMiniaturizable | NSWindowStyleMaskFullSizeContentView | NSWindowStyleMaskResizable | NSWindowStyleMaskTitled;
    self.movableByWindowBackground = YES;
    self.contentMinSize = NSMakeSize(1000, 600);
    self.releasedWhenClosed = NO;
    self.titlebarAppearsTransparent = NO;
    self.titleVisibility = NSWindowTitleHidden;
    self.delegate = self;
    self.restorable = NSProcessInfo.processInfo.isEnabledRestoration;
    self.restorationClass = [MainWindowRestoration class];
    self.identifier = NSUserInterfaceItemIdentifierMainWindow;
}

- (void)configureMainSplitViewController {
    MainSplitViewController *mainSplitViewController = [MainSplitViewController new];

    [mainSplitViewController loadViewIfNeeded];
    self.contentViewController = mainSplitViewController;
    
    self.mainSplitViewController = mainSplitViewController;
    [mainSplitViewController release];
}

#pragma mark - NSWindowDelegate

- (void)window:(NSWindow *)window willEncodeRestorableState:(NSCoder *)state {
    
}

- (void)window:(NSWindow *)window didDecodeRestorableState:(NSCoder *)state {
    
}

@end
