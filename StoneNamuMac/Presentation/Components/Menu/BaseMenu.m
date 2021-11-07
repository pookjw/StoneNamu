//
//  BaseMenu.m
//  StoneNamuMac
//
//  Created by Jinwoo Kim on 11/8/21.
//

#import "BaseMenu.h"

@implementation BaseMenu

- (instancetype)init {
    self = [super init];
    
    if (self) {
        [self configureAppMenuItem];
        [self configureFileMenuItem];
        [self configureEditMenu];
        [self configureViewMenu];
        [self configureWindowMenu];
        [self configureHelpMenu];
    }
    
    return self;
}

- (void)dealloc {
    [_appMenuItem release];
    [_fileMenuItem release];
    [_editMenuItem release];
    [_viewMenuItem release];
    [_windowMenuItem release];
    [_helpMenuItem release];
    [super dealloc];
}

- (void)configureAppMenuItem {
    AppMenuItem *appMenuItem = [AppMenuItem new];
    self.appMenuItem = appMenuItem;
    [self addItem:appMenuItem];
    [appMenuItem release];
}

- (void)configureFileMenuItem {
    FileMenuItem *fileMenuItem = [FileMenuItem new];
    self.fileMenuItem = fileMenuItem;
    [self addItem:fileMenuItem];
    [fileMenuItem release];
}

- (void)configureEditMenu {
    EditMenuItem *editMenuItem = [EditMenuItem new];
    self.editMenuItem = editMenuItem;
    [self addItem:editMenuItem];
    [editMenuItem release];
}

- (void)configureViewMenu {
    ViewMenuItem *viewMenuItem = [ViewMenuItem new];
    self.viewMenuItem = viewMenuItem;
    [self addItem:viewMenuItem];
    [viewMenuItem release];
}

- (void)configureWindowMenu {
    WindowMenuItem *windowMenuItem = [WindowMenuItem new];
    self.windowMenuItem = windowMenuItem;
    [self addItem:windowMenuItem];
    [windowMenuItem release];
}

- (void)configureHelpMenu {
    HelpMenuItem *helpMenuItem = [HelpMenuItem new];
    self.helpMenuItem = helpMenuItem;
    [self addItem:helpMenuItem];
    [helpMenuItem release];
}

@end
