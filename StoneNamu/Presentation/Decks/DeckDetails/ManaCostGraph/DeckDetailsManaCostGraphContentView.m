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
@property (class, readonly, nonatomic) UIFont *labelFont;
@property (class, readonly, nonatomic) UIEdgeInsets labelInsets;
@property (retain) InsetsLabel *costLabel;
@property (retain) UIProgressView *progressView;
@property (retain) InsetsLabel *countLabel;
@property (readonly, nonatomic) NSUInteger cardManaCost;
@property (readonly, nonatomic) float percentage;
@property (readonly, nonatomic) NSUInteger cardCount;
@property (readonly, nonatomic) BOOL isDarkMode;
@end

@implementation DeckDetailsManaCostGraphContentView

@synthesize configuration;

+ (CGRect)preferredLabelRect {
    NSString *string = @"99+";
    
    CGRect rect = [string boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX)
                                       options:NSStringDrawingUsesLineFragmentOrigin
                                    attributes:@{NSFontAttributeName: DeckDetailsManaCostGraphContentView.labelFont}
                                       context:nil];
    
    UIEdgeInsets costLabelInsets = DeckDetailsManaCostGraphContentView.labelInsets;
    
    rect.size.height += (costLabelInsets.top + costLabelInsets.bottom);
    rect.size.width += (costLabelInsets.left + costLabelInsets.right);
    
    return rect;
}

+ (UIFont *)labelFont {
    return [UIFont preferredFontForTextStyle:UIFontTextStyleCaption1];
}

+ (UIEdgeInsets)labelInsets {
    return UIEdgeInsetsMake(5, 5, 5, 5);
}

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
    [_progressView release];
    [_countLabel release];
    [super dealloc];
}

- (void)setAttributes {
    self.backgroundColor = nil;
}

- (void)configureCostLabel {
    InsetsLabel *costLabel = [InsetsLabel new];
    self.costLabel = costLabel;
    
    costLabel.textAlignment = NSTextAlignmentCenter;
    costLabel.font = DeckDetailsManaCostGraphContentView.labelFont;
    costLabel.contentInsets = DeckDetailsManaCostGraphContentView.labelInsets;
    costLabel.backgroundColor = UIColor.systemBlueColor;
    costLabel.textColor = UIColor.whiteColor;
    
    [self addSubview:costLabel];
    
    costLabel.translatesAutoresizingMaskIntoConstraints = NO;
    
    CGRect preferredRect = DeckDetailsManaCostGraphContentView.preferredLabelRect;
    
    [NSLayoutConstraint activateConstraints:@[
        [costLabel.topAnchor constraintEqualToAnchor:self.topAnchor],
        [costLabel.leadingAnchor constraintEqualToAnchor:self.leadingAnchor],
        [costLabel.widthAnchor constraintEqualToConstant:ceilf(preferredRect.size.width)],
        [costLabel.heightAnchor constraintEqualToConstant:ceilf(preferredRect.size.height)]
    ]];
    
    NSLayoutConstraint *bottomLayout = [costLabel.bottomAnchor constraintEqualToAnchor:self.bottomAnchor];
    bottomLayout.priority = UILayoutPriorityDefaultHigh;
    bottomLayout.active = YES;
    
    [costLabel release];
}

- (void)configureProgressView {
    UIProgressView *progressView = [UIProgressView new];
    self.progressView = progressView;
    
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
    
    [progressView release];
}

- (void)configureCountLabel {
    InsetsLabel *countLabel = [InsetsLabel new];
    self.countLabel = countLabel;
    
    countLabel.textAlignment = NSTextAlignmentCenter;
    countLabel.font = DeckDetailsManaCostGraphContentView.labelFont;
    countLabel.contentInsets = DeckDetailsManaCostGraphContentView.labelInsets;
    countLabel.textColor = UIColor.whiteColor;
    
    [self addSubview:countLabel];
    
    countLabel.translatesAutoresizingMaskIntoConstraints = NO;
    
    CGRect preferredRect = DeckDetailsManaCostGraphContentView.preferredLabelRect;
    
    [NSLayoutConstraint activateConstraints:@[
        [countLabel.topAnchor constraintEqualToAnchor:self.progressView.topAnchor],
        [countLabel.leadingAnchor constraintEqualToAnchor:self.progressView.trailingAnchor],
        [countLabel.trailingAnchor constraintEqualToAnchor:self.trailingAnchor],
        [countLabel.bottomAnchor constraintEqualToAnchor:self.progressView.bottomAnchor],
        [countLabel.widthAnchor constraintEqualToConstant:ceilf(preferredRect.size.width)],
        [countLabel.heightAnchor constraintEqualToConstant:ceilf(preferredRect.size.height)]
    ]];
    
    [countLabel release];
}

- (void)setConfiguration:(id<UIContentConfiguration>)configuration {
    DeckDetailsManaCostGraphContentConfiguration *oldContentConfig = (DeckDetailsManaCostGraphContentConfiguration *)self.configuration;
    DeckDetailsManaCostGraphContentConfiguration *newContentConfig = [(DeckDetailsManaCostGraphContentConfiguration *)configuration copy];
    self->configuration = newContentConfig;
    
    if ((oldContentConfig == nil) || (newContentConfig.cardManaCost != oldContentConfig.cardManaCost)) {
        [self updateCostLabel];
    }
    
    [self updateProgressLabel];
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
}

@end
