//
//  MainListViewController.m
//  MainListViewController
//
//  Created by Jinwoo Kim on 10/15/21.
//

#import "MainListViewController.h"
#import "MainListViewModel.h"
#import "UIViewController+animatedForSelectedIndexPath.h"
#import "OneBesideSecondarySplitViewController.h"
#import "CardsViewController.h"
#import "DecksViewController.h"
#import "PrefsViewController.h"
#import "MainLayoutProtocol.h"
#import <StoneNamuResources/StoneNamuResources.h>

@interface MainListViewController () <UICollectionViewDelegate>
@property (retain) UICollectionView *collectionView;
@property (retain) MainListViewModel *viewModel;
@property (retain) UICollectionViewSupplementaryRegistration *headerCellRegistration;
@property (retain) UICollectionViewSupplementaryRegistration *footerCellRegistration;
@end

@implementation MainListViewController

- (void)dealloc {
    [_collectionView release];
    [_viewModel release];
    [_headerCellRegistration release];
    [_footerCellRegistration release];
    [super dealloc];
}

- (void)setSelectionStatusForViewController:(__kindof UIViewController *)viewController {
    if ([viewController isKindOfClass:[CardsViewController class]]) {
        [self.viewModel indexPathOfItemType:MainListItemModelTypeCards completion:^(NSIndexPath * _Nullable indexPath) {
            if (indexPath == nil) return;
            
            [NSOperationQueue.mainQueue addOperationWithBlock:^{
                [self.collectionView selectItemAtIndexPath:indexPath animated:NO scrollPosition:UICollectionViewScrollPositionNone];
            }];
        }];
    } else if ([viewController isKindOfClass:[DecksViewController class]]) {
        [self.viewModel indexPathOfItemType:MainListItemModelTypeDecks completion:^(NSIndexPath * _Nullable indexPath) {
            if (indexPath == nil) return;
            
            [NSOperationQueue.mainQueue addOperationWithBlock:^{
                [self.collectionView selectItemAtIndexPath:indexPath animated:NO scrollPosition:UICollectionViewScrollPositionNone];
            }];
        }];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setAttributes];
    [self configureRightBarButtonItems];
    [self configureTableView];
    [self configureViewModel];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self configureNavigation];
    [self animatedForSelectedIndexPathWithCollectionView:self.collectionView];
}

- (void)setAttributes {
    self.view.backgroundColor = UIColor.clearColor;
}

- (void)configureRightBarButtonItems {
    UIBarButtonItem *prefsBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage systemImageNamed:@"gearshape"]
                                                                           style:UIBarButtonItemStylePlain
                                                                          target:self
                                                                          action:@selector(triggeredPrefsBarButtonItem:)];
    
    self.navigationItem.rightBarButtonItems = @[prefsBarButtonItem];
    
    [prefsBarButtonItem release];
}

- (void)triggeredPrefsBarButtonItem:(UIBarButtonItem *)sender {
    [self presentPrefsViewController];
}

- (void)configureNavigation {
    self.title = [ResourcesService localizationForKey:LocalizableKeyAppName];
    self.navigationItem.largeTitleDisplayMode = UINavigationItemLargeTitleDisplayModeAlways;
    self.navigationController.navigationBar.prefersLargeTitles = YES;
}

- (void)configureTableView {
    UICollectionLayoutListConfiguration *layoutConfiguration = [[UICollectionLayoutListConfiguration alloc] initWithAppearance:UICollectionLayoutListAppearanceSidebar];
    layoutConfiguration.headerMode = UICollectionLayoutListHeaderModeSupplementary;
    layoutConfiguration.footerMode = UICollectionLayoutListFooterModeSupplementary;
    
    UICollectionViewCompositionalLayout *layout = [UICollectionViewCompositionalLayout layoutWithListConfiguration:layoutConfiguration];
    [layoutConfiguration release];
    
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:layout];
    [self.view addSubview:collectionView];
    
    [collectionView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [NSLayoutConstraint activateConstraints:@[
        [collectionView.topAnchor constraintEqualToAnchor:self.view.topAnchor],
        [collectionView.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor],
        [collectionView.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor],
        [collectionView.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor]
    ]];
    
    collectionView.delegate = self;
    
    self.collectionView = collectionView;
    [collectionView release];
}

