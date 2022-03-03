//
//  CardDetailsViewController.m
//  CardDetailsViewController
//
//  Created by Jinwoo Kim on 8/2/21.
//

#import "CardDetailsViewController.h"
#import "DynamicPresentationController.h"
#import "UIImageView+setAsyncImage.h"
#import "CardDetailsCollectionViewLayout.h"
#import "CardDetailsLayoutCompactViewController.h"
#import "CardDetailsLayoutRegularViewController.h"
#import "CardDetailsViewModel.h"
#import "CardDetailsBasicContentConfiguration.h"
#import "CardDetailsChildContentConfiguration.h"
#import "PhotosService.h"
#import "UIScrollView+scrollToTop.h"
#import "UIViewController+SpinnerView.h"
#import "NSIndexPath+identifier.h"
#import "UIViewController+targetedPreviewWithClearBackgroundForView.h"
#import "UIImage+imageWithGrayScale.h"
#import "DynamicAnimatedTransitioning.h"
#import "CardDetailsChildContentView.h"
#import <StoneNamuResources/StoneNamuResources.h>

@interface CardDetailsViewController () <UICollectionViewDelegate, UICollectionViewDragDelegate, UIViewControllerTransitioningDelegate, UIContextMenuInteractionDelegate, UIDragInteractionDelegate>
@property (retain) UIImageView * _Nullable sourceImageView;
@property (retain) UIImageView *primaryImageView;
@property (retain) UIButton *closeButton;
@property (retain) UICollectionView *collectionView;
@property (retain) UIViewController<CardDetailsLayoutProtocol> *compactViewController;
@property (retain) UIViewController<CardDetailsLayoutProtocol> *regularViewController;
@property (retain) NSArray<UIViewController<CardDetailsLayoutProtocol> *> *layoutViewControllers;
@property (assign, nonatomic, readonly) UIViewController<CardDetailsLayoutProtocol> * _Nullable currentLayoutViewController;
@property (retain) UIContextMenuInteraction *primaryImageViewInteraction;
@property (retain) CardDetailsViewModel *viewModel;
@end

@implementation CardDetailsViewController

- (instancetype)initWithHSCard:(HSCard * _Nullable)hsCard hsGameModeSlugType:(HSCardGameModeSlugType)hsCardGameModeSlugType isGold:(BOOL)isGold sourceImageView:(UIImageView * _Nullable)sourceImageView {
    self = [self init];
    
    if (self) {
        self.sourceImageView = sourceImageView;
        [self loadViewIfNeeded];
        
        self.viewModel.hsCardGameModeSlugType = hsCardGameModeSlugType;
        self.viewModel.isGold = isGold;
        
        if (hsCard) {
            [self requestHSCard:hsCard];
        }
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
    [_viewModel release];
    [super dealloc];
}

- (void)viewDidLoad {
    [super viewDidLoad];
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
    [self animateCollectionViewWhenDidAppear];
    [self.currentLayoutViewController cardDetailsLayoutUpdateCollectionViewInsets];
    [self updateLayoutViewControllerWithTraitCollection:self.traitCollection];
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

- (void)requestHSCard:(HSCard *)hsCard  {
    [self.viewModel requestDataSourceWithCard:hsCard];
    [self loadPrimaryImage];
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
    
    primaryImageView.userInteractionEnabled = YES;
    primaryImageView.contentMode = UIViewContentModeScaleAspectFit;
    
    //
    
    UIContextMenuInteraction *interaction = [[UIContextMenuInteraction alloc] initWithDelegate:self];
    [primaryImageView addInteraction:interaction];
    self.primaryImageViewInteraction = interaction;
    [interaction release];
    
    //
    
    UIDragInteraction *dragInteraction = [[UIDragInteraction alloc] initWithDelegate:self];
    [primaryImageView addInteraction:dragInteraction];
    [dragInteraction release];
    
    //
    
    self.primaryImageView = primaryImageView;
    [primaryImageView release];
}

- (void)configureCloseButton {
    UIBackgroundConfiguration *backgroundConfiguration = [UIBackgroundConfiguration clearConfiguration];
    UIVisualEffectView *blurView = [[UIVisualEffectView alloc] initWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleLight]];
    backgroundConfiguration.customView = blurView;
    [blurView release];
    
    backgroundConfiguration.backgroundColor = UIColor.clearColor;
    backgroundConfiguration.visualEffect = [UIVibrancyEffect effectForBlurEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleDark]];
    
    UIButtonConfiguration *buttonConfiguration = UIButtonConfiguration.tintedButtonConfiguration;
    buttonConfiguration.image = [UIImage systemImageNamed:@"xmark"];
    buttonConfiguration.cornerStyle = UIButtonConfigurationCornerStyleCapsule;
    buttonConfiguration.baseForegroundColor = UIColor.whiteColor;
    buttonConfiguration.background = backgroundConfiguration;
    
    CardDetailsViewController * __block unretainedSelf = self;
    
    UIAction *action = [UIAction actionWithHandler:^(__kindof UIAction * _Nonnull action) {
        [unretainedSelf dismissViewControllerAnimated:YES completion:^{}];
    }];
    
    UIButton *closeButton = [UIButton buttonWithConfiguration:buttonConfiguration primaryAction:action];
    self.closeButton = closeButton;
}

