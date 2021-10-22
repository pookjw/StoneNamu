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
#import "CardOptionsViewControllerDelegate.h"
#import "SheetNavigationController.h"
#import "UIViewController+SpinnerView.h"
#import "CardsViewModel.h"

@interface CardsViewController () <UICollectionViewDelegate, UICollectionViewDragDelegate>
@property (retain) CardsViewModel *viewModel;
@property (retain) UICollectionView *collectionView;
@property (retain) UIBarButtonItem *optionsBarButtonItem;
@end

@implementation CardsViewController

- (void)dealloc {
    [_collectionView release];
    [_optionsBarButtonItem release];
    [_viewModel release];
    [super dealloc];
}

- (NSDictionary<NSString *,NSString *> * _Nullable)options {
    return self.viewModel.options;
}

- (void)requestWithOptions:(NSDictionary<NSString *,NSString *> *)options {
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
    
    self.optionsBarButtonItem = optionsBarButtonItem;
    self.navigationItem.leftBarButtonItems = @[optionsBarButtonItem];
    
    [optionsBarButtonItem release];
}

- (void)optionsBarButtonItemTriggered:(UIBarButtonItem *)sender {
    CardOptionsViewController *vc = [[CardOptionsViewController alloc] initWithOptions:self.viewModel.options];
    vc.delegate = self;
    SheetNavigationController *nvc = [[SheetNavigationController alloc] initWithRootViewController:vc];
    nvc.detents = @[[UISheetPresentationControllerDetent largeDetent]];
    [self presentViewController:nvc animated:YES completion:^{}];
    [vc release];
    [nvc release];
}

- (void)configureNavigation {
    self.title = NSLocalizedString(@"CARDS", @"");
    self.navigationItem.largeTitleDisplayMode = UINavigationItemLargeTitleDisplayModeNever;
}

- (void)configureCollectionView {
    CardsCollectionViewCompositionalLayout *layout = [[CardsCollectionViewCompositionalLayout alloc] init];
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:layout];
    [layout release];
    
    self.collectionView = collectionView;
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
        
        CardContentConfiguration *configuration = [CardContentConfiguration new];
        configuration.hsCard = itemModel.hsCard;
        
        cell.contentConfiguration = configuration;
        [configuration release];
    }];
    
    return cellRegistration;
}

- (void)bind {
    [NSNotificationCenter.defaultCenter addObserver:self
                                           selector:@selector(errorEventReceived:)
                                               name:CardsViewModelErrorNotificationName
                                             object:self.viewModel];
    
    [NSNotificationCenter.defaultCenter addObserver:self
                                           selector:@selector(applyingSnapshotWasDoneReceived:)
                                               name:CardsViewModelApplyingSnapshotToDataSourceWasDoneNotificationName
                                             object:self.viewModel];
}

- (void)errorEventReceived:(NSNotification *)notification {
    NSError * _Nullable error = notification.userInfo[CardsViewModelErrorNotificationErrorKey];
    
    if (error) {
        [NSOperationQueue.mainQueue addOperationWithBlock:^{
            [self presentErrorAlertWithError:error];
        }];
    } else {
        NSLog(@"No error found but the notification was posted: %@", notification.userInfo);
    }
}

- (void)applyingSnapshotWasDoneReceived:(NSNotification *)notification {
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

- (void)presentCardDetailsViewControllerWithHSCard:(HSCard *)hsCard sourceImageView:(UIImageView *)imageView {
    CardDetailsViewController *vc = [[CardDetailsViewController alloc] initWithHSCard:hsCard sourceImageView:imageView];
    [vc loadViewIfNeeded];
    [self presentViewController:vc animated:YES completion:^{}];
    [vc release];
}

- (void)presentCardDetailsViewControllerFromIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell * _Nullable cell = [self.collectionView cellForItemAtIndexPath:indexPath];
    if (cell == nil) return;
    HSCard * _Nullable hsCard = [self.viewModel.dataSource itemIdentifierForIndexPath:indexPath].hsCard;
    if (hsCard == nil) return;
    
    CardContentView *contentView = (CardContentView *)cell.contentView;
    if (![contentView isKindOfClass:[CardContentView class]]) return;
    
    [self presentCardDetailsViewControllerWithHSCard:hsCard sourceImageView:contentView.imageView];
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
        BOOL requested = [self.viewModel requestDataSourceWithOptions:self.viewModel.options reset:NO];
        
        if (requested) {
            [self addSpinnerView];
        }
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
        
        UIAction *saveAction = [UIAction actionWithTitle:NSLocalizedString(@"SAVE", @"")
                                                   image:[UIImage systemImageNamed:@"square.and.arrow.down"]
                                              identifier:nil
                                                 handler:^(__kindof UIAction * _Nonnull action) {
            [PhotosService.sharedInstance saveImageURL:itemModel.hsCard.image fromViewController:self completionHandler:^(BOOL success, NSError * _Nonnull error) {}];
        }];
        
        UIMenu *menu = [UIMenu menuWithTitle:itemModel.hsCard.name
                                    children:@[saveAction]];
        
        return menu;
    }];
    
    return configuration;
}

- (void)collectionView:(UICollectionView *)collectionView willPerformPreviewActionForMenuWithConfiguration:(UIContextMenuConfiguration *)configuration animator:(id<UIContextMenuInteractionCommitAnimating>)animator {
    NSIndexPath * _Nullable indexPath = self.viewModel.contextMenuIndexPath;
    
    if (indexPath == nil) {
        return;
    }
    
    self.viewModel.contextMenuIndexPath = nil;
    
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

- (void)cardOptionsViewController:(CardOptionsViewController *)viewController doneWithOptions:(NSDictionary<NSString *,NSString *> *)options {
//    if (self.splitViewController.isCollapsed) {
    if ([self.navigationItem.leftBarButtonItems containsObject:self.optionsBarButtonItem]) {
        [viewController dismissViewControllerAnimated:YES completion:^{}];
    }
    [self addSpinnerView];
    [self.viewModel requestDataSourceWithOptions:options reset:YES];
}

@end