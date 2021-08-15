//
//  CardsViewController.m
//  StoneNamu
//
//  Created by Jinwoo Kim on 7/23/21.
//

#import "CardsViewController.h"
#import "UIViewController+presentErrorAlert.h"
#import "CardsViewModel.h"
#import "CardContentConfiguration.h"
#import "CardContentView.h"
#import "CardsCollectionViewCompositionalLayout.h"
#import "CardDetailsViewController.h"
#import "PhotosService.h"

@interface CardsViewController () <UICollectionViewDelegate>
@property (retain) UICollectionView *collectionView;
@property (readonly, copy) NSDictionary<NSString *, id> * _Nullable options;
@property (retain) CardsViewModel *viewModel;
@end

@implementation CardsViewController

- (instancetype)init {
    self = [super init];
    
    if (self) {
        _options = nil;
    }
    
    return self;
}

- (instancetype)initWithOptions:(NSDictionary<NSString *,id> *)options {
    self = [self init];
    
    if (self) {
        _options = [options copy];
    }
    
    return self;
}

- (void)dealloc {
    [NSNotificationCenter.defaultCenter removeObserver:self];
    [_collectionView release];
    [_options release];
    [_viewModel release];
    [super dealloc];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setAttributes];
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
    
    [collectionView release];
}

- (void)configureViewModel {
    CardsViewModel *viewModel = [[CardsViewModel alloc] initWithDataSource:[self makeDataSource]];
    self.viewModel = viewModel;
    [viewModel requestDataSourceWithOptions:self.options];
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
        configuration.hsCard = itemModel.card;
        
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
                                           selector:@selector(presentDetailReceived:)
                                               name:CardsViewModelPresentDetailNotificationName
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

- (void)presentDetailReceived:(NSNotification *)notification {
    HSCard * _Nullable hsCard = notification.userInfo[CardsViewModelPresentDetailNotificationHSCardKey];
    NSIndexPath * _Nullable indexPath = notification.userInfo[CardsViewModelPresentDetailNotificationIndexPathKey];
    
    if (!(hsCard && indexPath)) return;
    
    [NSOperationQueue.mainQueue addOperationWithBlock:^{
        UICollectionViewCell * _Nullable cell = [self.collectionView cellForItemAtIndexPath:indexPath];
        
        if (!cell) return;
        
        CardContentView *contentView = (CardContentView *)cell.contentView;
        
        if (![contentView isKindOfClass:[CardContentView class]]) return;
        
        CardDetailsViewController *vc = [[CardDetailsViewController alloc] initWithHSCard:hsCard sourceImageView:contentView.imageView];
        [vc autorelease];
        [vc loadViewIfNeeded];
        [self presentViewController:vc animated:YES completion:^{}];
    }];
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [collectionView deselectItemAtIndexPath:indexPath animated:NO];
    [self.viewModel handleSelectionForIndexPath:indexPath];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if (![self.collectionView isEqual:scrollView]) return;
    
    CGSize contentSize = self.collectionView.contentSize;
    CGPoint contentOffset = self.collectionView.contentOffset;
    CGRect bounds = self.collectionView.bounds;
    
    if ((contentOffset.y + bounds.size.height) >= (contentSize.height)) {
        [self.viewModel requestDataSourceWithOptions:self.options];
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
            [PhotosService.sharedInstance saveImageURL:itemModel.card.image fromViewController:self completionHandler:^(BOOL success, NSError * _Nonnull error) {}];
        }];
        
        UIMenu *menu = [UIMenu menuWithTitle:itemModel.card.name
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
    
    [self.viewModel handleSelectionForIndexPath:indexPath];
}

@end
