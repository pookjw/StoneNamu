//
//  CardsViewController.m
//  StoneNamu
//
//  Created by Jinwoo Kim on 7/23/21.
//

#import "CardsViewController.h"
#import "UIViewController+presentErrorAlert.h"
#import "CardContentConfiguration.h"
#import "CardContentView.h"
#import "CardsCollectionViewCompositionalLayout.h"
#import "CardDetailsViewController.h"
#import "PhotosService.h"
#import "CardOptionsViewController.h"
#import "BattlegroundsCardOptionsViewController.h"
#import "SheetNavigationController.h"
#import "UIViewController+SpinnerView.h"
#import "CardsViewModel.h"
#import <StoneNamuResources/StoneNamuResources.h>

@interface CardsViewController () <UICollectionViewDelegate, UICollectionViewDragDelegate>
@property (retain) CardsViewModel *viewModel;
@property (retain) UICollectionView *collectionView;
@property (retain) UIBarButtonItem *optionsBarButtonItem;
@end

@implementation CardsViewController

- (instancetype)initWithHSGameModeSlugType:(HSCardGameModeSlugType)hsCardGameModeSlugType {
    self = [self init];
    
    if (self) {
        [self loadViewIfNeeded];
        
        self.viewModel.hsCardGameModeSlugType = hsCardGameModeSlugType;
        
        if ([HSCardGameModeSlugTypeConstructed isEqualToString:hsCardGameModeSlugType]) {
            self.title = [ResourcesService localizationForKey:LocalizableKeyCards];
        } else if ([HSCardGameModeSlugTypeBattlegrounds isEqualToString:hsCardGameModeSlugType]) {
            self.title = [ResourcesService localizationForKey:LocalizableKeyBattlegrounds];
        }
    }
    
    return self;
}

- (void)dealloc {
    [_collectionView release];
    [_optionsBarButtonItem release];
    [_viewModel release];
    [super dealloc];
}

- (NSDictionary<NSString *, NSSet<NSString *> *> * _Nullable)options {
    return self.viewModel.options;
}

- (void)requestWithOptions:(NSDictionary<NSString *, NSSet<NSString *> *> *)options {
    [self loadViewIfNeeded];
    [self.viewModel requestDataSourceWithOptions:options reset:YES];
}

- (void)setOptionsBarButtonItemHidden:(BOOL)hidden {
    if (hidden) {
        self.navigationItem.leftBarButtonItems = @[];
    } else {
        self.navigationItem.leftBarButtonItems = @[self.optionsBarButtonItem];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setAttributes];
    [self configureLeftBarButtonItems];
    [self configureCollectionView];
    [self configureViewModel];
    [self bind];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self configureNavigation];
}

- (void)setAttributes {
    
}

- (void)configureLeftBarButtonItems {
    UIBarButtonItem *optionsBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage systemImageNamed:@"magnifyingglass"]
                                                                             style:UIBarButtonItemStylePlain
                                                                            target:self
                                                                            action:@selector(optionsBarButtonItemTriggered:)];
    
    self.navigationItem.leftBarButtonItems = @[optionsBarButtonItem];
    self.optionsBarButtonItem = optionsBarButtonItem;
    [optionsBarButtonItem release];
}

- (void)optionsBarButtonItemTriggered:(UIBarButtonItem *)sender {
    if ([HSCardGameModeSlugTypeConstructed isEqualToString:self.viewModel.hsCardGameModeSlugType]) {
        CardOptionsViewController *vc = [[CardOptionsViewController alloc] initWithOptions:self.viewModel.options];
        vc.delegate = self;
        SheetNavigationController *nvc = [[SheetNavigationController alloc] initWithRootViewController:vc];
        nvc.detents = @[[UISheetPresentationControllerDetent largeDetent]];
        [self presentViewController:nvc animated:YES completion:^{}];
        [vc release];
        [nvc release];
    } else if ([HSCardGameModeSlugTypeBattlegrounds isEqualToString:self.viewModel.hsCardGameModeSlugType]) {
        BattlegroundsCardOptionsViewController *vc = [[BattlegroundsCardOptionsViewController alloc] initWithOptions:self.viewModel.options];
        vc.delegate = self;
        SheetNavigationController *nvc = [[SheetNavigationController alloc] initWithRootViewController:vc];
        nvc.detents = @[[UISheetPresentationControllerDetent largeDetent]];
        [self presentViewController:nvc animated:YES completion:^{}];
        [vc release];
        [nvc release];
    }
}

- (void)configureNavigation {
    self.navigationItem.largeTitleDisplayMode = UINavigationItemLargeTitleDisplayModeNever;
}

