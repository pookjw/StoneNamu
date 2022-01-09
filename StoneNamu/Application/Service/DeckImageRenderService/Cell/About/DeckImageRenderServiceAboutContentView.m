//
//  DeckImageRenderServiceAboutContentView.m
//  DeckImageRenderServiceAboutContentView
//
//  Created by Jinwoo Kim on 9/15/21.
//

#import "DeckImageRenderServiceAboutContentView.h"
#import "DeckImageRenderServiceAboutContentConfiguration.h"
#import "InsetsLabel.h"
#import <StoneNamuCore/StoneNamuCore.h>
#import "NSNumber+stringWithSepearatedDecimalNumber.h"
#import <StoneNamuResources/StoneNamuResources.h>

@interface DeckImageRenderServiceAboutContentView ()
@property (readonly, nonatomic) NSString * _Nullable hsYearCurrent;
@property (readonly, nonatomic) NSNumber * _Nullable totalArcaneDust;
@property (retain) InsetsLabel *deckYearLabel;
@property (retain) UIStackView *arcaneDustStackView;
@property (retain) InsetsLabel *arcaneDustLabel;
@property (retain) UIImageView *arcaneDustImageView;
@end

@implementation DeckImageRenderServiceAboutContentView

@synthesize configuration;

- (instancetype)init {
    self = [super init];
    
    if (self) {
        [self setAttributes];
        [self configureDeckYearLabel];
        [self configureArcaneDustStackView];
        [self configureArcaneDustLabel];
        [self configureArcaneDustImageView];
    }
    
    return self;
}

- (void)dealloc {
    [configuration release];
    [_deckYearLabel release];
    [_arcaneDustStackView release];
    [_arcaneDustLabel release];
    [_arcaneDustImageView release];
    [super dealloc];
}

- (void)setAttributes {
    self.backgroundColor = UIColor.clearColor;
}

- (void)configureDeckYearLabel {
    InsetsLabel *deckYearLabel = [InsetsLabel new];
    
    deckYearLabel.contentInsets = UIEdgeInsetsMake(10, 10, 10, 10);
    deckYearLabel.font = [ResourcesService fontForKey:FontKeyGmarketSansTTFMedium size:18.0f];
    deckYearLabel.backgroundColor = UIColor.clearColor;
    deckYearLabel.textColor = UIColor.whiteColor;
    
    deckYearLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:deckYearLabel];
    
    [NSLayoutConstraint activateConstraints:@[
        [deckYearLabel.topAnchor constraintEqualToAnchor:self.topAnchor],
        [deckYearLabel.leadingAnchor constraintEqualToAnchor:self.leadingAnchor]
    ]];
    
    NSLayoutConstraint *bottomLayout = [deckYearLabel.bottomAnchor constraintEqualToAnchor:self.bottomAnchor];
    bottomLayout.priority = UILayoutPriorityDefaultHigh;
    bottomLayout.active = YES;
    
    [deckYearLabel setContentCompressionResistancePriority:UILayoutPriorityDefaultHigh forAxis:UILayoutConstraintAxisHorizontal];
    
    self.deckYearLabel = deckYearLabel;
    [deckYearLabel release];
}

- (void)configureArcaneDustStackView {
    UIStackView *arcaneDustStackView = [UIStackView new];
    
    arcaneDustStackView.axis = UILayoutConstraintAxisHorizontal;
    arcaneDustStackView.backgroundColor = UIColor.clearColor;
    arcaneDustStackView.distribution = UIStackViewDistributionFill;
    
    arcaneDustStackView.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:arcaneDustStackView];
    
    //
    
    [NSLayoutConstraint activateConstraints:@[
        [arcaneDustStackView.centerYAnchor constraintEqualToAnchor:self.centerYAnchor],
        [arcaneDustStackView.trailingAnchor constraintEqualToAnchor:self.trailingAnchor]
    ]];
    
    NSLayoutConstraint *leadingLayout = [arcaneDustStackView.leadingAnchor constraintGreaterThanOrEqualToAnchor:self.deckYearLabel.trailingAnchor];
    leadingLayout.priority = UILayoutPriorityDefaultHigh;
    leadingLayout.active = YES;
    
    //
    
    [arcaneDustStackView setContentCompressionResistancePriority:UILayoutPriorityDefaultLow forAxis:UILayoutConstraintAxisHorizontal];
    
    self.arcaneDustStackView = arcaneDustStackView;
    [arcaneDustStackView release];
}

