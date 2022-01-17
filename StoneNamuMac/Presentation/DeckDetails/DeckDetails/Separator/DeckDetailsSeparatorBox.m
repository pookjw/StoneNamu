//
//  DeckDetailsSeparatorBox.m
//  StoneNamuMac
//
//  Created by Jinwoo Kim on 1/17/22.
//

#import "DeckDetailsSeparatorBox.h"
#import "NSView+isDarkMode.h"

@implementation DeckDetailsSeparatorBox

- (void)awakeFromNib {
    [super awakeFromNib];
    [self updateFillColor];
}

- (void)viewDidChangeEffectiveAppearance {
    [super viewDidChangeEffectiveAppearance];
    [self updateFillColor];
}

- (void)updateFillColor {
    if (self.isDarkMode) {
        self.fillColor = [NSColor.whiteColor colorWithAlphaComponent:0.5f];
    } else {
        self.fillColor = [NSColor.blackColor colorWithAlphaComponent:0.2f];
    }
}

@end
