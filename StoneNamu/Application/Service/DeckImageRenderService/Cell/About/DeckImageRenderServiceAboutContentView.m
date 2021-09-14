//
//  DeckImageRenderServiceAboutContentView.m
//  DeckImageRenderServiceAboutContentView
//
//  Created by Jinwoo Kim on 9/15/21.
//

#import "DeckImageRenderServiceAboutContentView.h"
#import "DeckImageRenderServiceAboutContentConfiguration.h"
#import "InsetsLabel.h"
#import "HSYear.h"
#import "UIFont+customFonts.h"
#import "NSNumber+stringWithSepearatedDecimalNumber.h"

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
        [self configureArcaneDustImageView];
        [self configureArcaneDustLabel];
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
    self.deckYearLabel = deckYearLabel;
    
    deckYearLabel.contentInsets = UIEdgeInsetsMake(10, 10, 10, 10);
    deckYearLabel.font = [UIFont customFontWithType:UIFontCustomFontTypeGmarketSansMedium size:18];
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
    
    [deckYearLabel release];
}

- (void)configureArcaneDustStackView {
    UIStackView *arcaneDustStackView = [UIStackView new];
    self.arcaneDustStackView = arcaneDustStackView;
    
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
    
    [arcaneDustStackView release];
}

- (void)configureArcaneDustImageView {
    UIImageView *arcaneDustImageView = [UIImageView new];
    self.arcaneDustImageView = arcaneDustImageView;
    
    arcaneDustImageView.backgroundColor = UIColor.clearColor;
    arcaneDustImageView.tintColor = UIColor.cyanColor;
    arcaneDustImageView.contentMode = UIViewContentModeScaleToFill;
    arcaneDustImageView.image = [UIImage imageNamed:@"chemistry"];
    
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
    
    arcaneDustLabel.font = [UIFont customFontWithType:UIFontCustomFontTypeGmarketSansMedium size:18];
    arcaneDustLabel.backgroundColor = UIColor.clearColor;
    arcaneDustLabel.textColor = UIColor.whiteColor;
    
    [self.arcaneDustStackView addArrangedSubview:arcaneDustLabel];
    
    CGRect rect = [@"9" boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX)
                                     options:NSStringDrawingUsesLineFragmentOrigin
                                  attributes:@{NSFontAttributeName: arcaneDustLabel.font}
                                     context:nil];
    
    [NSLayoutConstraint activateConstraints:@[
        [arcaneDustLabel.heightAnchor constraintEqualToAnchor:self.arcaneDustImageView.heightAnchor],
        [arcaneDustLabel.heightAnchor constraintEqualToConstant:ceil(rect.size.height)]
    ]];
    
    [arcaneDustLabel setContentCompressionResistancePriority:UILayoutPriorityDefaultHigh forAxis:UILayoutConstraintAxisHorizontal];
    [arcaneDustLabel setContentCompressionResistancePriority:UILayoutPriorityDefaultHigh forAxis:UILayoutConstraintAxisVertical];
    
    [arcaneDustLabel release];
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
    self.deckYearLabel.text = hsYearsWithLocalizables()[self.hsYearCurrent];
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
