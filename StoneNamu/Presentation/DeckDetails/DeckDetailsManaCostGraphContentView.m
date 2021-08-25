//
//  DeckDetailsManaCostGraphContentView.m
//  DeckDetailsManaCostGraphContentView
//
//  Created by Jinwoo Kim on 8/24/21.
//

#import "DeckDetailsManaCostGraphContentView.h"
#import "DeckDetailsManaCostGraphContentConfiguration.h"

@interface DeckDetailsManaCostGraphContentView ()
@property (retain) UILabel *testLabel;
@property (readonly, nonatomic) NSDictionary<NSNumber *, NSNumber *> * _Nullable manaDictionary;
@end

@implementation DeckDetailsManaCostGraphContentView

@synthesize configuration;

- (instancetype)init {
    self = [super init];
    
    if (self) {
        [self setAttributes];
        [self configureTestLabel];
    }
    
    return self;
}

- (void)dealloc {
    [configuration release];
    [_testLabel release];
    [super dealloc];
}

- (void)setAttributes {
    self.backgroundColor = nil;
}

- (void)configureTestLabel {
    UILabel *testLabel = [UILabel new];
    self.testLabel = testLabel;
    testLabel.numberOfLines = 0;
    [testLabel release];
    
    [self addSubview:testLabel];
    testLabel.translatesAutoresizingMaskIntoConstraints = NO;
    
    [NSLayoutConstraint activateConstraints:@[
        [testLabel.topAnchor constraintEqualToAnchor:self.topAnchor],
        [testLabel.leadingAnchor constraintEqualToAnchor:self.leadingAnchor],
        [testLabel.trailingAnchor constraintEqualToAnchor:self.trailingAnchor],
        [testLabel.bottomAnchor constraintEqualToAnchor:self.bottomAnchor]
    ]];
}

- (void)setConfiguration:(id<UIContentConfiguration>)configuration {
    DeckDetailsManaCostGraphContentConfiguration *oldContentConfig = (DeckDetailsManaCostGraphContentConfiguration *)self.configuration;
    DeckDetailsManaCostGraphContentConfiguration *newContentConfig = [(DeckDetailsManaCostGraphContentConfiguration *)configuration copy];
    self->configuration = newContentConfig;
    
    if (![newContentConfig.manaDictionary isEqualToDictionary:oldContentConfig.manaDictionary]) {
        [self updateLabel];
    }
    
    [oldContentConfig release];
}

- (NSDictionary<NSNumber *, NSNumber *> * _Nullable)manaDictionary {
    DeckDetailsManaCostGraphContentConfiguration *contentConfig = (DeckDetailsManaCostGraphContentConfiguration *)self.configuration;
    
    if (![contentConfig isKindOfClass:[DeckDetailsManaCostGraphContentConfiguration class]]) return nil;
    
    return contentConfig.manaDictionary;
}

- (void)updateLabel {
    self.testLabel.text = [NSString stringWithFormat:@"%@", self.manaDictionary];
}

@end
