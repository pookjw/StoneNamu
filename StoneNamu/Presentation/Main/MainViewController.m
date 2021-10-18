//
//  MainViewController.m
//  MainViewController
//
//  Created by Jinwoo Kim on 10/15/21.
//

#import "MainViewController.h"
#import "MainViewModel.h"
#import "UIViewController+animatedForSelectedIndexPath.h"
#import "CardsViewController.h"
#import "CardOptionsViewController.h"
#import "DecksViewController.h"
#import "PrefsViewController.h"
#import "OneBesideSecondarySplitViewController.h"

@interface MainViewController () <UICollectionViewDelegate>
@property (retain) UICollectionView *collectionView;
@property (retain) MainViewModel *viewModel;
@property (retain) UICollectionViewSupplementaryRegistration *headerCellRegistration;
@property (retain) UICollectionViewSupplementaryRegistration *footerCellRegistration;
@end

@implementation MainViewController

- (void)dealloc {
    [_collectionView release];
    [_viewModel release];
    [_headerCellRegistration release];
    [_footerCellRegistration release];
    [super dealloc];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setAttributes];
    [self configureRightBarButtonItems];
    [self configureCollectionView];
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
    self.title = NSLocalizedString(@"APP_NAME", @"");
    self.navigationItem.largeTitleDisplayMode = UINavigationItemLargeTitleDisplayModeAlways;
    self.navigationController.navigationBar.prefersLargeTitles = YES;
}

- (void)configureCollectionView {
    UICollectionLayoutListConfiguration *layoutConfiguration = [[UICollectionLayoutListConfiguration alloc] initWithAppearance:UICollectionLayoutListAppearanceSidebar];
    layoutConfiguration.headerMode = UICollectionLayoutListHeaderModeSupplementary;
    layoutConfiguration.footerMode = UICollectionLayoutListFooterModeSupplementary;
    
    UICollectionViewCompositionalLayout *layout = [UICollectionViewCompositionalLayout layoutWithListConfiguration:layoutConfiguration];
    [layoutConfiguration release];
    
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:layout];
    self.collectionView = collectionView;
    [self.view addSubview:collectionView];
    
    [collectionView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [NSLayoutConstraint activateConstraints:@[
        [collectionView.topAnchor constraintEqualToAnchor:self.view.topAnchor],
        [collectionView.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor],
        [collectionView.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor],
        [collectionView.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor]
    ]];
    
    collectionView.delegate = self;
    
    [collectionView release];
}

- (void)configureViewModel {
    MainViewModel *viewModel = [[MainViewModel alloc] initWithDataSource:[self makeDataSource]];
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
        
        if (![item isKindOfClass:[MainItemModel class]]) {
            return;
        }
        
        MainItemModel *itemModel = (MainItemModel *)item;
        
        UIListContentConfiguration *configuration = [UIListContentConfiguration cellConfiguration];
        configuration.image = itemModel.primaryImage;
        configuration.text = itemModel.primaryText;
        configuration.secondaryText = itemModel.secondaryText;
        configuration.imageProperties.maximumSize = CGSizeMake(50, 50);
        configuration.imageProperties.cornerRadius = 25;
        cell.contentConfiguration = configuration;
        
        //
        
        NSMutableArray<UICellAccessory *> *accessories = [@[] mutableCopy];
        
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
    
    UICollectionViewDiffableDataSourceSupplementaryViewProvider provider = ^UICollectionReusableView * _Nullable(UICollectionView * _Nonnull collectionView, NSString * _Nonnull elementKind, NSIndexPath * _Nonnull indexPath) {
        
        if ([elementKind isEqualToString:UICollectionElementKindSectionHeader]) {
            return [collectionView dequeueConfiguredReusableSupplementaryViewWithRegistration:self.headerCellRegistration forIndexPath:indexPath];
        } else if ([elementKind isEqualToString:UICollectionElementKindSectionFooter]) {
            return [collectionView dequeueConfiguredReusableSupplementaryViewWithRegistration:self.footerCellRegistration forIndexPath:indexPath];
        } else {
            return nil;
        }
    };
    
    return [[provider copy] autorelease];
}

