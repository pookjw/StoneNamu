//
//  main.m
//  StoneNamuMac
//
//  Created by Jinwoo Kim on 9/26/21.
//

#import <Cocoa/Cocoa.h>
#import "AppDelegate.h"

int main(int argc, const char * argv[]) {
    AppDelegate *delegate = [AppDelegate new];
    NSApplication.sharedApplication.delegate = delegate;
    [NSApplication.sharedApplication run];
    [delegate release];
    return NSApplicationMain(argc, argv);
}
