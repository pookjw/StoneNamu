//
//  DeckDetailsManaCostGraphContentView.m
//  DeckDetailsManaCostGraphContentView
//
//  Created by Jinwoo Kim on 8/26/21.
//

#import "DeckDetailsManaCostGraphContentView.h"
#import "InsetsLabel.h"
#import "DeckDetailsManaCostGraphContentConfiguration.h"

@interface DeckDetailsManaCostGraphContentView ()
@property (retain) InsetsLabel *costLabel;
@property (retain) NSLayoutConstraint *costLabelWidthLayout;
@property (retain) UIProgressView *progressView;
@property (retain) InsetsLabel *countLabel;
@property (retain) NSLayoutConstraint *countLabelWidthLayout;
@property (readonly, nonatomic) CGFloat preferredWidth;
@property (readonly, nonatomic) NSUInteger cardManaCost;
@property (readonly, nonatomic) float percentage;
@property (readonly, nonatomic) NSUInteger cardCount;
@property (readonly, nonatomic) BOOL isDarkMode;
@end

@implementation DeckDetailsManaCostGraphContentView

@synthesize configuration;

- (instancetype)init {
    self = [super init];
    
    if (self) {
        [self setAttributes];
        [self configureCostLabel];
        [self configureProgressView];
        [self configureCountLabel];
    }
    
    return self;
}

- (void)dealloc {
    [configuration release];
    [_costLabel release];
    [_costLabelWidthLayout release];
    [_progressView release];
    [_countLabel release];
    [_countLabelWidthLayout release];
    [super dealloc];
}

- (void)setAttributes {
    self.backgroundColor = nil;
}

- (void)configureCostLabel {
    InsetsLabel *costLabel = [InsetsLabel new];
    
    costLabel.textAlignment = NSTextAlignmentCenter;
    costLabel.adjustsFontForContentSizeCategory = YES;
    costLabel.adjustsFontSizeToFitWidth = YES;
    costLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleCaption1];
    costLabel.contentInsets = UIEdgeInsetsMake(5.0f, 5.0f, 5.0f, 5.0f);
    costLabel.backgroundColor = UIColor.systemBlueColor;
    costLabel.textColor = UIColor.whiteColor;
    
    [self addSubview:costLabel];
    
    costLabel.translatesAutoresizingMaskIntoConstraints = NO;
    
    NSLayoutConstraint *costLabelWidthLayout = [costLabel.widthAnchor constraintEqualToConstant:self.preferredWidth];
    NSLayoutConstraint *bottomLayout = [costLabel.bottomAnchor constraintEqualToAnchor:self.bottomAnchor];
    bottomLayout.priority = UILayoutPriorityDefaultHigh;
    bottomLayout.active = YES;;
    
    [NSLayoutConstraint activateConstraints:@[
        [costLabel.topAnchor constraintEqualToAnchor:self.topAnchor],
        [costLabel.leadingAnchor constraintEqualToAnchor:self.leadingAnchor],
        bottomLayout,
        costLabelWidthLayout
    ]];
    
    self.costLabel = costLabel;
    self.costLabelWidthLayout = costLabelWidthLayout;
    [costLabel release];
}

- (void)configureProgressView {
    UIProgressView *progressView = [UIProgressView new];
    
    progressView.tintColor = UIColor.systemCyanColor;
    progressView.backgroundColor = UIColor.clearColor;
    progressView.trackTintColor = UIColor.clearColor;
    progressView.progressViewStyle = UIProgressViewStyleBar;
    
    [self addSubview:progressView];
    
    progressView.translatesAutoresizingMaskIntoConstraints = NO;
    [NSLayoutConstraint activateConstraints:@[
        [progressView.topAnchor constraintEqualToAnchor:self.costLabel.topAnchor],
        [progressView.leadingAnchor constraintEqualToAnchor:self.costLabel.trailingAnchor],
        [progressView.bottomAnchor constraintEqualToAnchor:self.costLabel.bottomAnchor]
    ]];
    
    self.progressView = progressView;
    [progressView release];
}

