//
//  CardDetailsChildContentView.m
//  CardDetailsChildContentView
//
//  Created by Jinwoo Kim on 8/9/21.
//

#import "CardDetailsChildContentView.h"
#import "UIImageView+setAsyncImage.h"
#import "CardDetailsChildContentConfiguration.h"

@interface CardDetailsChildContentView ()
@property (readonly, nonatomic) HSCard * _Nullable hsCard;
@end

@implementation CardDetailsChildContentView

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
    [super dealloc];
}

- (void)setAttributes {
    self.backgroundColor = UIColor.clearColor;
}

- (void)configureImageView {
    UIImageView *imageView = [UIImageView new];
    
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
    
    [self->_imageView release];
    self->_imageView = [imageView retain];
    [imageView release];
}

- (void)setConfiguration:(id<UIContentConfiguration>)configuration {
    CardDetailsChildContentConfiguration *oldContentConfig = (CardDetailsChildContentConfiguration *)self.configuration;
    CardDetailsChildContentConfiguration *newContentConfig = [(CardDetailsChildContentConfiguration *)configuration copy];
    self->configuration = newContentConfig;
    
    if (![newContentConfig.hsCard isEqual:oldContentConfig.hsCard]) {
        [self.imageView setAsyncImageWithURL:newContentConfig.hsCard.image indicator:YES];
        self.imageView.hidden = NO;
    }
    
    [oldContentConfig release];
}

- (HSCard * _Nullable)hsCard {
    if (![self.configuration isKindOfClass:[CardDetailsChildContentConfiguration class]]) {
        return nil;
    }
    
    CardDetailsChildContentConfiguration *contentConfiguration = (CardDetailsChildContentConfiguration *)self.configuration;
    return contentConfiguration.hsCard;
}

@end
