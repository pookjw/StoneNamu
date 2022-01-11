//
//  CardDetailsWindowRestoration.m
//  StoneNamuMac
//
//  Created by Jinwoo Kim on 1/12/22.
//

#import "CardDetailsWindowRestoration.h"
#import "CardDetailsWindow.h"

@implementation CardDetailsWindowRestoration

+ (void)restoreWindowWithIdentifier:(NSUserInterfaceItemIdentifier)identifier state:(NSCoder *)state completionHandler:(void (^)(NSWindow * _Nullable, NSError * _Nullable))completionHandler {
    CardDetailsWindow *window = [CardDetailsWindow new];
    [window restoreStateWithCoder:state];
    [window makeKeyAndOrderFront:nil];
    completionHandler([window autorelease], nil);
}

@end
