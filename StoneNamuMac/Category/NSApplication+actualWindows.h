//
//  NSApplication+actualWindows.h
//  StoneNamuMac
//
//  Created by Jinwoo Kim on 1/19/22.
//

#import <Cocoa/Cocoa.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSApplication (actualWindows)
@property (readonly, nonatomic) NSArray<NSWindow *> *actualWindows;
@property (readonly, nonatomic) NSArray<NSWindow *> *actualOrderedWindows;
@end

NS_ASSUME_NONNULL_END