- (void)configureViewModel {
    MainListViewModel *viewModel = [[MainListViewModel alloc] initWithDataSource:[self makeDataSource]];
    self.viewModel = viewModel;
    [viewModel autorelease];
}

- (MainDataSource *)makeDataSource {
    UICollectionViewCellRegistration *cellRegistration = [self makeCellRegistration];
    
    MainDataSource *dataSource = [[MainDataSource alloc] initWithCollectionView:self.collectionView cellProvider:^UICollectionViewCell * _Nullable(UICollectionView * _Nonnull collectionView, NSIndexPath * _Nonnull indexPath, id  _Nonnull itemIdentifier) {
        
        UICollectionViewCell *cell = [collectionView dequeueConfiguredReusableCellWithRegistration:cellRegistration forIndexPath:indexPath item:itemIdentifier];
        
        return cell;
    }];
    
    dataSource.supplementaryViewProvider = [self makeSupplementaryViewProvider];
    
    return [dataSource autorelease];
}

- (UICollectionViewCellRegistration *)makeCellRegistration {
    UICollectionViewCellRegistration *cellRegistration = [UICollectionViewCellRegistration registrationWithCellClass:[UICollectionViewListCell class] configurationHandler:^(__kindof UICollectionViewListCell * _Nonnull cell, NSIndexPath * _Nonnull indexPath, id  _Nonnull item) {
        
        if (![item isKindOfClass:[MainListItemModel class]]) {
            return;
        }
        
        MainListItemModel *itemModel = (MainListItemModel *)item;
        
        UIListContentConfiguration *configuration = [UIListContentConfiguration cellConfiguration];
        configuration.image = itemModel.primaryImage;
        configuration.text = itemModel.primaryText;
        configuration.secondaryText = itemModel.secondaryText;
        configuration.imageProperties.maximumSize = CGSizeMake(50, 50);
        configuration.imageProperties.cornerRadius = 25;
        cell.contentConfiguration = configuration;
        
        //
        
        NSMutableArray<UICellAccessory *> *accessories = [NSMutableArray<UICellAccessory *> new];
        
        [accessories addObject:[[UICellAccessoryDisclosureIndicator new] autorelease]];
        
        NSArray<UICellAccessory *> *results = [accessories copy];
        [accessories release];
        cell.accessories = results;
        
        [results release];
    }];
    
    return cellRegistration;
}

- (UICollectionViewDiffableDataSourceSupplementaryViewProvider)makeSupplementaryViewProvider {
    self.headerCellRegistration = [self makeHeaderCellRegistration];
    self.footerCellRegistration = [self makeFooterCellRegistration];
    
    MainListViewController * __block unretainedSelf = self;
    
    UICollectionViewDiffableDataSourceSupplementaryViewProvider provider = ^UICollectionReusableView * _Nullable(UICollectionView * _Nonnull collectionView, NSString * _Nonnull elementKind, NSIndexPath * _Nonnull indexPath) {
        
        if ([elementKind isEqualToString:UICollectionElementKindSectionHeader]) {
            return [collectionView dequeueConfiguredReusableSupplementaryViewWithRegistration:unretainedSelf.headerCellRegistration forIndexPath:indexPath];
        } else if ([elementKind isEqualToString:UICollectionElementKindSectionFooter]) {
            return [collectionView dequeueConfiguredReusableSupplementaryViewWithRegistration:unretainedSelf.footerCellRegistration forIndexPath:indexPath];
        } else {
            return nil;
        }
    };
    
    return [[provider copy] autorelease];
}

