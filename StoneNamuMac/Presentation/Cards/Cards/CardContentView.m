//
//  CardContentView.m
//  StoneNamuMac
//
//  Created by Jinwoo Kim on 10/24/21.
//

#import "CardContentView.h"
#import "NSImageView+setAsyncImage.h"

@interface CardContentView ()
@property (copy) HSCard *hsCard;
@end

@implementation CardContentView

- (void)dealloc {
    [_hsCard release];
    [super dealloc];
}

- (void)configureWithHSCard:(HSCard *)hsCard {
    self.hsCard = hsCard;
    [self.imageView setAsyncImageWithURL:self.hsCard.image indicator:YES];
}

@end
