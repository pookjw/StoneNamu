//
//  DeckBaseContentView.m
//  DeckBaseContentView
//
//  Created by Jinwoo Kim on 8/26/21.
//

#import "DeckBaseContentView.h"
#import "DeckBaseContentConfiguration.h"
#import "InsetsLabel.h"
#import <StoneNamuResources/StoneNamuResources.h>

@interface DeckBaseContentView ()
@property (retain) UIStackView *stackView;
@property (retain) UIImageView *cardSetImageView;
@property (retain) InsetsLabel *nameLabel;
@property (retain) UIImageView *heroImageView;
@property (retain) CAGradientLayer *heroImageViewGradientLayer;
@property (retain) UIView *countLabelContainerView;
@property (retain) InsetsLabel *countLabel;
@property (readonly, nonatomic) LocalDeck * _Nullable localDeck;
@property (readonly, nonatomic) BOOL isDarkMode;
@property (readonly, nonatomic) BOOL isEasterEgg;
@property (readonly, nonatomic) NSUInteger count;
@end

@implementation DeckBaseContentView

@synthesize configuration;

- (instancetype)init {
    self = [super init];
    
    if (self) {
        [self configureStackView];
        [self configureCardSetImageView];
        [self configureNameLabel];
        [self configureHeroImageView];
        [self configureCountLabelContainerView];
        [self configureCountLabel];
    }
    
    return self;
}

- (void)dealloc {
    [configuration release];
    [_stackView release];
    [_cardSetImageView release];
    [_nameLabel release];
    [_heroImageView release];
    [_heroImageViewGradientLayer release];
    [_countLabelContainerView release];
    [_countLabel release];
    [super dealloc];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self updateGradientLayer];
    [self updateCountLabel];
}

- (void)configureStackView {
    UIStackView *stackView = [UIStackView new];
    
    stackView.backgroundColor = UIColor.clearColor;
    stackView.axis = UILayoutConstraintAxisHorizontal;
    stackView.distribution = UIStackViewDistributionFill;
    stackView.alignment = UIStackViewAlignmentFill;
    
    stackView.translatesAutoresizingMaskIntoConstraints = NO;
    
    [self addSubview:stackView];
    [NSLayoutConstraint activateConstraints:@[
        [stackView.topAnchor constraintEqualToAnchor:self.topAnchor],
        [stackView.leadingAnchor constraintEqualToAnchor:self.leadingAnchor],
        [stackView.trailingAnchor constraintLessThanOrEqualToAnchor:self.trailingAnchor],
        [stackView.bottomAnchor constraintEqualToAnchor:self.bottomAnchor]
    ]];
    
    self.stackView = stackView;
    [stackView release];
}

- (void)configureCardSetImageView {
    UIImageView *cardSetImageView = [UIImageView new];
    
    cardSetImageView.backgroundColor = UIColor.clearColor;
    cardSetImageView.contentMode = UIViewContentModeScaleAspectFit;
    
    [self.stackView addArrangedSubview:cardSetImageView];
    
    [cardSetImageView setContentCompressionResistancePriority:UILayoutPriorityDefaultHigh forAxis:UILayoutConstraintAxisHorizontal];
    [cardSetImageView setContentHuggingPriority:UILayoutPriorityDefaultHigh forAxis:UILayoutConstraintAxisVertical];
    
    NSLayoutConstraint *aspectRatio = [NSLayoutConstraint constraintWithItem:cardSetImageView
                                                                   attribute:NSLayoutAttributeWidth
                                                                   relatedBy:NSLayoutRelationEqual
                                                                      toItem:cardSetImageView
                                                                   attribute:NSLayoutAttributeHeight
                                                                  multiplier:1
                                                                    constant:0];
    aspectRatio.active = YES;
    
    self.cardSetImageView = cardSetImageView;
    [cardSetImageView release];
}