- (void)configureCollectionView {
    CardsCollectionViewCompositionalLayout *layout = [[CardsCollectionViewCompositionalLayout alloc] init];
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:layout];
    [layout release];

    [self.view addSubview:collectionView];
    
    collectionView.translatesAutoresizingMaskIntoConstraints = NO;
    [NSLayoutConstraint activateConstraints:@[
        [collectionView.topAnchor constraintEqualToAnchor:self.view.topAnchor],
        [collectionView.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor],
        [collectionView.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor],
        [collectionView.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor]
    ]];
    
    collectionView.backgroundColor = UIColor.systemBackgroundColor;
    collectionView.delegate = self;
    collectionView.dragDelegate = self;
    
    self.collectionView = collectionView;
    [collectionView release];
}

- (void)configureViewModel {
    CardsViewModel *viewModel = [[CardsViewModel alloc] initWithDataSource:[self makeDataSource]];
    self.viewModel = viewModel;
    [viewModel release];
}

- (CardsDataSource *)makeDataSource {
    UICollectionViewCellRegistration *cellRegistration = [self makeCellRegistration];
    
    CardsDataSource *dataSource = [[CardsDataSource alloc] initWithCollectionView:self.collectionView
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
    UICollectionViewCellRegistration *cellRegistration = [UICollectionViewCellRegistration registrationWithCellClass:[UICollectionViewCell class]
                                                                                                configurationHandler:^(__kindof UICollectionViewCell * _Nonnull cell, NSIndexPath * _Nonnull indexPath, id  _Nonnull item) {
        if (![item isKindOfClass:[CardItemModel class]]) {
            return;
        }
        CardItemModel *itemModel = (CardItemModel *)item;
        
        CardContentConfiguration *configuration = [[CardContentConfiguration alloc] initWithHSCard:itemModel.hsCard hsCardGameModeSlugType:itemModel.hsCardGameModeSlugType];
        
        cell.contentConfiguration = configuration;
        [configuration release];
    }];
    
    return cellRegistration;
}

- (void)bind {
    [NSNotificationCenter.defaultCenter addObserver:self
                                           selector:@selector(errorEventReceived:)
                                               name:NSNotificationNameCardsViewModelError
                                             object:self.viewModel];
    
    [NSNotificationCenter.defaultCenter addObserver:self
                                           selector:@selector(startedLoadingDataSourceReceived:)
                                               name:NSNotificationNameCardsViewModelStartedLoadingDataSource
                                             object:self.viewModel];
    
    [NSNotificationCenter.defaultCenter addObserver:self
                                           selector:@selector(endedLoadingDataSourceReceived:)
                                               name:NSNotificationNameCardsViewModelEndedLoadingDataSource
                                             object:self.viewModel];
}

- (void)errorEventReceived:(NSNotification *)notification {
    NSError * _Nullable error = notification.userInfo[CardsViewModelErrorNotificationErrorKey];
    
    [NSOperationQueue.mainQueue addOperationWithBlock:^{
        [self removeAllSpinnerview];
        
        if (error) {
            [self presentErrorAlertWithError:error];
        } else {
            NSLog(@"No error found but the notification was posted: %@", notification.userInfo);
        }
    }];
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

- (NSArray<UIDragItem *> *)makeDragItemsFromIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell * _Nullable cell = [self.collectionView cellForItemAtIndexPath:indexPath];
    CardContentView *contentView = (CardContentView *)cell.contentView;
    
    UIImage * _Nullable image;
    
    if ([contentView isKindOfClass:[CardContentView class]]) {
        image = contentView.imageView.image;
    } else {
        image = nil;
    }
    
    return [self.viewModel makeDragItemFromIndexPath:indexPath image:image];
}

- (void)presentCardDetailsViewControllerFromIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell * _Nullable cell = [self.collectionView cellForItemAtIndexPath:indexPath];
    if (cell == nil) return;
    
    CardContentView *contentView = (CardContentView *)cell.contentView;
    if (![contentView isKindOfClass:[CardContentView class]]) return;
    
    UIImageView *sourceImageView = contentView.imageView;
    
    CardDetailsViewController *vc = [[CardDetailsViewController alloc] initWithHSCard:nil hsGameModeSlugType:self.viewModel.hsCardGameModeSlugType isGold:NO sourceImageView:sourceImageView];
    
    [self.viewModel hsCardFromIndexPath:indexPath completion:^(HSCard * _Nonnull hsCard) {
        [NSOperationQueue.mainQueue addOperationWithBlock:^{
            [vc requestHSCard:hsCard];
        }];
    }];
    
    [self presentViewController:vc animated:YES completion:^{}];
    [vc release];
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [collectionView deselectItemAtIndexPath:indexPath animated:NO];
    [self presentCardDetailsViewControllerFromIndexPath:indexPath];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if (![self.collectionView isEqual:scrollView]) return;
    
    CGSize contentSize = self.collectionView.contentSize;
    CGPoint contentOffset = self.collectionView.contentOffset;
    CGRect bounds = self.collectionView.bounds;
    
    if ((contentOffset.y + bounds.size.height) >= (contentSize.height)) {
        [self.viewModel requestDataSourceWithOptions:self.viewModel.options reset:NO];
    }
}

