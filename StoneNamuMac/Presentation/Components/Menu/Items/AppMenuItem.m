//
//  AppMenuItem.m
//  StoneNamuMac
//
//  Created by Jinwoo Kim on 11/8/21.
//

#import "AppMenuItem.h"
#import "WindowsService.h"

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
    NSMenuItem *prefsItem = [[NSMenuItem alloc] initWithTitle:@"Preferences (Demo)"
                                                       action:@selector(presentNewPrefsWindowIfNeeded:)
                                                keyEquivalent:@","];
    NSMenuItem *hideItem = [[NSMenuItem alloc] initWithTitle:@"Hide StoneNamu (Demo)"
                                                      action:@selector(hide:)
                                               keyEquivalent:@"h"];
    NSMenuItem *hideOthersItem = [[NSMenuItem alloc] initWithTitle:@"Hide Others (Demo)"
                                                            action:@selector(hideOtherApplications:)
                                                     keyEquivalent:@"h"];
    NSMenuItem *showAllItem = [[NSMenuItem alloc] initWithTitle:@"Show All (Demo)"
                                                         action:@selector(unhideAllApplications:)
                                                  keyEquivalent:@""];
    NSMenuItem *quitItem = [[NSMenuItem alloc] initWithTitle:@"Quit StoneNamu (Demo)"
                                                      action:@selector(terminate:)
                                               keyEquivalent:@"q"];
    
    prefsItem.target = self;
    hideOthersItem.keyEquivalentModifierMask = NSEventModifierFlagShift | NSEventModifierFlagCommand;
    
    self.submenu = appSubMenu;
    appSubMenu.itemArray = @[
        aboutItem,
        [NSMenuItem separatorItem],
        prefsItem,
        [NSMenuItem separatorItem],
        hideItem,
        hideOthersItem,
        showAllItem,
        [NSMenuItem separatorItem],
        quitItem
    ];
    
    [appSubMenu release];
    [aboutItem release];
    [prefsItem release];
    [hideItem release];
    [hideOthersItem release];
    [showAllItem release];
    [quitItem release];
}

- (void)presentNewPrefsWindowIfNeeded:(NSMenuItem *)sender {
    [WindowsService.sharedInstance presentNewPrefsWindowIfNeeded];
}

@end
