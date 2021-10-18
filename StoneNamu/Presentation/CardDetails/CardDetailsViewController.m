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
#import "CardDetailsChildrenContentConfiguration.h"
#import "PhotosService.h"
#import "UIScrollView+scrollToTop.h"
#import "UIViewController+SpinnerView.h"
#import "NSIndexPath+identifier.h"
#import "UIViewController+targetedPreviewWithClearBackgroundForView.h"
#import "UIImage+imageWithGrayScale.h"
#import "DynamicAnimatedTransitioning.h"

@interface CardDetailsViewController () <UICollectionViewDelegate, UIViewControllerTransitioningDelegate, UIContextMenuInteractionDelegate, UIDragInteractionDelegate, CardDetailsChildrenContentConfigurationDelegate>
@property (retain) UIImageView * _Nullable sourceImageView;
@property (retain) UIImageView *primaryImageView;
@property (retain) UIButton *closeButton;
@property (retain) UICollectionView *collectionView;
@property (retain) UIViewController<CardDetailsLayoutProtocol> *compactViewController;
@property (retain) UIViewController<CardDetailsLayoutProtocol> *regularViewController;
@property (retain) NSArray<UIViewController<CardDetailsLayoutProtocol> *> *layoutViewControllers;
@property (assign, nonatomic, readonly) UIViewController<CardDetailsLayoutProtocol> * _Nullable currentLayoutViewController;
@property (retain) UIContextMenuInteraction *primaryImageViewInteraction;
@property (copy) HSCard *hsCard;
@property (retain) CardDetailsViewModel *viewModel;
@end

@implementation CardDetailsViewController

- (instancetype)initWithHSCard:(HSCard *)hsCard sourceImageView:(UIImageView * _Nullable)sourceImageView {
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
    [_closeButton release];
    [_compactViewController release];
    [_regularViewController release];
    [_layoutViewControllers release];
    [_primaryImageViewInteraction release];
    [_hsCard release];
    [_viewModel release];
    [super dealloc];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"hsCard.slug: %@, hsCard.cardId: %lu", self.hsCard.slug, self.hsCard.cardId);
    
    [self setAttributes];
    [self configurePrimaryImageView];
    [self configureCloseButton];
    [self configureCollectionView];
    [self configureLayoutViewControllers];
    [self configureViewModel];
    [self bind];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self updateCollectionViewAttributes];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.currentLayoutViewController cardDetailsLayoutUpdateCollectionViewInsets];
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (void)willTransitionToTraitCollection:(UITraitCollection *)newCollection withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator {
    [super willTransitionToTraitCollection:newCollection withTransitionCoordinator:coordinator];
    [self updateLayoutViewControllerWithTraitCollection:newCollection];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    [self.currentLayoutViewController cardDetailsLayoutUpdateCollectionViewInsets];
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
}

- (void)configurePrimaryImageView {
    UIImageView *primaryImageView = [UIImageView new];
    self.primaryImageView = primaryImageView;
    
    primaryImageView.userInteractionEnabled = YES;
    primaryImageView.contentMode = UIViewContentModeScaleAspectFit;
    
    if (self.sourceImageView.image == nil) {
        [primaryImageView setAsyncImageWithURL:self.hsCard.image indicator:YES];
    } else {
        if ((self.sourceImageView.image.isGrayScaleApplied) && (self.sourceImageView.image.imageBeforeGrayScale != nil)) {
            primaryImageView.image = self.sourceImageView.image.imageBeforeGrayScale;
        } else {
            primaryImageView.image = self.sourceImageView.image;
        }
    }
    
    //
    
    UIContextMenuInteraction *interaction = [[UIContextMenuInteraction alloc] initWithDelegate:self];
    self.primaryImageViewInteraction = interaction;
    [primaryImageView addInteraction:interaction];
    [interaction release];
    
    //
    
    UIDragInteraction *dragInteraction = [[UIDragInteraction alloc] initWithDelegate:self];
    [primaryImageView addInteraction:dragInteraction];
    [dragInteraction release];
    
    //
    
    [primaryImageView release];
}

