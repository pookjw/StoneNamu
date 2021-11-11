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

@interface MainWindow () <NSWindowDelegate>
@property (retain) MainSplitViewController *mainSplitViewController;
@end

@implementation MainWindow

- (instancetype)init {
    self = [super init];
    
    if (self) {
        [self setAttributes];
        
        MainSplitViewController *mainSplitViewController = [MainSplitViewController new];
        self.mainSplitViewController = mainSplitViewController;
        [mainSplitViewController loadViewIfNeeded];
        self.contentViewController = mainSplitViewController;
        [mainSplitViewController release];
    }
    
    return self;
}

- (void)dealloc {
    [_mainSplitViewController release];
    [super dealloc];
}

- (void)restoreStateWithCoder:(NSCoder *)coder {
    [super restoreStateWithCoder:coder];
    [self.mainSplitViewController restoreStateWithCoder:coder];
}

- (void)setAttributes {
    self.styleMask = NSWindowStyleMaskClosable | NSWindowStyleMaskMiniaturizable | NSWindowStyleMaskFullSizeContentView | NSWindowStyleMaskResizable | NSWindowStyleMaskTitled;
    self.movableByWindowBackground = YES;
    self.contentMinSize = NSMakeSize(800, 600);
    self.releasedWhenClosed = NO;
    self.titlebarAppearsTransparent = NO;
    self.titleVisibility = NSWindowTitleHidden;
    self.delegate = self;
    self.restorable = YES;
    self.restorationClass = [MainWindowRestoration class];
    self.identifier = NSUserInterfaceItemIdentifierMainWindow;
}

#pragma mark - NSWindowDelegate

- (void)window:(NSWindow *)window willEncodeRestorableState:(NSCoder *)state {
    
}

- (void)window:(NSWindow *)window didDecodeRestorableState:(NSCoder *)state {
    
}

@end
