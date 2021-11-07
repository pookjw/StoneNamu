//
//  EditMenuItem.m
//  StoneNamuMac
//
//  Created by Jinwoo Kim on 11/8/21.
//

#import "EditMenuItem.h"

@implementation EditMenuItem

- (instancetype)init {
    self = [super init];
    
    if (self) {
        [self configureSubMenus];
    }
    
    return self;
}

- (void)configureSubMenus {
    NSMenu *editSubMenu = [[NSMenu alloc] initWithTitle:@"Edit (Demo)"];
    
    //
    
    NSMenuItem *undoItem = [[NSMenuItem alloc] initWithTitle:@"Undo"
                                                          action:@selector(undo:)
                                                   keyEquivalent:@"z"];
    NSMenuItem *redoItem = [[NSMenuItem alloc] initWithTitle:@"Redo"
                                                          action:@selector(redo:)
                                                   keyEquivalent:@"z"];
    
    redoItem.keyEquivalentModifierMask = NSEventModifierFlagShift | NSEventModifierFlagCommand;
    
    //
    
    self.submenu = editSubMenu;
    editSubMenu.itemArray = @[
        undoItem,
        redoItem,
        [NSMenuItem separatorItem]
    ];
    
    [editSubMenu release];
    [undoItem release];
    [redoItem release];
}

@end
