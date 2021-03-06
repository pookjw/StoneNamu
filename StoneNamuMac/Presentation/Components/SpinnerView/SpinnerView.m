//
//  SpinnerView.m
//  StoneNamuMac
//
//  Created by Jinwoo Kim on 10/26/21.
//

#import "SpinnerView.h"
#import <QuartzCore/QuartzCore.h>
#import <StoneNamuCore/StoneNamuCore.h>
#import "NSView+isDarkMode.h"

#define PROGRESS_CIRCULAR_ANIMATION_KEY @"rotation"

@interface SpinnerView ()
@property (retain) NSView *contentView;
@property (retain) NSView *baseCircularView;
@property (retain) CAShapeLayer *baseCircularPathLayer;
@property (retain) NSView *progressCircularView;
@property (retain) CAShapeLayer *progressCircularLayer;
@property (retain) CABasicAnimation *progressCircularAnimation;
@end

@implementation SpinnerView

- (instancetype)init {
    self = [super init];
    
    if (self) {
        [self setAttributes];
        [self configureContentView];
        [self configureBaseCircularView];
        [self configureProgressCircularView];
        [self updateTintColors];
    }
    
    return self;
}

- (void)dealloc {
    [_contentView release];
    [_baseCircularView release];
    [_baseCircularPathLayer release];
    [_progressCircularView release];
    [_progressCircularLayer release];
    [_progressCircularAnimation release];
    [super dealloc];
}

- (void)viewDidChangeEffectiveAppearance {
    [super viewDidChangeEffectiveAppearance];
    [self updateTintColors];
}

- (void)layout {
    [super layout];
    [self redrawBaseCircularPath];
    [self redrawProgressCircularPath];
}

- (void)startAnimating {
    if (![self.progressCircularLayer.animationKeys containsString:PROGRESS_CIRCULAR_ANIMATION_KEY]) {
        [self.progressCircularLayer addAnimation:self.progressCircularAnimation forKey:PROGRESS_CIRCULAR_ANIMATION_KEY];
    }
}

- (void)stopAnimating {
    [self.progressCircularLayer removeAnimationForKey:PROGRESS_CIRCULAR_ANIMATION_KEY];
}

- (void)setAttributes {
    self.wantsLayer = YES;
    self.layer.backgroundColor = NSColor.clearColor.CGColor;
}

- (void)configureContentView {
    NSView *contentView = [NSView new];
    
    [self addSubview:contentView];
    contentView.translatesAutoresizingMaskIntoConstraints = NO;
    
    NSLayoutConstraint *topConstraint = [contentView.topAnchor constraintEqualToAnchor:self.topAnchor];
    topConstraint.priority = NSLayoutPriorityDefaultLow;
    
    NSLayoutConstraint *leadingConstraint = [contentView.leadingAnchor constraintEqualToAnchor:self.leadingAnchor];
    leadingConstraint.priority = NSLayoutPriorityDefaultLow;
    
    NSLayoutConstraint *trailingConstraint = [contentView.trailingAnchor constraintEqualToAnchor:self.trailingAnchor];
    trailingConstraint.priority = NSLayoutPriorityDefaultLow;
    
    NSLayoutConstraint *bottomConstraint = [contentView.bottomAnchor constraintEqualToAnchor:self.bottomAnchor];
    bottomConstraint.priority = NSLayoutPriorityDefaultLow;
    
    NSLayoutConstraint *widthConstraint = [contentView.widthAnchor constraintLessThanOrEqualToAnchor:self.widthAnchor];
    widthConstraint.priority = NSLayoutPriorityDefaultHigh;
    
    NSLayoutConstraint *heightConstraint = [contentView.heightAnchor constraintLessThanOrEqualToAnchor:self.heightAnchor];
    heightConstraint.priority = NSLayoutPriorityDefaultHigh;
    
    NSLayoutConstraint *centerXConstraint = [contentView.centerXAnchor constraintEqualToAnchor:self.centerXAnchor];
    centerXConstraint.priority = NSLayoutPriorityRequired;
    
    NSLayoutConstraint *centerYConstraint = [contentView.centerYAnchor constraintEqualToAnchor:self.centerYAnchor];
    centerYConstraint.priority = NSLayoutPriorityRequired;
    
    NSLayoutConstraint *aspectConstraint = [NSLayoutConstraint constraintWithItem:contentView
                                                                        attribute:NSLayoutAttributeWidth
                                                                        relatedBy:NSLayoutRelationEqual
                                                                           toItem:contentView
                                                                        attribute:NSLayoutAttributeHeight
                                                                       multiplier:1.0f
                                                                         constant:0.0f];
    aspectConstraint.priority = NSLayoutPriorityRequired;
    
    [NSLayoutConstraint activateConstraints:@[
        topConstraint,
        leadingConstraint,
        trailingConstraint,
        bottomConstraint,
        widthConstraint,
        heightConstraint,
        centerXConstraint,
        centerYConstraint,
        aspectConstraint
    ]];
    
    contentView.wantsLayer = YES;
    contentView.layer.backgroundColor = NSColor.clearColor.CGColor;
    
    self.contentView = contentView;
    [contentView release];
}

