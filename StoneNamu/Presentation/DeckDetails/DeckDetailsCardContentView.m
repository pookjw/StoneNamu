//
//  DeckDetailsCardContentView.m
//  DeckDetailsCardContentView
//
//  Created by Jinwoo Kim on 8/23/21.
//

#import "DeckDetailsCardContentView.h"
#import "UIImageView+setAsyncImage.h"
#import "DeckDetailsCardContentConfiguration.h"
#import "InsetsLabel.h"

@interface DeckDetailsCardContentView ()
@property (readonly, nonatomic) HSCard *hsCard;
@property (readonly, nonatomic) NSUInteger hsCardCount;
@property (retain) UIImageView *imageView;
@property (retain) UILabel *manaCostLabel;
@property (retain) InsetsLabel *nameLabel;
@property (retain) UILabel *countLabel;
@property (retain) CAGradientLayer *imageViewGradientLayer;
@end

@implementation DeckDetailsCardContentView

@synthesize configuration;

- (instancetype)init {
    self = [super init];
    
    if (self) {
        [self setAttributes];
        [self configureNameLabel];
        [self configureManaCostLabel];
        [self configureImageView];
        [self configureCountLabel];
    }
    
    return self;
}

- (void)dealloc {
    [configuration release];
    [_imageView release];
    [_manaCostLabel release];
    [_nameLabel release];
    [_countLabel release];
    [_imageViewGradientLayer release];
    [super dealloc];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self updateGradientLayer];
}

- (void)setAttributes {
    self.backgroundColor = nil;
}

- (void)configureNameLabel {
    InsetsLabel *nameLabel = [InsetsLabel new];
    self.nameLabel = nameLabel;
    
    nameLabel.contentInsets = UIEdgeInsetsMake(15, 15, 15, 15);
    nameLabel.backgroundColor = UIColor.clearColor;
    nameLabel.textColor = nil;
    nameLabel.adjustsFontSizeToFitWidth = YES;
    nameLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleTitle2];
    nameLabel.minimumScaleFactor = 0.1;
    
    nameLabel.layer.shadowColor = UIColor.blackColor.CGColor;
    nameLabel.layer.shadowRadius = 3.0;
    nameLabel.layer.shadowOpacity = 0.5;
    nameLabel.layer.shadowOffset = CGSizeMake(0, 0);
    nameLabel.layer.masksToBounds = YES;
    
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
        [nameLabel.heightAnchor constraintEqualToConstant:height]
    ]];
    
    NSLayoutConstraint *bottomLayout = [nameLabel.bottomAnchor constraintEqualToAnchor:self.bottomAnchor];
    bottomLayout.priority = UILayoutPriorityDefaultHigh;
    bottomLayout.active = YES;
    
    //
    
    [nameLabel release];
}

- (void)configureManaCostLabel {
    UILabel *manaCostLabel = [UILabel new];
    self.manaCostLabel = manaCostLabel;
    
    manaCostLabel.backgroundColor = UIColor.systemGray2Color;
    manaCostLabel.textColor = UIColor.whiteColor;
    manaCostLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleTitle2];
    manaCostLabel.textAlignment = NSTextAlignmentCenter;
    
    [self addSubview:manaCostLabel];
    manaCostLabel.translatesAutoresizingMaskIntoConstraints = NO;
    
    //
    
    NSString *string = @"99";
    
    CGRect rect = [string boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX)
                                        options:NSStringDrawingUsesLineFragmentOrigin
                                     attributes:@{NSFontAttributeName: manaCostLabel.font}
                                        context:nil];
    CGFloat margin = 10;
    CGFloat width = rect.size.width + margin;
    
    //
    
    [NSLayoutConstraint activateConstraints:@[
        [manaCostLabel.leadingAnchor constraintEqualToAnchor:self.leadingAnchor],
        [manaCostLabel.topAnchor constraintEqualToAnchor:self.topAnchor],
        [manaCostLabel.trailingAnchor constraintEqualToAnchor:self.nameLabel.leadingAnchor],
        [manaCostLabel.bottomAnchor constraintEqualToAnchor:self.bottomAnchor],
        [manaCostLabel.widthAnchor constraintEqualToConstant:width]
    ]];
    
    //
    
    [manaCostLabel release];
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
//        [imageView.leadingAnchor constraintEqualToAnchor:self.nameLabel.trailingAnchor],
        [imageView.heightAnchor constraintEqualToAnchor:self.nameLabel.heightAnchor]
    ]];

    NSLayoutConstraint *aspectLayout = [NSLayoutConstraint constraintWithItem:imageView
                                                                    attribute:NSLayoutAttributeWidth
                                                                    relatedBy:NSLayoutRelationEqual
                                                                       toItem:imageView
                                                                    attribute:NSLayoutAttributeHeight
                                                                   multiplier:243 / 64
                                                                     constant:0];
    aspectLayout.active = YES;
    
    //
    
    [self bringSubviewToFront:self.nameLabel];
    
    //
    
    CAGradientLayer *imageViewGradientLayer = [CAGradientLayer new];
    self.imageViewGradientLayer = imageViewGradientLayer;
    imageViewGradientLayer.colors = @[
        (id)[UIColor.whiteColor colorWithAlphaComponent:0].CGColor,
        (id)UIColor.whiteColor.CGColor
    ];
    imageViewGradientLayer.startPoint = CGPointMake(0, 0);
    imageViewGradientLayer.endPoint = CGPointMake(0.8, 0);
    imageView.layer.mask = imageViewGradientLayer;
    [imageViewGradientLayer release];
    
    //
    
    [imageView release];
}

