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
@property (readonly, nonatomic) HSCard * _Nullable hsCard;
@property (readonly, nonatomic) HSCardGameModeSlugType hsCardGameModeSlugType;
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
    [super dealloc];
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
    CardContentConfiguration *oldContentConfig = (CardContentConfiguration *)self.configuration;
    CardContentConfiguration *newContentConfig = [(CardContentConfiguration *)configuration copy];
    self->configuration = newContentConfig;
    
    if ((![newContentConfig.hsCard isEqual:oldContentConfig.hsCard]) || (![oldContentConfig.hsCardGameModeSlugType isEqualToString:newContentConfig.hsCardGameModeSlugType])) {
        if ([HSCardGameModeSlugTypeConstructed isEqualToString:newContentConfig.hsCardGameModeSlugType]) {
            [self.imageView setAsyncImageWithURL:newContentConfig.hsCard.image indicator:YES];
        } else if ([HSCardGameModeSlugTypeBattlegrounds isEqualToString:newContentConfig.hsCardGameModeSlugType]) {
            [self.imageView setAsyncImageWithURL:newContentConfig.hsCard.battlegroundsImage indicator:YES];
        } else {
            self.imageView.image = nil;
        }
        
        self.imageView.hidden = NO;
    }
    
    [oldContentConfig release];
}

- (HSCard * _Nullable)hsCard {
    if (![self.configuration isKindOfClass:[CardContentConfiguration class]]) {
        return nil;
    }
    
    CardContentConfiguration *contentConfiguration = (CardContentConfiguration *)self.configuration;
    return contentConfiguration.hsCard;
}

- (HSCardGameModeSlugType)hsCardGameModeSlugType {
    if (![self.configuration isKindOfClass:[CardContentConfiguration class]]) {
        return nil;
    }
    
    CardContentConfiguration *contentConfiguration = (CardContentConfiguration *)self.configuration;
    return contentConfiguration.hsCardGameModeSlugType;
}

@end
