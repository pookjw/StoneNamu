//
//  ViewMenuItem.m
//  StoneNamuMac
//
//  Created by Jinwoo Kim on 11/8/21.
//

#import "ViewMenuItem.h"

@implementation ViewMenuItem

- (instancetype)init {
    self = [super init];
    
    if (self) {
        [self configureSubMenus];
    }
    
    return self;
}

- (void)configureSubMenus {
    NSMenu *viewSubMenu = [[NSMenu alloc] initWithTitle:@"View (Demo)"];
    
    //
    
    NSMenuItem *toggleToolbarItem = [[NSMenuItem alloc] initWithTitle:@""
                                                                   action:@selector(toggleToolbarShown:)
                                                            keyEquivalent:@"t"];
    NSMenuItem *customizeToolbarItem = [[NSMenuItem alloc] initWithTitle:@"Customize Toolbar... (Demo)"
                                                                      action:@selector(runToolbarCustomizationPalette:)
                                                               keyEquivalent:@""];
    NSMenuItem *customizeTouchBarItem = [[NSMenuItem alloc] initWithTitle:@""
                                                                       action:@selector(toggleTouchBarCustomizationPalette:)
                                                                keyEquivalent:@""];
    NSMenuItem *toggleFullScreenItem = [[NSMenuItem alloc] initWithTitle:@""
                                                                             action:@selector(toggleFullScreen:)
                                                                      keyEquivalent:@"f"];
    
    
    toggleToolbarItem.keyEquivalentModifierMask = NSEventModifierFlagOption | NSEventModifierFlagCommand;
    toggleFullScreenItem.keyEquivalentModifierMask = NSEventModifierFlagOption | NSEventModifierFlagCommand;
    
    //
    
    self.submenu = viewSubMenu;
    viewSubMenu.itemArray = @[
        toggleToolbarItem,
        customizeToolbarItem,
        [NSMenuItem separatorItem],
        customizeTouchBarItem,
        [NSMenuItem separatorItem],
        toggleFullScreenItem
    ];
    
    [viewSubMenu release];
    [toggleToolbarItem release];
    [customizeToolbarItem release];
    [customizeTouchBarItem release];
    [toggleFullScreenItem release];
}

@end
