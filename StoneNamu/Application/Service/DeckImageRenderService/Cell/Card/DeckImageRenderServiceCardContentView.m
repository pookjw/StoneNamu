//
//  DeckImageRenderServiceCardContentView.m
//  DeckImageRenderServiceCardContentView
//
//  Created by Jinwoo Kim on 9/10/21.
//

#import "DeckImageRenderServiceCardContentView.h"
#import "DeckImageRenderServiceCardContentConfiguration.h"
#import "InsetsLabel.h"
#import <StoneNamuResources/StoneNamuResources.h>

@interface DeckImageRenderServiceCardContentView ()
@property (readonly, nonatomic) HSCard * _Nullable hsCard;
@property (readonly, nonatomic) UIImage * _Nullable hsCardImage;
@property (readonly, nonatomic) NSUInteger hsCardCount;
@property (readonly, nonatomic) HSCardRaritySlugType raritySlug;
@property (retain) UIImageView *imageView;
@property (retain) UILabel *manaCostLabel;
@property (retain) InsetsLabel *nameLabel;
@property (retain) UILabel *countLabel;
@property (retain) CAGradientLayer *imageViewGradientLayer;
@end

@implementation DeckImageRenderServiceCardContentView

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
    self.backgroundColor = UIColor.clearColor;
}

- (void)configureNameLabel {
    InsetsLabel *nameLabel = [InsetsLabel new];
    
    nameLabel.contentInsets = UIEdgeInsetsMake(10, 10, 10, 10);
    nameLabel.backgroundColor = UIColor.clearColor;
    nameLabel.textColor = UIColor.whiteColor;
    nameLabel.adjustsFontSizeToFitWidth = YES;
    nameLabel.font = [ResourcesService fontForKey:FontKeyGmarketSansTTFMedium size:18.0f];
    nameLabel.minimumScaleFactor = 0.1;
    
    nameLabel.layer.shadowRadius = 2.0;
    nameLabel.layer.shadowOpacity = 1;
    nameLabel.layer.shadowOffset = CGSizeMake(0, 0);
    nameLabel.layer.shadowColor = UIColor.blackColor.CGColor;
    nameLabel.layer.masksToBounds = NO;
    [nameLabel setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
    
    [self addSubview:nameLabel];
    nameLabel.translatesAutoresizingMaskIntoConstraints = NO;
    
    //
    
    [NSLayoutConstraint activateConstraints:@[
        [nameLabel.topAnchor constraintEqualToAnchor:self.topAnchor],
        [nameLabel.bottomAnchor constraintEqualToAnchor:self.bottomAnchor]
    ]];
    
    //
    
    self.nameLabel = nameLabel;
    [nameLabel release];
}

- (void)configureManaCostLabel {
    UILabel *manaCostLabel = [UILabel new];
    
    manaCostLabel.backgroundColor = [UIColor colorWithRed:33.0 / 255.0
                                                    green:109.0 / 255.0
                                                     blue:217.0 / 255.0
                                                    alpha:1.0];
    manaCostLabel.textColor = UIColor.whiteColor;
    manaCostLabel.font = [ResourcesService fontForKey:FontKeyGmarketSansTTFBold size:18.0f];
    manaCostLabel.textAlignment = NSTextAlignmentCenter;
    
    [manaCostLabel setContentHuggingPriority:UILayoutPriorityDefaultHigh forAxis:UILayoutConstraintAxisVertical];
    
    [self addSubview:manaCostLabel];
    manaCostLabel.translatesAutoresizingMaskIntoConstraints = NO;
    
    //
    
    NSString *string = @"99";
    
    CGRect rect = [string boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX)
                                       options:NSStringDrawingUsesLineFragmentOrigin
                                    attributes:@{NSFontAttributeName: manaCostLabel.font}
                                       context:nil];
    CGFloat margin = 10;
    CGFloat width = ceilf(rect.size.width + margin);
    
    //
    
    [NSLayoutConstraint activateConstraints:@[
        [manaCostLabel.topAnchor constraintEqualToAnchor:self.topAnchor],
        [manaCostLabel.leadingAnchor constraintEqualToAnchor:self.leadingAnchor],
        [manaCostLabel.trailingAnchor constraintEqualToAnchor:self.nameLabel.leadingAnchor],
        [manaCostLabel.bottomAnchor constraintEqualToAnchor:self.bottomAnchor],
        [manaCostLabel.widthAnchor constraintEqualToConstant:width]
    ]];
    
    //
    
    self.manaCostLabel = manaCostLabel;
    [manaCostLabel release];
}

