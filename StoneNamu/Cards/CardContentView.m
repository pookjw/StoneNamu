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
@property (retain) UIImageView *imageView;
@end

@implementation CardContentView

@synthesize configuration;

- (instancetype)init {
    self = [super init];
    
    if (self) {
        UIImageView *imageView = [UIImageView new];
        self.imageView = imageView;
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
    
//    NSData *data = [[NSData alloc] initWithContentsOfURL:cardContent.hsCard.image];
//    UIImage *image = [UIImage imageWithData:data];
//    self.imageView.image = image;
    [self.imageView setAsyncImageWithURL:cardContent.hsCard.image indicator:YES];
}

@end
