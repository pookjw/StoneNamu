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
    [self addItem:appMenuItem];
    self.appMenuItem = appMenuItem;
    [appMenuItem release];
}

- (void)configureFileMenuItem {
    FileMenuItem *fileMenuItem = [FileMenuItem new];
    [self addItem:fileMenuItem];
    self.fileMenuItem = fileMenuItem;
    [fileMenuItem release];
}

- (void)configureEditMenu {
    EditMenuItem *editMenuItem = [EditMenuItem new];
    [self addItem:editMenuItem];
    self.editMenuItem = editMenuItem;
    [editMenuItem release];
}

- (void)configureViewMenu {
    ViewMenuItem *viewMenuItem = [ViewMenuItem new];
    [self addItem:viewMenuItem];
    self.viewMenuItem = viewMenuItem;
    [viewMenuItem release];
}

- (void)configureWindowMenu {
    WindowMenuItem *windowMenuItem = [WindowMenuItem new];
    [self addItem:windowMenuItem];
    self.windowMenuItem = windowMenuItem;
    [windowMenuItem release];
}

- (void)configureHelpMenu {
    HelpMenuItem *helpMenuItem = [HelpMenuItem new];
    [self addItem:helpMenuItem];
    self.helpMenuItem = helpMenuItem;
    [helpMenuItem release];
}

@end
