//
//  CardDetailsLayoutRegularViewController.m
//  CardDetailsLayoutRegularViewController
//
//  Created by Jinwoo Kim on 8/4/21.
//

#import "CardDetailsLayoutRegularViewController.h"

@interface CardDetailsLayoutRegularViewController ()
@property (retain) UIView *primaryImageViewContainerView;
@property (retain) UIView *closeButtonContainerView;
@property (retain) UIView *goldButtonContainerView;
@property (retain) UIView *collectionViewContainerView;
@property (retain) UIImageView * _Nullable primaryImageView;
@property (retain) UIButton * _Nullable closeButton;
@property (retain) UIButton * _Nullable goldButton;
@property (retain) UICollectionView * _Nullable collectionView;
@end

@implementation CardDetailsLayoutRegularViewController

- (instancetype)init {
    self = [super init];
    
    if (self) {
        self.primaryImageView = nil;
        self.closeButton = nil;
        self.goldButton = nil;
        self.collectionView = nil;
    }
    
    return self;
}

- (void)dealloc {
    [_primaryImageViewContainerView release];
    [_closeButtonContainerView release];
    [_goldButtonContainerView release];
    [_collectionViewContainerView release];
    [_primaryImageView release];
    [_closeButton release];
    [_goldButton release];
    [_collectionView release];
    [super dealloc];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configureContainerViews];
}

- (void)configureContainerViews {
    UIView *primaryImageViewContainerView = [UIView new];
    [self.view addSubview:primaryImageViewContainerView];
    primaryImageViewContainerView.translatesAutoresizingMaskIntoConstraints = NO;
    [NSLayoutConstraint activateConstraints:@[
        [primaryImageViewContainerView.topAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.topAnchor],
        [primaryImageViewContainerView.leadingAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.leadingAnchor],
        [primaryImageViewContainerView.bottomAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.bottomAnchor],
        [NSLayoutConstraint constraintWithItem:primaryImageViewContainerView
                                     attribute:NSLayoutAttributeWidth
                                     relatedBy:NSLayoutRelationEqual
                                        toItem:self.view
                                     attribute:NSLayoutAttributeWidth
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
        [closeButtonContainerView.topAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.topAnchor],
        [closeButtonContainerView.trailingAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.trailingAnchor],
        [closeButtonContainerView.widthAnchor constraintEqualToConstant:60.0f],
        [closeButtonContainerView.heightAnchor constraintEqualToConstant:60.0f]
    ]];
    closeButtonContainerView.backgroundColor = UIColor.clearColor;
    
    self.closeButtonContainerView = closeButtonContainerView;
    [closeButtonContainerView release];
    
    //
    
    UIView *goldButtonContainerView = [UIView new];
    [self.view addSubview:goldButtonContainerView];
    goldButtonContainerView.translatesAutoresizingMaskIntoConstraints = NO;
    [NSLayoutConstraint activateConstraints:@[
        [goldButtonContainerView.topAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.topAnchor],
        [goldButtonContainerView.leadingAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.leadingAnchor],
        [goldButtonContainerView.widthAnchor constraintEqualToConstant:60.0f],
        [goldButtonContainerView.heightAnchor constraintEqualToConstant:60.0f]
    ]];
    
    self.goldButtonContainerView = goldButtonContainerView;
    [goldButtonContainerView release];
    
    //
    
    UIView *collectionViewContainerView = [UIView new];
    [self.view addSubview:collectionViewContainerView];
    collectionViewContainerView.translatesAutoresizingMaskIntoConstraints = NO;
    [NSLayoutConstraint activateConstraints:@[
        [collectionViewContainerView.topAnchor constraintEqualToAnchor:self.view.topAnchor],
        [collectionViewContainerView.leadingAnchor constraintEqualToAnchor:primaryImageViewContainerView.trailingAnchor],
        [collectionViewContainerView.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor],
        [collectionViewContainerView.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor]
    ]];
    collectionViewContainerView.backgroundColor = UIColor.clearColor;
    
    self.collectionViewContainerView = collectionViewContainerView;
    [collectionViewContainerView release];
    
    //
    
    [self.view bringSubviewToFront:closeButtonContainerView];
}

- (CGRect)estimatedPrimaryImageRectUsingWindow:(UIWindow *)window safeAreaInsets:(UIEdgeInsets)safeAreaInsets {
    CGFloat x = safeAreaInsets.left;
    CGFloat y = safeAreaInsets.top;
    CGFloat width = (window.bounds.size.width / 2);
    CGFloat height = window.bounds.size.height - safeAreaInsets.top - safeAreaInsets.bottom;
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
        self.collectionView.contentInset = UIEdgeInsetsMake(self.closeButton.frame.origin.y + self.closeButton.frame.size.height,
                                                            0, 0, 0);
    }
}

@end
