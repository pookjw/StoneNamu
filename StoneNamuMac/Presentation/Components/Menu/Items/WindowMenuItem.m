//
//  WindowMenuItem.m
//  StoneNamuMac
//
//  Created by Jinwoo Kim on 11/8/21.
//

#import "WindowMenuItem.h"

@implementation WindowMenuItem

- (instancetype)init {
    self = [super init];
    
    if (self) {
        [self configureSubMenus];
    }
    
    return self;
}

- (void)configureSubMenus {
    NSMenu *windowSubMenu = [[NSMenu alloc] initWithTitle:@"Window (Demo)"];
    
    //
    
    NSMenuItem *minimizeItem = [[NSMenuItem alloc] initWithTitle:@"Minimize (Demo)"
                                                          action:@selector(performMiniaturize:)
                                                   keyEquivalent:@"m"];
    NSMenuItem *zoomItem = [[NSMenuItem alloc] initWithTitle:@"Zoom (Demo)"
                                                      action:@selector(performZoom:)
                                               keyEquivalent:@""];
    NSMenuItem *bringItem = [[NSMenuItem alloc] initWithTitle:@"Bring All to Front (Demo)"
                                                       action:@selector(arrangeInFront:)
                                                keyEquivalent:@""];
    
    //
    
    self.submenu = windowSubMenu;
    windowSubMenu.itemArray = @[
        minimizeItem,
        zoomItem,
        [NSMenuItem separatorItem],
        bringItem
    ];
    
    [windowSubMenu release];
    [minimizeItem release];
    [zoomItem release];
    [bringItem release];
}

@end
