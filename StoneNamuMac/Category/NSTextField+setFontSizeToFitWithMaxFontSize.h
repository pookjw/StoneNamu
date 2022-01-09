//
//  NSTextField+setFontSizeToFitWithMaxFontSize.h
//  StoneNamuMac
//
//  Created by Jinwoo Kim on 1/10/22.
//

#import <Cocoa/Cocoa.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSTextField (setFontSizeToFitWithMaxFontSize)
- (void)setFontSizeToFitWithMaxFontSize:(CGFloat)maxFontSize inWidth:(CGFloat)width;
@end

NS_ASSUME_NONNULL_END
