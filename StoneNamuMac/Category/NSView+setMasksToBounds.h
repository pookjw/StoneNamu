//
//  NSView+setMasksToBounds.h
//  StoneNamuMac
//
//  Created by Jinwoo Kim on 3/5/22.
//

#import <Cocoa/Cocoa.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSView (setMaskToBounds)
- (void)setMasksToBounds:(BOOL)masksToBounds recursiveToSubviews:(BOOL)recursiveToSubviews;
@end

NS_ASSUME_NONNULL_END