- (void)configureArcaneDustLabel {
    InsetsLabel *arcaneDustLabel = [InsetsLabel new];
    
    arcaneDustLabel.contentInsets = UIEdgeInsetsMake(0, 0, 0, 10);
    arcaneDustLabel.font = [ResourcesService fontForKey:FontKeyGmarketSansTTFMedium size:18.0f];
    arcaneDustLabel.backgroundColor = UIColor.clearColor;
    arcaneDustLabel.textColor = UIColor.whiteColor;
    
    [self.arcaneDustStackView addArrangedSubview:arcaneDustLabel];
    
    [arcaneDustLabel setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    [arcaneDustLabel setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
    
    self.arcaneDustLabel = arcaneDustLabel;
    [arcaneDustLabel release];
}

- (void)configureArcaneDustImageView {
    UIImageView *arcaneDustImageView = [UIImageView new];
    
    arcaneDustImageView.backgroundColor = UIColor.clearColor;
    arcaneDustImageView.tintColor = UIColor.cyanColor;
    arcaneDustImageView.contentMode = UIViewContentModeScaleToFill;
    arcaneDustImageView.image = [ResourcesService imageForKey:ImageKeyChemistry];
    
    [self.arcaneDustStackView insertArrangedSubview:arcaneDustImageView atIndex:0];
    
    NSLayoutConstraint *aspectRatio = [NSLayoutConstraint constraintWithItem:arcaneDustImageView
                                                                   attribute:NSLayoutAttributeWidth
                                                                   relatedBy:NSLayoutRelationEqual
                                                                      toItem:arcaneDustImageView
                                                                   attribute:NSLayoutAttributeHeight
                                                                  multiplier:1
                                                                    constant:0];
    
    [NSLayoutConstraint activateConstraints:@[
        aspectRatio,
        [arcaneDustImageView.heightAnchor constraintEqualToAnchor:self.arcaneDustLabel.heightAnchor]
    ]];
    
    [arcaneDustImageView setContentHuggingPriority:UILayoutPriorityDefaultHigh forAxis:UILayoutConstraintAxisHorizontal];
    [arcaneDustImageView setContentHuggingPriority:UILayoutPriorityDefaultHigh forAxis:UILayoutConstraintAxisVertical];
    
    self.arcaneDustImageView = arcaneDustImageView;
    [arcaneDustImageView release];
}

//

- (void)setConfiguration:(id<UIContentConfiguration>)configuration {
    [self->configuration release];
    DeckImageRenderServiceAboutContentConfiguration *newConfiguration = [(DeckImageRenderServiceAboutContentConfiguration *)configuration copy];
    self->configuration = newConfiguration;
    
    [self updateDeckYearLabel];
    [self updateArcaneDustLabel];
}

- (void)updateDeckYearLabel {
    self.deckYearLabel.text = [ResourcesService localizationForHSYear:self.hsYearCurrent];
}

- (void)updateArcaneDustLabel {
    self.arcaneDustLabel.text = self.totalArcaneDust.stringWithSepearatedDecimalNumber;
}

- (NSString *)hsYearCurrent {
    DeckImageRenderServiceAboutContentConfiguration *configuration = (DeckImageRenderServiceAboutContentConfiguration *)self.configuration;
    
    if (![configuration isKindOfClass:[DeckImageRenderServiceAboutContentConfiguration class]]) {
        return nil;
    }
    
    return configuration.hsYearCurrent;
}

- (NSNumber *)totalArcaneDust {
    DeckImageRenderServiceAboutContentConfiguration *configuration = (DeckImageRenderServiceAboutContentConfiguration *)self.configuration;
    
    if (![configuration isKindOfClass:[DeckImageRenderServiceAboutContentConfiguration class]]) {
        return nil;
    }
    
    return configuration.totalArcaneDust;
}

@end
