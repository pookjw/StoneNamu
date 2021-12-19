//
//  DeckDetailsManaCostGraphBaseView.m
//  StoneNamuMac
//
//  Created by Jinwoo Kim on 12/19/21.
//

#import "DeckDetailsManaCostGraphBaseView.h"
#import "NSTextField+setLabelStyle.h"

@interface DeckDetailsManaCostGraphBaseView ()
@property (copy) DeckDetailsManaCostGraphData *data;
@property (retain) NSTextField *manaLabel;
@property (retain) NSTextField *countLabel;
@property (retain) NSView *backgroundView;
@property (retain) NSView *filledView;
@property (retain) NSLayoutConstraint *filledViewHeightConstraint;
@end

@implementation DeckDetailsManaCostGraphBaseView

- (instancetype)init {
    self = [super init];
    
    if (self) {
        [self configureManaLabel];
        [self configureCountLabel];
        [self configureBackgroundView];
        [self configureFilledView];
    }
    
    return self;
}

- (void)dealloc {
    [_data release];
    [_backgroundView release];
    [_filledView release];
    [_filledViewHeightConstraint release];
    [_manaLabel release];
    [_countLabel release];
    [super dealloc];
}

- (void)layout {
    [super layout];
    [self updateFilledView];
}

- (void)configureWithData:(DeckDetailsManaCostGraphData *)data {
    self.data = data;
    
    if (data.manaCost >= 10) {
        self.manaLabel.stringValue = [NSString stringWithFormat:@"%lu+", data.manaCost];
    } else {
        self.manaLabel.stringValue = [NSString stringWithFormat:@"%lu", data.manaCost];
    }
    
    self.countLabel.stringValue = [NSString stringWithFormat:@"x%lu", data.count];
    [self updateFilledView];
}

- (void)configureManaLabel {
    NSTextField *manaLabel = [NSTextField new];
    self.manaLabel = manaLabel;
    
    [manaLabel setLabelStyle];
    manaLabel.alignment = NSTextAlignmentCenter;
    manaLabel.translatesAutoresizingMaskIntoConstraints = NO;
    
    [self addSubview:manaLabel];
    [NSLayoutConstraint activateConstraints:@[
        [manaLabel.leadingAnchor constraintEqualToAnchor:self.leadingAnchor],
        [manaLabel.trailingAnchor constraintEqualToAnchor:self.trailingAnchor],
        [manaLabel.bottomAnchor constraintEqualToAnchor:self.bottomAnchor]
    ]];
    
    [manaLabel release];
}

- (void)configureCountLabel {
    NSTextField *countLabel = [NSTextField new];
    self.countLabel = countLabel;
    
    [countLabel setLabelStyle];
    countLabel.alignment = NSTextAlignmentCenter;
    countLabel.translatesAutoresizingMaskIntoConstraints = NO;
    
    [self addSubview:countLabel];
    [NSLayoutConstraint activateConstraints:@[
        [countLabel.topAnchor constraintEqualToAnchor:self.topAnchor],
        [countLabel.leadingAnchor constraintEqualToAnchor:self.leadingAnchor],
        [countLabel.trailingAnchor constraintEqualToAnchor:self.trailingAnchor]
    ]];
    
    [countLabel release];
}

- (void)configureBackgroundView {
    NSView *backgroundView = [NSView new];
    self.backgroundView = backgroundView;
    
    backgroundView.translatesAutoresizingMaskIntoConstraints = NO;
    
    [self addSubview:backgroundView];
    [NSLayoutConstraint activateConstraints:@[
        [backgroundView.topAnchor constraintEqualToAnchor:self.countLabel.bottomAnchor],
        [backgroundView.leadingAnchor constraintEqualToAnchor:self.leadingAnchor],
        [backgroundView.trailingAnchor constraintEqualToAnchor:self.trailingAnchor],
        [backgroundView.bottomAnchor constraintEqualToAnchor:self.manaLabel.topAnchor]
    ]];
    
    [backgroundView release];
}

- (void)configureFilledView {
    NSView *filledView = [NSView new];
    self.filledView = filledView;
    
    filledView.wantsLayer = YES;
    filledView.layer.backgroundColor = NSColor.systemGreenColor.CGColor;
    filledView.translatesAutoresizingMaskIntoConstraints = NO;
    
    [self.backgroundView addSubview:filledView];
    
    NSLayoutConstraint *filledViewHeightConstraint = [filledView.heightAnchor constraintEqualToConstant:0.0f];
    self.filledViewHeightConstraint = filledViewHeightConstraint;
    
    [NSLayoutConstraint activateConstraints:@[
        filledViewHeightConstraint,
        [filledView.leadingAnchor constraintEqualToAnchor:self.backgroundView.leadingAnchor],
        [filledView.trailingAnchor constraintEqualToAnchor:self.backgroundView.trailingAnchor],
        [filledView.bottomAnchor constraintEqualToAnchor:self.backgroundView.bottomAnchor]
    ]];
    
    [filledView release];
}

- (void)updateFilledView {
    self.filledViewHeightConstraint.constant = self.bounds.size.height * self.data.percentage;
}

@end
