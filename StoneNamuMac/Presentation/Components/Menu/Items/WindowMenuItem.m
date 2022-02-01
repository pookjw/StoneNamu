//
//  WindowMenuItem.m
//  StoneNamuMac
//
//  Created by Jinwoo Kim on 11/8/21.
//

#import "WindowMenuItem.h"
#import <StoneNamuResources/StoneNamuResources.h>

@implementation WindowMenuItem

- (instancetype)init {
    self = [super init];
    
    if (self) {
        [self configureSubMenus];
    }
    
    return self;
}

- (void)configureSubMenus {
    NSMenu *windowSubMenu = [[NSMenu alloc] initWithTitle:[ResourcesService localizationForKey:LocalizableKeyWindowMenuTitle]];
    
    //
    
    NSMenuItem *minimizeItem = [[NSMenuItem alloc] initWithTitle:[ResourcesService localizationForKey:LocalizableKeyWindowMenuMinimize]
                                                          action:@selector(performMiniaturize:)
                                                   keyEquivalent:@"m"];
    NSMenuItem *zoomItem = [[NSMenuItem alloc] initWithTitle:[ResourcesService localizationForKey:LocalizableKeyWindowMenuZoom]
                                                      action:@selector(performZoom:)
                                               keyEquivalent:@""];
    NSMenuItem *bringItem = [[NSMenuItem alloc] initWithTitle:[ResourcesService localizationForKey:LocalizableKeyWindowMenuBringAllToFront]
                                                       action:@selector(arrangeInFront:)
                                                keyEquivalent:@""];
    
#if DEBUG
    NSMenuItem *centerItem = [[NSMenuItem alloc] initWithTitle:@"Center"
                                                        action:@selector(center)
                                                 keyEquivalent:@""];
#endif
    
    //
    
    self.submenu = windowSubMenu;
    windowSubMenu.itemArray = @[
        minimizeItem,
        zoomItem,
        [NSMenuItem separatorItem],
        bringItem,
        centerItem
    ];
    
    [windowSubMenu release];
    [minimizeItem release];
    [zoomItem release];
    [bringItem release];
#if DEBUG
    [centerItem release];
#endif
}

@end
