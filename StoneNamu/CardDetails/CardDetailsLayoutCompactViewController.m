//
//  CardDetailsLayoutCompactViewController.m
//  CardDetailsLayoutCompactViewController
//
//  Created by Jinwoo Kim on 8/4/21.
//

#import "CardDetailsLayoutCompactViewController.h"

@interface CardDetailsLayoutCompactViewController ()
@property (retain) UIView *primaryImageViewContainerView;
@property (retain) UIView *collectionViewContainerView;
@property (retain) UIImageView * _Nullable primaryImageView;
@property (retain) UICollectionView * _Nullable collectionView;
@end

@implementation CardDetailsLayoutCompactViewController

- (instancetype)init {
    self = [super init];
    
    if (self) {
        self.primaryImageView = nil;
    }
    
    return self;
}

- (void)dealloc {
    [_primaryImageViewContainerView release];
    [_collectionViewContainerView release];
    [_primaryImageView release];
    [_collectionView release];
    [super dealloc];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configureContainerViews];
}

- (void)configureContainerViews {
    UIView *primaryImageViewContainerView = [UIView new];
    self.primaryImageViewContainerView = primaryImageViewContainerView;
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
    
    [primaryImageViewContainerView release];
    
    //
    
    UIView *collectionViewContainerView = [UIView new];
    self.collectionViewContainerView = collectionViewContainerView;
    [self.view addSubview:collectionViewContainerView];
    collectionViewContainerView.translatesAutoresizingMaskIntoConstraints = NO;
    [NSLayoutConstraint activateConstraints:@[
        [collectionViewContainerView.topAnchor constraintEqualToAnchor:primaryImageViewContainerView.bottomAnchor],
        [collectionViewContainerView.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor],
        [collectionViewContainerView.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor],
        [collectionViewContainerView.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor]
    ]];
    collectionViewContainerView.backgroundColor = UIColor.clearColor;
    
    [collectionViewContainerView release];
}

- (CGRect)estimatedPrimaryImageRectUsingWindow:(UIWindow *)window safeAreaInsets:(UIEdgeInsets)safeAreaInsets {
    CGFloat x = safeAreaInsets.left;
    CGFloat y = safeAreaInsets.top;
    CGFloat width = window.bounds.size.width - safeAreaInsets.left - safeAreaInsets.right;
    CGFloat height = (window.bounds.size.height / 2);
    return CGRectMake(x, y, width, height);
}

- (void)cardDetailsLayoutAddPrimaryImageView:(nonnull UIImageView *)primaryImageView {
    self.primaryImageView = primaryImageView;
    
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
}

- (void)cardDetailsLayoutAddCollectionView:(UICollectionView *)collectionView {
    self.collectionView = collectionView;
    
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
}

- (void)cardDetailsLayoutRemovePrimaryImageView {
    [self.primaryImageView removeFromSuperview];
}

- (void)cardDetailsLayoutRemoveCollectionView {
    [self.collectionView removeFromSuperview];
}

@end
