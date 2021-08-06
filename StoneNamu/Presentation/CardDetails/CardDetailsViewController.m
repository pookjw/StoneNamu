//
//  CardDetailsViewController.m
//  CardDetailsViewController
//
//  Created by Jinwoo Kim on 8/2/21.
//

#import "CardDetailsViewController.h"
#import "DynamicPresentationController.h"
#import "UIImageView+setAsyncImage.h"
#import "CardDetailsLayoutCompactViewController.h"
#import "CardDetailsLayoutRegularViewController.h"
#import "CardDetailsViewModel.h"
#import "CardDetailsBasicContentConfiguration.h"

@interface CardDetailsViewController () <UIViewControllerTransitioningDelegate>
@property (retain) UIImageView *sourceImageView;
@property (retain) UIImageView *primaryImageView;
@property (retain) UICollectionView *collectionView;
@property (retain) UIViewController<CardDetailsLayoutProtocol> *compactViewController;
@property (retain) UIViewController<CardDetailsLayoutProtocol> *regularViewController;
@property (retain) NSArray<UIViewController<CardDetailsLayoutProtocol> *> *layoutViewControllers;
@property (assign, nonatomic) UIViewController<CardDetailsLayoutProtocol> * _Nullable currentLayoutViewController;
@property (copy) HSCard *hsCard;
@property (retain) CardDetailsViewModel *viewModel;
@end

@implementation CardDetailsViewController

- (instancetype)initWithHSCard:(HSCard *)hsCard sourceImageView:(UIImageView *)sourceImageView {
    self = [self init];
    
    if (self) {
        self.sourceImageView = sourceImageView;
        self.hsCard = hsCard;
    }
    
    return self;
}

- (void)dealloc {
    [_sourceImageView release];
    [_primaryImageView release];
    [_collectionView release];
    [_compactViewController release];
    [_regularViewController release];
    [_layoutViewControllers release];
    [_hsCard release];
    [_viewModel release];
    [super dealloc];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"hsCard.slug: %@", self.hsCard.slug);
    
    [self setAttributes];
    [self configurePrimaryImageView];
    [self configureCollectionView];
    [self configureLayoutViewControllers];
    [self configureViewModel];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self updateLayoutViewControllerWithTraitCollection:self.traitCollection];
    [self updateCollectionViewWhenDidAppear];
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (void)willTransitionToTraitCollection:(UITraitCollection *)newCollection withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator {
    [super willTransitionToTraitCollection:newCollection withTransitionCoordinator:coordinator];
    [self updateLayoutViewControllerWithTraitCollection:newCollection];
}

- (UIViewController<CardDetailsLayoutProtocol> * _Nullable)currentLayoutViewController {
    UIViewController<CardDetailsLayoutProtocol> * _Nullable current = nil;
    
    for (UIViewController<CardDetailsLayoutProtocol> *tmp in self.layoutViewControllers) {
        if (!tmp.view.isHidden) {
            current = tmp;
            break;
        }
    }
    
    return current;
}

- (void)setAttributes {
    self.modalPresentationStyle = UIModalPresentationCustom;
    self.transitioningDelegate = self;
    self.modalPresentationCapturesStatusBarAppearance = YES;
    self.view.backgroundColor = UIColor.clearColor;
    
    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(triggeredViewTapGesgure:)];
    [self.view addGestureRecognizer:gesture];
    [gesture release];
}

- (void)triggeredViewTapGesgure:(UITapGestureRecognizer *)sender {
    [self dismissViewControllerAnimated:YES completion:^{}];
}

- (void)configurePrimaryImageView {
    UIImageView *primaryImageView = [UIImageView new];
    self.primaryImageView = primaryImageView;
    
    primaryImageView.contentMode = UIViewContentModeScaleAspectFit;
    
    if (self.sourceImageView.image) {
        primaryImageView.image = self.sourceImageView.image;
    } else {
        [primaryImageView setAsyncImageWithURL:self.hsCard.image indicator:YES];
    }

    primaryImageView.userInteractionEnabled = NO;
    
    [primaryImageView release];
}

