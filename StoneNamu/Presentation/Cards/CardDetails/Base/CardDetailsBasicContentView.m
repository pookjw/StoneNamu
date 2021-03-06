//
//  CardDetailsBasicContentView.m
//  CardDetailsBasicContentView
//
//  Created by Jinwoo Kim on 8/6/21.
//

#import "CardDetailsBasicContentView.h"
#import "CardDetailsBasicContentConfiguration.h"
#import "InsetsLabel.h"
#import <StoneNamuResources/StoneNamuResources.h>

@interface CardDetailsBasicContentView ()
@property (retain) UIVisualEffectView *visualEffectView;
@property (retain) UIVisualEffectView *vibrancyView;
@property (retain) InsetsLabel *leadingLabel;
@property (retain) InsetsLabel *trailingLabel;
@end

@implementation CardDetailsBasicContentView

@synthesize configuration;

- (instancetype)init {
    self = [super init];
    
    if (self) {
        [self configureVisualEffectView];
        [self configureVibrancyView];
        [self configureLabels];
    }
    
    return self;
}

- (void)dealloc {
    [configuration release];
    [_visualEffectView release];
    [_vibrancyView release];
    [_leadingLabel release];
    [_trailingLabel release];
    [super dealloc];
}

- (void)configureVisualEffectView {
    UIVisualEffectView *visualEffectView = [[UIVisualEffectView alloc] initWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleLight]];
    
    visualEffectView.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:visualEffectView];
    
    NSLayoutConstraint *bottomLayout = [visualEffectView.bottomAnchor constraintEqualToAnchor:self.bottomAnchor];
    bottomLayout.priority = UILayoutPriorityDefaultHigh;
    
    [NSLayoutConstraint activateConstraints:@[
        [visualEffectView.topAnchor constraintEqualToAnchor:self.topAnchor],
        [visualEffectView.trailingAnchor constraintEqualToAnchor:self.trailingAnchor],
        [visualEffectView.leadingAnchor constraintEqualToAnchor:self.leadingAnchor],
        bottomLayout
    ]];
    
    self.visualEffectView = visualEffectView;
    [visualEffectView release];
}

- (void)configureVibrancyView {
    UIVibrancyEffect *effect = [UIVibrancyEffect effectForBlurEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleDark]];
    UIVisualEffectView *vibrancyView = [[UIVisualEffectView alloc] initWithEffect:effect];
    
    vibrancyView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.visualEffectView.contentView addSubview:vibrancyView];
    [NSLayoutConstraint activateConstraints:@[
        [vibrancyView.topAnchor constraintEqualToAnchor:self.visualEffectView.contentView.topAnchor],
        [vibrancyView.trailingAnchor constraintEqualToAnchor:self.visualEffectView.contentView.trailingAnchor],
        [vibrancyView.leadingAnchor constraintEqualToAnchor:self.visualEffectView.contentView.leadingAnchor],
        [vibrancyView.bottomAnchor constraintEqualToAnchor:self.visualEffectView.contentView.bottomAnchor]
    ]];
    
    self.vibrancyView = vibrancyView;
    [vibrancyView release];
}

- (void)configureLabels {
    CGFloat margin = 15;
    
    InsetsLabel *leadingLabel = [InsetsLabel new];
    
    [self.vibrancyView.contentView addSubview:leadingLabel];
    
    leadingLabel.contentInsets = UIEdgeInsetsMake(margin, margin, margin, 0);
    
    leadingLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [NSLayoutConstraint activateConstraints:@[
        [leadingLabel.leadingAnchor constraintEqualToAnchor:self.vibrancyView.contentView.leadingAnchor],
        [leadingLabel.centerYAnchor constraintEqualToAnchor:self.vibrancyView.contentView.centerYAnchor]
    ]];
    
    leadingLabel.numberOfLines = 0;
    leadingLabel.adjustsFontForContentSizeCategory = YES;
    leadingLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleHeadline];
    leadingLabel.textAlignment = NSTextAlignmentLeft;
    
    //
    
    InsetsLabel *trailingLabel = [InsetsLabel new];
    
    [self.vibrancyView.contentView addSubview:trailingLabel];
    
    trailingLabel.contentInsets = UIEdgeInsetsMake(margin, 0, margin, margin);
    
    trailingLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [NSLayoutConstraint activateConstraints:@[
        [trailingLabel.topAnchor constraintEqualToAnchor:self.vibrancyView.contentView.topAnchor],
        [trailingLabel.trailingAnchor constraintEqualToAnchor:self.vibrancyView.contentView.trailingAnchor],
        [trailingLabel.bottomAnchor constraintEqualToAnchor:self.vibrancyView.contentView.bottomAnchor]
    ]];
    
    trailingLabel.numberOfLines = 0;
    trailingLabel.adjustsFontForContentSizeCategory = YES;
    trailingLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
    trailingLabel.textAlignment = NSTextAlignmentRight;
    
    //
    
    NSLayoutConstraint *betweenConstraint = [NSLayoutConstraint constraintWithItem:leadingLabel
                                                                         attribute:NSLayoutAttributeTrailing
                                                                         relatedBy:NSLayoutRelationLessThanOrEqual
                                                                            toItem:trailingLabel
                                                                         attribute:NSLayoutAttributeLeading
                                                                        multiplier:1
                                                                          constant:-margin];
    betweenConstraint.active = YES;
    
    [leadingLabel setContentHuggingPriority:UILayoutPriorityDefaultHigh forAxis:UILayoutConstraintAxisHorizontal];
    [trailingLabel setContentHuggingPriority:UILayoutPriorityDefaultLow forAxis:UILayoutConstraintAxisHorizontal];
    
    [leadingLabel setContentCompressionResistancePriority:UILayoutPriorityDefaultHigh forAxis:UILayoutConstraintAxisHorizontal];
    [trailingLabel setContentCompressionResistancePriority:UILayoutPriorityDefaultLow forAxis:UILayoutConstraintAxisHorizontal];
    
    //
    
    self.leadingLabel = leadingLabel;
    self.trailingLabel = trailingLabel;
    [leadingLabel release];
    [trailingLabel release];
}

- (void)setConfiguration:(id<UIContentConfiguration>)configuration {
    [self->configuration release];
    CardDetailsBasicContentConfiguration *content = (CardDetailsBasicContentConfiguration *)configuration;
    self->configuration = [content copy];
    
    [NSOperationQueue.mainQueue addOperationWithBlock:^{
        NSString * _Nullable leadingText = content.text;
        if ((leadingText == nil) || ([leadingText isEqualToString:@""])) {
            self.leadingLabel.text = [ResourcesService localizationForKey:LocalizableKeyEmpty];
        } else {
            self.leadingLabel.text = leadingText;
        }
        
        NSString * _Nullable trailingText = content.secondaryText;
        
        if ((trailingText == nil) || ([trailingText isEqualToString:@""])) {
            self.trailingLabel.text = [ResourcesService localizationForKey:LocalizableKeyEmpty];
        } else {
            self.trailingLabel.text = trailingText;
        }
        
        [self invalidateIntrinsicContentSize];
    }];
}

@end
