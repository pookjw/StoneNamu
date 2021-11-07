//
//  AppMenuItem.m
//  StoneNamuMac
//
//  Created by Jinwoo Kim on 11/8/21.
//

#import "AppMenuItem.h"

@implementation AppMenuItem

- (instancetype)init {
    self = [super init];
    
    if (self) {
        [self configureSubMenus];
    }
    
    return self;
}

- (void)configureSubMenus {
    NSMenu *appSubMenu = [NSMenu new];
    
    //
    
    NSMenuItem *aboutItem = [[NSMenuItem alloc] initWithTitle:@"About StoneNamu (Demo)"
                                                       action:@selector(orderFrontStandardAboutPanel:)
                                                keyEquivalent:@""];
    
    self.submenu = appSubMenu;
    appSubMenu.itemArray = @[
        aboutItem
    ];
    
    [appSubMenu release];
    [aboutItem release];
}

@end