- (void)configureCloseButton {
    UIBackgroundConfiguration *backgroundConfiguration = [UIBackgroundConfiguration clearConfiguration];
    UIVisualEffectView *blurView = [[UIVisualEffectView alloc] initWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleLight]];
    backgroundConfiguration.customView = blurView;
    backgroundConfiguration.backgroundColor = UIColor.clearColor;
    [blurView release];
    backgroundConfiguration.visualEffect = [UIVibrancyEffect effectForBlurEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleDark]];
    
    UIButtonConfiguration *buttonConfiguration = UIButtonConfiguration.tintedButtonConfiguration;
    buttonConfiguration.image = [UIImage systemImageNamed:@"xmark"];
    buttonConfiguration.cornerStyle = UIButtonConfigurationCornerStyleCapsule;
    buttonConfiguration.baseForegroundColor = UIColor.whiteColor;
    buttonConfiguration.background = backgroundConfiguration;
    
    UIAction *action = [UIAction actionWithHandler:^(__kindof UIAction * _Nonnull action) {
        [self dismissViewControllerAnimated:YES completion:^{}];
    }];
    
    UIButton *closeButton = [UIButton buttonWithConfiguration:buttonConfiguration primaryAction:action];
    self.closeButton = closeButton;
}

- (void)configureCollectionView {
    UICollectionLayoutListConfiguration *layoutConfiguration = [[UICollectionLayoutListConfiguration alloc] initWithAppearance:UICollectionLayoutListAppearanceInsetGrouped];
    layoutConfiguration.backgroundColor = UIColor.clearColor;
    layoutConfiguration.showsSeparators = YES;
    
    UIListSeparatorConfiguration *separatorConfiguration = [[UIListSeparatorConfiguration alloc] initWithListAppearance:UICollectionLayoutListAppearanceInsetGrouped];
    
    UIVibrancyEffect *effect = [UIVibrancyEffect effectForBlurEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleDark] style:UIVibrancyEffectStyleSeparator];
    separatorConfiguration.visualEffect = effect;
    
    layoutConfiguration.separatorConfiguration = separatorConfiguration;
    [separatorConfiguration release];
    
    UICollectionViewCompositionalLayout *layout = [UICollectionViewCompositionalLayout layoutWithListConfiguration:layoutConfiguration];
    [layoutConfiguration release];
    
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:layout];
    self.collectionView = collectionView;
    
    collectionView.delegate = self;
    collectionView.backgroundColor = UIColor.clearColor;
    
    collectionView.indicatorStyle = UIScrollViewIndicatorStyleWhite;
    
    [collectionView release];
}

