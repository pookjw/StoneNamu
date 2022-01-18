//
//  CardDetailsBackgroundBox.m
//  StoneNamuMac
//
//  Created by Jinwoo Kim on 1/19/22.
//

#import "CardDetailsBackgroundBox.h"

@interface CardDetailsBackgroundBox ()
@property (retain) IBOutlet NSVisualEffectView *blurView;
@end

@implementation CardDetailsBackgroundBox

- (void)dealloc {
    [_blurView release];
    [super dealloc];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    [self setAttributes];
}

- (void)setAttributes {
    self.blurView.wantsLayer = YES;
    self.blurView.layer.cornerRadius = 15.0f;
    self.blurView.layer.cornerCurve = kCACornerCurveContinuous;
}

@end
