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
@property (readonly, nonatomic) HSCardGameModeSlugType _Nullable hsCardGameModeSlugType;
@property (readonly) BOOL isGold;
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
        NSURL * _Nullable url;
        
        NSURL * _Nullable image = newContentConfig.hsCard.image;
        NSURL * _Nullable imageGold = newContentConfig.hsCard.imageGold;
        NSURL * _Nullable battlegroundsImage = newContentConfig.hsCard.battlegroundsImage;
        NSURL * _Nullable battlegroundsImageGold = newContentConfig.hsCard.battlegroundsImageGold;
        
        if ([HSCardGameModeSlugTypeConstructed isEqualToString:newContentConfig.hsCardGameModeSlugType]) {
            url = image;
        } else if ([HSCardGameModeSlugTypeBattlegrounds isEqualToString:newContentConfig.hsCardGameModeSlugType]) {
            if (newContentConfig.isGold) {
                if ((battlegroundsImageGold) && (!battlegroundsImageGold.isEmpty)) {
                    url = battlegroundsImageGold;
                } else if ((battlegroundsImage) && (!battlegroundsImage.isEmpty)) {
                    url = battlegroundsImage;
                } else if ((imageGold) && (!imageGold.isEmpty)) {
                    url = imageGold;
                } else {
                    url = newContentConfig.hsCard.image;
                }
            } else {
                if ((battlegroundsImage) && (!battlegroundsImage.isEmpty)) {
                    url = battlegroundsImage;
                } else {
                    url = newContentConfig.hsCard.image;
                }
            }
        } else {
            url = nil;
        }
        
        if (url) {
            [self.imageView setAsyncImageWithURL:url indicator:YES];
        } else {
            [self.imageView clearSetAsyncImageContexts];
            self.imageView.image = nil;
        }
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

- (HSCardGameModeSlugType)hsCardGameModeSlugType {
    if (![self.configuration isKindOfClass:[CardDetailsChildContentConfiguration class]]) {
        return nil;
    }
    
    CardDetailsChildContentConfiguration *contentConfiguration = (CardDetailsChildContentConfiguration *)self.configuration;
    return contentConfiguration.hsCardGameModeSlugType;
}

- (BOOL)isGold {
    if (![self.configuration isKindOfClass:[CardDetailsChildContentConfiguration class]]) {
        return NO;
    }
    
    CardDetailsChildContentConfiguration *contentConfiguration = (CardDetailsChildContentConfiguration *)self.configuration;
    return contentConfiguration.isGold;
}

@end
