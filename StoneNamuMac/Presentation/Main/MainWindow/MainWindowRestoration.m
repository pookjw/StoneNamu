//
//  MainWindowRestoration.m
//  StoneNamuMac
//
//  Created by Jinwoo Kim on 11/12/21.
//

#import "MainWindowRestoration.h"
#import "MainWindow.h"

@implementation MainWindowRestoration

+ (void)restoreWindowWithIdentifier:(NSUserInterfaceItemIdentifier)identifier state:(NSCoder *)state completionHandler:(void (^)(NSWindow * _Nullable, NSError * _Nullable))completionHandler {
    MainWindow *window = [MainWindow new];
    [window restoreStateWithCoder:state];
    [window makeKeyAndOrderFront:nil];
    completionHandler([window autorelease], nil);
}

@end