- (void)configureNameLabel {
    InsetsLabel *nameLabel = [InsetsLabel new];
    
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(15.0f, 0.0f, 15.0f, 15.0f);
    nameLabel.contentInsets = contentInsets;
    nameLabel.backgroundColor = UIColor.clearColor;
    nameLabel.layer.cornerCurve = kCACornerCurveContinuous;
    nameLabel.textColor = nil;
    nameLabel.numberOfLines = 1;
    nameLabel.adjustsFontForContentSizeCategory = YES;
    nameLabel.adjustsFontSizeToFitWidth = NO;
    nameLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleTitle3];
    nameLabel.minimumScaleFactor = 0.1f;
    
    [self.stackView addArrangedSubview:nameLabel];
    
    //
    
    [nameLabel setContentCompressionResistancePriority:UILayoutPriorityDefaultLow forAxis:UILayoutConstraintAxisHorizontal];
    [nameLabel setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
    
    self.nameLabel = nameLabel;
    [nameLabel release];
}

- (void)configureHeroImageView {
    UIImageView *heroImageView = [UIImageView new];
    
    heroImageView.backgroundColor = UIColor.clearColor;
    heroImageView.contentMode = UIViewContentModeScaleAspectFill;
    heroImageView.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:heroImageView];
    
    [heroImageView setContentHuggingPriority:UILayoutPriorityDefaultHigh forAxis:UILayoutConstraintAxisVertical];
    
    NSLayoutConstraint *aspectLayout = [NSLayoutConstraint constraintWithItem:heroImageView
                                                                    attribute:NSLayoutAttributeWidth
                                                                    relatedBy:NSLayoutRelationEqual
                                                                       toItem:heroImageView
                                                                    attribute:NSLayoutAttributeHeight
                                                                   multiplier:243.0f / 64.0f
                                                                     constant:0.0f];
    
    [NSLayoutConstraint activateConstraints:@[
        [heroImageView.topAnchor constraintEqualToAnchor:self.topAnchor],
        [heroImageView.trailingAnchor constraintEqualToAnchor:self.trailingAnchor],
        [heroImageView.bottomAnchor constraintEqualToAnchor:self.bottomAnchor],
        aspectLayout
    ]];
    
    //
    
    [self bringSubviewToFront:self.stackView];
    
    //
    
    CAGradientLayer *heroImageViewGradientLayer = [CAGradientLayer new];
    heroImageViewGradientLayer.colors = @[
        (id)[UIColor.whiteColor colorWithAlphaComponent:0.0f].CGColor,
        (id)UIColor.whiteColor.CGColor
    ];
    heroImageViewGradientLayer.startPoint = CGPointMake(0.0f, 0.0f);
    heroImageViewGradientLayer.endPoint = CGPointMake(0.8f, 0.0f);
    heroImageView.layer.mask = heroImageViewGradientLayer;
    self.heroImageViewGradientLayer = heroImageViewGradientLayer;
    [heroImageViewGradientLayer release];
    
    //
    
    self.heroImageView = heroImageView;
    [heroImageView release];
}

- (void)configureCountLabelContainerView {
    UIView *countLabelContainerView = [UIView new];
    
    countLabelContainerView.backgroundColor = UIColor.clearColor;
    [self.stackView addArrangedSubview:countLabelContainerView];
    
    self.countLabelContainerView = countLabelContainerView;
    [countLabelContainerView release];
}

- (void)configureCountLabel {
    InsetsLabel *countLabel = [InsetsLabel new];
    
    countLabel.contentInsets = UIEdgeInsetsMake(0.0f, 10.0f, 0.0f, 10.0f);
    countLabel.layer.masksToBounds = YES;
    countLabel.backgroundColor = UIColor.tintColor;
    countLabel.textColor = UIColor.whiteColor;
    countLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleHeadline];
    
    [countLabel setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    [countLabel setContentHuggingPriority:UILayoutPriorityDefaultHigh forAxis:UILayoutConstraintAxisVertical];
    countLabel.translatesAutoresizingMaskIntoConstraints = NO;
    
    [self.countLabelContainerView addSubview:countLabel];
    
    [NSLayoutConstraint activateConstraints:@[
        [countLabel.topAnchor constraintEqualToAnchor:self.countLabelContainerView.topAnchor constant:10.0f],
        [countLabel.leadingAnchor constraintEqualToAnchor:self.countLabelContainerView.leadingAnchor],
        [countLabel.trailingAnchor constraintEqualToAnchor:self.countLabelContainerView.trailingAnchor constant:-5.0f],
        [countLabel.bottomAnchor constraintEqualToAnchor:self.countLabelContainerView.bottomAnchor constant:-10.0f]
    ]];
    
    self.countLabel = countLabel;
    [countLabel release];
}

