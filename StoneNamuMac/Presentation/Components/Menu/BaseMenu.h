//
//  BaseMenu.h
//  StoneNamuMac
//
//  Created by Jinwoo Kim on 11/8/21.
//

#import <Cocoa/Cocoa.h>
#import "AppMenuItem.h"
#import "FileMenuItem.h"
#import "EditMenuItem.h"
#import "ViewMenuItem.h"
#import "WindowMenuItem.h"
#import "HelpMenuItem.h"

NS_ASSUME_NONNULL_BEGIN

@interface BaseMenu : NSMenu
@property (retain) AppMenuItem *appMenuItem;
@property (retain) FileMenuItem *fileMenuItem;
@property (retain) EditMenuItem *editMenuItem;
@property (retain) ViewMenuItem *viewMenuItem;
@property (retain) WindowMenuItem *windowMenuItem;
@property (retain) HelpMenuItem *helpMenuItem;
- (instancetype)initWithTitle:(NSString *)title NS_UNAVAILABLE;
- (instancetype)initWithCoder:(NSCoder *)coder NS_UNAVAILABLE;
@end

NS_ASSUME_NONNULL_END
