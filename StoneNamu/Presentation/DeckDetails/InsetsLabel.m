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

- (void)drawTextInRect:(CGRect)rect {
    CGRect newRect = rect;
    UIEdgeInsets contentInsets = self.contentInsets;
    
    newRect.size.width -= (contentInsets.left + contentInsets.right);
    newRect.size.height -= (contentInsets.top + contentInsets.bottom);
    newRect.origin.x = contentInsets.left;
    newRect.origin.y = contentInsets.top;
    
    return [super drawTextInRect:newRect];
}

@end
