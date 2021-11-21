//
//  CardDetailsChildrenContentImageContentCollectionViewItem.m
//  StoneNamuMac
//
//  Created by Jinwoo Kim on 11/22/21.
//

#import "CardDetailsChildrenContentImageContentCollectionViewItem.h"
#import "NSImageView+setAsyncImage.h"

@interface CardDetailsChildrenContentImageContentCollectionViewItem ()
@property (copy) HSCard * _Nullable hsCard;
@end

@implementation CardDetailsChildrenContentImageContentCollectionViewItem

- (void)dealloc {
    [_hsCard release];
    [super dealloc];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    [self clearContents];
}

- (void)prepareForReuse {
    [super prepareForReuse];
    [self clearContents];
}

- (void)configureWithHSCard:(HSCard *)hsCard {
    self.hsCard = hsCard;
    
    [self.imageView setAsyncImageWithURL:hsCard.image indicator:YES];
}

- (void)clearContents {
    self.hsCard = nil;
    [self.imageView cancelAsyncImage];
    self.imageView.image = nil;
}

@end
