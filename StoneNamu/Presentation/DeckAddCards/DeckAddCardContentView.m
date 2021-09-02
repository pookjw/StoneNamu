//
//  DeckAddCardContentView.m
//  StoneNamu
//
//  Created by Jinwoo Kim on 8/1/21.
//

#import "DeckAddCardContentView.h"
#import "DeckAddCardContentConfiguration.h"
#import "UIImageView+setAsyncImage.h"

@interface DeckAddCardContentView ()
@property (readonly, nonatomic) HSCard * _Nullable hsCard;
@end

@implementation DeckAddCardContentView

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
    [super dealloc];
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
    DeckAddCardContentConfiguration *oldContentConfig = (DeckAddCardContentConfiguration *)self.configuration;
    DeckAddCardContentConfiguration *newContentConfig = [(DeckAddCardContentConfiguration *)configuration copy];
    self->configuration = newContentConfig;
    
    if (![newContentConfig.hsCard isEqual:oldContentConfig.hsCard]) {
        [self.imageView setAsyncImageWithURL:newContentConfig.hsCard.image indicator:YES];
        self.imageView.hidden = NO;
    }
    
    [oldContentConfig release];
}

- (HSCard * _Nullable)hsCard {
    if (![self.configuration isKindOfClass:[DeckAddCardContentConfiguration class]]) {
        return nil;
    }
    
    DeckAddCardContentConfiguration *contentConfiguration = (DeckAddCardContentConfiguration *)self.configuration;
    return contentConfiguration.hsCard;
}

@end
