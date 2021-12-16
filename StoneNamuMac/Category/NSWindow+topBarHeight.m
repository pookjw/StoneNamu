//
//  NSWindow+topBarHeight.m
//  StoneNamuMac
//
//  Created by Jinwoo Kim on 12/16/21.
//

#import "NSWindow+topBarHeight.h"

@implementation NSWindow (topBarHeight)

- (CGFloat)topBarHeight {
    NSView * _Nullable contentView = self.contentView;
    
    if (contentView == nil) {
        return self.frame.size.height - [self contentRectForFrameRect:self.frame].size.height;
    }
    
    return contentView.frame.size.height - self.contentLayoutRect.size.height;
}

@end