- (void)configureCollectionView {
    CardDetailsCollectionViewLayout *layout = [CardDetailsCollectionViewLayout new];
    
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:layout];
    [layout release];
    
    collectionView.delegate = self;
    collectionView.dragDelegate = self;
    collectionView.backgroundColor = UIColor.clearColor;
    collectionView.alpha = 0.0f;
    collectionView.indicatorStyle = UIScrollViewIndicatorStyleWhite;
    
    self.collectionView = collectionView;
    [collectionView release];
}

- (void)updateCollectionViewAttributes {
    [self.collectionView.collectionViewLayout invalidateLayout];
    [self.collectionView scrollToTopAnimated:YES];
}

- (void)configureLayoutViewControllers {
    CardDetailsLayoutCompactViewController *compactViewController = [CardDetailsLayoutCompactViewController new];
    [compactViewController loadViewIfNeeded];
    [compactViewController willMoveToParentViewController:self];
    [self addChildViewController:compactViewController];
    [self.view addSubview:compactViewController.view];
    compactViewController.view.translatesAutoresizingMaskIntoConstraints = NO;
    [NSLayoutConstraint activateConstraints:@[
        [compactViewController.view.topAnchor constraintEqualToAnchor:self.view.topAnchor],
        [compactViewController.view.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor],
        [compactViewController.view.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor],
        [compactViewController.view.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor]
    ]];
    [compactViewController didMoveToParentViewController:self];
    
    CardDetailsLayoutRegularViewController *regularViewController = [CardDetailsLayoutRegularViewController new];
    [regularViewController loadViewIfNeeded];
    [regularViewController willMoveToParentViewController:self];
    [self addChildViewController:regularViewController];
    [self.view addSubview:regularViewController.view];
    regularViewController.view.translatesAutoresizingMaskIntoConstraints = NO;
    [NSLayoutConstraint activateConstraints:@[
        [regularViewController.view.topAnchor constraintEqualToAnchor:self.view.topAnchor],
        [regularViewController.view.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor],
        [regularViewController.view.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor],
        [regularViewController.view.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor]
    ]];
    [regularViewController didMoveToParentViewController:self];
    
    self.layoutViewControllers = @[compactViewController, regularViewController];
    self.compactViewController = compactViewController;
    self.regularViewController = regularViewController;
    
    [self updateLayoutViewControllerWithTraitCollection:self.view.traitCollection];
    [compactViewController release];
    [regularViewController release];
}

- (void)configureViewModel {
    CardDetailsViewModel *viewModel = [[CardDetailsViewModel alloc] initWithDataSource:[self makeDataSource]];
    self.viewModel = viewModel;
    [viewModel release];
}

