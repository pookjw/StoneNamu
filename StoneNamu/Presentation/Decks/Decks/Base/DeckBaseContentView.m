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
@property (retain) UIView *countBlurContainerView;
@property (retain) UIVisualEffectView *countBlurView;
@property (retain) InsetsLabel *countLabel;
@property (readonly, nonatomic) LocalDeck * _Nullable localDeck;
@property (readonly, nonatomic) BOOL isDarkMode;
@property (readonly, nonatomic) BOOL isEasterEgg;
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
        [self configureCountBlurView];
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
    [_countBlurContainerView release];
    [_countBlurView release];
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
        [stackView.trailingAnchor constraintEqualToAnchor:self.trailingAnchor],
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
    
    [cardSetImageView setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
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
    nameLabel.textColor = nil;
    nameLabel.numberOfLines = 1;
    nameLabel.adjustsFontForContentSizeCategory = YES;
    nameLabel.adjustsFontSizeToFitWidth = NO;
    nameLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleTitle3];
    nameLabel.minimumScaleFactor = 0.1f;
    
    [self.stackView addArrangedSubview:nameLabel];
    
    //
    
    [nameLabel setContentHuggingPriority:UILayoutPriorityDefaultHigh forAxis:UILayoutConstraintAxisHorizontal];
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

- (void)configureCountBlurView {
    UIView *countBlurContainerView = [UIView new];
    UIVisualEffectView *countBlurView = [[UIVisualEffectView alloc] initWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleLight]];
    
    countBlurContainerView.backgroundColor = UIColor.clearColor;
    countBlurView.clipsToBounds = YES;
    countBlurView.translatesAutoresizingMaskIntoConstraints = NO;
    
    [countBlurContainerView addSubview:countBlurView];
    [NSLayoutConstraint activateConstraints:@[
        [countBlurContainerView.topAnchor constraintEqualToAnchor:countBlurView.topAnchor constant:-5.0f],
        [countBlurContainerView.leadingAnchor constraintEqualToAnchor:countBlurView.leadingAnchor],
        [countBlurContainerView.trailingAnchor constraintEqualToAnchor:countBlurView.trailingAnchor constant:10.0f],
        [countBlurContainerView.bottomAnchor constraintEqualToAnchor:countBlurView.bottomAnchor constant:5.0f]
    ]];
    
    [self.stackView addArrangedSubview:countBlurContainerView];
    
    self.countBlurContainerView = countBlurContainerView;
    self.countBlurView = countBlurView;
    [countBlurContainerView release];
    [countBlurView release];
}

- (void)configureCountLabel {
    InsetsLabel *countLabel = [InsetsLabel new];
    
    countLabel.contentInsets = UIEdgeInsetsMake(0.0f, 5.0f, 0.0f, 5.0f);
    countLabel.backgroundColor = [UIColor.tintColor colorWithAlphaComponent:0.5f];
    countLabel.textColor = UIColor.whiteColor;
    countLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleHeadline];
    
    [countLabel setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    countLabel.translatesAutoresizingMaskIntoConstraints = NO;
    
    [self.countBlurView.contentView addSubview:countLabel];
    
    [NSLayoutConstraint activateConstraints:@[
        [countLabel.topAnchor constraintEqualToAnchor:self.countBlurView.contentView.topAnchor],
        [countLabel.leadingAnchor constraintEqualToAnchor:self.countBlurView.contentView.leadingAnchor],
        [countLabel.trailingAnchor constraintEqualToAnchor:self.countBlurView.contentView.trailingAnchor],
        [countLabel.bottomAnchor constraintEqualToAnchor:self.countBlurView.contentView.bottomAnchor]
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
    NSUInteger count = self.localDeck.hsCards.count;
    
    if (count >= HSDECK_MAX_TOTAL_CARDS) {
        self.countBlurContainerView.hidden = YES;
    } else {
        self.countBlurContainerView.hidden = NO;
    }
    
    self.countLabel.text = [NSString stringWithFormat:@"%lu / %d", count, HSDECK_MAX_TOTAL_CARDS];
    self.countBlurView.layer.cornerRadius = self.countBlurView.frame.size.height / 2.0f;
}

- (void)updateGradientLayer {
    [CATransaction begin];
    [CATransaction setDisableActions:YES];
    self.heroImageViewGradientLayer.frame = self.heroImageView.bounds;
    [CATransaction commit];
}

@end
