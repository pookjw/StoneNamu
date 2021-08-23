//
//  DeckDetailsCardContentView.m
//  DeckDetailsCardContentView
//
//  Created by Jinwoo Kim on 8/23/21.
//

#import "DeckDetailsCardContentView.h"
#import "UIImageView+setAsyncImage.h"
#import "DeckDetailsCardContentConfiguration.h"
#import "UIImage+averageColor.h"
#import "UIColor+invertedColor.h"

@interface DeckDetailsCardContentView ()
@property (retain) HSCard *hsCard;
@property (retain) UIImageView *imageView;
@property (retain) UILabel *nameLabel;
@property (retain) CAGradientLayer *imageViewGradientLayer;
@property (retain) CAGradientLayer *nameLabelGradientLayer;
@end

@implementation DeckDetailsCardContentView

@synthesize configuration;

- (instancetype)init {
    self = [super init];
    
    if (self) {
        [self setAttributes];
        [self configureNameLabel];
        [self configureImageView];
    }
    
    return self;
}

- (void)dealloc {
    [configuration release];
    [_hsCard release];
    [_imageView release];
    [_nameLabel release];
    [_imageViewGradientLayer release];
    [_nameLabelGradientLayer release];
    [super dealloc];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self updateGradientLayer];
}

- (void)setAttributes {
    self.backgroundColor = UIColor.clearColor;
}

- (void)configureNameLabel {
    UILabel *nameLabel = [UILabel new];
    self.nameLabel = nameLabel;
    
    nameLabel.backgroundColor = UIColor.whiteColor;
    nameLabel.textColor = UIColor.blackColor;
    nameLabel.adjustsFontSizeToFitWidth = YES;
    nameLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleTitle2];
    
    [self addSubview:nameLabel];
    nameLabel.translatesAutoresizingMaskIntoConstraints = NO;
    
    //
    
    NSString *string = @"";
    
    CGRect rect = [string boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX)
                                        options:NSStringDrawingUsesLineFragmentOrigin
                                     attributes:@{NSFontAttributeName: nameLabel.font}
                                        context:nil];
    CGFloat margin = 30;
    CGFloat height = rect.size.height + margin;
    
    //
    
    [NSLayoutConstraint activateConstraints:@[
        [nameLabel.topAnchor constraintEqualToAnchor:self.topAnchor],
        [nameLabel.leadingAnchor constraintEqualToAnchor:self.leadingAnchor],
        [nameLabel.trailingAnchor constraintEqualToAnchor:self.trailingAnchor],
        [nameLabel.heightAnchor constraintEqualToConstant:height]
    ]];
    
    NSLayoutConstraint *bottomLayout = [nameLabel.bottomAnchor constraintEqualToAnchor:self.bottomAnchor];
    bottomLayout.priority = UILayoutPriorityDefaultHigh;
    bottomLayout.active = YES;
    
    //
    
    CAGradientLayer *nameLabelGradientLayer = [CAGradientLayer new];
    self.nameLabelGradientLayer = nameLabelGradientLayer;
    nameLabelGradientLayer.colors = @[
        (id)[UIColor.whiteColor colorWithAlphaComponent:0].CGColor,
        (id)UIColor.whiteColor.CGColor
    ];
    nameLabelGradientLayer.startPoint = CGPointMake(1, 0);
    nameLabelGradientLayer.endPoint = CGPointMake(0, 0);
    nameLabel.layer.mask = nameLabelGradientLayer;
    [nameLabelGradientLayer release];
    
    //
    
    [nameLabel release];
}

- (void)configureImageView {
    UIImageView *imageView = [UIImageView new];
    self.imageView = imageView;
    
    imageView.backgroundColor = UIColor.clearColor;
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    imageView.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:imageView];
    
    [NSLayoutConstraint activateConstraints:@[
        [imageView.centerYAnchor constraintEqualToAnchor:self.nameLabel.centerYAnchor],
        [imageView.trailingAnchor constraintEqualToAnchor:self.nameLabel.trailingAnchor],
        [imageView.heightAnchor constraintEqualToAnchor:self.nameLabel.heightAnchor]
    ]];
    
    [self bringSubviewToFront:self.nameLabel];
    
    NSLayoutConstraint *leadingLayout = [NSLayoutConstraint constraintWithItem:imageView
                                                                     attribute:NSLayoutAttributeLeading
                                                                     relatedBy:NSLayoutRelationGreaterThanOrEqual
                                                                        toItem:self.nameLabel
                                                                     attribute:NSLayoutAttributeLeading
                                                                    multiplier:1
                                                                      constant:0];
    leadingLayout.active = YES;

    NSLayoutConstraint *aspectLayout = [NSLayoutConstraint constraintWithItem:imageView
                                                                    attribute:NSLayoutAttributeWidth
                                                                    relatedBy:NSLayoutRelationEqual
                                                                       toItem:imageView
                                                                    attribute:NSLayoutAttributeHeight
                                                                   multiplier:243 / 64
                                                                     constant:0];
    aspectLayout.active = YES;
    
    //
    
    CAGradientLayer *imageViewGradientLayer = [CAGradientLayer new];
    self.imageViewGradientLayer = imageViewGradientLayer;
    imageViewGradientLayer.colors = @[
        (id)[UIColor.whiteColor colorWithAlphaComponent:0].CGColor,
        (id)UIColor.whiteColor.CGColor
    ];
    imageViewGradientLayer.startPoint = CGPointMake(0, 0);
    imageViewGradientLayer.endPoint = CGPointMake(0.6, 0);
    imageView.layer.mask = imageViewGradientLayer;
    [imageViewGradientLayer release];
    
    //
    
    [imageView release];
}

- (void)setConfiguration:(id<UIContentConfiguration>)configuration {
    [self->configuration release];
    DeckDetailsCardContentConfiguration *contentConfig = [(DeckDetailsCardContentConfiguration *)configuration copy];
    self->configuration = contentConfig;
    
    if (![self.hsCard isEqual:contentConfig.hsCard]) {
        self.hsCard = contentConfig.hsCard;
        [self updateView];
    }
}

- (void)updateView {
    self.nameLabel.text = self.hsCard.name;
    
    void (^asyncImageCompletion)(UIImage * _Nullable, NSError * _Nullable) = ^(UIImage * _Nullable image, NSError * _Nullable error) {
        [NSOperationQueue.mainQueue addOperationWithBlock:^{
            self.backgroundColor = image.averageColor;
            self.nameLabel.textColor = self.backgroundColor.invertedColor;
            [self updateGradientLayer];
        }];
    };
    
    if (self.hsCard.cropImage) {
        [self.imageView setAsyncImageWithURL:self.hsCard.cropImage indicator:NO completion:asyncImageCompletion];
    } else {
        [self.imageView setAsyncImageWithURL:self.hsCard.image indicator:NO completion:asyncImageCompletion];
    }
}

- (void)updateGradientLayer {
    [CATransaction begin];
    [CATransaction setDisableActions:YES];
    self.imageViewGradientLayer.frame = self.imageView.bounds;
    self.nameLabelGradientLayer.frame = self.nameLabel.bounds;
    [CATransaction commit];
}

@end