- (void)loadPrimaryImage {
    if (self.sourceImageView.image == nil) {
        [self.viewModel preferredImageURLWithCompletion:^(NSURL * _Nullable url) {
            [NSOperationQueue.mainQueue addOperationWithBlock:^{
                if (url) {
                    [self.primaryImageView setAsyncImageWithURL:url indicator:YES];
                } else {
                    [self.primaryImageView clearSetAsyncImageContexts];
                    self.primaryImageView.image = nil;
                }
            }];
        }];
    } else {
        [self.primaryImageView clearSetAsyncImageContexts];
        
        if ((self.sourceImageView.image.isGrayScaleApplied) && (self.sourceImageView.image.imageBeforeGrayScale != nil)) {
            self.primaryImageView.image = self.sourceImageView.image.imageBeforeGrayScale;
        } else {
            self.primaryImageView.image = self.sourceImageView.image;
        }
    }
}

- (void)bind {
    [NSNotificationCenter.defaultCenter addObserver:self
                                           selector:@selector(startedLoadingDataSourceReceived:)
                                               name:NSNotificationNameCardDetailsViewModelStartedLoadingDataSource
                                             object:self.viewModel];
    
    [NSNotificationCenter.defaultCenter addObserver:self
                                           selector:@selector(endedLoadingDataSourceReceived:)
                                               name:NSNotificationNameCardDetailsViewModelEndedLoadingDataSource
                                             object:self.viewModel];
}

- (void)startedLoadingDataSourceReceived:(NSNotification *)notification {
    [NSOperationQueue.mainQueue addOperationWithBlock:^{
        [self addSpinnerView];
    }];
}

- (void)endedLoadingDataSourceReceived:(NSNotification *)notification {
    [NSOperationQueue.mainQueue addOperationWithBlock:^{
        [self removeAllSpinnerview];
    }];
}

- (void)updateLayoutViewControllerWithTraitCollection:(UITraitCollection *)traitCollection {
    for (UIViewController<CardDetailsLayoutProtocol> *tmp in self.layoutViewControllers) {
        [tmp cardDetailsLayoutRemovePrimaryImageView];
        [tmp cardDetailsLayoutRemoveCloseButton];
        [tmp cardDetailsLayoutRemoveCollectionView];
        tmp.view.hidden = YES;
    }
    
    UIViewController<CardDetailsLayoutProtocol> *targetLayoutViewController;
    UIUserInterfaceSizeClass sizeClass = traitCollection.horizontalSizeClass;
    
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

- (void)animateCollectionViewWhenDidAppear {
    [UIView animateWithDuration:0.3
                          delay:0
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
        self.collectionView.alpha = 1.0f;
    } completion:^(BOOL finished) {
        
    }];
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
    
    return [dataSource autorelease];
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
            case CardDetailsItemModelTypeChild: {
                CardDetailsChildContentConfiguration *configuration = [[CardDetailsChildContentConfiguration alloc] initWithHSCard:itemModel.childHSCard imageURL:itemModel.imageURL];
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
    return [self.viewModel makeDragItemFromImage:self.primaryImageView.image indexPath:nil];
}

- (NSArray<UIDragItem *> *)makeDragItemsFromIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewListCell * _Nullable cell = (UICollectionViewListCell *)[self.collectionView cellForItemAtIndexPath:indexPath];
    
    UIImage * _Nullable image = nil;
    
    CardDetailsChildContentView *contentView = (CardDetailsChildContentView *)cell.contentView;
    if ([contentView isKindOfClass:[CardDetailsChildContentView class]]) {
        image = contentView.imageView.image;
    }
    
    return [self.viewModel makeDragItemFromImage:image indexPath:indexPath];
}

- (UITargetedPreview *)targetedPreviewWithClearBackgroundFromIdentifier:(NSString *)identifier {
    NSIndexPath *indexPath = [NSIndexPath indexPathFromString:identifier];
    UICollectionViewCell *cell = [self.collectionView cellForItemAtIndexPath:indexPath];
    
    return [self targetedPreviewWithClearBackgroundForView:cell];
}

