//
//  DeckImageRenderServiceCardContentView.m
//  DeckImageRenderServiceCardContentView
//
//  Created by Jinwoo Kim on 9/10/21.
//

#import "DeckImageRenderServiceCardContentView.h"
#import "DeckImageRenderServiceCardContentConfiguration.h"
#import "InsetsLabel.h"

@interface DeckImageRenderServiceCardContentView ()
@property (readonly, nonatomic) HSCard * _Nullable hsCard;
@property (readonly, nonatomic) UIImage * _Nullable hsCardImage;
@property (readonly, nonatomic) NSUInteger hsCardCount;
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
    self.nameLabel = nameLabel;
    
    nameLabel.contentInsets = UIEdgeInsetsMake(10, 10, 10, 10);
    nameLabel.backgroundColor = UIColor.clearColor;
    nameLabel.textColor = UIColor.whiteColor;
    nameLabel.adjustsFontSizeToFitWidth = YES;
    nameLabel.font = [UIFont systemFontOfSize:18 weight:UIFontWeightRegular];
    nameLabel.minimumScaleFactor = 0.1;
    
    nameLabel.layer.shadowRadius = 2.0;
    nameLabel.layer.shadowOpacity = 1;
    nameLabel.layer.shadowOffset = CGSizeMake(0, 0);
    nameLabel.layer.shadowColor = UIColor.blackColor.CGColor;
    nameLabel.layer.masksToBounds = YES;
    
    [self addSubview:nameLabel];
    nameLabel.translatesAutoresizingMaskIntoConstraints = NO;
    
    //
    
    NSString *string = @"";
    
    CGRect rect = [string boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX)
                                       options:NSStringDrawingUsesLineFragmentOrigin
                                    attributes:@{NSFontAttributeName: nameLabel.font}
                                       context:nil];
    CGFloat margin = nameLabel.contentInsets.top + nameLabel.contentInsets.bottom;
    CGFloat height = ceil(rect.size.height + margin);
    
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
    
    manaCostLabel.backgroundColor = UIColor.systemBlueColor;
    manaCostLabel.textColor = UIColor.whiteColor;
    manaCostLabel.font = [UIFont systemFontOfSize:18 weight:UIFontWeightBold];
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
    CGFloat width = ceil(rect.size.width + margin);
    
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
    
    countLabel.backgroundColor = UIColor.grayColor;
    countLabel.font = [UIFont systemFontOfSize:18 weight:UIFontWeightBold];
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
    CGFloat width = ceil(MAX(integerRect.size.width, starRect.size.width) + margin);
    
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

- (void)updateViewFromHSCard {
    self.nameLabel.text = self.hsCard.name;
    
    //
    
    switch (self.hsCard.rarityId) {
        case HSCardRarityCommon:
            self.nameLabel.textColor = UIColor.whiteColor;
            break;
        case HSCardRarityRare:
            self.nameLabel.textColor = UIColor.cyanColor;
            break;
        case HSCardRarityEpic:
            self.nameLabel.textColor = UIColor.magentaColor;
            break;
        case HSCardRarityLegendary:
            self.nameLabel.textColor = UIColor.orangeColor;
            break;
        default:
            self.nameLabel.textColor = UIColor.grayColor;
            break;
    }
    
    //
    
    self.manaCostLabel.text = [NSString stringWithFormat:@"%lu", self.hsCard.manaCost];
    
    //
    
    self.imageView.image = self.hsCardImage;
    NSLog(@"%@", self.hsCardImage);
    [self updateGradientLayer];
}

- (void)updateCountLabel {
    if ((self.hsCard.rarityId == HSCardRarityLegendary) && (self.hsCardCount == 1)) {
        self.countLabel.text = @"★";
        self.countLabel.textColor = UIColor.orangeColor;
    } else {
        self.countLabel.text = [NSString stringWithFormat:@"%lu", self.hsCardCount];
        self.countLabel.textColor = UIColor.whiteColor;
    }
}

- (void)updateGradientLayer {
    [CATransaction begin];
    [CATransaction setDisableActions:YES];
    self.imageViewGradientLayer.frame = self.imageView.bounds;
    [CATransaction commit];
}

@end
