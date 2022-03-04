//
//  NSView+setMasksToBounds.m
//  StoneNamuMac
//
//  Created by Jinwoo Kim on 3/5/22.
//

#import "NSView+setMasksToBounds.h"

@implementation NSView (setMaskToBounds)

- (void)setMasksToBounds:(BOOL)masksToBounds recursiveToSubviews:(BOOL)recursiveToSubviews {
    self.wantsLayer = YES;
    self.layer.masksToBounds = NO;
    
    if (recursiveToSubviews) {
        [self.subviews enumerateObjectsUsingBlock:^(__kindof NSView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [obj setMasksToBounds:masksToBounds recursiveToSubviews:recursiveToSubviews];
        }];
    }
}

@end