- (void)updateCollectionViewAttributes {
    [self.collectionView.collectionViewLayout invalidateLayout];
    [self.collectionView scrollToTopAnimated:YES];
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

- (void)bind {
    [NSNotificationCenter.defaultCenter addObserver:self
                                           selector:@selector(startFetchingChildCardsReceived:)
                                               name:CardDetailsViewModelStartFetchingChildCardsNotificationName
                                             object:self.viewModel];
    
    [NSNotificationCenter.defaultCenter addObserver:self
                                           selector:@selector(fetchedChildCardsReceived:)
                                               name:CardDetailsViewModelStartFetchedChildCardsNotificationName
                                             object:self.viewModel];
}

- (void)startFetchingChildCardsReceived:(NSNotification *)notification {
    [NSOperationQueue.mainQueue addOperationWithBlock:^{
        [self addSpinnerView];
    }];
}

- (void)fetchedChildCardsReceived:(NSNotification *)notification {
    [NSOperationQueue.mainQueue addOperationWithBlock:^{
        [self removeAllSpinnerview];
    }];
}

- (void)updateLayoutViewControllerWithTraitCollection:(UITraitCollection *)trailtCollection {
    for (UIViewController<CardDetailsLayoutProtocol> *tmp in self.layoutViewControllers) {
        [tmp cardDetailsLayoutRemovePrimaryImageView];
        [tmp cardDetailsLayoutRemoveCloseButton];
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
    [targetLayoutViewController cardDetailsLayoutAddCloseButton:self.closeButton];
    [targetLayoutViewController cardDetailsLayoutAddCollectionView:self.collectionView];
    [targetLayoutViewController cardDetailsLayoutUpdateCollectionViewInsets];
    
    targetLayoutViewController.view.hidden = NO;
    
    [self.collectionView.collectionViewLayout invalidateLayout];
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
        
        //
        
        CardDetailsItemModel *itemModel = (CardDetailsItemModel *)item;
        
        switch (itemModel.type) {
            case CardDetailsItemModelTypeChildren: {
                NSArray<HSCard *> *childCards = (itemModel.childCards == nil) ? @[] : itemModel.childCards;
                CardDetailsChildrenContentConfiguration *configuration = [[CardDetailsChildrenContentConfiguration alloc] initwithChildCards:childCards];
                configuration.delegate = self;
                cell.contentConfiguration = configuration;
                [configuration release];
                break;
            }
            default: {
                CardDetailsBasicContentConfiguration *configuration = [[CardDetailsBasicContentConfiguration alloc] initWithLeadingText:itemModel.primaryText trailingText:itemModel.secondaryText];
                cell.contentConfiguration = configuration;
                [configuration release];
                break;
            }
        }
        
        
        //
        
        UIBackgroundConfiguration *backgroundConfiguration = [UIBackgroundConfiguration listGroupedCellConfiguration];
        backgroundConfiguration.backgroundColor = UIColor.clearColor;
        cell.backgroundConfiguration = backgroundConfiguration;
    }];
    
    return cellRegistration;
}

- (NSArray<UIDragItem *> *)makeDragItemsForPrimaryImageView {
    return [self.viewModel makeDragItemFromImage:self.primaryImageView.image];
}

- (UITargetedPreview *)targetedPreviewWithClearBackgroundFromIdentifier:(NSString *)identifier {
    NSIndexPath *indexPath = [NSIndexPath indexPathFromString:identifier];
    UICollectionViewCell *cell = [self.collectionView cellForItemAtIndexPath:indexPath];
    
    return [self targetedPreviewWithClearBackgroundForView:cell];
}

#pragma mark - UICollectionViewDelegate

- (UIContextMenuConfiguration *)collectionView:(UICollectionView *)collectionView contextMenuConfigurationForItemAtIndexPath:(NSIndexPath *)indexPath point:(CGPoint)point {
    
    CardDetailsItemModel * _Nullable itemModel = [self.viewModel.dataSource itemIdentifierForIndexPath:indexPath];
    if (itemModel == nil) return nil;
    if (itemModel.secondaryText == nil) return nil;
    if ([itemModel.secondaryText isEqualToString:@""]) return nil;
    
    UIContextMenuConfiguration *configuration = [UIContextMenuConfiguration configurationWithIdentifier:indexPath.identifier
                                                                                        previewProvider:nil
                                                                                         actionProvider:^UIMenu * _Nullable(NSArray<UIMenuElement *> * _Nonnull suggestedActions) {
        UIAction *copyAction = [UIAction actionWithTitle:NSLocalizedString(@"COPY", @"")
                                                   image:[UIImage systemImageNamed:@"doc.on.doc"]
                                              identifier:nil
                                                 handler:^(__kindof UIAction * _Nonnull action) {
            
            UIPasteboard.generalPasteboard.string = itemModel.secondaryText;
            }];
        
        UIMenu *menu = [UIMenu menuWithChildren:@[copyAction]];
        
        return menu;
    }];
    
    return configuration;
}