- (void)setConfiguration:(id<UIContentConfiguration>)configuration {
    DeckBaseContentConfiguration *oldContentConfig = self.configuration;
    DeckBaseContentConfiguration *newContentConfig = [(DeckBaseContentConfiguration *)configuration copy];
    self->configuration = newContentConfig;
    
    [self updateCardSetImageView];
    [self updateNameLabel];
    [self updateHeroImageView];
    [self updateCountLabel];
    
    [oldContentConfig release];
}

- (LocalDeck * _Nullable)localDeck {
    DeckBaseContentConfiguration *contentConfig = (DeckBaseContentConfiguration *)self.configuration;
    
    if (![contentConfig isKindOfClass:[DeckBaseContentConfiguration class]]) {
        return nil;
    }
    
    return contentConfig.localDeck;
}

- (BOOL)isDarkMode {
    DeckBaseContentConfiguration *contentConfiguration = (DeckBaseContentConfiguration *)self.configuration;
    
    if (![self.configuration isKindOfClass:[DeckBaseContentConfiguration class]]) {
        return NO;
    }
    
    return contentConfiguration.isDarkMode;
}

- (BOOL)isEasterEgg {
    DeckBaseContentConfiguration *contentConfiguration = (DeckBaseContentConfiguration *)self.configuration;
    
    if (![self.configuration isKindOfClass:[DeckBaseContentConfiguration class]]) {
        return NO;
    }
    
    return contentConfiguration.isEasterEgg;
}

- (NSUInteger)count {
    DeckBaseContentConfiguration *contentConfiguration = (DeckBaseContentConfiguration *)self.configuration;
    
    if (![self.configuration isKindOfClass:[DeckBaseContentConfiguration class]]) {
        return NO;
    }
    
    return contentConfiguration.count;
}

- (void)updateCardSetImageView {
    UIEdgeInsets inset = UIEdgeInsetsMake(-8.0f, -8.0f, -8.0f, -8.0f);
    self.cardSetImageView.image = [[ResourcesService imageForDeckFormat:self.localDeck.format] imageWithAlignmentRectInsets:inset];
}

- (void)updateNameLabel {
    self.nameLabel.text = self.localDeck.name;
}

- (void)updateHeroImageView {
    UIImage *image;
    
    if (self.isEasterEgg) {
        image = [ResourcesService imageForKey:ImageKeyPnamuEasteregg1];
    } else {
        image = [ResourcesService portraitImageForClassId:self.localDeck.classId.unsignedIntegerValue];
    }
    
    self.heroImageView.image = image;
    [self updateGradientLayer];
}

- (void)updateCountLabel {
    NSUInteger count = self.count;
    
    if (count >= HSDECK_MAX_TOTAL_CARDS) {
        self.countLabelContainerView.hidden = YES;
    } else {
        self.countLabelContainerView.hidden = NO;
    }
    
    self.countLabel.text = [NSString stringWithFormat:@"%lu / %d", count, HSDECK_MAX_TOTAL_CARDS];
    [self.countLabel sizeToFit];
    [self.countLabelContainerView layoutIfNeeded];
    self.countLabel.layer.cornerRadius = self.countLabel.frame.size.height / 2.0f;
}

- (void)updateGradientLayer {
    [CATransaction begin];
    [CATransaction setDisableActions:YES];
    self.heroImageViewGradientLayer.frame = self.heroImageView.bounds;
    [CATransaction commit];
}

@end