- (UICollectionViewSupplementaryRegistration *)makeHeaderCellRegistration {
    MainListViewController * __block unretainedSelf = self;
    
    UICollectionViewSupplementaryRegistration *registration = [UICollectionViewSupplementaryRegistration registrationWithSupplementaryClass:[UICollectionViewListCell class]
                                                                                                                                elementKind:UICollectionElementKindSectionHeader
                                                                                                                       configurationHandler:^(__kindof UICollectionViewListCell * _Nonnull supplementaryView, NSString * _Nonnull elementKind, NSIndexPath * _Nonnull indexPath) {
        
        NSString * _Nullable text = [unretainedSelf.viewModel headerTextFromIndexPath:indexPath];
        
        UIListContentConfiguration *configuration = [UIListContentConfiguration groupedHeaderConfiguration];
        configuration.text = text;
        
        supplementaryView.contentConfiguration = configuration;
    }];
    
    return registration;
}

- (UICollectionViewSupplementaryRegistration *)makeFooterCellRegistration {
    MainListViewController * __block unretainedSelf = self;
    
    UICollectionViewSupplementaryRegistration *registration = [UICollectionViewSupplementaryRegistration registrationWithSupplementaryClass:[UICollectionViewListCell class]
                                                                                                                                elementKind:UICollectionElementKindSectionFooter
                                                                                                                       configurationHandler:^(__kindof UICollectionViewListCell * _Nonnull supplementaryView, NSString * _Nonnull elementKind, NSIndexPath * _Nonnull indexPath) {
        
        NSString * _Nullable text = [unretainedSelf.viewModel footerTextFromIndexPath:indexPath];
        
        UIListContentConfiguration *configuration = [UIListContentConfiguration groupedFooterConfiguration];
        configuration.text = text;
        configuration.textProperties.alignment = UIListContentTextAlignmentCenter;
        
        supplementaryView.contentConfiguration = configuration;
    }];
    
    return registration;
}

- (void)presentCardsViewController {
    CardsViewController *cardsViewController = ((id<MainLayoutProtocol>)self.splitViewController).cardsViewController;
    [(id<MainLayoutProtocol>)self.splitViewController restoreViewControllers:@[cardsViewController]];
}

- (void)presentDecksViewController {
    DecksViewController *decksViewController = ((id<MainLayoutProtocol>)self.splitViewController).decksViewController;
    [(id<MainLayoutProtocol>)self.splitViewController restoreViewControllers:@[decksViewController]];
}

- (void)presentPrefsViewController {
    PrefsViewController *prefsViewController = ((id<MainLayoutProtocol>)self.splitViewController).prefsViewController;
    [prefsViewController loadViewIfNeeded];
    [prefsViewController setDoneButtonHidden:NO];
    
    UINavigationController *prefsPrimaryNavigationController = [[UINavigationController alloc] initWithRootViewController:prefsViewController];
    UINavigationController *prefsSecondaryNavigationController = [UINavigationController new];
    
    prefsPrimaryNavigationController.view.backgroundColor = UIColor.systemBackgroundColor;
    prefsSecondaryNavigationController.view.backgroundColor = UIColor.systemBackgroundColor;
    
    OneBesideSecondarySplitViewController *prefsSplitViewController = [OneBesideSecondarySplitViewController new];
    
    prefsSplitViewController.viewControllers = @[prefsPrimaryNavigationController, prefsSecondaryNavigationController];
    
    [prefsPrimaryNavigationController release];
    [prefsSecondaryNavigationController release];
    
    [self presentViewController:prefsSplitViewController animated:YES completion:^{}];
    
    [prefsSplitViewController release];
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    MainListItemModel * _Nullable itemModel = [self.viewModel.dataSource itemIdentifierForIndexPath:indexPath];
    
    switch (itemModel.type) {
        case MainListItemModelTypeCards: {
            [self presentCardsViewController];
            break;
        }
        case MainListItemModelTypeDecks: {
            [self presentDecksViewController];
            break;
        }
        default:
            break;
    }
}

@end
