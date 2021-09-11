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
#import "HSDeckFormat.h"
#import "HSYear.h"

@interface DeckImageRenderServiceIntroContentView ()
@property (retain) UIImageView *heroImageView;
@property (retain) UIStackView *primaryStackView;
@property (retain) UIStackView *secondaryStackView;
@property (retain) UIStackView *arcaneDustStackView;
@property (retain) InsetsLabel *arcaneDustLabel;
@property (retain) UIImageView *arcaneDustImageView;
@property (retain) InsetsLabel *nameLabel;
@property (retain) InsetsLabel *yearsLabel;
@property (retain) InsetsLabel *deckFormatLabel;
@end

@implementation DeckImageRenderServiceIntroContentView

@synthesize configuration;

- (instancetype)init {
    self = [super init];
    
    if (self) {
        [self setAttributes];
        [self configureHeroImageView];
        [self configureSecondaryStackView];
        [self configurePrimaryStackView];
        [self configureArcaneDustStackView];
        [self configureArcaneDustImageView];
        [self configureArcaneDustLabel];
        [self configureNameLabel];
        [self configureYearsLabel];
        [self configureDeckFormatLabel];
    }
    
    return self;
}

- (void)dealloc {
    [configuration release];
    [_heroImageView release];
    [_primaryStackView release];
    [_secondaryStackView release];
    [_arcaneDustStackView release];
    [_arcaneDustLabel release];
    [_arcaneDustImageView release];
    [_nameLabel release];
    [_yearsLabel release];
    [_deckFormatLabel release];
    [super dealloc];
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
    
    [heroImageView release];
}

- (void)configureSecondaryStackView {
    UIStackView *secondaryStackView = [UIStackView new];
    self.secondaryStackView = secondaryStackView;
    
    secondaryStackView.axis = UILayoutConstraintAxisHorizontal;
    secondaryStackView.backgroundColor = [UIColor.blackColor colorWithAlphaComponent:0.7];
    secondaryStackView.translatesAutoresizingMaskIntoConstraints = NO;
    
    [self addSubview:secondaryStackView];
    
    [NSLayoutConstraint activateConstraints:@[
        [secondaryStackView.leadingAnchor constraintEqualToAnchor:self.leadingAnchor],
        [secondaryStackView.trailingAnchor constraintEqualToAnchor:self.trailingAnchor],
        [secondaryStackView.bottomAnchor constraintEqualToAnchor:self.bottomAnchor]
    ]];
    
    [secondaryStackView release];
}

- (void)configurePrimaryStackView {
    UIStackView *primaryStackView = [UIStackView new];
    self.primaryStackView = primaryStackView;
    
    primaryStackView.axis = UILayoutConstraintAxisVertical;
    primaryStackView.alignment = UIStackViewAlignmentLeading;
    primaryStackView.backgroundColor = [UIColor.blackColor colorWithAlphaComponent:0.7];
    primaryStackView.translatesAutoresizingMaskIntoConstraints = NO;
    
    [self addSubview:primaryStackView];
    
    [NSLayoutConstraint activateConstraints:@[
        [primaryStackView.leadingAnchor constraintEqualToAnchor:self.secondaryStackView.leadingAnchor],
        [primaryStackView.bottomAnchor constraintEqualToAnchor:self.secondaryStackView.topAnchor]
    ]];
    
    [primaryStackView release];
}

- (void)configureArcaneDustStackView {
    UIStackView *arcaneDustStackView = [UIStackView new];
    self.arcaneDustStackView = arcaneDustStackView;
    
    arcaneDustStackView.axis = UILayoutConstraintAxisHorizontal;
    arcaneDustStackView.backgroundColor = UIColor.clearColor;
    arcaneDustStackView.translatesAutoresizingMaskIntoConstraints = NO;
    
    [self.primaryStackView addArrangedSubview:arcaneDustStackView];
    
    [arcaneDustStackView release];
}

- (void)configureArcaneDustImageView {
    UIImageView *arcaneDustImageView = [UIImageView new];
    self.arcaneDustImageView = arcaneDustImageView;
    
    arcaneDustImageView.backgroundColor = UIColor.clearColor;
    arcaneDustImageView.tintColor = UIColor.cyanColor;
    arcaneDustImageView.image = [UIImage systemImageNamed:@"testtube.2"];
    
    [self.arcaneDustStackView addArrangedSubview:arcaneDustImageView];
    
    NSLayoutConstraint *aspectRatio = [NSLayoutConstraint constraintWithItem:arcaneDustImageView
                                                                   attribute:NSLayoutAttributeWidth
                                                                   relatedBy:NSLayoutRelationEqual
                                                                      toItem:arcaneDustImageView
                                                                   attribute:NSLayoutAttributeHeight
                                                                  multiplier:1
                                                                    constant:0];
    aspectRatio.active = YES;
    
    [arcaneDustImageView setContentCompressionResistancePriority:UILayoutPriorityDefaultLow forAxis:UILayoutConstraintAxisHorizontal];
    [arcaneDustImageView setContentCompressionResistancePriority:UILayoutPriorityDefaultLow forAxis:UILayoutConstraintAxisVertical];
    
    [arcaneDustImageView release];
}

