//
//  NSTextField+setFontSizeToFitWithMaxFontSize.m
//  StoneNamuMac
//
//  Created by Jinwoo Kim on 1/10/22.
//

#import "NSTextField+setFontSizeToFitWithMaxFontSize.h"

@implementation NSTextField (setFontSizeToFitWithMaxFontSize)

- (void)setFontSizeToFitWithMaxFontSize:(CGFloat)maxFontSize inWidth:(CGFloat)width {
    NSFont *newFont = [NSFont fontWithName:self.font.fontName size:maxFontSize];
    
    [self sizeToFit];
    
    while (true) {
        CGSize stringSize = [self.stringValue sizeWithAttributes:@{NSFontAttributeName: newFont}];
        
        if (width < stringSize.width) {
            newFont = [NSFont fontWithName:newFont.fontName size:newFont.pointSize - 0.1f];
        } else {
            break;
        }
    }
    
    self.font = newFont;
}

@end