- (void)configureImageView {
    UIImageView *imageView = [UIImageView new];
    
    imageView.backgroundColor = UIColor.clearColor;
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    imageView.translatesAutoresizingMaskIntoConstraints = NO;
    
    [imageView setContentHuggingPriority:UILayoutPriorityDefaultHigh forAxis:UILayoutConstraintAxisVertical];
    [self addSubview:imageView];
    
    NSLayoutConstraint *aspectLayout = [NSLayoutConstraint constraintWithItem:imageView
                                                                    attribute:NSLayoutAttributeWidth
                                                                    relatedBy:NSLayoutRelationEqual
                                                                       toItem:imageView
                                                                    attribute:NSLayoutAttributeHeight
                                                                   multiplier:243.0f / 64.0f
                                                                     constant:0];
    
    [NSLayoutConstraint activateConstraints:@[
        [imageView.topAnchor constraintEqualToAnchor:self.topAnchor],
        [imageView.bottomAnchor constraintEqualToAnchor:self.bottomAnchor],
        aspectLayout
    ]];
    
    //
    
    [self bringSubviewToFront:self.nameLabel];
    
    //
    
    CAGradientLayer *imageViewGradientLayer = [CAGradientLayer new];
    imageViewGradientLayer.colors = @[
        (id)UIColor.clearColor.CGColor,
        (id)UIColor.whiteColor.CGColor
    ];
    imageViewGradientLayer.startPoint = CGPointMake(0.3, 0);
    imageViewGradientLayer.endPoint = CGPointMake(1.0, 0);
    imageView.layer.mask = imageViewGradientLayer;
    self.imageViewGradientLayer = imageViewGradientLayer;
    [imageViewGradientLayer release];
    
    //
    
    self.imageView = imageView;
    [imageView release];
}


- (void)configureCountLabel {
    UILabel *countLabel = [UILabel new];
    
    //
    
    countLabel.backgroundColor = [UIColor colorWithRed:19.0 / 255.0
                                                 green:22.0 / 255.0
                                                  blue:26.0 / 255.0
                                                 alpha:1.0];
    countLabel.textColor = [UIColor colorWithRed:255.0 / 255.0
                                           green:191.0 / 255.0
                                            blue:0 / 255.0
                                           alpha:1.0];
    countLabel.font = [ResourcesService fontForKey:FontKeyGmarketSansTTFBold size:18.0f];
    countLabel.textAlignment = NSTextAlignmentCenter;
    
    [countLabel setContentHuggingPriority:UILayoutPriorityDefaultHigh forAxis:UILayoutConstraintAxisVertical];
    
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
    CGFloat width = ceilf(MAX(integerRect.size.width, starRect.size.width) + margin);
    
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
    
    self.countLabel = countLabel;
    [countLabel release];
}

- (void)setConfiguration:(id<UIContentConfiguration>)configuration {
    DeckImageRenderServiceCardContentConfiguration *oldContentConfig = (DeckImageRenderServiceCardContentConfiguration *)self.configuration;
    DeckImageRenderServiceCardContentConfiguration *newContentConfig = [(DeckImageRenderServiceCardContentConfiguration *)configuration copy];
    self->configuration = newContentConfig;
    
    if (![newContentConfig.hsCard isEqual:oldContentConfig.hsCard]) {
        [self updateViewFromHSCard];
    }
    
    [self updateCountLabel];
    
    [oldContentConfig release];
}

- (HSCard * _Nullable)hsCard {
    if (![self.configuration isKindOfClass:[DeckImageRenderServiceCardContentConfiguration class]]) {
        return nil;
    }
    
    DeckImageRenderServiceCardContentConfiguration *contentConfiguration = (DeckImageRenderServiceCardContentConfiguration *)self.configuration;
    return contentConfiguration.hsCard;
}

- (UIImage *_Nullable)hsCardImage {
    if (![self.configuration isKindOfClass:[DeckImageRenderServiceCardContentConfiguration class]]) {
        return nil;
    }
    
    DeckImageRenderServiceCardContentConfiguration *contentConfiguration = (DeckImageRenderServiceCardContentConfiguration *)self.configuration;
    return contentConfiguration.hsCardImage;
}

- (NSUInteger)hsCardCount {
    if (![self.configuration isKindOfClass:[DeckImageRenderServiceCardContentConfiguration class]]) {
        return 0;
    }
    
    DeckImageRenderServiceCardContentConfiguration *contentConfiguration = (DeckImageRenderServiceCardContentConfiguration *)self.configuration;
    return contentConfiguration.hsCardCount;
}

- (HSCardRaritySlugType)raritySlug {
    if (![self.configuration isKindOfClass:[DeckImageRenderServiceCardContentConfiguration class]]) {
        return nil;
    }
    
    DeckImageRenderServiceCardContentConfiguration *contentConfiguration = (DeckImageRenderServiceCardContentConfiguration *)self.configuration;
    return contentConfiguration.raritySlug;
}

- (void)updateViewFromHSCard {
    self.nameLabel.text = self.hsCard.name;
    
    //
    
    if ([self.raritySlug isEqualToString:HSCardRaritySlugTypeCommon]) {
        self.nameLabel.textColor = UIColor.whiteColor;
    } else if ([self.raritySlug isEqualToString:HSCardRaritySlugTypeRare]) {
        self.nameLabel.textColor = UIColor.cyanColor;
    } else if ([self.raritySlug isEqualToString:HSCardRaritySlugTypeEpic]) {
        self.nameLabel.textColor = UIColor.magentaColor;
    } else if ([self.raritySlug isEqualToString:HSCardRaritySlugTypeLegendary]) {
        self.nameLabel.textColor = UIColor.orangeColor;
    } else {
        self.nameLabel.textColor = UIColor.grayColor;
    }
    
    //
    
    self.manaCostLabel.text = [NSString stringWithFormat:@"%lu", self.hsCard.manaCost];
    
    //
    
    self.imageView.image = self.hsCardImage;
    [self updateGradientLayer];
}

- (void)updateCountLabel {
    if (([self.raritySlug isEqualToString:HSCardRaritySlugTypeLegendary]) && (self.hsCardCount == 1)) {
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
