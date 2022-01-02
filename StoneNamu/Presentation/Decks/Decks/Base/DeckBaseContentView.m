//
//  DeckBaseContentView.m
//  DeckBaseContentView
//
//  Created by Jinwoo Kim on 8/26/21.
//

#import "DeckBaseContentView.h"
#import "DeckBaseContentConfiguration.h"
#import "InsetsLabel.h"
#import "DeckBaseContentViewModel.h"
#import <StoneNamuResources/StoneNamuResources.h>

@interface DeckBaseContentView ()
@property (retain) UIImageView *cardSetImageView;
@property (retain) InsetsLabel *nameLabel;
@property (retain) UIImageView *heroImageView;
@property (retain) CAGradientLayer *imageViewGradientLayer;
@property (retain) UIVisualEffectView *countBlurView;
@property (retain) InsetsLabel *countLabel;
@property (readonly, nonatomic) LocalDeck * _Nullable localDeck;
@property (retain) DeckBaseContentViewModel *viewModel;
@end

@implementation DeckBaseContentView

@synthesize configuration;

- (instancetype)init {
    self = [super init];
    
    if (self) {
        [self configureCardSetImageView];
        [self configureNameLabel];
        [self configureHeroImageView];
        [self configureCountBlurView];
        [self configureCountLabel];
        [self configureViewModel];
    }
    
    return self;
}

- (void)dealloc {
    [configuration release];
    [_cardSetImageView release];
    [_nameLabel release];
    [_heroImageView release];
    [_imageViewGradientLayer release];
    [_countBlurView release];
    [_countLabel release];
    [_viewModel release];
    [super dealloc];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self updateGradientLayer];
    [self updateCountLabel];
}

- (void)configureCardSetImageView {
    UIImageView *cardSetImageView = [UIImageView new];
    
    cardSetImageView.backgroundColor = UIColor.clearColor;
    cardSetImageView.translatesAutoresizingMaskIntoConstraints = NO;
    cardSetImageView.contentMode = UIViewContentModeScaleAspectFit;
    [self addSubview:cardSetImageView];
    
    [NSLayoutConstraint activateConstraints:@[
        [cardSetImageView.topAnchor constraintEqualToAnchor:self.topAnchor],
        [cardSetImageView.leadingAnchor constraintEqualToAnchor:self.leadingAnchor]
    ]];
    
    NSLayoutConstraint *bottomLayout = [cardSetImageView.bottomAnchor constraintEqualToAnchor:self.bottomAnchor];
    bottomLayout.priority = UILayoutPriorityDefaultHigh;
    bottomLayout.active = YES;
    
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
    
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(15, 0, 15, 15);
    nameLabel.contentInsets = contentInsets;
    nameLabel.backgroundColor = UIColor.clearColor;
    nameLabel.textColor = nil;
    nameLabel.adjustsFontSizeToFitWidth = YES;
    nameLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleTitle3];
    nameLabel.minimumScaleFactor = 0.1;
    
    NSString *string = @"";
    CGRect rect = [string boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX)
                                       options:NSStringDrawingUsesLineFragmentOrigin
                                    attributes:@{NSFontAttributeName: nameLabel.font}
                                       context:nil];
    
    [self addSubview:nameLabel];
    
    //
    
    nameLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [NSLayoutConstraint activateConstraints:@[
        [nameLabel.topAnchor constraintEqualToAnchor:self.topAnchor],
        [nameLabel.leadingAnchor constraintEqualToAnchor:self.cardSetImageView.trailingAnchor],
        [nameLabel.heightAnchor constraintEqualToConstant:ceilf(rect.size.height + contentInsets.top + contentInsets.bottom)],
        [self.cardSetImageView.heightAnchor constraintEqualToAnchor:nameLabel.heightAnchor]
    ]];
    
    NSLayoutConstraint *bottomLayout = [nameLabel.bottomAnchor constraintEqualToAnchor:self.bottomAnchor];
    bottomLayout.priority = UILayoutPriorityDefaultHigh;
    bottomLayout.active = YES;
    
    self.nameLabel = nameLabel;
    [nameLabel release];
}