- (void)presentCardDetailsViewControllerFromIndexPath:(NSIndexPath *)indexPath {
    [self.viewModel itemModelsFromIndexPaths:[NSSet setWithObject:indexPath] completion:^(NSDictionary<NSIndexPath *, CardDetailsItemModel *> * _Nonnull itemModels) {
        [itemModels enumerateKeysAndObjectsUsingBlock:^(NSIndexPath * _Nonnull key, CardDetailsItemModel * _Nonnull obj, BOOL * _Nonnull stop) {
            if (obj.childHSCard == nil) return;
            
            [NSOperationQueue.mainQueue addOperationWithBlock:^{
                UICollectionViewListCell * _Nullable cell = (UICollectionViewListCell *)[self.collectionView cellForItemAtIndexPath:key];
                if (cell == nil) return;
                CardDetailsChildContentView *contentView = (CardDetailsChildContentView *)cell.contentView;
                if (![contentView isKindOfClass:[CardDetailsChildContentView class]]) return;
                
                //
                
                HSCard *hsCard = obj.childHSCard;
                
                CardDetailsViewController *vc = [[CardDetailsViewController alloc] initWithHSCard:hsCard hsGameModeSlugType:self.viewModel.hsCardGameModeSlugType isGold:obj.isGold sourceImageView:contentView.imageView];
                [vc loadViewIfNeeded];
                [self presentViewController:vc animated:YES completion:^{}];
                [vc release];
            }];
        }];
    }];
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [self presentCardDetailsViewControllerFromIndexPath:indexPath];
}

