//
//  FileMenuItem.m
//  StoneNamuMac
//
//  Created by Jinwoo Kim on 11/8/21.
//

#import "FileMenuItem.h"
#import "WindowsService.h"
#import <StoneNamuResources/StoneNamuResources.h>

@implementation FileMenuItem

- (instancetype)init {
    self = [super init];
    
    if (self) {
        [self configureSubMenus];
    }
    
    return self;
}

- (void)configureSubMenus {
    NSMenu *fileSubMenu = [[NSMenu alloc] initWithTitle:[ResourcesService localizationForKey:LocalizableKeyFlieMenuTitle]];
    
    //
    
    NSMenuItem *newItem = [[NSMenuItem alloc] initWithTitle:[ResourcesService localizationForKey:LocalizableKeyFileMenuNewWindow]
                                                     action:@selector(presentNewMainWindow:)
                                              keyEquivalent:@"n"];
    NSMenuItem *closeItem = [[NSMenuItem alloc] initWithTitle:[ResourcesService localizationForKey:LocalizableKeyFlieMenuClose]
                                                       action:@selector(performClose:)
                                                keyEquivalent:@"w"];
    
    newItem.target = self;
    
    self.submenu = fileSubMenu;
    fileSubMenu.itemArray = @[
        newItem,
        closeItem
    ];
    
    [fileSubMenu release];
    [newItem release];
    [closeItem release];
}

- (void)presentNewMainWindow:(NSMenuItem *)sender {
    [WindowsService.sharedInstance presentNewMainWindow];
}

@end
