//
//  NSViewController+splitViewController.m
//  StoneNamuMac
//
//  Created by Jinwoo Kim on 11/28/21.
//

#import "NSViewController+splitViewController.h"

@implementation NSViewController (splitViewController)

- (__kindof NSSplitViewController * _Nullable)splitViewController {
    NSViewController *parentViewController = self.parentViewController;
    
    if (parentViewController == nil) {
        return nil;
    } else if ([parentViewController isKindOfClass:[NSSplitViewController class]]) {
        return (NSSplitViewController *)parentViewController;
    } else if ([parentViewController isKindOfClass:[NSViewController class]]) {
        return parentViewController.splitViewController;
    } else {
        return nil;
    }
}

@end
