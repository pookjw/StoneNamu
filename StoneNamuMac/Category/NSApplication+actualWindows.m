//
//  NSApplication+actualWindows.m
//  StoneNamuMac
//
//  Created by Jinwoo Kim on 1/19/22.
//

#import "NSApplication+actualWindows.h"

@implementation NSApplication (actualWindows)

- (NSArray<NSWindow *> *)actualWindows {
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"!(self isMemberOfClass: %@)", NSClassFromString(@"NSMenuWindowManagerWindow")];
    return [self.windows filteredArrayUsingPredicate:predicate];
}

- (NSArray<NSWindow *> *)actualOrderedWindows {
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"!(self isMemberOfClass: %@)", NSClassFromString(@"NSMenuWindowManagerWindow")];
    return [self.orderedWindows filteredArrayUsingPredicate:predicate];
}

@end