- (void)configureBaseCircularView {
    NSView *baseCircularView = [NSView new];
    
    [self.contentView addSubview:baseCircularView];
    baseCircularView.translatesAutoresizingMaskIntoConstraints = NO;
    
    //
    
    [NSLayoutConstraint activateConstraints:@[
        [baseCircularView.topAnchor constraintEqualToAnchor:self.contentView.topAnchor],
        [baseCircularView.leadingAnchor constraintEqualToAnchor:self.contentView.leadingAnchor],
        [baseCircularView.trailingAnchor constraintEqualToAnchor:self.contentView.trailingAnchor],
        [baseCircularView.bottomAnchor constraintEqualToAnchor:self.contentView.bottomAnchor]
    ]];
    
    //
    
    baseCircularView.wantsLayer = YES;
    baseCircularView.layer.backgroundColor = NSColor.clearColor.CGColor;
    
    CAShapeLayer *baseCircularPathLayer = [CAShapeLayer new];
    baseCircularPathLayer.fillColor = NSColor.clearColor.CGColor;
    
    [baseCircularView.layer addSublayer:baseCircularPathLayer];
    self.baseCircularPathLayer = baseCircularPathLayer;
    [baseCircularPathLayer release];
    
    [NSNotificationCenter.defaultCenter addObserver:self
                                           selector:@selector(baseCircularViewDidChangeFrame:)
                                               name:NSViewFrameDidChangeNotification
                                             object:baseCircularView];
    
    self.baseCircularView = baseCircularView;
    [baseCircularView release];
}

- (void)baseCircularViewDidChangeFrame:(NSNotification *)notification {
    [NSOperationQueue.mainQueue addOperationWithBlock:^{
        [self redrawBaseCircularPath];
    }];
}

- (void)redrawBaseCircularPath {
    CGMutablePathRef mutablePath = CGPathCreateMutable();
    CGFloat lineWidth = (self.baseCircularView.bounds.size.height / 10.0f);

    CGPathAddArc(mutablePath,
                 nil,
                 NSMidX(self.baseCircularView.bounds),
                 NSMidY(self.baseCircularView.bounds),
                 (NSMidY(self.baseCircularView.bounds) - (lineWidth / 2.0f)),
                 (M_PI / 2.0f),
                 -(M_PI / 2.0f),
                 YES);
    CGPathAddArc(mutablePath,
                 nil,
                 NSMidX(self.baseCircularView.bounds),
                 NSMidY(self.baseCircularView.bounds),
                 (NSMidY(self.baseCircularView.bounds) - (lineWidth / 2.0f)),
                 -(M_PI / 2.0f),
                 (M_PI / 2.0f),
                 YES);
    
    CGPathCloseSubpath(mutablePath);
    
    CGPathRef path = CGPathCreateCopy(mutablePath);
    CGPathRelease(mutablePath);
    
    self.baseCircularPathLayer.path = path;
    CGPathRelease(path);
    
    self.baseCircularPathLayer.lineWidth = lineWidth;
}

