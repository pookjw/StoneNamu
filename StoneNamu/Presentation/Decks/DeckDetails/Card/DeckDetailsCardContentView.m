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
@property (readonly, nonatomic) HSCard * _Nullable hsCard;
@property (readonly, nonatomic) NSUInteger hsCardCount;
@property (readonly, nonatomic) HSCardRaritySlugType _Nullable raritySlugType;
@property (readonly, nonatomic) BOOL isDarkMode;
@property (retain) UIImageView *imageView;
@property (retain) UILabel *manaCostLabel;
@property (retain) NSLayoutConstraint *manaCostLabelWidthLayout;
@property (retain) InsetsLabel *nameLabel;
@property (retain) UILabel *countLabel;
@property (retain) NSLayoutConstraint *countLabelWidthLayout;
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
    [_manaCostLabelWidthLayout release];
    [_nameLabel release];
    [_countLabel release];
    [_countLabelWidthLayout release];
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
    
    nameLabel.contentInsets = UIEdgeInsetsMake(10, 10, 10, 10);
    nameLabel.backgroundColor = UIColor.clearColor;
    nameLabel.textColor = nil;
    nameLabel.adjustsFontForContentSizeCategory = YES;
    nameLabel.adjustsFontSizeToFitWidth = YES;
    nameLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleTitle3];
    nameLabel.minimumScaleFactor = 0.1;
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
    
    manaCostLabel.backgroundColor = UIColor.systemBlueColor;
    manaCostLabel.textColor = UIColor.whiteColor;
    manaCostLabel.adjustsFontForContentSizeCategory = YES;
    manaCostLabel.adjustsFontSizeToFitWidth = YES;
    manaCostLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleTitle2];
    manaCostLabel.textAlignment = NSTextAlignmentCenter;
    
    [self addSubview:manaCostLabel];
    manaCostLabel.translatesAutoresizingMaskIntoConstraints = NO;
    
    //
    
    CGFloat width = [self preferredWidthWithManaCostLabel:manaCostLabel];
    NSLayoutConstraint *manaCostLabelWidthLayout = [manaCostLabel.widthAnchor constraintEqualToConstant:width];
    
    [NSLayoutConstraint activateConstraints:@[
        [manaCostLabel.leadingAnchor constraintEqualToAnchor:self.leadingAnchor],
        [manaCostLabel.topAnchor constraintEqualToAnchor:self.topAnchor],
        [manaCostLabel.trailingAnchor constraintEqualToAnchor:self.nameLabel.leadingAnchor],
        [manaCostLabel.bottomAnchor constraintEqualToAnchor:self.bottomAnchor],
        manaCostLabelWidthLayout
    ]];
    
    self.manaCostLabelWidthLayout = manaCostLabelWidthLayout;
    
    //
    
    self.manaCostLabel = manaCostLabel;
    [manaCostLabel release];
}

- (CGFloat)preferredWidthWithManaCostLabel:(UILabel *)manaCostLabel {
    NSString *string = @"99";
    
    CGRect rect = [string boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX)
                                       options:NSStringDrawingUsesLineFragmentOrigin
                                    attributes:@{NSFontAttributeName: manaCostLabel.font}
                                       context:nil];
    CGFloat margin = 10;
    CGFloat width = ceilf(rect.size.width + margin);
    
    return width;
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
                                                                   multiplier:243.0 / 64.0
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
        (id)[UIColor.whiteColor colorWithAlphaComponent:0].CGColor,
        (id)UIColor.whiteColor.CGColor
    ];
    imageViewGradientLayer.startPoint = CGPointMake(0, 0);
    imageViewGradientLayer.endPoint = CGPointMake(0.8, 0);
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
    
    countLabel.backgroundColor = UIColor.systemGrayColor;
    countLabel.adjustsFontForContentSizeCategory = YES;
    countLabel.adjustsFontSizeToFitWidth = YES;
    countLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleTitle2];
    countLabel.textAlignment = NSTextAlignmentCenter;
    
    [self addSubview:countLabel];
    countLabel.translatesAutoresizingMaskIntoConstraints = NO;
    
    //
    
    CGFloat width = [self preferredWidthWithCountLabel:countLabel];
    NSLayoutConstraint *countLabelWidthLayout = [countLabel.widthAnchor constraintEqualToConstant:width];
    
    [NSLayoutConstraint activateConstraints:@[
        [countLabel.topAnchor constraintEqualToAnchor:self.topAnchor],
        [countLabel.trailingAnchor constraintEqualToAnchor:self.trailingAnchor],
        [countLabel.bottomAnchor constraintEqualToAnchor:self.bottomAnchor],
        [countLabel.leadingAnchor constraintEqualToAnchor:self.imageView.trailingAnchor],
        [countLabel.leadingAnchor constraintEqualToAnchor:self.nameLabel.trailingAnchor],
        countLabelWidthLayout
    ]];
    
    self.countLabelWidthLayout = countLabelWidthLayout;
    
    //
    
    self.countLabel = countLabel;
    [countLabel release];
}

