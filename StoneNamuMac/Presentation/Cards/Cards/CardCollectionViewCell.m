//
//  CardCollectionViewCell.m
//  StoneNamuMac
//
//  Created by Jinwoo Kim on 10/24/21.
//

#import "CardCollectionViewCell.h"
#import "NSImageView+setAsyncImage.h"

@interface CardCollectionViewCell ()
@property (copy) HSCard *hsCard;
@end

@implementation CardCollectionViewCell

- (void)dealloc {
    [_hsCard release];
    [super dealloc];
}

- (void)configureWithHSCard:(HSCard *)hsCard {
    self.hsCard = hsCard;
    [self.imageView setAsyncImageWithURL:self.hsCard.image indicator:YES];
}

@end
