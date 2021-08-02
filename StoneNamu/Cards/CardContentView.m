//
//  CardContentView.m
//  StoneNamu
//
//  Created by Jinwoo Kim on 8/1/21.
//

#import "CardContentView.h"
#import "CardContentConfiguration.h"
#import "UIImageView+setAsyncImage.h"

@implementation CardContentView

@synthesize configuration;

- (instancetype)init {
    self = [super init];
    
    if (self) {
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
    
    return self;
}

- (void)dealloc {
    [configuration release];
    [_imageView release];
    [super dealloc];
}

- (void)setConfiguration:(id<UIContentConfiguration>)configuration {
    [self->configuration release];
    CardContentConfiguration *cardContent = (CardContentConfiguration *)configuration;
    self->configuration = [cardContent copy];
    
    [self.imageView setAsyncImageWithURL:cardContent.hsCard.image indicator:YES];
}

@end
