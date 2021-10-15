//
//  MainWindow.m
//  MainWindow
//
//  Created by Jinwoo Kim on 9/26/21.
//

#import "MainWindow.h"
#import "OneBesideSecondarySplitViewController.h"

@interface MainWindow ()
@property (retain) OneBesideSecondarySplitViewController *mainSplitViewController;
@end

@implementation MainWindow

- (instancetype)init {
    self = [super init];
    
    if (self) {
        self.styleMask = NSWindowStyleMaskClosable | NSWindowStyleMaskMiniaturizable | NSWindowStyleMaskFullSizeContentView | NSWindowStyleMaskResizable | NSWindowStyleMaskTitled;
        self.titlebarAppearsTransparent = YES;
        self.movableByWindowBackground = YES;
        self.titleVisibility = NSWindowTitleHidden;
        self.contentMinSize = NSMakeSize(300, 300);
        self.releasedWhenClosed = NO;
        
        OneBesideSecondarySplitViewController *mainSplitViewController = [OneBesideSecondarySplitViewController new];
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
