//
//  FileMenuItem.m
//  StoneNamuMac
//
//  Created by Jinwoo Kim on 11/8/21.
//

#import "FileMenuItem.h"
#import "AppDelegate.h"

@implementation FileMenuItem

- (instancetype)init {
    self = [super init];
    
    if (self) {
        [self configureSubMenus];
    }
    
    return self;
}

- (void)configureSubMenus {
    NSMenu *fileSubMenu = [[NSMenu alloc] initWithTitle:@"File (Demo)"];
    
    //
    
    NSMenuItem *newItem = [[NSMenuItem alloc] initWithTitle:@"New Window (Demo)"
                                                       action:@selector(presentNewMainWindow)
                                                keyEquivalent:@"n"];
    NSMenuItem *closeItem = [[NSMenuItem alloc] initWithTitle:@"Close (Demo)"
                                                       action:@selector(performClose:)
                                                keyEquivalent:@"w"];
    
    newItem.target = NSApp.delegate;
    
    self.submenu = fileSubMenu;
    fileSubMenu.itemArray = @[
        newItem,
        closeItem
    ];
    
    [fileSubMenu release];
    [newItem release];
    [closeItem release];
}

@end
