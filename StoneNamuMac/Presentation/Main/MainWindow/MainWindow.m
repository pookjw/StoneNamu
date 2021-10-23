//
//  MainWindow.m
//  MainWindow
//
//  Created by Jinwoo Kim on 9/26/21.
//

#import "MainWindow.h"
#import "MainSplitViewController.h"

@interface MainWindow ()
@property (retain) MainSplitViewController *mainSplitViewController;
@end

@implementation MainWindow

- (instancetype)init {
    self = [super init];
    
    if (self) {
        self.styleMask = NSWindowStyleMaskClosable | NSWindowStyleMaskMiniaturizable | NSWindowStyleMaskFullSizeContentView | NSWindowStyleMaskResizable | NSWindowStyleMaskTitled;
        self.titlebarAppearsTransparent = YES;
        self.movableByWindowBackground = YES;
        self.titleVisibility = NSWindowTitleHidden;
        self.contentMinSize = NSMakeSize(800, 600);
        self.releasedWhenClosed = NO;
        
        MainSplitViewController *mainSplitViewController = [MainSplitViewController new];
        self.mainSplitViewController = mainSplitViewController;
        self.contentViewController = mainSplitViewController;
        [mainSplitViewController release];
    }
    
    return self;
}

- (void)dealloc {
    [_mainSplitViewController release];
    [super dealloc];
}

@end
