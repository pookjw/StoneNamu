//
//  SpinnerView.m
//  StoneNamuMac
//
//  Created by Jinwoo Kim on 10/26/21.
//

#import "SpinnerView.h"
#import <QuartzCore/QuartzCore.h>
#import <StoneNamuCore/StoneNamuCore.h>

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
    self.contentView = contentView;
    
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
    
    [contentView release];
}

- (void)configureBaseCircularView {
    NSView *baseCircularView = [NSView new];
    self.baseCircularView = baseCircularView;
    
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
    self.baseCircularPathLayer = baseCircularPathLayer;
    baseCircularPathLayer.fillColor = NSColor.clearColor.CGColor;
    baseCircularPathLayer.strokeColor = [NSColor.whiteColor colorWithAlphaComponent:0.1f].CGColor;
    
    [baseCircularView.layer addSublayer:baseCircularPathLayer];
    [baseCircularPathLayer release];
    
    [NSNotificationCenter.defaultCenter addObserver:self
                                           selector:@selector(baseCircularViewDidChangeFrame:)
                                               name:NSViewFrameDidChangeNotification
                                             object:baseCircularView];
    
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

    CGPathMoveToPoint(mutablePath,
                      nil,
                      (self.baseCircularView.bounds.size.width / 2.0f),
                      (self.baseCircularView.bounds.size.height - (lineWidth / 2.0f)));
    CGPathAddArc(mutablePath,
                 nil,
                 (self.baseCircularView.bounds.size.width / 2.0f),
                 (self.baseCircularView.bounds.size.height / 2.0f),
                 (self.baseCircularView.bounds.size.height / 2.0f) - (lineWidth / 2.0f),
                 (M_PI / 2.0f),
                 -(M_PI / 2.0f),
                 YES);
    CGPathAddArc(mutablePath,
                 nil,
                 (self.baseCircularView.bounds.size.width / 2.0f),
                 (self.baseCircularView.bounds.size.height / 2.0f),
                 (self.baseCircularView.bounds.size.height / 2.0f) - (lineWidth / 2.0f),
                 -(M_PI / 2.0f),
                 (M_PI / 2.0f),
                 YES);
    
    CGPathCloseSubpath(mutablePath);
    
    CGPathRef path = CGPathCreateCopy(mutablePath);
    CGPathRelease(mutablePath);
    
    self.baseCircularPathLayer.path = path;
    CGPathRelease(path);
    
    self.baseCircularPathLayer.lineWidth = (self.baseCircularView.bounds.size.height / 10.0f);
}

- (void)configureProgressCircularView {
    NSView *progressCircularView = [NSView new];
    self.progressCircularView = progressCircularView;

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
    self.progressCircularLayer = progressCircularLayer;
    progressCircularLayer.backgroundColor = NSColor.clearColor.CGColor;
    progressCircularLayer.fillColor = NSColor.whiteColor.CGColor;
    progressCircularLayer.strokeColor = NSColor.clearColor.CGColor;
    
    [progressCircularView.layer addSublayer:progressCircularLayer];
    [progressCircularLayer release];
    
    //
    
    [NSNotificationCenter.defaultCenter addObserver:self
                                           selector:@selector(progressCircularViewDidChangeFrame:)
                                               name:NSViewFrameDidChangeNotification
                                             object:progressCircularView];
    
    //
    
    CABasicAnimation *progressCircularAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
    self.progressCircularAnimation = progressCircularAnimation;
    
    progressCircularAnimation.removedOnCompletion = NO;
    progressCircularAnimation.duration = 1.0f;
    progressCircularAnimation.repeatCount = INFINITY;
    progressCircularAnimation.fromValue = [NSNumber numberWithFloat:0.0f];
    progressCircularAnimation.toValue = [NSNumber numberWithFloat:-(M_PI * 2.0)];
    
    //
    
    [progressCircularView release];
}

- (void)progressCircularViewDidChangeFrame:(NSNotification *)notification {
    [NSOperationQueue.mainQueue addOperationWithBlock:^{
        [self redrawProgressCircularPath];
    }];
}

- (void)redrawProgressCircularPath {
    CGMutablePathRef mutablePath = CGPathCreateMutable();
    CGFloat lineWidth = self.progressCircularView.bounds.size.height / 10.0f;
    CGFloat degree = M_PI * (1.0f / 2.0f);
    
    CGPathMoveToPoint(mutablePath,
                      nil,
                      0.0f,
                      NSMidY(self.progressCircularView.bounds));
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
    CGPathAddLineToPoint(mutablePath,
                         nil,
                         0.0f,
                         NSMidY(self.progressCircularView.bounds));
    
    CGPathCloseSubpath(mutablePath);
    
    CGPathRef path = CGPathCreateCopy(mutablePath);
    CGPathRelease(mutablePath);
    
    self.progressCircularLayer.path = path;
    CGPathRelease(path);
    
    //
    
    // https://stackoverflow.com/a/226761
    [CATransaction begin];
    [CATransaction setValue:(id)kCFBooleanTrue forKey: kCATransactionDisableActions];
    self.progressCircularLayer.position = CGPointMake((self.progressCircularView.bounds.size.width / 2.0f),
                                                      (self.progressCircularView.bounds.size.height / 2.0f));
    [CATransaction commit];
}

@end
