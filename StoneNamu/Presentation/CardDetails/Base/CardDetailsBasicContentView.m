//
//  CardDetailsBasicContentView.m
//  CardDetailsBasicContentView
//
//  Created by Jinwoo Kim on 8/6/21.
//

#import "CardDetailsBasicContentView.h"
#import "CardDetailsBasicContentConfiguration.h"
#import "NSString+clearedHTML.h"

@interface CardDetailsBasicContentView ()
@property (retain) UIVisualEffectView *visualEffectView;
@property (retain) UIVisualEffectView *vibrancyView;
@property (retain) UILabel *leadingLabel;
@property (retain) UILabel *trailingLabel;
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
    self.visualEffectView = visualEffectView;
    
    visualEffectView.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:visualEffectView];
    [NSLayoutConstraint activateConstraints:@[
        [visualEffectView.topAnchor constraintEqualToAnchor:self.topAnchor],
        [visualEffectView.trailingAnchor constraintEqualToAnchor:self.trailingAnchor],
        [visualEffectView.leadingAnchor constraintEqualToAnchor:self.leadingAnchor],
        [visualEffectView.bottomAnchor constraintEqualToAnchor:self.bottomAnchor]
    ]];
    
    [visualEffectView release];
}

- (void)configureVibrancyView {
    UIVibrancyEffect *effect = [UIVibrancyEffect effectForBlurEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleDark]];
    UIVisualEffectView *vibrancyView = [[UIVisualEffectView alloc] initWithEffect:effect];
    self.vibrancyView = vibrancyView;
    
    vibrancyView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.visualEffectView.contentView addSubview:vibrancyView];
    [NSLayoutConstraint activateConstraints:@[
        [vibrancyView.topAnchor constraintEqualToAnchor:self.visualEffectView.contentView.topAnchor],
        [vibrancyView.trailingAnchor constraintEqualToAnchor:self.visualEffectView.contentView.trailingAnchor],
        [vibrancyView.leadingAnchor constraintEqualToAnchor:self.visualEffectView.contentView.leadingAnchor],
        [vibrancyView.bottomAnchor constraintEqualToAnchor:self.visualEffectView.contentView.bottomAnchor]
    ]];
    
    [vibrancyView release];
}

- (void)configureLabels {
    CGFloat margin = 15;
    
    UILabel *leadingLabel = [UILabel new];
    self.leadingLabel = leadingLabel;
    
    [self.vibrancyView.contentView addSubview:leadingLabel];
    leadingLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [NSLayoutConstraint activateConstraints:@[
        [leadingLabel.topAnchor constraintEqualToAnchor:self.vibrancyView.contentView.topAnchor constant:margin],
        [leadingLabel.leadingAnchor constraintEqualToAnchor:self.vibrancyView.contentView.leadingAnchor constant:margin],
        [leadingLabel.bottomAnchor constraintEqualToAnchor:self.vibrancyView.contentView.bottomAnchor constant:-margin]
    ]];
    
    leadingLabel.numberOfLines = 0;
    leadingLabel.adjustsFontForContentSizeCategory = YES;
    leadingLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleHeadline];
    leadingLabel.textAlignment = NSTextAlignmentLeft;
    
    //
    
    UILabel *trailingLabel = [UILabel new];
    self.trailingLabel = trailingLabel;
    
    [self.vibrancyView.contentView addSubview:trailingLabel];
    trailingLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [NSLayoutConstraint activateConstraints:@[
        [trailingLabel.topAnchor constraintEqualToAnchor:self.vibrancyView.contentView.topAnchor constant:margin],
        [trailingLabel.trailingAnchor constraintEqualToAnchor:self.vibrancyView.contentView.trailingAnchor constant:-margin],
        [trailingLabel.bottomAnchor constraintEqualToAnchor:self.vibrancyView.contentView.bottomAnchor constant:-margin]
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
    
    [leadingLabel setContentCompressionResistancePriority:750 forAxis:UILayoutConstraintAxisHorizontal];
    [trailingLabel setContentCompressionResistancePriority:749 forAxis:UILayoutConstraintAxisHorizontal];
    
    //
    
    [leadingLabel release];
    [trailingLabel release];
}

- (void)setConfiguration:(id<UIContentConfiguration>)configuration {
    [self->configuration release];
    CardDetailsBasicContentConfiguration *content = (CardDetailsBasicContentConfiguration *)configuration;
    self->configuration = [content copy];
    
    [NSOperationQueue.mainQueue addOperationWithBlock:^{
        NSString * _Nullable clearedLeadingText = content.leadingText.clearedHTML;
        if ((clearedLeadingText == nil) || ([clearedLeadingText isEqualToString:@""])) {
            self.leadingLabel.text = NSLocalizedString(@"EMPTY", @"");
        } else {
            self.leadingLabel.text = clearedLeadingText;
        }
        
        NSString * _Nullable clearedTrailingText = content.trailingText.clearedHTML;
        if ((clearedTrailingText == nil) || ([clearedTrailingText isEqualToString:@""])) {
            self.trailingLabel.text = NSLocalizedString(@"EMPTY", @"");
        } else {
            self.trailingLabel.text = clearedTrailingText;
        }
    }];
}

@end
