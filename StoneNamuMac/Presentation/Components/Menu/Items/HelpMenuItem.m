//
//  HelpMenuItem.m
//  StoneNamuMac
//
//  Created by Jinwoo Kim on 11/8/21.
//

#import "HelpMenuItem.h"
#import <StoneNamuResources/StoneNamuResources.h>

@implementation HelpMenuItem

- (instancetype)init {
    self = [super init];
    
    if (self) {
        [self configureSubMenus];
    }
    
    return self;
}

- (void)configureSubMenus {
    NSMenu *helpSubMenu = [[NSMenu alloc] initWithTitle:[ResourcesService localizationForKey:LocalizableKeyHelpMenuTitle]];
    
    //
    
//    NSMenuItem *helpItem = [[NSMenuItem alloc] initWithTitle:[ResourcesService localizationForKey:LocalizableKeyHelpMenuHelp]
//                                                      action:@selector(showHelp:)
//                                               keyEquivalent:@"?"];
    
    //
    
    self.submenu = helpSubMenu;
//    helpSubMenu.itemArray = @[
//        helpItem
//    ];
    
    [helpSubMenu release];
//    [helpItem release];
}

@end
