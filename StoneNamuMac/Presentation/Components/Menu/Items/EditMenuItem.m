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
                                                      action:NSSelectorFromString(@"undo:")
                                               keyEquivalent:@"z"];
    NSMenuItem *redoItem = [[NSMenuItem alloc] initWithTitle:@"Redo"
                                                      action:NSSelectorFromString(@"redo:")
                                               keyEquivalent:@"z"];
    NSMenuItem *cutItem = [[NSMenuItem alloc] initWithTitle:@"Cut (Demo)"
                                                     action:@selector(cut:)
                                              keyEquivalent:@"x"];
    NSMenuItem *copyItem = [[NSMenuItem alloc] initWithTitle:@"Copy (Demo)"
                                                      action:@selector(copy:)
                                               keyEquivalent:@"c"];
    NSMenuItem *pasteItem = [[NSMenuItem alloc] initWithTitle:@"Paste (Demo)"
                                                       action:@selector(paste:)
                                                keyEquivalent:@"v"];
    NSMenuItem *pasteAsPlainTextItem = [[NSMenuItem alloc] initWithTitle:@"Paste and Match Style (Demo)" action:@selector(pasteAsPlainText:) keyEquivalent:@"v"];
    NSMenuItem *deleteItem = [[NSMenuItem alloc] initWithTitle:@"Delete (Demo)" action:@selector(delete:) keyEquivalent:@""];
    NSMenuItem *selectAllItem = [[NSMenuItem alloc] initWithTitle:@"Select All (Demo)" action:@selector(selectAll:) keyEquivalent:@"a"];
    
    redoItem.keyEquivalentModifierMask = NSEventModifierFlagShift | NSEventModifierFlagCommand;
    pasteAsPlainTextItem.keyEquivalentModifierMask = NSEventModifierFlagOption | NSEventModifierFlagShift | NSEventModifierFlagCommand;
    
    //
    
    self.submenu = editSubMenu;
    editSubMenu.itemArray = @[
        undoItem,
        redoItem,
        [NSMenuItem separatorItem],
        cutItem,
        copyItem,
        pasteItem,
        pasteAsPlainTextItem,
        selectAllItem
    ];
    
    [editSubMenu release];
    [undoItem release];
    [redoItem release];
    [cutItem release];
    [copyItem release];
    [pasteItem release];
    [pasteAsPlainTextItem release];
    [deleteItem release];
    [selectAllItem release];
}

@end
