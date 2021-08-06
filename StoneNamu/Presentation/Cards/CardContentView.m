//
//  CardContentView.m
//  StoneNamu
//
//  Created by Jinwoo Kim on 8/1/21.
//

#import "CardContentView.h"
#import "CardContentConfiguration.h"
#import "UIImageView+setAsyncImage.h"

@interface CardContentView ()
@property (copy) HSCard *hsCard;
@end

@implementation CardContentView

@synthesize configuration;

- (instancetype)init {
    self = [super init];
    
    if (self) {
        [self configureImageView];
    }
    
    return self;
}

- (void)dealloc {
    [configuration release];
    [_imageView release];
    [_hsCard release];
    [super dealloc];
}

- (void)configureImageView {
    UIImageView *imageView = [UIImageView new];
    _imageView = [imageView retain];
    self.imageView.contentMode = UIViewContentModeScaleAspectFit;
    [self addSubview:imageView];
    imageView.translatesAutoresizingMaskIntoConstraints = NO;
    [NSLayoutConstraint activateConstraints:@[
        [imageView.topAnchor constraintEqualToAnchor:self.topAnchor],
        [imageView.trailingAnchor constraintEqualToAnchor:self.trailingAnchor],
        [imageView.leadingAnchor constraintEqualToAnchor:self.leadingAnchor],
        [imageView.bottomAnchor constraintEqualToAnchor:self.bottomAnchor]
    ]];
    [imageView release];
}

- (void)setConfiguration:(id<UIContentConfiguration>)configuration {
    [self->configuration release];
    CardContentConfiguration *cardContent = (CardContentConfiguration *)configuration;
    self->configuration = [cardContent copy];
    
    if (![self.hsCard isEqual:cardContent.hsCard]) {
        self.hsCard = cardContent.hsCard;
        
        if (cardContent.hsCard.imageGold) {
            [self.imageView setAsyncImageWithURL:cardContent.hsCard.imageGold indicator:YES];
        } else {
            [self.imageView setAsyncImageWithURL:cardContent.hsCard.image indicator:YES];
        }
        self.imageView.hidden = NO;
    }
}

@end
