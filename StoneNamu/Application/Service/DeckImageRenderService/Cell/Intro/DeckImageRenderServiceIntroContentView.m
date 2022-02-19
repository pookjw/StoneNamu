//
//  DeckImageRenderServiceIntroContentView.m
//  DeckImageRenderServiceIntroContentView
//
//  Created by Jinwoo Kim on 9/11/21.
//

#import "DeckImageRenderServiceIntroContentView.h"
#import "DeckImageRenderServiceIntroContentConfiguration.h"
#import "InsetsLabel.h"
#import <StoneNamuCore/StoneNamuCore.h>
#import <StoneNamuResources/StoneNamuResources.h>

@interface DeckImageRenderServiceIntroContentView ()
@property (retain) UIImageView *heroImageView;
@property (retain) UIStackView *primaryStackView;
@property (retain) UIStackView *secondaryStackView;
@property (retain) InsetsLabel *nameLabel;
@property (retain) InsetsLabel *classLabel;
@property (retain) InsetsLabel *deckFormatLabel;
@property (retain) UIView *backgroundView;
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
    [super dealloc];
}

- (void)setAttributes {
    self.backgroundColor = UIColor.clearColor;
}

- (void)configureHeroImageView {
    UIImageView *heroImageView = [UIImageView new];
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
                                                                  multiplier:243.0f / 64.0f
                                                                    constant:0];
    aspectRatio.priority = UILayoutPriorityDefaultHigh;
    aspectRatio.active = YES;
    
    self.heroImageView = heroImageView;
    [heroImageView release];
}

- (void)configurePrimaryStackView {
    UIStackView *primaryStackView = [UIStackView new];
    
    primaryStackView.axis = UILayoutConstraintAxisVertical;
    primaryStackView.backgroundColor = [UIColor.blackColor colorWithAlphaComponent:0.5f];
    primaryStackView.translatesAutoresizingMaskIntoConstraints = NO;
    
    [self addSubview:primaryStackView];
    
    [NSLayoutConstraint activateConstraints:@[
        [primaryStackView.leadingAnchor constraintEqualToAnchor:self.leadingAnchor],
        [primaryStackView.trailingAnchor constraintEqualToAnchor:self.trailingAnchor],
        [primaryStackView.bottomAnchor constraintEqualToAnchor:self.bottomAnchor]
    ]];
    
    self.primaryStackView = primaryStackView;
    [primaryStackView release];
}

- (void)configureNameLabel {
    InsetsLabel *nameLabel = [InsetsLabel new];
    
    nameLabel.contentInsets = UIEdgeInsetsMake(10, 10, 0, 10);
    nameLabel.font = [ResourcesService fontForKey:FontKeyGmarketSansTTFBold size:18.0f];
    nameLabel.backgroundColor = UIColor.clearColor;
    nameLabel.textColor = UIColor.whiteColor;
    nameLabel.textAlignment = NSTextAlignmentCenter;
    
    nameLabel.layer.shadowRadius = 2.0;
    nameLabel.layer.shadowOpacity = 1;
    nameLabel.layer.shadowOffset = CGSizeZero;
    nameLabel.layer.shadowColor = UIColor.blackColor.CGColor;
    nameLabel.layer.masksToBounds = NO;
    
    [self.primaryStackView addArrangedSubview:nameLabel];
    
    self.nameLabel = nameLabel;
    [nameLabel release];
}

- (void)configureSecondaryStackView {
    UIStackView *secondaryStackView = [UIStackView new];
    
    secondaryStackView.axis = UILayoutConstraintAxisHorizontal;
    secondaryStackView.backgroundColor = UIColor.clearColor;
    
    [self.primaryStackView addArrangedSubview:secondaryStackView];
    
    self.secondaryStackView = secondaryStackView;
    [secondaryStackView release];
}