- (UIContextMenuConfiguration *)collectionView:(UICollectionView *)collectionView contextMenuConfigurationForItemAtIndexPath:(NSIndexPath *)indexPath point:(CGPoint)point {
    
    self.viewModel.contextMenuIndexPath = nil;
    
    CardDetailsItemModel * _Nullable itemModel = [self.viewModel.dataSource itemIdentifierForIndexPath:indexPath];
    if (itemModel == nil) return nil;
    
    switch (itemModel.type) {
        case CardDetailsItemModelTypeChild: {
            if (itemModel.childHSCard == nil) return nil;
            self.viewModel.contextMenuIndexPath = indexPath;
            
            UIContextMenuConfiguration *configuration = [UIContextMenuConfiguration configurationWithIdentifier:indexPath.identifier
                                                                                                previewProvider:nil
                                                                                                 actionProvider:^UIMenu * _Nullable(NSArray<UIMenuElement *> * _Nonnull suggestedActions) {
                
                UIAction *saveAction = [UIAction actionWithTitle:[ResourcesService localizationForKey:LocalizableKeySave]
                                                           image:[UIImage systemImageNamed:@"square.and.arrow.down"]
                                                      identifier:nil
                                                         handler:^(__kindof UIAction * _Nonnull action) {
                    PhotosService *photosService = [[PhotosService alloc] initWithHSCards:[NSSet setWithObject:itemModel.childHSCard] hsGameModeSlugType:self.viewModel.hsCardGameModeSlugType isGold:itemModel.isGold];
                    [photosService beginSavingFromViewController:self completion:^(BOOL success, NSError * _Nullable error) {}];
                    [photosService release];
                }];
                
                UIAction *shareAction = [UIAction actionWithTitle:[ResourcesService localizationForKey:LocalizableKeyShare]
                                                            image:[UIImage systemImageNamed:@"square.and.arrow.up"]
                                                       identifier:nil
                                                          handler:^(__kindof UIAction * _Nonnull action) {
                    PhotosService *photosService = [[PhotosService alloc] initWithHSCards:[NSSet setWithObject:itemModel.childHSCard] hsGameModeSlugType:self.viewModel.hsCardGameModeSlugType isGold:itemModel.isGold];
                    [photosService beginSharingFromViewController:self completion:^(BOOL success, NSError * _Nullable error) {}];
                    [photosService release];
                }];
                
                UIMenu *menu = [UIMenu menuWithTitle:itemModel.childHSCard.name
                                            children:@[saveAction, shareAction]];
                
                return menu;
            }];
               
            return configuration;
        }
        default: {
            if (itemModel.secondaryText == nil) return nil;
            if ([itemModel.secondaryText isEqualToString:@""]) return nil;
            self.viewModel.contextMenuIndexPath = indexPath;
            
            UIContextMenuConfiguration *configuration = [UIContextMenuConfiguration configurationWithIdentifier:indexPath.identifier
                                                                                                previewProvider:nil
                                                                                                 actionProvider:^UIMenu * _Nullable(NSArray<UIMenuElement *> * _Nonnull suggestedActions) {
                UIAction *copyAction = [UIAction actionWithTitle:[ResourcesService localizationForKey:LocalizableKeyCopy]
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
    }
}

- (UITargetedPreview *)collectionView:(UICollectionView *)collectionView previewForHighlightingContextMenuWithConfiguration:(UIContextMenuConfiguration *)configuration {
    return [self targetedPreviewWithClearBackgroundFromIdentifier:(NSString *)configuration.identifier];
}

- (UITargetedPreview *)collectionView:(UICollectionView *)collectionView previewForDismissingContextMenuWithConfiguration:(UIContextMenuConfiguration *)configuration {
    return [self targetedPreviewWithClearBackgroundFromIdentifier:(NSString *)configuration.identifier];
}

- (void)collectionView:(UICollectionView *)collectionView willEndContextMenuInteractionWithConfiguration:(UIContextMenuConfiguration *)configuration animator:(id<UIContextMenuInteractionAnimating>)animator {
    [animator addCompletion:^{
        self.viewModel.contextMenuIndexPath = nil;
    }];
}

- (void)collectionView:(UICollectionView *)collectionView willPerformPreviewActionForMenuWithConfiguration:(UIContextMenuConfiguration *)configuration animator:(id<UIContextMenuInteractionCommitAnimating>)animator {
    NSIndexPath * _Nullable indexPath = self.viewModel.contextMenuIndexPath;
    
    if (indexPath == nil) {
        return;
    }
    
    [animator addAnimations:^{
        [self presentCardDetailsViewControllerFromIndexPath:indexPath];
    }];
}

#pragma mark - UICollectionViewDragDelegate

- (NSArray<UIDragItem *> *)collectionView:(UICollectionView *)collectionView itemsForBeginningDragSession:(id<UIDragSession>)session atIndexPath:(NSIndexPath *)indexPath {
    return [self makeDragItemsFromIndexPath:indexPath];
}

- (NSArray<UIDragItem *> *)collectionView:(UICollectionView *)collectionView itemsForAddingToDragSession:(id<UIDragSession>)session atIndexPath:(NSIndexPath *)indexPath point:(CGPoint)point {
    return [self makeDragItemsFromIndexPath:indexPath];
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
    CardDetailsViewController * __block unretainedSelf = self;
    
    UIContextMenuConfiguration *configuration = [UIContextMenuConfiguration configurationWithIdentifier:nil
                                                                                        previewProvider:nil
                                                                                         actionProvider:^UIMenu * _Nullable(NSArray<UIMenuElement *> * _Nonnull suggestedActions) {
        
        UIAction *saveAction = [UIAction actionWithTitle:[ResourcesService localizationForKey:LocalizableKeySave]
                                                   image:[UIImage systemImageNamed:@"square.and.arrow.down"]
                                              identifier:nil
                                                 handler:^(__kindof UIAction * _Nonnull action) {
            PhotosService *photosService = [[PhotosService alloc] initWithHSCards:[NSSet setWithObject:unretainedSelf.viewModel.hsCard] hsGameModeSlugType:unretainedSelf.viewModel.hsCardGameModeSlugType isGold:unretainedSelf.viewModel.isGold];
            [photosService beginSavingFromViewController:self completion:^(BOOL success, NSError * _Nullable error) {}];
            [photosService release];
        }];
        
        UIAction *shareAction = [UIAction actionWithTitle:[ResourcesService localizationForKey:LocalizableKeyShare]
                                                    image:[UIImage systemImageNamed:@"square.and.arrow.up"]
                                               identifier:nil
                                                  handler:^(__kindof UIAction * _Nonnull action) {
            PhotosService *photosService = [[PhotosService alloc] initWithHSCards:[NSSet setWithObject:unretainedSelf.viewModel.hsCard] hsGameModeSlugType:unretainedSelf.viewModel.hsCardGameModeSlugType isGold:unretainedSelf.viewModel.isGold];
            [photosService beginSharingFromViewController:self completion:^(BOOL success, NSError * _Nullable error) {}];
            [photosService release];
        }];
        
        UIMenu *menu = [UIMenu menuWithTitle:self.viewModel.hsCard.name
                                    children:@[saveAction, shareAction]];
        
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

@end
