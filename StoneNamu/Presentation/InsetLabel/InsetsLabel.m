//
//  InsetsLabel.m
//  InsetsLabel
//
//  Created by Jinwoo Kim on 8/24/21.
//

#import "InsetsLabel.h"

@implementation InsetsLabel

- (void)setContentInsets:(UIEdgeInsets)contentInsets {
    self->_contentInsets = contentInsets;
    [self.layer setNeedsDisplay];
    [self.layer displayIfNeeded];
}

- (CGSize)intrinsicContentSize {
    CGSize size = [super intrinsicContentSize];
    size.width += (self.contentInsets.left + self.contentInsets.right);
    size.height += (self.contentInsets.top + self.contentInsets.bottom);
    return size;
}

- (void)drawTextInRect:(CGRect)rect {
    return [super drawTextInRect:UIEdgeInsetsInsetRect(rect, self.contentInsets)];
}

- (CGRect)textRectForBounds:(CGRect)bounds limitedToNumberOfLines:(NSInteger)numberOfLines {
    CGRect trancated = UIEdgeInsetsInsetRect(bounds, self.contentInsets);
    return [super textRectForBounds:trancated limitedToNumberOfLines:numberOfLines];
}

@end