- (void)configureClassLabel {
    InsetsLabel *classLabel = [InsetsLabel new];
    
    classLabel.contentInsets = UIEdgeInsetsMake(10, 10, 10, 10);
    classLabel.font = [ResourcesService fontForKey:FontKeyGmarketSansTTFMedium size:18.0f];
    classLabel.backgroundColor = UIColor.clearColor;
    classLabel.textColor = UIColor.whiteColor;
    classLabel.textAlignment = NSTextAlignmentLeft;
    
    classLabel.layer.shadowRadius = 2.0f;
    classLabel.layer.shadowOpacity = 1.0f;
    classLabel.layer.shadowOffset = CGSizeZero;
    classLabel.layer.shadowColor = UIColor.blackColor.CGColor;
    classLabel.layer.masksToBounds = NO;
    
    [self.secondaryStackView addArrangedSubview:classLabel];
    [classLabel setContentCompressionResistancePriority:UILayoutPriorityDefaultLow forAxis:UILayoutConstraintAxisHorizontal];
    
    self.classLabel = classLabel;
    [classLabel release];
}

- (void)configureDeckFormatLabel {
    InsetsLabel *deckFormatLabel = [InsetsLabel new];
    
    deckFormatLabel.contentInsets = UIEdgeInsetsMake(10, 10, 10, 10);
    deckFormatLabel.font = [ResourcesService fontForKey:FontKeyGmarketSansTTFMedium size:18.0f];
    deckFormatLabel.backgroundColor = UIColor.clearColor;
    deckFormatLabel.textColor = UIColor.whiteColor;
    deckFormatLabel.textAlignment = NSTextAlignmentRight;
    
    deckFormatLabel.layer.shadowRadius = 2.0;
    deckFormatLabel.layer.shadowOpacity = 1;
    deckFormatLabel.layer.shadowOffset = CGSizeZero;
    deckFormatLabel.layer.shadowColor = UIColor.blackColor.CGColor;
    deckFormatLabel.layer.masksToBounds = NO;
    
    [self.secondaryStackView addArrangedSubview:deckFormatLabel];
    [deckFormatLabel setContentCompressionResistancePriority:UILayoutPriorityDefaultHigh forAxis:UILayoutConstraintAxisHorizontal];
    
    self.deckFormatLabel = deckFormatLabel;
    [deckFormatLabel release];
}

- (void)configureBackgroundView {
    UIView *backgroundView = [UIView new];
    
    backgroundView.backgroundColor = [UIColor.blackColor colorWithAlphaComponent:0.5f];
    backgroundView.translatesAutoresizingMaskIntoConstraints = NO;
    
    [self addSubview:backgroundView];
    [NSLayoutConstraint activateConstraints:@[
        [backgroundView.topAnchor constraintEqualToAnchor:self.topAnchor],
        [backgroundView.leadingAnchor constraintEqualToAnchor:self.leadingAnchor],
        [backgroundView.trailingAnchor constraintEqualToAnchor:self.trailingAnchor],
        [backgroundView.bottomAnchor constraintEqualToAnchor:self.primaryStackView.topAnchor]
    ]];
    
    self.backgroundView = backgroundView;
    [backgroundView release];
}

//

- (void)setConfiguration:(id<UIContentConfiguration>)configuration {
    [self->configuration release];
    DeckImageRenderServiceIntroContentConfiguration *newConfiguration = [(DeckImageRenderServiceIntroContentConfiguration *)configuration copy];
    self->configuration = newConfiguration;
    
    //
    
    if (newConfiguration.isEasterEgg) {
        self.heroImageView.backgroundColor = UIColor.grayColor;
        self.heroImageView.image = [ResourcesService imageForKey:ImageKeyPnamuEasteregg1];
    } else {
        self.heroImageView.backgroundColor = UIColor.clearColor;
        self.heroImageView.image = [ResourcesService portraitImageForHSCardClassSlugType:newConfiguration.classSlug];
    }
    
    self.classLabel.text = newConfiguration.className;
    self.nameLabel.text = newConfiguration.deckName;
    
    self.deckFormatLabel.text = [ResourcesService localizationForHSDeckFormat:newConfiguration.deckFormat];
    
    if ([newConfiguration.deckFormat isEqualToString:HSDeckFormatStandard]) {
        self.deckFormatLabel.textColor = UIColor.greenColor;
    } else if ([newConfiguration.deckFormat isEqualToString:HSDeckFormatWild]) {
        self.deckFormatLabel.textColor = UIColor.orangeColor;
    } else if ([newConfiguration.deckFormat isEqualToString:HSDeckFormatClassic]) {
        self.deckFormatLabel.textColor = UIColor.yellowColor;
    }
}

@end
