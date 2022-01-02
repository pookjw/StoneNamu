//
//  CardDetailsLayoutCompactViewController.m
//  CardDetailsLayoutCompactViewController
//
//  Created by Jinwoo Kim on 8/4/21.
//

#import "CardDetailsLayoutCompactViewController.h"

@interface CardDetailsLayoutCompactViewController ()
@property (retain) UIView *primaryImageViewContainerView;
@property (retain) UIView *closeButtonContainerView;
@property (retain) UIView *collectionViewContainerView;
@property (retain) CAGradientLayer *gradientLayer;
@property (retain) UIImageView * _Nullable primaryImageView;
@property (retain) UIButton * _Nullable closeButton;
@property (retain) UICollectionView * _Nullable collectionView;
@end

@implementation CardDetailsLayoutCompactViewController

- (instancetype)init {
    self = [super init];
    
    if (self) {
        self.primaryImageView = nil;
        self.closeButton = nil;
        self.collectionView = nil;
    }
    
    return self;
}

- (void)dealloc {
    [_primaryImageViewContainerView release];
    [_closeButtonContainerView release];
    [_collectionViewContainerView release];
    [_gradientLayer release];
    [_primaryImageView release];
    [_closeButton release];
    [_collectionView release];
    [super dealloc];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configureContainerViews];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    [self updateGradientLayer];
}

- (void)configureContainerViews {
    UIView *primaryImageViewContainerView = [UIView new];
    [self.view addSubview:primaryImageViewContainerView];
    primaryImageViewContainerView.translatesAutoresizingMaskIntoConstraints = NO;
    [NSLayoutConstraint activateConstraints:@[
        [primaryImageViewContainerView.topAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.topAnchor],
        [primaryImageViewContainerView.trailingAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.trailingAnchor],
        [primaryImageViewContainerView.leadingAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.leadingAnchor],
        [NSLayoutConstraint constraintWithItem:primaryImageViewContainerView
                                     attribute:NSLayoutAttributeHeight
                                     relatedBy:NSLayoutRelationEqual
                                        toItem:self.view
                                     attribute:NSLayoutAttributeHeight
                                    multiplier:0.5
                                      constant:0]
    ]];
    primaryImageViewContainerView.backgroundColor = UIColor.clearColor;
    
    self.primaryImageViewContainerView = primaryImageViewContainerView;
    [primaryImageViewContainerView release];
    
    //
    
    UIView *closeButtonContainerView = [UIView new];
    [self.view addSubview:closeButtonContainerView];
    closeButtonContainerView.translatesAutoresizingMaskIntoConstraints = NO;
    [NSLayoutConstraint activateConstraints:@[
        [closeButtonContainerView.topAnchor constraintEqualToAnchor:primaryImageViewContainerView.topAnchor],
        [closeButtonContainerView.trailingAnchor constraintEqualToAnchor:primaryImageViewContainerView.trailingAnchor],
        [closeButtonContainerView.widthAnchor constraintEqualToConstant:60.0f],
        [closeButtonContainerView.heightAnchor constraintEqualToConstant:60.0f]
    ]];
    closeButtonContainerView.backgroundColor = UIColor.clearColor;
    
    self.closeButtonContainerView = closeButtonContainerView;
    [closeButtonContainerView release];
    
    //
    
    UIView *collectionViewContainerView = [UIView new];
    [self.view addSubview:collectionViewContainerView];
    collectionViewContainerView.translatesAutoresizingMaskIntoConstraints = NO;
    [NSLayoutConstraint activateConstraints:@[
        [collectionViewContainerView.topAnchor constraintEqualToAnchor:primaryImageViewContainerView.bottomAnchor],
        [collectionViewContainerView.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor],
        [collectionViewContainerView.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor],
        [collectionViewContainerView.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor]
    ]];
    collectionViewContainerView.backgroundColor = UIColor.clearColor;
    
    CAGradientLayer *gradientLayer = [CAGradientLayer new];
    gradientLayer.colors = @[
        (id)[UIColor.whiteColor colorWithAlphaComponent:0].CGColor,
        (id)UIColor.whiteColor.CGColor
    ];
    gradientLayer.startPoint = CGPointMake(0, 0);
    gradientLayer.endPoint = CGPointMake(0, 0.05);
    collectionViewContainerView.layer.mask = gradientLayer;
    self.gradientLayer = gradientLayer;
    [gradientLayer release];
    
    self.collectionViewContainerView = collectionViewContainerView;
    [collectionViewContainerView release];
    
    //
    
    [self.view bringSubviewToFront:closeButtonContainerView];
}

