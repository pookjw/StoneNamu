//
//  SpinnerView.m
//  SpinnerView
//
//  Created by Jinwoo Kim on 8/29/21.
//

#import "SpinnerView.h"

@interface SpinnerView ()
@property (retain) UIVisualEffectView *visualEffectView;
@property (retain) UIActivityIndicatorView *activityIndicatorView;
@end

@implementation SpinnerView

- (instancetype)init {
    self = [super init];

    if (self) {
        [self setAttributes];
        [self configureVisualEffectView];
        [self configureActivityIndicatorView];
        [self traitCollectionDidChange:nil];
    }

    return self;
}

- (void)dealloc {
    [_visualEffectView release];
    [_activityIndicatorView release];
    [super dealloc];
}

- (void)startAnimating {
    [self.activityIndicatorView startAnimating];
}

- (void)stopAnimating {
    [self.activityIndicatorView stopAnimating];
}

- (void)setAttributes {
    self.backgroundColor = UIColor.clearColor;
    self.userInteractionEnabled = YES;
}

- (void)traitCollectionDidChange:(UITraitCollection *)previousTraitCollection {
    [super traitCollectionDidChange:previousTraitCollection];
    
    [self.activityIndicatorView stopAnimating];
    
    switch (self.traitCollection.userInterfaceStyle) {
        case UIUserInterfaceStyleLight:
            self.visualEffectView.effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
            self.activityIndicatorView.color = UIColor.whiteColor;
            break;
        case UIUserInterfaceStyleDark:
            self.visualEffectView.effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleExtraLight];
            self.activityIndicatorView.color = UIColor.blackColor;
            break;
        default:
            self.visualEffectView.effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
            self.activityIndicatorView.color = UIColor.whiteColor;
            break;
    }
    
    [self.activityIndicatorView startAnimating];
}

- (void)configureVisualEffectView {
    UIVisualEffectView *visualEffectView = [UIVisualEffectView new];
    self.visualEffectView = visualEffectView;
    
    [self addSubview:visualEffectView];
    
    visualEffectView.translatesAutoresizingMaskIntoConstraints = NO;
    [NSLayoutConstraint activateConstraints:@[
        [visualEffectView.centerXAnchor constraintEqualToAnchor:self.safeAreaLayoutGuide.centerXAnchor],
        [visualEffectView.centerYAnchor constraintEqualToAnchor:self.safeAreaLayoutGuide.centerYAnchor]
    ]];
    visualEffectView.layer.cornerRadius = 10;
    visualEffectView.layer.cornerCurve = kCACornerCurveContinuous;
    visualEffectView.clipsToBounds = YES;
    visualEffectView.userInteractionEnabled = NO;
    
    [visualEffectView release];
}

- (void)configureActivityIndicatorView {
    UIActivityIndicatorView *activityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleLarge];
    self.activityIndicatorView = activityIndicatorView;
    
    [self.visualEffectView.contentView addSubview:activityIndicatorView];
    [activityIndicatorView startAnimating];
    
    activityIndicatorView.translatesAutoresizingMaskIntoConstraints = NO;
    [NSLayoutConstraint activateConstraints:@[
        [activityIndicatorView.topAnchor constraintEqualToAnchor:self.visualEffectView.contentView.topAnchor constant:15.0f],
        [activityIndicatorView.leadingAnchor constraintEqualToAnchor:self.visualEffectView.contentView.leadingAnchor constant:15.0f],
        [activityIndicatorView.trailingAnchor constraintEqualToAnchor:self.visualEffectView.contentView.trailingAnchor constant:-15.0f],
        [activityIndicatorView.bottomAnchor constraintEqualToAnchor:self.visualEffectView.contentView.bottomAnchor constant:-15.0f]
    ]];
    activityIndicatorView.backgroundColor = UIColor.clearColor;
    activityIndicatorView.userInteractionEnabled = NO;
    
    [activityIndicatorView release];
}

@end
