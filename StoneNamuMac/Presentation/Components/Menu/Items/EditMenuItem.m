//
//  EditMenuItem.m
//  StoneNamuMac
//
//  Created by Jinwoo Kim on 11/8/21.
//

#import "EditMenuItem.h"
#import <StoneNamuResources/StoneNamuResources.h>

@implementation EditMenuItem

- (instancetype)init {
    self = [super init];
    
    if (self) {
        [self configureSubMenus];
    }
    
    return self;
}

- (void)configureSubMenus {
    NSMenu *editSubMenu = [[NSMenu alloc] initWithTitle:[ResourcesService localizationForKey:LocalizableKeyEditMenuTitle]];
    
    //
    
    NSMenuItem *undoItem = [[NSMenuItem alloc] initWithTitle:[ResourcesService localizationForKey:LocalizableKeyEditMenuUndo]
                                                      action:NSSelectorFromString(@"undo:")
                                               keyEquivalent:@"z"];
    NSMenuItem *redoItem = [[NSMenuItem alloc] initWithTitle:[ResourcesService localizationForKey:LocalizableKeyEditMenuRedo]
                                                      action:NSSelectorFromString(@"redo:")
                                               keyEquivalent:@"z"];
    NSMenuItem *cutItem = [[NSMenuItem alloc] initWithTitle:[ResourcesService localizationForKey:LocalizableKeyEditMenuCut]
                                                     action:@selector(cut:)
                                              keyEquivalent:@"x"];
    NSMenuItem *copyItem = [[NSMenuItem alloc] initWithTitle:[ResourcesService localizationForKey:LocalizableKeyEditMenuCopy]
                                                      action:@selector(copy:)
                                               keyEquivalent:@"c"];
    NSMenuItem *pasteItem = [[NSMenuItem alloc] initWithTitle:[ResourcesService localizationForKey:LocalizableKeyEditMenuPaste]
                                                       action:@selector(paste:)
                                                keyEquivalent:@"v"];
    NSMenuItem *pasteAndPlainTextItem = [[NSMenuItem alloc] initWithTitle:[ResourcesService localizationForKey:LocalizableKeyEditMenuPasteAndMatchStyle]
                                                                  action:@selector(pasteAsPlainText:)
                                                           keyEquivalent:@"v"];
    NSMenuItem *deleteItem = [[NSMenuItem alloc] initWithTitle:[ResourcesService localizationForKey:NSNotificationNameLocalDeckUseCaseDeleteAll]
                                                        action:@selector(delete:)
                                                 keyEquivalent:@""];
    NSMenuItem *selectAllItem = [[NSMenuItem alloc] initWithTitle:[ResourcesService localizationForKey:LocalizableKeyEditMenuSelectAll]
                                                           action:@selector(selectAll:)
                                                    keyEquivalent:@"a"];
    
    redoItem.keyEquivalentModifierMask = NSEventModifierFlagShift | NSEventModifierFlagCommand;
    pasteAndPlainTextItem.keyEquivalentModifierMask = NSEventModifierFlagOption | NSEventModifierFlagShift | NSEventModifierFlagCommand;
    
    //
    
    self.submenu = editSubMenu;
    editSubMenu.itemArray = @[
        undoItem,
        redoItem,
        [NSMenuItem separatorItem],
        cutItem,
        copyItem,
        pasteItem,
        pasteAndPlainTextItem,
        selectAllItem
    ];
    
    [editSubMenu release];
    [undoItem release];
    [redoItem release];
    [cutItem release];
    [copyItem release];
    [pasteItem release];
    [pasteAndPlainTextItem release];
    [deleteItem release];
    [selectAllItem release];
}

@end
