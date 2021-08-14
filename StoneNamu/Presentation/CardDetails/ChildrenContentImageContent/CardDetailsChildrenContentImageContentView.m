//
//  CardDetailsChildrenContentImageContentView.m
//  CardDetailsChildrenContentImageContentView
//
//  Created by Jinwoo Kim on 8/9/21.
//

#import "CardDetailsChildrenContentImageContentView.h"
#import "UIImageView+setAsyncImage.h"
#import "CardDetailsChildrenContentImageConfiguration.h"

@interface CardDetailsChildrenContentImageContentView ()
@property (copy) HSCard *hsCard;
@end

@implementation CardDetailsChildrenContentImageContentView

@synthesize configuration;

- (instancetype)init {
    self = [super init];
    
    if (self) {
        [self setAttributes];
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

- (void)setAttributes {
    self.backgroundColor = UIColor.clearColor;
}

- (void)configureImageView {
    UIImageView *imageView = [UIImageView new];
    _imageView = [imageView retain];
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    [self addSubview:imageView];
    imageView.translatesAutoresizingMaskIntoConstraints = NO;
    [NSLayoutConstraint activateConstraints:@[
        [imageView.topAnchor constraintEqualToAnchor:self.topAnchor],
        [imageView.trailingAnchor constraintEqualToAnchor:self.trailingAnchor],
        [imageView.leadingAnchor constraintEqualToAnchor:self.leadingAnchor],
        [imageView.bottomAnchor constraintEqualToAnchor:self.bottomAnchor]
    ]];
    imageView.backgroundColor = UIColor.clearColor;
    [imageView release];
}

- (void)setConfiguration:(id<UIContentConfiguration>)configuration {
    [self->configuration release];
    CardDetailsChildrenContentImageConfiguration *content = [(CardDetailsChildrenContentImageConfiguration *)configuration copy];
    self->configuration = content;
    
    if (![self.hsCard isEqual:content.hsCard]) {
        self.hsCard = content.hsCard;
        [self.imageView setAsyncImageWithURL:content.hsCard.image indicator:YES];
        self.imageView.hidden = NO;
    }
}

@end