- (void)updateGradientLayer {
    [CATransaction begin];
    [CATransaction setDisableActions:YES];
    self.gradientLayer.frame = self.collectionViewContainerView.bounds;
    [CATransaction commit];
}

- (CGRect)estimatedPrimaryImageRectUsingWindow:(UIWindow *)window safeAreaInsets:(UIEdgeInsets)safeAreaInsets {
    CGFloat x = safeAreaInsets.left;
    CGFloat y = safeAreaInsets.top;
    CGFloat width = window.bounds.size.width - safeAreaInsets.left - safeAreaInsets.right;
    CGFloat height = (window.bounds.size.height / 2);
    return CGRectMake(x, y, width, height);
}

- (void)cardDetailsLayoutAddPrimaryImageView:(nonnull UIImageView *)primaryImageView {
    if (primaryImageView.superview) {
        [primaryImageView removeFromSuperview];
    }
    
    [self.primaryImageViewContainerView addSubview:primaryImageView];
    primaryImageView.translatesAutoresizingMaskIntoConstraints = NO;
    [NSLayoutConstraint activateConstraints:@[
        [primaryImageView.topAnchor constraintEqualToAnchor:self.primaryImageViewContainerView.topAnchor],
        [primaryImageView.trailingAnchor constraintEqualToAnchor:self.primaryImageViewContainerView.trailingAnchor],
        [primaryImageView.leadingAnchor constraintEqualToAnchor:self.primaryImageViewContainerView.leadingAnchor],
        [primaryImageView.bottomAnchor constraintEqualToAnchor:self.primaryImageViewContainerView.bottomAnchor]
    ]];
    
    self.primaryImageView = primaryImageView;
}

- (void)cardDetailsLayoutAddCollectionView:(UICollectionView *)collectionView {
    if (collectionView.superview) {
        [collectionView removeFromSuperview];
    }
    
    [self.collectionViewContainerView addSubview:collectionView];
    collectionView.translatesAutoresizingMaskIntoConstraints = NO;
    [NSLayoutConstraint activateConstraints:@[
        [collectionView.topAnchor constraintEqualToAnchor:self.collectionViewContainerView.topAnchor],
        [collectionView.trailingAnchor constraintEqualToAnchor:self.collectionViewContainerView.trailingAnchor],
        [collectionView.leadingAnchor constraintEqualToAnchor:self.collectionViewContainerView.leadingAnchor],
        [collectionView.bottomAnchor constraintEqualToAnchor:self.collectionViewContainerView.bottomAnchor]
    ]];
    
    self.collectionView = collectionView;
}

- (void)cardDetailsLayoutAddCloseButton:(UIButton *)closeButton {
    if (closeButton.superview) {
        [closeButton removeFromSuperview];
    }
    
    [self.closeButtonContainerView addSubview:closeButton];
    closeButton.translatesAutoresizingMaskIntoConstraints = NO;
    [NSLayoutConstraint activateConstraints:@[
        [closeButton.topAnchor constraintEqualToAnchor:self.closeButtonContainerView.layoutMarginsGuide.topAnchor],
        [closeButton.trailingAnchor constraintEqualToAnchor:self.closeButtonContainerView.layoutMarginsGuide.trailingAnchor],
        [closeButton.leadingAnchor constraintEqualToAnchor:self.closeButtonContainerView.layoutMarginsGuide.leadingAnchor],
        [closeButton.bottomAnchor constraintEqualToAnchor:self.closeButtonContainerView.layoutMarginsGuide.bottomAnchor]
    ]];
    
    self.closeButton = closeButton;
}

- (void)cardDetailsLayoutRemovePrimaryImageView {
    [self.primaryImageView removeFromSuperview];
}

- (void)cardDetailsLayoutRemoveCollectionView {
    [self.collectionView removeFromSuperview];
}

- (void)cardDetailsLayoutRemoveCloseButton {
    [self.closeButton removeFromSuperview];
}

- (void)cardDetailsLayoutUpdateCollectionViewInsets {
    if ([self.collectionView.superview isEqual:self.collectionViewContainerView]) {
        self.collectionView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    }
}

@end
