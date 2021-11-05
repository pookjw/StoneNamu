//
//  DeckImageRenderServiceIntroContentView.m
//  DeckImageRenderServiceIntroContentView
//
//  Created by Jinwoo Kim on 9/11/21.
//

#import "DeckImageRenderServiceIntroContentView.h"
#import "DeckImageRenderServiceIntroContentConfiguration.h"
#import "ImageService.h"
#import "InsetsLabel.h"
#import <StoneNamuCore/StoneNamuCore.h>
#import "UIFont+customFonts.h"

@interface DeckImageRenderServiceIntroContentView ()
@property (retain) UIImageView *heroImageView;
@property (retain) UIStackView *primaryStackView;
@property (retain) UIStackView *secondaryStackView;
@property (retain) InsetsLabel *nameLabel;
@property (retain) InsetsLabel *classLabel;
@property (retain) InsetsLabel *deckFormatLabel;
@property (retain) UIView *backgroundView;
@property (retain) CAGradientLayer *gradientLayer;
@end

@implementation DeckImageRenderServiceIntroContentView

@synthesize configuration;

- (instancetype)init {
    self = [super init];
    
    if (self) {
        [self setAttributes];
        [self configureHeroImageView];
        [self configurePrimaryStackView];
        [self configureNameLabel];
        [self configureSecondaryStackView];
        [self configureClassLabel];
        [self configureDeckFormatLabel];
        [self configureBackgroundView];
    }
    
    return self;
}

- (void)dealloc {
    [configuration release];
    [_heroImageView release];
    [_primaryStackView release];
    [_secondaryStackView release];
    [_classLabel release];
    [_nameLabel release];
    [_deckFormatLabel release];
    [_backgroundView release];
    [_gradientLayer release];
    [super dealloc];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self updateGradientLayer];
}

- (void)setAttributes {
    self.backgroundColor = UIColor.clearColor;
}

- (void)configureHeroImageView {
    UIImageView *heroImageView = [UIImageView new];
    self.heroImageView = heroImageView;
    
    heroImageView.backgroundColor = UIColor.clearColor;
    heroImageView.contentMode = UIViewContentModeScaleAspectFill;
    heroImageView.translatesAutoresizingMaskIntoConstraints = NO;
    
    [self addSubview:heroImageView];
    
    [NSLayoutConstraint activateConstraints:@[
        [heroImageView.topAnchor constraintEqualToAnchor:self.topAnchor],
        [heroImageView.leadingAnchor constraintEqualToAnchor:self.leadingAnchor],
        [heroImageView.trailingAnchor constraintEqualToAnchor:self.trailingAnchor],
        [heroImageView.bottomAnchor constraintEqualToAnchor:self.bottomAnchor]
    ]];
    
    NSLayoutConstraint *aspectRatio = [NSLayoutConstraint constraintWithItem:heroImageView
                                                                   attribute:NSLayoutAttributeWidth
                                                                   relatedBy:NSLayoutRelationEqual
                                                                      toItem:heroImageView
                                                                   attribute:NSLayoutAttributeHeight
                                                                  multiplier:243 / 64
                                                                    constant:0];
    aspectRatio.priority = UILayoutPriorityDefaultHigh;
    aspectRatio.active = YES;
    
    [heroImageView release];
}

- (void)configurePrimaryStackView {
    UIStackView *primaryStackView = [UIStackView new];
    self.primaryStackView = primaryStackView;
    
    primaryStackView.axis = UILayoutConstraintAxisVertical;
    primaryStackView.backgroundColor = [UIColor.blackColor colorWithAlphaComponent:0.6];
    primaryStackView.translatesAutoresizingMaskIntoConstraints = NO;
    
    [self addSubview:primaryStackView];
    
    [NSLayoutConstraint activateConstraints:@[
        [primaryStackView.leadingAnchor constraintEqualToAnchor:self.leadingAnchor],
        [primaryStackView.trailingAnchor constraintEqualToAnchor:self.trailingAnchor],
        [primaryStackView.bottomAnchor constraintEqualToAnchor:self.bottomAnchor]
    ]];
    
    [primaryStackView release];
}

- (void)configureNameLabel {
    InsetsLabel *nameLabel = [InsetsLabel new];
    self.nameLabel = nameLabel;
    
    nameLabel.contentInsets = UIEdgeInsetsMake(10, 10, 0, 10);
    nameLabel.font = [UIFont customFontWithType:UIFontCustomFontTypeGmarketSansBold size:18];
    nameLabel.backgroundColor = UIColor.clearColor;
    nameLabel.textColor = UIColor.whiteColor;
    nameLabel.textAlignment = NSTextAlignmentCenter;
    
    nameLabel.layer.shadowRadius = 2.0;
    nameLabel.layer.shadowOpacity = 1;
    nameLabel.layer.shadowOffset = CGSizeMake(0, 0);
    nameLabel.layer.shadowColor = UIColor.blackColor.CGColor;
    nameLabel.layer.masksToBounds = YES;
    
    [self.primaryStackView addArrangedSubview:nameLabel];
    
    [nameLabel release];
}

- (void)configureSecondaryStackView {
    UIStackView *secondaryStackView = [UIStackView new];
    self.secondaryStackView = secondaryStackView;
    
    secondaryStackView.axis = UILayoutConstraintAxisHorizontal;
    secondaryStackView.backgroundColor = UIColor.clearColor;
    
    [self.primaryStackView addArrangedSubview:secondaryStackView];
    
    [secondaryStackView release];
}

