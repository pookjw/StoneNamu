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

@interface DeckImageRenderServiceIntroContentView ()
@property (retain) UIImageView *heroImageView;
@property (retain) UIStackView *primaryStackView;
@property (retain) UIStackView *arcaneDustStackView;
@property (retain) InsetsLabel *arcaneDustLabel;
@property (retain) UIImageView *arcaneDustImageView;
@property (retain) InsetsLabel *nameLabel;
@end

@implementation DeckImageRenderServiceIntroContentView

@synthesize configuration;

- (instancetype)init {
    self = [super init];
    
    if (self) {
        [self setAttributes];
        [self configureHeroImageView];
        [self configurePrimaryStackView];
        [self configureArcaneDustStackView];
        [self configureArcaneDustImageView];
        [self configureArcaneDustLabel];
        [self configureNameLabel];
    }
    
    return self;
}

- (void)dealloc {
    [configuration release];
    [_heroImageView release];
    [_primaryStackView release];
    [_arcaneDustStackView release];
    [_arcaneDustLabel release];
    [_arcaneDustImageView release];
    [_nameLabel release];
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

- (void)configurePrimaryStackView {
    UIStackView *primaryStackView = [UIStackView new];
    self.primaryStackView = primaryStackView;
    
    primaryStackView.axis = UILayoutConstraintAxisVertical;
    primaryStackView.backgroundColor = [UIColor.blackColor colorWithAlphaComponent:0.4];
    primaryStackView.translatesAutoresizingMaskIntoConstraints = NO;
    
    [self addSubview:primaryStackView];
    
    [NSLayoutConstraint activateConstraints:@[
        [primaryStackView.leadingAnchor constraintEqualToAnchor:self.heroImageView.leadingAnchor],
        [primaryStackView.bottomAnchor constraintEqualToAnchor:self.heroImageView.bottomAnchor]
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
    
    nameLabel.backgroundColor = UIColor.clearColor;
    nameLabel.textColor = UIColor.whiteColor;
    
    [self.primaryStackView addArrangedSubview:nameLabel];
    
    [nameLabel release];
}

- (void)setConfiguration:(id<UIContentConfiguration>)configuration {
    [self->configuration release];
    DeckImageRenderServiceIntroContentConfiguration *newConfiguration = [(DeckImageRenderServiceIntroContentConfiguration *)configuration copy];
    self->configuration = newConfiguration;
    
    //
    
    self.heroImageView.image = [ImageService.sharedInstance portraitImageOfClassId:newConfiguration.classId];
    self.nameLabel.text = newConfiguration.deckName;
    self.arcaneDustLabel.text = newConfiguration.totalArcaneDust.stringValue;
}

@end