- (void)configureArcaneDustLabel {
    InsetsLabel *arcaneDustLabel = [InsetsLabel new];
    self.arcaneDustLabel = arcaneDustLabel;
    
    arcaneDustLabel.contentInsets = UIEdgeInsetsMake(5, 5, 5, 5);
    arcaneDustLabel.font = [UIFont systemFontOfSize:14 weight:UIFontWeightRegular];
    arcaneDustLabel.backgroundColor = UIColor.clearColor;
    arcaneDustLabel.textColor = UIColor.whiteColor;
    
    [self.arcaneDustStackView addArrangedSubview:arcaneDustLabel];
    
    NSLayoutConstraint *heightLayout = [arcaneDustLabel.heightAnchor constraintEqualToAnchor:self.arcaneDustImageView.heightAnchor];
    heightLayout.active = YES;
    
    [arcaneDustLabel setContentCompressionResistancePriority:UILayoutPriorityDefaultHigh forAxis:UILayoutConstraintAxisHorizontal];
    [arcaneDustLabel setContentCompressionResistancePriority:UILayoutPriorityDefaultHigh forAxis:UILayoutConstraintAxisVertical];
    
    [arcaneDustLabel release];
}

- (void)configureNameLabel {
    InsetsLabel *nameLabel = [InsetsLabel new];
    self.nameLabel = nameLabel;
    
    nameLabel.contentInsets = UIEdgeInsetsMake(0, 10, 0, 10);
    nameLabel.font = [UIFont systemFontOfSize:20 weight:UIFontWeightBold];
    nameLabel.backgroundColor = UIColor.clearColor;
    nameLabel.textColor = UIColor.whiteColor;
    
    [self.primaryStackView addArrangedSubview:nameLabel];
    
    [nameLabel release];
}

- (void)configureYearsLabel {
    InsetsLabel *yearsLabel = [InsetsLabel new];
    self.yearsLabel = yearsLabel;
    
    yearsLabel.contentInsets = UIEdgeInsetsMake(10, 10, 10, 10);
    yearsLabel.font = [UIFont systemFontOfSize:18 weight:UIFontWeightRegular];
    yearsLabel.backgroundColor = UIColor.clearColor;
    yearsLabel.textColor = UIColor.whiteColor;
    yearsLabel.textAlignment = NSTextAlignmentLeft;
    
    [self.secondaryStackView addArrangedSubview:yearsLabel];
    [yearsLabel setContentCompressionResistancePriority:UILayoutPriorityDefaultLow forAxis:UILayoutConstraintAxisHorizontal];
    
    [yearsLabel release];
}

- (void)configureDeckFormatLabel {
    InsetsLabel *deckFormatLabel = [InsetsLabel new];
    self.deckFormatLabel = deckFormatLabel;
    
    deckFormatLabel.contentInsets = UIEdgeInsetsMake(10, 10, 10, 10);
    deckFormatLabel.font = [UIFont systemFontOfSize:18 weight:UIFontWeightBold];
    deckFormatLabel.backgroundColor = UIColor.clearColor;
    deckFormatLabel.textColor = UIColor.whiteColor;
    deckFormatLabel.textAlignment = NSTextAlignmentRight;
    
    [self.secondaryStackView addArrangedSubview:deckFormatLabel];
    [deckFormatLabel setContentCompressionResistancePriority:UILayoutPriorityDefaultHigh forAxis:UILayoutConstraintAxisHorizontal];
    
    [deckFormatLabel release];
}

//

- (void)setConfiguration:(id<UIContentConfiguration>)configuration {
    [self->configuration release];
    DeckImageRenderServiceIntroContentConfiguration *newConfiguration = [(DeckImageRenderServiceIntroContentConfiguration *)configuration copy];
    self->configuration = newConfiguration;
    
    //
    
    self.heroImageView.image = [ImageService.sharedInstance portraitImageOfClassId:newConfiguration.classId];
    self.nameLabel.text = newConfiguration.deckName;
    self.arcaneDustLabel.text = newConfiguration.totalArcaneDust.stringValue;
    self.yearsLabel.text = hsYearsWithLocalizables()[newConfiguration.hsYearCurrent];
    self.deckFormatLabel.text = hsDeckFormatsWithLocalizable()[newConfiguration.deckFormat];
}

@end
