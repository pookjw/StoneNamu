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
@property (readonly, nonatomic) HSCard * _Nullable hsCard;
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
    CardDetailsChildrenContentImageConfiguration *oldContentConfig = (CardDetailsChildrenContentImageConfiguration *)self.configuration;
    CardDetailsChildrenContentImageConfiguration *newContentConfig = [(CardDetailsChildrenContentImageConfiguration *)configuration copy];
    self->configuration = newContentConfig;
    
    if (![newContentConfig.hsCard isEqual:oldContentConfig.hsCard]) {
        [self.imageView setAsyncImageWithURL:newContentConfig.hsCard.image indicator:YES];
        self.imageView.hidden = NO;
    }
    
    [oldContentConfig release];
}

- (HSCard * _Nullable)hsCard {
    if (![self.configuration isKindOfClass:[CardDetailsChildrenContentImageConfiguration class]]) {
        return nil;
    }
    
    CardDetailsChildrenContentImageConfiguration *contentConfiguration = (CardDetailsChildrenContentImageConfiguration *)self.configuration;
    return contentConfiguration.hsCard;
}

@end