- (void)configureHeroImageView {
    UIImageView *heroImageView = [UIImageView new];
    
    heroImageView.backgroundColor = UIColor.clearColor;
    heroImageView.contentMode = UIViewContentModeScaleAspectFill;
    heroImageView.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:heroImageView];
    
    [NSLayoutConstraint activateConstraints:@[
        [heroImageView.centerYAnchor constraintEqualToAnchor:self.centerYAnchor],
        [heroImageView.heightAnchor constraintEqualToAnchor:self.nameLabel.heightAnchor],
        [heroImageView.trailingAnchor constraintEqualToAnchor:self.trailingAnchor]
    ]];
    
    NSLayoutConstraint *aspectLayout = [NSLayoutConstraint constraintWithItem:heroImageView
                                                                    attribute:NSLayoutAttributeWidth
                                                                    relatedBy:NSLayoutRelationEqual
                                                                       toItem:heroImageView
                                                                    attribute:NSLayoutAttributeHeight
                                                                   multiplier:243.0 / 64.0
                                                                     constant:0];
    aspectLayout.active = YES;
    
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
    heroImageView.layer.mask = imageViewGradientLayer;
    self.imageViewGradientLayer = imageViewGradientLayer;
    [imageViewGradientLayer release];
    
    //
    
    self.heroImageView = heroImageView;
    [heroImageView release];
}

- (void)configureCountBlurView {
    UIVisualEffectView *countBlurView = [[UIVisualEffectView alloc] initWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleLight]];
    
    countBlurView.translatesAutoresizingMaskIntoConstraints = NO;
    
    [self addSubview:countBlurView];
    
    [NSLayoutConstraint activateConstraints:@[
        [countBlurView.centerYAnchor constraintEqualToAnchor:self.nameLabel.centerYAnchor],
        [countBlurView.leadingAnchor constraintEqualToAnchor:self.nameLabel.trailingAnchor]
    ]];
    
    self.countBlurView = countBlurView;
    [countBlurView release];
}

- (void)configureCountLabel {
    InsetsLabel *countLabel = [InsetsLabel new];
    
    countLabel.contentInsets = UIEdgeInsetsMake(5, 5, 5, 5);
    countLabel.backgroundColor = [UIColor.tintColor colorWithAlphaComponent:0.5];
    countLabel.textColor = UIColor.whiteColor;
    countLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleHeadline];
    
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

- (void)configureViewModel {
    DeckBaseContentViewModel *viewModel = [DeckBaseContentViewModel new];
    self.viewModel = viewModel;
    [viewModel release];
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

- (void)updateCardSetImageView {
    UIEdgeInsets inset = UIEdgeInsetsMake(-8, -8, -8, -8);
    self.cardSetImageView.image = [[ResourcesService imageForDeckFormat:self.localDeck.format] imageWithAlignmentRectInsets:inset];
}

- (void)updateNameLabel {
    self.nameLabel.text = self.localDeck.name;
}

- (void)updateHeroImageView {
    self.heroImageView.image = [self.viewModel portraitImageOfLocalDeck:self.localDeck];
    [self updateGradientLayer];
}

- (void)updateCountLabel {
    NSUInteger count = self.localDeck.hsCards.count;
    
    if (count >= HSDECK_MAX_TOTAL_CARDS) {
        self.countBlurView.alpha = 0.0;
    } else {
        self.countBlurView.alpha = 1.0;
    }
    
    self.countLabel.text = [NSString stringWithFormat:@"%lu / %d", count, HSDECK_MAX_TOTAL_CARDS];
    [self.countLabel layoutIfNeeded];
    
    self.countBlurView.layer.cornerRadius = self.countLabel.frame.size.height / 2;
    self.countBlurView.clipsToBounds = YES;
}

- (void)updateGradientLayer {
    [CATransaction begin];
    [CATransaction setDisableActions:YES];
    self.imageViewGradientLayer.frame = self.heroImageView.bounds;
    [CATransaction commit];
}

@end
