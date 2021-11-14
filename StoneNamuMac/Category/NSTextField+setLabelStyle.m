//
//  NSTextField+setLabelStyle.m
//  StoneNamuMac
//
//  Created by Jinwoo Kim on 11/1/21.
//

#import "NSTextField+setLabelStyle.h"

@implementation NSTextField (setLabelStyle)

- (void)setLabelStyle {
    self.editable = NO;
    self.selectable = NO;
    self.bezeled = NO;
    self.preferredMaxLayoutWidth = 0.0f;
    self.lineBreakMode = NSLineBreakByWordWrapping;
    self.drawsBackground = YES;
    self.backgroundColor = NSColor.clearColor;
}

@end
