//
//  CardDetailsBasicContentView.m
//  CardDetailsBasicContentView
//
//  Created by Jinwoo Kim on 8/6/21.
//

#import "CardDetailsBasicContentView.h"
#import "CardDetailsBasicContentConfiguration.h"
#import "NSString+clearedHTML.h"
#import "InsetsLabel.h"

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
    self.visualEffectView = visualEffectView;
    
    visualEffectView.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:visualEffectView];
    [NSLayoutConstraint activateConstraints:@[
        [visualEffectView.topAnchor constraintEqualToAnchor:self.topAnchor],
        [visualEffectView.trailingAnchor constraintEqualToAnchor:self.trailingAnchor],
        [visualEffectView.leadingAnchor constraintEqualToAnchor:self.leadingAnchor]
    ]];
    
    NSLayoutConstraint *bottomLayout = [visualEffectView.bottomAnchor constraintEqualToAnchor:self.bottomAnchor];
    bottomLayout.priority = UILayoutPriorityDefaultHigh;
    bottomLayout.active = YES;
    
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
    
    InsetsLabel *leadingLabel = [InsetsLabel new];
    self.leadingLabel = leadingLabel;
    
    [self.vibrancyView.contentView addSubview:leadingLabel];
    
    leadingLabel.contentInsets = UIEdgeInsetsMake(margin, margin, margin, 0);
    
    leadingLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [NSLayoutConstraint activateConstraints:@[
        [leadingLabel.topAnchor constraintEqualToAnchor:self.vibrancyView.contentView.topAnchor],
        [leadingLabel.leadingAnchor constraintEqualToAnchor:self.vibrancyView.contentView.leadingAnchor],
        [leadingLabel.bottomAnchor constraintEqualToAnchor:self.vibrancyView.contentView.bottomAnchor]
    ]];
    
    leadingLabel.numberOfLines = 0;
    leadingLabel.adjustsFontForContentSizeCategory = YES;
    leadingLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleHeadline];
    leadingLabel.textAlignment = NSTextAlignmentLeft;
    
    //
    
    InsetsLabel *trailingLabel = [InsetsLabel new];
    self.trailingLabel = trailingLabel;
    
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
    
    [leadingLabel setContentCompressionResistancePriority:UILayoutPriorityDefaultHigh forAxis:UILayoutConstraintAxisHorizontal];
    [trailingLabel setContentCompressionResistancePriority:UILayoutPriorityDefaultLow forAxis:UILayoutConstraintAxisHorizontal];
    
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
        
        [self invalidateIntrinsicContentSize];
    }];
}

@end
