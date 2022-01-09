//
//  DeckDetailsManaCostGraphBaseView.m
//  StoneNamuMac
//
//  Created by Jinwoo Kim on 12/19/21.
//

#import "DeckDetailsManaCostGraphBaseView.h"
#import "NSTextField+setLabelStyle.h"
#import "NSBox+setSimpleBoxStyle.h"

@interface DeckDetailsManaCostGraphBaseView ()
@property (copy) DeckDetailsManaCostGraphData *data;
@property (retain) NSTextField *manaLabel;
@property (retain) NSTextField *countLabel;
@property (retain) NSView *backgroundView;
@property (retain) NSBox *filledBox;
@property (retain) NSLayoutConstraint *filledBoxHeightConstraint;
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
    [_filledBox release];
    [_filledBoxHeightConstraint release];
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
    
    [manaLabel setLabelStyle];
    manaLabel.alignment = NSTextAlignmentCenter;
    manaLabel.translatesAutoresizingMaskIntoConstraints = NO;
    
    [self addSubview:manaLabel];
    [NSLayoutConstraint activateConstraints:@[
        [manaLabel.leadingAnchor constraintEqualToAnchor:self.leadingAnchor],
        [manaLabel.trailingAnchor constraintEqualToAnchor:self.trailingAnchor],
        [manaLabel.bottomAnchor constraintEqualToAnchor:self.bottomAnchor]
    ]];
    
    self.manaLabel = manaLabel;
    [manaLabel release];
}

- (void)configureCountLabel {
    NSTextField *countLabel = [NSTextField new];
    
    [countLabel setLabelStyle];
    countLabel.alignment = NSTextAlignmentCenter;
    countLabel.translatesAutoresizingMaskIntoConstraints = NO;
    
    [self addSubview:countLabel];
    [NSLayoutConstraint activateConstraints:@[
        [countLabel.topAnchor constraintEqualToAnchor:self.topAnchor],
        [countLabel.leadingAnchor constraintEqualToAnchor:self.leadingAnchor],
        [countLabel.trailingAnchor constraintEqualToAnchor:self.trailingAnchor]
    ]];
    
    self.countLabel = countLabel;
    [countLabel release];
}

- (void)configureBackgroundView {
    NSView *backgroundView = [NSView new];
    
    backgroundView.translatesAutoresizingMaskIntoConstraints = NO;
    
    [self addSubview:backgroundView];
    [NSLayoutConstraint activateConstraints:@[
        [backgroundView.topAnchor constraintEqualToAnchor:self.countLabel.bottomAnchor],
        [backgroundView.leadingAnchor constraintEqualToAnchor:self.leadingAnchor],
        [backgroundView.trailingAnchor constraintEqualToAnchor:self.trailingAnchor],
        [backgroundView.bottomAnchor constraintEqualToAnchor:self.manaLabel.topAnchor]
    ]];
    
    self.backgroundView = backgroundView;
    [backgroundView release];
}

- (void)configureFilledView {
    NSBox *filledBox = [NSBox new];
    
    [filledBox setSimpleBoxStyle];
    filledBox.fillColor = NSColor.controlAccentColor;
    filledBox.wantsLayer = YES;
    filledBox.layer.cornerCurve = kCACornerCurveContinuous;
    filledBox.layer.cornerRadius = 5.0f;
    filledBox.translatesAutoresizingMaskIntoConstraints = NO;
    
    [self.backgroundView addSubview:filledBox];
    
    NSLayoutConstraint *filledBoxHeightConstraint = [filledBox.heightAnchor constraintEqualToConstant:0.0f];
    
    [NSLayoutConstraint activateConstraints:@[
        filledBoxHeightConstraint,
        [filledBox.leadingAnchor constraintEqualToAnchor:self.backgroundView.leadingAnchor],
        [filledBox.trailingAnchor constraintEqualToAnchor:self.backgroundView.trailingAnchor],
        [filledBox.bottomAnchor constraintEqualToAnchor:self.backgroundView.bottomAnchor]
    ]];
    
    self.filledBox = filledBox;
    self.filledBoxHeightConstraint = filledBoxHeightConstraint;
    [filledBox release];
}

- (void)updateFilledView {
    [NSAnimationContext runAnimationGroup:^(NSAnimationContext * _Nonnull context) {
        context.duration = 0.2f;
        [self.filledBoxHeightConstraint animator].constant = self.backgroundView.bounds.size.height * self.data.percentage;
        
        [self.filledBox layoutSubtreeIfNeeded];
    }];
}

@end