- (void)configureCollectionView {
    UICollectionLayoutListConfiguration *layoutConfiguration = [[UICollectionLayoutListConfiguration alloc] initWithAppearance:UICollectionLayoutListAppearanceInsetGrouped];
    layoutConfiguration.backgroundColor = UIColor.clearColor;
    layoutConfiguration.showsSeparators = YES;
    
    if (@available(iOS 14.5, *)) {
        UIListSeparatorConfiguration *separatorConfiguration = [[UIListSeparatorConfiguration alloc] initWithListAppearance:UICollectionLayoutListAppearanceInsetGrouped];
        
        if (@available(iOS 15.0, *)) {
            UIVibrancyEffect *effect = [UIVibrancyEffect effectForBlurEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleDark] style:UIVibrancyEffectStyleSeparator];
            separatorConfiguration.visualEffect = effect;
        } else {
            separatorConfiguration.color = [UIColor.whiteColor colorWithAlphaComponent:0.5];
        }
        
        layoutConfiguration.separatorConfiguration = separatorConfiguration;
        [separatorConfiguration release];
    }
    
    UICollectionViewCompositionalLayout *layout = [UICollectionViewCompositionalLayout layoutWithListConfiguration:layoutConfiguration];
    [layoutConfiguration release];
    
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:layout];
    self.collectionView = collectionView;
    
    collectionView.backgroundColor = UIColor.clearColor;
    collectionView.alpha = 0;
    
    collectionView.indicatorStyle = UIScrollViewIndicatorStyleWhite;
    
    [collectionView release];
}

- (void)updateCollectionViewWhenDidAppear {
    [UIView animateWithDuration:0.2 animations:^{
        self.collectionView.alpha = 1;
    }];
    [self.collectionView.collectionViewLayout invalidateLayout];
}

- (void)configureLayoutViewControllers {
    CardDetailsLayoutCompactViewController *compactViewController = [CardDetailsLayoutCompactViewController new];
    self.compactViewController = compactViewController;
    [compactViewController loadViewIfNeeded];
    [self addChildViewController:compactViewController];
    [self.view addSubview:compactViewController.view];
    compactViewController.view.translatesAutoresizingMaskIntoConstraints = NO;
    [NSLayoutConstraint activateConstraints:@[
        [compactViewController.view.topAnchor constraintEqualToAnchor:self.view.topAnchor],
        [compactViewController.view.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor],
        [compactViewController.view.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor],
        [compactViewController.view.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor]
    ]];
    
    CardDetailsLayoutRegularViewController *regularViewController = [CardDetailsLayoutRegularViewController new];
    self.regularViewController = regularViewController;
    [regularViewController loadViewIfNeeded];
    [self addChildViewController:regularViewController];
    [self.view addSubview:regularViewController.view];
    regularViewController.view.translatesAutoresizingMaskIntoConstraints = NO;
    [NSLayoutConstraint activateConstraints:@[
        [regularViewController.view.topAnchor constraintEqualToAnchor:self.view.topAnchor],
        [regularViewController.view.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor],
        [regularViewController.view.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor],
        [regularViewController.view.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor]
    ]];
    
    self.layoutViewControllers = @[compactViewController, regularViewController];
    
    [self updateLayoutViewControllerWithTraitCollection:self.view.traitCollection];
    
    [compactViewController release];
    [regularViewController release];
}

- (void)configureViewModel {
    CardDetailsViewModel *viewModel = [[CardDetailsViewModel alloc] initWithDataSource:[self makeDataSource]];
    self.viewModel = viewModel;
    
    [viewModel requestDataSourceWithCard:self.hsCard];
    
    [viewModel release];
}

