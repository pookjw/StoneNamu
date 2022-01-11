//
//  PrefsWindowRestoration.m
//  StoneNamuMac
//
//  Created by Jinwoo Kim on 1/12/22.
//

#import "PrefsWindowRestoration.h"
#import "PrefsWindow.h"

@implementation PrefsWindowRestoration

+ (void)restoreWindowWithIdentifier:(nonnull NSUserInterfaceItemIdentifier)identifier state:(nonnull NSCoder *)state completionHandler:(nonnull void (^)(NSWindow * _Nullable, NSError * _Nullable))completionHandler {
    PrefsWindow *window = [PrefsWindow new];
    [window restoreStateWithCoder:state];
    [window makeKeyAndOrderFront:nil];
    completionHandler([window autorelease], nil);
}

@end