- (void)configureCountLabel {
    InsetsLabel *countLabel = [InsetsLabel new];
    
    countLabel.textAlignment = NSTextAlignmentCenter;
    countLabel.adjustsFontForContentSizeCategory = YES;
    countLabel.adjustsFontSizeToFitWidth = YES;
    countLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleCaption1];
    countLabel.contentInsets = UIEdgeInsetsMake(5.0f, 5.0f, 5.0f, 5.0f);
    countLabel.textColor = UIColor.whiteColor;
    
    [self addSubview:countLabel];
    
    countLabel.translatesAutoresizingMaskIntoConstraints = NO;
    
    NSLayoutConstraint *countLabelWidthLayout = [countLabel.widthAnchor constraintEqualToConstant:self.preferredWidth];
    
    [NSLayoutConstraint activateConstraints:@[
        [countLabel.topAnchor constraintEqualToAnchor:self.progressView.topAnchor],
        [countLabel.leadingAnchor constraintEqualToAnchor:self.progressView.trailingAnchor],
        [countLabel.trailingAnchor constraintEqualToAnchor:self.trailingAnchor],
        [countLabel.bottomAnchor constraintEqualToAnchor:self.progressView.bottomAnchor],
        countLabelWidthLayout
    ]];
    
    self.countLabel = countLabel;
    self.countLabelWidthLayout = countLabelWidthLayout;
    [countLabel release];
}

- (CGFloat)preferredWidth {
    NSString *string = @"99+";
    
    CGRect rect = [string boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX)
                                       options:NSStringDrawingUsesLineFragmentOrigin
                                    attributes:@{NSFontAttributeName: [UIFont preferredFontForTextStyle:UIFontTextStyleCaption1]}
                                       context:nil];
    CGFloat margin = 10;
    CGFloat width = ceilf(rect.size.width + margin);
    
    return width;
}

- (void)setConfiguration:(id<UIContentConfiguration>)configuration {
    DeckDetailsManaCostGraphContentConfiguration *oldContentConfig = (DeckDetailsManaCostGraphContentConfiguration *)self.configuration;
    DeckDetailsManaCostGraphContentConfiguration *newContentConfig = [(DeckDetailsManaCostGraphContentConfiguration *)configuration copy];
    self->configuration = newContentConfig;
    
    [self updateProgressLabel];
    [self updateCostLabel];
    [self updateCountLabel];
    
    [oldContentConfig release];
}

- (NSUInteger)cardManaCost {
    DeckDetailsManaCostGraphContentConfiguration *contentConfig = (DeckDetailsManaCostGraphContentConfiguration *)self.configuration;
    
    if (![contentConfig isKindOfClass:[DeckDetailsManaCostGraphContentConfiguration class]]) return 0;
    
    return contentConfig.cardManaCost;
}

- (float)percentage {
    DeckDetailsManaCostGraphContentConfiguration *contentConfig = (DeckDetailsManaCostGraphContentConfiguration *)self.configuration;
    
    if (![contentConfig isKindOfClass:[DeckDetailsManaCostGraphContentConfiguration class]]) return 0.0f;
    
    return contentConfig.percentage;
}

- (NSUInteger)cardCount {
    DeckDetailsManaCostGraphContentConfiguration *contentConfig = (DeckDetailsManaCostGraphContentConfiguration *)self.configuration;
    
    if (![contentConfig isKindOfClass:[DeckDetailsManaCostGraphContentConfiguration class]]) return 0;
    
    return contentConfig.cardCount;
}

- (BOOL)isDarkMode {
    if (![self.configuration isKindOfClass:[DeckDetailsManaCostGraphContentConfiguration class]]) {
        return NO;
    }
    
    DeckDetailsManaCostGraphContentConfiguration *contentConfiguration = (DeckDetailsManaCostGraphContentConfiguration *)self.configuration;
    return contentConfiguration.isDarkMode;
}

- (void)updateCostLabel {
    if (self.cardManaCost == 10) {
        self.costLabel.text = @"10+";
    } else {
        self.costLabel.text = [NSString stringWithFormat:@"%lu", self.cardManaCost];
    }
    
    self.costLabelWidthLayout.constant = self.preferredWidth;
}

- (void)updateProgressLabel {
    [self.progressView setProgress:self.percentage animated:NO];
}

- (void)updateCountLabel {
    if (self.isDarkMode) {
        self.countLabel.backgroundColor = UIColor.systemGray2Color;
    } else {
        self.countLabel.backgroundColor = UIColor.systemGrayColor;
    }
    
    self.countLabel.text = [NSString stringWithFormat:@"%lu", self.cardCount];
    self.countLabelWidthLayout.constant = self.preferredWidth;
}

@end