- (void)updateLayoutViewControllerWithTraitCollection:(UITraitCollection *)trailtCollection {
    for (UIViewController<CardDetailsLayoutProtocol> *tmp in self.layoutViewControllers) {
        [tmp cardDetailsLayoutRemovePrimaryImageView];
        [tmp cardDetailsLayoutRemoveCollectionView];
        tmp.view.hidden = YES;
    }
    
    UIViewController<CardDetailsLayoutProtocol> *targetLayoutViewController;
    UIUserInterfaceSizeClass sizeClass = trailtCollection.horizontalSizeClass;
    
    switch (sizeClass) {
        case UIUserInterfaceSizeClassCompact:
            targetLayoutViewController = self.compactViewController;
            break;
        case UIUserInterfaceSizeClassRegular:
            targetLayoutViewController = self.regularViewController;
            break;
        default:
            targetLayoutViewController = self.compactViewController;
            break;
    }
    
    [targetLayoutViewController cardDetailsLayoutAddPrimaryImageView:self.primaryImageView];
    [targetLayoutViewController cardDetailsLayoutAddCollectionView:self.collectionView];
    
    targetLayoutViewController.view.hidden = NO;
}

- (CardDetailsDataSource *)makeDataSource {
    UICollectionViewCellRegistration *cellRegistration = [self makeCellRegistration];
    
    CardDetailsDataSource *dataSource = [[CardDetailsDataSource alloc] initWithCollectionView:self.collectionView
                                                                     cellProvider:^UICollectionViewCell * _Nullable(UICollectionView * _Nonnull collectionView, NSIndexPath * _Nonnull indexPath, id  _Nonnull itemIdentifier) {
        
        UICollectionViewCell *cell = [collectionView dequeueConfiguredReusableCellWithRegistration:cellRegistration
                                                                                      forIndexPath:indexPath
                                                                                              item:itemIdentifier];
        return cell;
    }];
    
    [dataSource autorelease];
    return dataSource;
}

- (UICollectionViewCellRegistration *)makeCellRegistration {
    UICollectionViewCellRegistration *cellRegistration = [UICollectionViewCellRegistration registrationWithCellClass:[UICollectionViewListCell class]
                                                                                                configurationHandler:^(__kindof UICollectionViewListCell * _Nonnull cell, NSIndexPath * _Nonnull indexPath, id  _Nonnull item) {
        if (![item isKindOfClass:[CardDetailsItemModel class]]) {
            return;
        }
        CardDetailsItemModel *itemModel = (CardDetailsItemModel *)item;
        
        CardDetailsBasicContentConfiguration *configuration = [[CardDetailsBasicContentConfiguration alloc] initWithLeadingText:itemModel.primaryText trailingText:itemModel.secondaryText];
        cell.contentConfiguration = configuration;
        
        UIBackgroundConfiguration *backgroundConfiguration = [UIBackgroundConfiguration listGroupedCellConfiguration];
        backgroundConfiguration.backgroundColor = UIColor.clearColor;
        cell.backgroundConfiguration = backgroundConfiguration;
        
        [configuration release];
    }];
    
    return cellRegistration;
}

#pragma mark - UIViewControllerTransitioningDelegate
- (UIPresentationController *)presentationControllerForPresentedViewController:(UIViewController *)presented presentingViewController:(UIViewController *)presenting sourceViewController:(UIViewController *)source {
    
    CGRect destinationRect = [self.currentLayoutViewController estimatedPrimaryImageRectUsingWindow:source.view.window
                                                                                     safeAreaInsets:source.view.superview.safeAreaInsets];
    
    DynamicPresentationController *pc = [[DynamicPresentationController alloc] initWithPresentedViewController:presented
                                                                                      presentingViewController:presenting
                                                                                                    sourceView:self.sourceImageView
                                                                                                    targetView:self.primaryImageView
                                                                                               destinationRect:destinationRect];
    
    [pc autorelease];
    
    return pc;
}

@end