- (UITargetedPreview *)collectionView:(UICollectionView *)collectionView previewForHighlightingContextMenuWithConfiguration:(UIContextMenuConfiguration *)configuration {
    return [self targetedPreviewWithClearBackgroundFromIdentifier:(NSString *)configuration.identifier];
}

- (UITargetedPreview *)collectionView:(UICollectionView *)collectionView previewForDismissingContextMenuWithConfiguration:(UIContextMenuConfiguration *)configuration {
    return [self targetedPreviewWithClearBackgroundFromIdentifier:(NSString *)configuration.identifier];
}

#pragma mark - UIViewControllerTransitioningDelegate

- (UIPresentationController *)presentationControllerForPresentedViewController:(UIViewController *)presented presentingViewController:(UIViewController *)presenting sourceViewController:(UIViewController *)source {
    
    [self updateLayoutViewControllerWithTraitCollection:source.view.window.traitCollection];
    CGRect destinationRect = [self.currentLayoutViewController estimatedPrimaryImageRectUsingWindow:source.view.window
                                                                                     safeAreaInsets:source.view.window.safeAreaInsets];
    
    DynamicPresentationController *pc = [[DynamicPresentationController alloc] initWithPresentedViewController:presented
                                                                                      presentingViewController:presenting
                                                                                                    sourceView:self.sourceImageView
                                                                                                    targetView:self.primaryImageView
                                                                                               destinationRect:destinationRect];
    
    [pc autorelease];
    
    return pc;
}

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source {
    DynamicAnimatedTransitioning *animator = [[DynamicAnimatedTransitioning alloc] initWithIsPresenting:YES];
    [animator autorelease];
    return animator;
}

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed {
    DynamicAnimatedTransitioning *animator = [[DynamicAnimatedTransitioning alloc] initWithIsPresenting:NO];
    [animator autorelease];
    return animator;
}

#pragma mark - UIContextMenuInteractionDelegate

- (nullable UIContextMenuConfiguration *)contextMenuInteraction:(nonnull UIContextMenuInteraction *)interaction configurationForMenuAtLocation:(CGPoint)location {
    UIContextMenuConfiguration *configuration = [UIContextMenuConfiguration configurationWithIdentifier:nil
                                                                                        previewProvider:nil
                                                                                         actionProvider:^UIMenu * _Nullable(NSArray<UIMenuElement *> * _Nonnull suggestedActions) {
        
        UIAction *saveAction = [UIAction actionWithTitle:NSLocalizedString(@"SAVE", @"")
                                                   image:[UIImage systemImageNamed:@"square.and.arrow.down"]
                                              identifier:nil
                                                 handler:^(__kindof UIAction * _Nonnull action) {
            [PhotosService.sharedInstance saveImageURL:self.hsCard.image fromViewController:self completionHandler:^(BOOL success, NSError * _Nonnull error) {}];
        }];
        
        UIMenu *menu = [UIMenu menuWithTitle:self.hsCard.name
                                    children:@[saveAction]];
        
        return menu;
    }];
    
    return configuration;
}

#pragma mark - UIDragInteractionDelegate

- (NSArray<UIDragItem *> *)dragInteraction:(UIDragInteraction *)interaction itemsForBeginningSession:(id<UIDragSession>)session {
    return [self makeDragItemsForPrimaryImageView];
}

- (NSArray<UIDragItem *> *)dragInteraction:(UIDragInteraction *)interaction itemsForAddingToSession:(id<UIDragSession>)session withTouchAtPoint:(CGPoint)point {
    return [self makeDragItemsForPrimaryImageView];
}

#pragma mark - CardDetailsChildrenContentConfigurationDelegate

- (void)cardDetailsChildrenContentConfigurationDidTapImageView:(UIImageView *)imageView hsCard:(HSCard *)hsCard {
    CardDetailsViewController *vc = [[CardDetailsViewController alloc] initWithHSCard:hsCard sourceImageView:imageView];
    [vc autorelease];
    [vc loadViewIfNeeded];
    [self presentViewController:vc animated:YES completion:^{}];
}

@end