- (UIContextMenuConfiguration *)collectionView:(UICollectionView *)collectionView contextMenuConfigurationForItemAtIndexPath:(NSIndexPath *)indexPath point:(CGPoint)point {
    self.viewModel.contextMenuIndexPath = nil;
    
    CardItemModel * _Nullable itemModel = [self.viewModel.dataSource itemIdentifierForIndexPath:indexPath];
    if (itemModel == nil) return nil;
    
    self.viewModel.contextMenuIndexPath = indexPath;
    
    UIContextMenuConfiguration *configuration = [UIContextMenuConfiguration configurationWithIdentifier:nil
                                                                                        previewProvider:nil
                                                                                         actionProvider:^UIMenu * _Nullable(NSArray<UIMenuElement *> * _Nonnull suggestedActions) {
        
        UIAction *saveAction = [UIAction actionWithTitle:[ResourcesService localizationForKey:LocalizableKeySave]
                                                   image:[UIImage systemImageNamed:@"square.and.arrow.down"]
                                              identifier:nil
                                                 handler:^(__kindof UIAction * _Nonnull action) {
            PhotosService *photosService = [[PhotosService alloc] initWithHSCards:[NSSet setWithObject:itemModel.hsCard]];
            [photosService beginSavingFromViewController:self completion:^(BOOL success, NSError * _Nullable error) {}];
            [photosService release];
        }];
        
        UIAction *shareAction = [UIAction actionWithTitle:[ResourcesService localizationForKey:LocalizableKeyShare]
                                                    image:[UIImage systemImageNamed:@"square.and.arrow.up"]
                                               identifier:nil
                                                  handler:^(__kindof UIAction * _Nonnull action) {
            PhotosService *photosService = [[PhotosService alloc] initWithHSCards:[NSSet setWithObject:itemModel.hsCard]];
            [photosService beginSharingFromViewController:self completion:^(BOOL success, NSError * _Nullable error) {}];
            [photosService release];
        }];
        
        UIMenu *menu = [UIMenu menuWithTitle:itemModel.hsCard.name
                                    children:@[saveAction, shareAction]];
        
        return menu;
    }];
    
    return configuration;
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

#pragma mark - CardOptionsViewControllerDelegate

- (void)cardOptionsViewController:(CardOptionsViewController *)viewController doneWithOptions:(NSDictionary<NSString *, NSSet<NSString *> *> *)options {
    if ([self.navigationItem.leftBarButtonItems containsObject:self.optionsBarButtonItem]) {
        [viewController dismissViewControllerAnimated:YES completion:^{}];
    }
    
    [self.viewModel requestDataSourceWithOptions:options reset:YES];
}

- (void)cardOptionsViewController:(CardOptionsViewController *)viewController defaultOptionsAreNeededWithCompletion:(CardOptionsViewControllerDelegateDefaultOptionsAreNeededCompletion)completion {
    completion(self.viewModel.defaultOptions);
}

#pragma mark - BattlegroundsCardOptionsViewControllerDelegate

- (void)battlegroundsCardOptionsViewController:(nonnull BattlegroundsCardOptionsViewController *)viewController doneWithOptions:(nonnull NSDictionary<NSString *,NSSet<NSString *> *> *)options {
    if ([self.navigationItem.leftBarButtonItems containsObject:self.optionsBarButtonItem]) {
        [viewController dismissViewControllerAnimated:YES completion:^{}];
    }
    
    [self.viewModel requestDataSourceWithOptions:options reset:YES];
}

- (void)battlegroundsCardOptionsViewController:(nonnull BattlegroundsCardOptionsViewController *)viewController defaultOptionsAreNeededWithCompletion:(nonnull BattlegroundsCardOptionsViewControllerDelegateDefaultOptionsAreNeededCompletion)completion {
    completion(self.viewModel.defaultOptions);
}

@end
