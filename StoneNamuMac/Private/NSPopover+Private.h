//
//  NSPopover+Private.h
//  StoneNamu
//
//  Created by Jinwoo Kim on 1/29/22.
//

#import <Cocoa/Cocoa.h>
#import "_NSPopoverWindow.h"

NS_ASSUME_NONNULL_BEGIN

@interface NSPopover (Private)
- (_NSPopoverWindow * _Nullable)_popoverWindow;
@end

NS_ASSUME_NONNULL_END