- (void)configureProgressCircularView {
    NSView *progressCircularView = [NSView new];

    [self.contentView addSubview:progressCircularView];
    progressCircularView.translatesAutoresizingMaskIntoConstraints = NO;
    
    //
    
    [NSLayoutConstraint activateConstraints:@[
        [progressCircularView.topAnchor constraintEqualToAnchor:self.contentView.topAnchor],
        [progressCircularView.leadingAnchor constraintEqualToAnchor:self.contentView.leadingAnchor],
        [progressCircularView.trailingAnchor constraintEqualToAnchor:self.contentView.trailingAnchor],
        [progressCircularView.bottomAnchor constraintEqualToAnchor:self.contentView.bottomAnchor]
    ]];
    
    //
    
    progressCircularView.wantsLayer = YES;
    progressCircularView.layer.backgroundColor = NSColor.clearColor.CGColor;
    
    CAShapeLayer *progressCircularLayer = [CAShapeLayer new];
    progressCircularLayer.backgroundColor = NSColor.clearColor.CGColor;
    progressCircularLayer.strokeColor = NSColor.clearColor.CGColor;
    
    [progressCircularView.layer addSublayer:progressCircularLayer];
    
    self.progressCircularLayer = progressCircularLayer;
    [progressCircularLayer release];
    
    //
    
    [NSNotificationCenter.defaultCenter addObserver:self
                                           selector:@selector(progressCircularViewDidChangeFrame:)
                                               name:NSViewFrameDidChangeNotification
                                             object:progressCircularView];
    
    //
    
    CABasicAnimation *progressCircularAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
    
    progressCircularAnimation.removedOnCompletion = NO;
    progressCircularAnimation.duration = 1.0f;
    progressCircularAnimation.repeatCount = INFINITY;
    progressCircularAnimation.fromValue = [NSNumber numberWithFloat:0.0f];
    progressCircularAnimation.toValue = [NSNumber numberWithFloat:-(M_PI * 2.0)];
    
    self.progressCircularAnimation = progressCircularAnimation;
    
    //
    
    self.progressCircularView = progressCircularView;
    [progressCircularView release];
}

- (void)progressCircularViewDidChangeFrame:(NSNotification *)notification {
    [NSOperationQueue.mainQueue addOperationWithBlock:^{
        [self redrawProgressCircularPath];
    }];
}

- (void)redrawProgressCircularPath {
    CGMutablePathRef mutablePath = CGPathCreateMutable();
    CGFloat lineWidth = NSMaxY(self.progressCircularView.bounds) / 10.0f;
    CGFloat degree = M_PI * (1.0f / 2.0f);
    
    CGPathAddArc(mutablePath,
                 nil,
                 0.0f,
                 0.0f,
                 NSMidY(self.progressCircularView.bounds),
                 (M_PI / 2.0f),
                 ((M_PI / 2.0f) - degree),
                 YES);
    CGPathAddArc(mutablePath,
                 nil,
                 0.0f,
                 0.0f,
                 (NSMidY(self.progressCircularView.bounds) - lineWidth),
                 ((M_PI / 2.0f) - degree),
                 (M_PI / 2.0f),
                 NO);
    
    CGPathCloseSubpath(mutablePath);
    
    CGPathRef path = CGPathCreateCopy(mutablePath);
    CGPathRelease(mutablePath);
    
    self.progressCircularLayer.path = path;
    CGPathRelease(path);
    
    //
    
    // https://stackoverflow.com/a/226761
    [CATransaction begin];
    [CATransaction setValue:(id)kCFBooleanTrue forKey: kCATransactionDisableActions];
    self.progressCircularLayer.position = CGPointMake(NSMidX(self.progressCircularView.bounds),
                                                      NSMidY(self.progressCircularView.bounds));
    [CATransaction commit];
}

- (void)updateTintColors {
    if (self.isDarkMode) {
        self.baseCircularPathLayer.strokeColor = [NSColor.whiteColor colorWithAlphaComponent:0.1f].CGColor;
        self.progressCircularLayer.fillColor = NSColor.whiteColor.CGColor;
    } else {
        self.baseCircularPathLayer.strokeColor = [NSColor.blackColor colorWithAlphaComponent:0.1f].CGColor;
        self.progressCircularLayer.fillColor = NSColor.blackColor.CGColor;
    }
}

@end