- (void)configureCountLabel {
    UILabel *countLabel = [UILabel new];
    self.countLabel = countLabel;
    
    //
    
    countLabel.backgroundColor = UIColor.systemGrayColor;
    countLabel.textColor = UIColor.whiteColor;
    countLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleTitle2];
    countLabel.textAlignment = NSTextAlignmentCenter;
    
    [self addSubview:countLabel];
    countLabel.translatesAutoresizingMaskIntoConstraints = NO;
    
    //
    
    NSString *integerString = @"9";
    CGRect integerRect = [integerString boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX)
                                        options:NSStringDrawingUsesLineFragmentOrigin
                                     attributes:@{NSFontAttributeName: countLabel.font}
                                        context:nil];
    
    NSString *starString = @"★";
    CGRect starRect = [starString boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX)
                                        options:NSStringDrawingUsesLineFragmentOrigin
                                     attributes:@{NSFontAttributeName: countLabel.font}
                                        context:nil];
    CGFloat margin = 10;
    CGFloat width = MAX(integerRect.size.width, starRect.size.width) + margin;
    
    //
    
    [NSLayoutConstraint activateConstraints:@[
        [countLabel.topAnchor constraintEqualToAnchor:self.topAnchor],
        [countLabel.trailingAnchor constraintEqualToAnchor:self.trailingAnchor],
        [countLabel.bottomAnchor constraintEqualToAnchor:self.bottomAnchor],
        [countLabel.leadingAnchor constraintEqualToAnchor:self.imageView.trailingAnchor],
        [countLabel.leadingAnchor constraintEqualToAnchor:self.nameLabel.trailingAnchor],
        [countLabel.widthAnchor constraintEqualToConstant:width]
    ]];
    
    //
    
    [countLabel release];
}

- (void)setConfiguration:(id<UIContentConfiguration>)configuration {
    DeckDetailsCardContentConfiguration *oldContentConfig = (DeckDetailsCardContentConfiguration *)self.configuration;
    DeckDetailsCardContentConfiguration *newContentConfig = [(DeckDetailsCardContentConfiguration *)configuration copy];
    self->configuration = newContentConfig;
    
    if (![newContentConfig.hsCard isEqual:oldContentConfig.hsCard]) {
        [self updateViewFromHSCard];
        [self updateCount];
    } else if (newContentConfig.hsCardCount != oldContentConfig.hsCardCount) {
        [self updateCount];
    }
    
    [oldContentConfig release];
}

- (HSCard * _Nullable)hsCard {
    if (![self.configuration isKindOfClass:[DeckDetailsCardContentConfiguration class]]) {
        return nil;
    }
    
    DeckDetailsCardContentConfiguration *contentConfiguration = (DeckDetailsCardContentConfiguration *)self.configuration;
    return contentConfiguration.hsCard;
}

- (NSUInteger)hsCardCount {
    if (![self.configuration isKindOfClass:[DeckDetailsCardContentConfiguration class]]) {
        return 0;
    }
    
    DeckDetailsCardContentConfiguration *contentConfiguration = (DeckDetailsCardContentConfiguration *)self.configuration;
    return contentConfiguration.hsCardCount;
}

- (void)updateViewFromHSCard {
    self.nameLabel.text = self.hsCard.name;
    
    //
    
    switch (self.hsCard.rarityId) {
        case HSCardRarityCommon:
            self.nameLabel.textColor = nil;
            break;
        case HSCardRarityRare:
            self.nameLabel.textColor = UIColor.systemBlueColor;
            break;
        case HSCardRarityEpic:
            self.nameLabel.textColor = UIColor.systemPurpleColor;
            break;
        case HSCardRarityLegendary:
            self.nameLabel.textColor = UIColor.systemOrangeColor;
            break;
        default:
            self.nameLabel.textColor = UIColor.systemGrayColor;
            break;
    }
    
    //
    
    self.manaCostLabel.text = [NSString stringWithFormat:@"%lu", self.hsCard.manaCost];
    
    //
    
    void (^asyncImageCompletion)(UIImage * _Nullable, NSError * _Nullable) = ^(UIImage * _Nullable image, NSError * _Nullable error) {
        [NSOperationQueue.mainQueue addOperationWithBlock:^{
            [self updateGradientLayer];
        }];
    };
    
    if (self.hsCard.cropImage) {
        [self.imageView setAsyncImageWithURL:self.hsCard.cropImage indicator:NO completion:asyncImageCompletion];
    } else {
        [self.imageView setAsyncImageWithURL:self.hsCard.image indicator:NO completion:asyncImageCompletion];
    }
}

- (void)updateCount {
    if ((self.hsCard.rarityId == HSCardRarityLegendary) && (self.hsCardCount == 1)) {
        self.countLabel.text = @"★";
    } else {
        self.countLabel.text = [NSString stringWithFormat:@"%lu", self.hsCardCount];
    }
}

- (void)updateGradientLayer {
    [CATransaction begin];
    [CATransaction setDisableActions:YES];
    self.imageViewGradientLayer.frame = self.imageView.bounds;
    [CATransaction commit];
}

@end