- (void)configureClassLabel {
    InsetsLabel *classLabel = [InsetsLabel new];
    self.classLabel = classLabel;
    
    classLabel.contentInsets = UIEdgeInsetsMake(10, 10, 10, 10);
    classLabel.font = [UIFont customFontWithType:UIFontCustomFontTypeGmarketSansMedium size:15];
    classLabel.backgroundColor = UIColor.clearColor;
    classLabel.textColor = UIColor.whiteColor;
    classLabel.textAlignment = NSTextAlignmentLeft;
    
    classLabel.layer.shadowRadius = 2.0f;
    classLabel.layer.shadowOpacity = 1.0f;
    classLabel.layer.shadowOffset = CGSizeZero;
    classLabel.layer.shadowColor = UIColor.blackColor.CGColor;
    classLabel.layer.masksToBounds = YES;
    
    [self.secondaryStackView addArrangedSubview:classLabel];
    [classLabel setContentCompressionResistancePriority:UILayoutPriorityDefaultLow forAxis:UILayoutConstraintAxisHorizontal];
    
    [classLabel release];
}

- (void)configureDeckFormatLabel {
    InsetsLabel *deckFormatLabel = [InsetsLabel new];
    self.deckFormatLabel = deckFormatLabel;
    
    deckFormatLabel.contentInsets = UIEdgeInsetsMake(10, 10, 10, 10);
    deckFormatLabel.font = [UIFont customFontWithType:UIFontCustomFontTypeGmarketSansMedium size:15];
    deckFormatLabel.backgroundColor = UIColor.clearColor;
    deckFormatLabel.textColor = UIColor.whiteColor;
    deckFormatLabel.textAlignment = NSTextAlignmentRight;
    
    deckFormatLabel.layer.shadowRadius = 2.0;
    deckFormatLabel.layer.shadowOpacity = 1;
    deckFormatLabel.layer.shadowOffset = CGSizeMake(0, 0);
    deckFormatLabel.layer.shadowColor = UIColor.blackColor.CGColor;
    deckFormatLabel.layer.masksToBounds = YES;
    
    [self.secondaryStackView addArrangedSubview:deckFormatLabel];
    [deckFormatLabel setContentCompressionResistancePriority:UILayoutPriorityDefaultHigh forAxis:UILayoutConstraintAxisHorizontal];
    
    [deckFormatLabel release];
}

- (void)configureBackgroundView {
    UIView *backgroundView = [UIView new];
    self.backgroundView = backgroundView;
    
    backgroundView.backgroundColor = [UIColor.blackColor colorWithAlphaComponent:0.6];
    backgroundView.translatesAutoresizingMaskIntoConstraints = NO;
    
    [self addSubview:backgroundView];
    [NSLayoutConstraint activateConstraints:@[
        [backgroundView.topAnchor constraintEqualToAnchor:self.topAnchor],
        [backgroundView.leadingAnchor constraintEqualToAnchor:self.leadingAnchor],
        [backgroundView.trailingAnchor constraintEqualToAnchor:self.trailingAnchor],
        [backgroundView.bottomAnchor constraintEqualToAnchor:self.primaryStackView.topAnchor]
    ]];
    
    CAGradientLayer *gradientLayer = [CAGradientLayer new];
    self.gradientLayer = gradientLayer;
    gradientLayer.colors = @[
        (id)[UIColor.whiteColor colorWithAlphaComponent:0].CGColor,
        (id)UIColor.whiteColor.CGColor
    ];
    gradientLayer.startPoint = CGPointMake(0, 0);
    gradientLayer.endPoint = CGPointMake(0, 1);
    self.backgroundView.layer.mask = gradientLayer;
    [gradientLayer release];
    
    [backgroundView release];
}

- (void)updateGradientLayer {
    [CATransaction begin];
    [CATransaction setDisableActions:YES];
    self.gradientLayer.frame = self.backgroundView.bounds;
    [CATransaction commit];
}

//

- (void)setConfiguration:(id<UIContentConfiguration>)configuration {
    [self->configuration release];
    DeckImageRenderServiceIntroContentConfiguration *newConfiguration = [(DeckImageRenderServiceIntroContentConfiguration *)configuration copy];
    self->configuration = newConfiguration;
    
    //
    
    if (newConfiguration.isEasterEgg) {
        self.heroImageView.backgroundColor = UIColor.grayColor;
        self.heroImageView.image = [ImageService.sharedInstance portraitOfPnamu];
    } else {
        self.heroImageView.backgroundColor = UIColor.clearColor;
        self.heroImageView.image = [ImageService.sharedInstance portraitImageOfClassId:newConfiguration.classId];
    }
    
    self.classLabel.text = localizableFromHSCardClass(newConfiguration.classId);
    self.nameLabel.text = newConfiguration.deckName;
    
    self.deckFormatLabel.text = hsDeckFormatsWithLocalizable()[newConfiguration.deckFormat];
    
    if ([newConfiguration.deckFormat isEqualToString:HSDeckFormatStandard]) {
        self.deckFormatLabel.textColor = UIColor.greenColor;
    } else if ([newConfiguration.deckFormat isEqualToString:HSDeckFormatWild]) {
        self.deckFormatLabel.textColor = UIColor.orangeColor;
    } else if ([newConfiguration.deckFormat isEqualToString:HSDeckFormatClassic]) {
        self.deckFormatLabel.textColor = UIColor.yellowColor;
    }
}

@end
