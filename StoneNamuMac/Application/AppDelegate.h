//
//  AppDelegate.h
//  StoneNamuMac
//
//  Created by Jinwoo Kim on 9/26/21.
//

#import <Cocoa/Cocoa.h>
#import <StoneNamuCore/StoneNamuCore.h>

@interface AppDelegate : NSObject <NSApplicationDelegate>
- (void)presentNewMainWindow;
- (void)presentNewMainWindowIfNeeded;
- (void)presentCardDetailsWithHSCard:(HSCard *)hsCard;
- (void)presentNewPrefsWindow;
- (void)presentNewPrefsWindowIfNeeded;
@end