- (UICollectionViewSupplementaryRegistration *)makeHeaderCellRegistration {
    UICollectionViewSupplementaryRegistration *registration = [UICollectionViewSupplementaryRegistration registrationWithSupplementaryClass:[UICollectionViewListCell class]
                                                                                                                                elementKind:UICollectionElementKindSectionHeader
                                                                                                                       configurationHandler:^(__kindof UICollectionViewListCell * _Nonnull supplementaryView, NSString * _Nonnull elementKind, NSIndexPath * _Nonnull indexPath) {
        
        NSString * _Nullable text = [self.viewModel headerTextFromIndexPath:indexPath];
        
        UIListContentConfiguration *configuration = [UIListContentConfiguration groupedHeaderConfiguration];
        configuration.text = text;
        
        supplementaryView.contentConfiguration = configuration;
    }];
    
    return registration;
}

- (UICollectionViewSupplementaryRegistration *)makeFooterCellRegistration {
    UICollectionViewSupplementaryRegistration *registration = [UICollectionViewSupplementaryRegistration registrationWithSupplementaryClass:[UICollectionViewListCell class]
                                                                                                                                elementKind:UICollectionElementKindSectionFooter
                                                                                                                       configurationHandler:^(__kindof UICollectionViewListCell * _Nonnull supplementaryView, NSString * _Nonnull elementKind, NSIndexPath * _Nonnull indexPath) {
        
        NSString * _Nullable text = [self.viewModel footerTextFromIndexPath:indexPath];
        
        UIListContentConfiguration *configuration = [UIListContentConfiguration groupedFooterConfiguration];
        configuration.text = text;
        configuration.textProperties.alignment = UIListContentTextAlignmentCenter;
        
        supplementaryView.contentConfiguration = configuration;
    }];
    
    return registration;
}

- (void)presentCardsViewControllerWithOptions:(NSDictionary<NSString *, NSString *> * _Nullable)options {
    CardsViewController *cardsViewController = [CardsViewController new];
    [cardsViewController loadViewIfNeeded];
    [cardsViewController setOptionsBarButtonItemHidden:YES];
    [cardsViewController requestWithOptions:options];
    
    if (self.splitViewController.isCollapsed) {
        [self.navigationController pushViewController:cardsViewController animated:YES];
    } else {
        CardOptionsViewController *cardOptionsViewController = [[CardOptionsViewController alloc] initWithOptions:cardsViewController.options];
        cardOptionsViewController.delegate = cardsViewController;
        [cardOptionsViewController setCancelButtonHidden:YES];
        [self.splitViewController setViewController:cardOptionsViewController forColumn:UISplitViewControllerColumnSupplementary];
        [self.splitViewController setViewController:cardsViewController forColumn:UISplitViewControllerColumnSecondary];
        // setViewController:forColumn: will push the view controller, so prevent this
        [cardsViewController.navigationController setViewControllers:@[cardsViewController] animated:NO];
        
        [cardOptionsViewController release];
    }
    
    [cardsViewController release];
}

- (void)presentDecksViewController {
    DecksViewController *decksViewController = [DecksViewController new];
    [decksViewController loadViewIfNeeded];
    
    if (self.splitViewController.isCollapsed) {
        [self.navigationController pushViewController:decksViewController animated:YES];
    } else {
        [self.splitViewController setViewController:decksViewController forColumn:UISplitViewControllerColumnSupplementary];
        [self.splitViewController setViewController:nil forColumn:UISplitViewControllerColumnSecondary];
    }
    
    [decksViewController release];
}

- (void)presentPrefsViewController {
    PrefsViewController *prefsViewController = [PrefsViewController new];
    [prefsViewController loadViewIfNeeded];
    [prefsViewController setDoneButtonHidden:NO];
    
    UINavigationController *prefsPrimaryNavigationController = [[UINavigationController alloc] initWithRootViewController:prefsViewController];
    UINavigationController *prefsSecondaryNavigationController = [UINavigationController new];
    
    [prefsViewController release];
    
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
    MainItemModel * _Nullable itemModel = [self.viewModel.dataSource itemIdentifierForIndexPath:indexPath];
    
    switch (itemModel.type) {
        case MainItemModelTypeCardsConstructed: {
            NSDictionary<NSString *, NSString *> * _Nullable options = [self.viewModel cardOptionsFromType:itemModel.type];
            [self presentCardsViewControllerWithOptions:options];
            break;
        }
        case MainItemModelTypeCardsMercenaries: {
            NSDictionary<NSString *, NSString *> * _Nullable options = [self.viewModel cardOptionsFromType:itemModel.type];
            [self presentCardsViewControllerWithOptions:options];
            break;
        }
        case MainItemModelTypeDecks: {
            [self presentDecksViewController];
            break;
        }
        default:
            break;
    }
}

@end