- (CGFloat)preferredWidthWithCountLabel:(UILabel *)countLabel {
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
    
    return width;
}

- (void)setConfiguration:(id<UIContentConfiguration>)configuration {
    DeckDetailsCardContentConfiguration *oldContentConfig = (DeckDetailsCardContentConfiguration *)self.configuration;
    DeckDetailsCardContentConfiguration *newContentConfig = [(DeckDetailsCardContentConfiguration *)configuration copy];
    self->configuration = newContentConfig;
    
    if (![newContentConfig.hsCard isEqual:oldContentConfig.hsCard]) {
        [self updateViewFromHSCard];
    }
    
    self.manaCostLabelWidthLayout.constant = [self preferredWidthWithManaCostLabel:self.manaCostLabel];
    [self updateCountLabel];
    
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

- (HSCardRaritySlugType)raritySlugType {
    if (![self.configuration isKindOfClass:[DeckDetailsCardContentConfiguration class]]) {
        return nil;
    }
    
    DeckDetailsCardContentConfiguration *contentConfiguration = (DeckDetailsCardContentConfiguration *)self.configuration;
    return contentConfiguration.raritySlugType;
}

- (BOOL)isDarkMode {
    if (![self.configuration isKindOfClass:[DeckDetailsCardContentConfiguration class]]) {
        return NO;
    }
    
    DeckDetailsCardContentConfiguration *contentConfiguration = (DeckDetailsCardContentConfiguration *)self.configuration;
    return contentConfiguration.isDarkMode;
}

- (void)updateViewFromHSCard {
    self.nameLabel.text = self.hsCard.name;
    
    //
    
    if ([HSCardRaritySlugTypeFree isEqualToString:self.raritySlugType]) {
        self.nameLabel.textColor = UIColor.systemGrayColor;
    } else if ([HSCardRaritySlugTypeCommon isEqualToString:self.raritySlugType]) {
        self.nameLabel.textColor = nil;
    } else if ([HSCardRaritySlugTypeRare isEqualToString:self.raritySlugType]) {
        self.nameLabel.textColor = UIColor.systemBlueColor;
    } else if ([HSCardRaritySlugTypeEpic isEqualToString:self.raritySlugType]) {
        self.nameLabel.textColor = UIColor.systemPurpleColor;
    } else if ([HSCardRaritySlugTypeLegendary isEqualToString:self.raritySlugType]) {
        self.nameLabel.textColor = UIColor.systemOrangeColor;
    } else {
        self.nameLabel.textColor = nil;
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

- (void)updateCountLabel {
    if ([HSCardRaritySlugTypeLegendary isEqualToString:self.raritySlugType]) {
        self.countLabel.text = @"★";
        self.countLabel.textColor = UIColor.systemOrangeColor;
    } else {
        self.countLabel.text = [NSString stringWithFormat:@"%lu", self.hsCardCount];
        self.countLabel.textColor = UIColor.whiteColor;
    }
    
    self.countLabelWidthLayout.constant = [self preferredWidthWithCountLabel:self.countLabel];
}

- (void)updateGradientLayer {
    [CATransaction begin];
    [CATransaction setDisableActions:YES];
    self.imageViewGradientLayer.frame = self.imageView.bounds;
    [CATransaction commit];
}

@end
