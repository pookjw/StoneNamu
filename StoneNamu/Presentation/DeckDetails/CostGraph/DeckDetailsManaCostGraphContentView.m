//
//  DeckDetailsManaCostGraphContentView.m
//  DeckDetailsManaCostGraphContentView
//
//  Created by Jinwoo Kim on 8/26/21.
//

#import "DeckDetailsManaCostGraphContentView.h"
#import "InsetsLabel.h"
#import "DeckDetailsManaCostGraphContentConfiguration.h"
#import "DeckDetailsManaCostContentViewModel.h"

@interface DeckDetailsManaCostGraphContentView ()
@property (class, readonly, nonatomic) UIFont *costLabelFont;
@property (class, readonly, nonatomic) UIEdgeInsets costLabelInsets;
@property (retain) InsetsLabel *costLabel;
@property (retain) UIProgressView *progressView;
@property (readonly, nonatomic) NSNumber *cardManaCost;
@property (readonly, nonatomic) NSNumber *percentage;
@property (readonly, nonatomic) BOOL isDarkMode;
@end

@implementation DeckDetailsManaCostGraphContentView

@synthesize configuration;

+ (CGRect)preferredCostLabelRect {
    NSString *string = @"10+";
    
    CGRect rect = [string boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX)
                                       options:NSStringDrawingUsesLineFragmentOrigin
                                    attributes:@{NSFontAttributeName: DeckDetailsManaCostGraphContentView.costLabelFont}
                                       context:nil];
    
    UIEdgeInsets costLabelInsets = DeckDetailsManaCostGraphContentView.costLabelInsets;
    
    rect.size.height += (costLabelInsets.top + costLabelInsets.bottom);
    rect.size.width += (costLabelInsets.left + costLabelInsets.right);
    
    return rect;
}

+ (UIFont *)costLabelFont {
    return [UIFont preferredFontForTextStyle:UIFontTextStyleCaption1];
}

+ (UIEdgeInsets)costLabelInsets {
    return UIEdgeInsetsMake(5, 5, 5, 5);
}

- (instancetype)init {
    self = [super init];
    
    if (self) {
        [self setAttributes];
        [self configureCostLabel];
        [self configureProgressView];
    }
    
    return self;
}

- (void)dealloc {
    [configuration release];
    [_costLabel release];
    [_progressView release];
    [super dealloc];
}

- (void)setAttributes {
    self.backgroundColor = nil;
}

- (void)configureCostLabel {
    InsetsLabel *costLabel = [InsetsLabel new];
    self.costLabel = costLabel;
    
    costLabel.textAlignment = NSTextAlignmentCenter;
    costLabel.font = DeckDetailsManaCostGraphContentView.costLabelFont;
    costLabel.contentInsets = DeckDetailsManaCostGraphContentView.costLabelInsets;
    costLabel.backgroundColor = UIColor.systemBlueColor;
    costLabel.textColor = UIColor.whiteColor;
    
    [self addSubview:costLabel];
    
    costLabel.translatesAutoresizingMaskIntoConstraints = NO;
    
    CGRect preferredRect = DeckDetailsManaCostGraphContentView.preferredCostLabelRect;
    
    [NSLayoutConstraint activateConstraints:@[
        [costLabel.topAnchor constraintEqualToAnchor:self.topAnchor],
        [costLabel.leadingAnchor constraintEqualToAnchor:self.leadingAnchor],
        [costLabel.widthAnchor constraintEqualToConstant:ceil(preferredRect.size.width)],
        [costLabel.heightAnchor constraintEqualToConstant:ceil(preferredRect.size.height)]
    ]];
    
    NSLayoutConstraint *bottomLayout = [costLabel.bottomAnchor constraintEqualToAnchor:self.bottomAnchor];
    bottomLayout.priority = UILayoutPriorityDefaultHigh;
    bottomLayout.active = YES;
    
    [costLabel release];
}

- (void)configureProgressView {
    UIProgressView *progressView = [UIProgressView new];
    self.progressView = progressView;
    
    progressView.backgroundColor = UIColor.clearColor;
    progressView.trackTintColor = UIColor.clearColor;
    progressView.progressViewStyle = UIProgressViewStyleBar;
    
    [self addSubview:progressView];
    
    progressView.translatesAutoresizingMaskIntoConstraints = NO;
    [NSLayoutConstraint activateConstraints:@[
        [progressView.topAnchor constraintEqualToAnchor:self.topAnchor],
        [progressView.leadingAnchor constraintEqualToAnchor:self.costLabel.trailingAnchor],
        [progressView.bottomAnchor constraintEqualToAnchor:self.bottomAnchor],
        [progressView.trailingAnchor constraintEqualToAnchor:self.trailingAnchor]
    ]];
    
    [progressView release];
}

- (void)setConfiguration:(id<UIContentConfiguration>)configuration {
    DeckDetailsManaCostGraphContentConfiguration *oldContentConfig = (DeckDetailsManaCostGraphContentConfiguration *)self.configuration;
    DeckDetailsManaCostGraphContentConfiguration *newContentConfig = [(DeckDetailsManaCostGraphContentConfiguration *)configuration copy];
    self->configuration = newContentConfig;
    
    if ((oldContentConfig == nil) || (![newContentConfig.cardManaCost isEqualToNumber:oldContentConfig.cardManaCost])) {
        [self updateCostLabel];
    }
    
    [self updateProgressLabel];
    
    [oldContentConfig release];
}

- (NSNumber * _Nullable)cardManaCost {
    DeckDetailsManaCostGraphContentConfiguration *contentConfig = (DeckDetailsManaCostGraphContentConfiguration *)self.configuration;
    
    if (![contentConfig isKindOfClass:[DeckDetailsManaCostGraphContentConfiguration class]]) return nil;
    
    return contentConfig.cardManaCost;
}

- (NSNumber * _Nullable)percentage {
    DeckDetailsManaCostGraphContentConfiguration *contentConfig = (DeckDetailsManaCostGraphContentConfiguration *)self.configuration;
    
    if (![contentConfig isKindOfClass:[DeckDetailsManaCostGraphContentConfiguration class]]) return nil;
    
    return contentConfig.percentage;
}

- (BOOL)isDarkMode {
    if (![self.configuration isKindOfClass:[DeckDetailsManaCostGraphContentConfiguration class]]) {
        return NO;
    }
    
    DeckDetailsManaCostGraphContentConfiguration *contentConfiguration = (DeckDetailsManaCostGraphContentConfiguration *)self.configuration;
    return contentConfiguration.isDarkMode;
}

- (void)updateCostLabel {
    if (self.cardManaCost.unsignedIntegerValue == (DeckDetailsManaCostContentViewModelCountOfData - 1)) {
        self.costLabel.text = [NSString stringWithFormat:@"%@+", self.cardManaCost.stringValue];
    } else {
        self.costLabel.text = self.cardManaCost.stringValue;
    }
}

- (void)updateProgressLabel {
    self.progressView.progress = self.percentage.floatValue;
    
    if (self.isDarkMode) {
        self.progressView.tintColor = UIColor.systemGray2Color;
    } else {
        self.progressView.tintColor = UIColor.systemGrayColor;
    }
}

@end
