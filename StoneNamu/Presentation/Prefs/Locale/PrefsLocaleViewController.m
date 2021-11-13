//
//  PrefsLocaleViewController.m
//  PrefsLocaleViewController
//
//  Created by Jinwoo Kim on 8/15/21.
//

#import "PrefsLocaleViewController.h"
#import "PrefsLocaleViewModel.h"
#import <StoneNamuResources/StoneNamuResources.h>

@interface PrefsLocaleViewController () <UICollectionViewDelegate>
@property (retain) UICollectionView *collectionView;
@property (retain) PrefsLocaleViewModel *viewModel;
@end

@implementation PrefsLocaleViewController

- (void)dealloc {
    [_collectionView release];
    [_viewModel release];
    [super dealloc];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setAttributes];
    [self configureCollectionView];
    [self configureViewModel];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self configureNavigation];
}

- (void)setAttributes {
    self.view.backgroundColor = UIColor.systemBackgroundColor;
}

- (void)configureNavigation {
    self.title = [ResourcesService localizaedStringForKey:LocalizableKeyLocale];
    self.navigationItem.largeTitleDisplayMode = UINavigationItemLargeTitleDisplayModeNever;
}

- (void)configureCollectionView {
    UICollectionLayoutListConfiguration *layoutConfiguration = [[UICollectionLayoutListConfiguration alloc] initWithAppearance:UICollectionLayoutListAppearanceInsetGrouped];
    
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
    
    collectionView.backgroundColor = UIColor.systemBackgroundColor;
    collectionView.delegate = self;
    
    [collectionView release];
}

- (void)configureViewModel {
    PrefsLocaleViewModel *viewModel = [[PrefsLocaleViewModel alloc] initWithDataSource:[self makeDataSource]];
    self.viewModel = viewModel;
    [viewModel autorelease];
}

- (PrefsLocaleDataSource *)makeDataSource {
    UICollectionViewCellRegistration *cellRegistration = [self makeCellRegistration];
    
    PrefsLocaleDataSource *dataSource = [[PrefsLocaleDataSource alloc] initWithCollectionView:self.collectionView cellProvider:^UICollectionViewCell * _Nullable(UICollectionView * _Nonnull collectionView, NSIndexPath * _Nonnull indexPath, id  _Nonnull itemIdentifier) {
        
        UICollectionViewCell *cell = [collectionView dequeueConfiguredReusableCellWithRegistration:cellRegistration forIndexPath:indexPath item:itemIdentifier];
        
        return cell;
    }];
    
    return [dataSource autorelease];
}

- (UICollectionViewCellRegistration *)makeCellRegistration {
    UICollectionViewCellRegistration *cellRegistration = [UICollectionViewCellRegistration registrationWithCellClass:[UICollectionViewListCell class] configurationHandler:^(__kindof UICollectionViewListCell * _Nonnull cell, NSIndexPath * _Nonnull indexPath, id  _Nonnull item) {
        
        if (![item isKindOfClass:[PrefsLocaleItemModel class]]) {
            return;
        }
        
        PrefsLocaleItemModel *itemModel = (PrefsLocaleItemModel *)item;
        
        UIListContentConfiguration *configuration = [UIListContentConfiguration subtitleCellConfiguration];
        configuration.text = itemModel.primaryText;
        configuration.secondaryText = itemModel.secondaryText;
        configuration.secondaryTextProperties.numberOfLines = 0;
        cell.contentConfiguration = configuration;
        
        //
        
        if (itemModel.isSelected) {
            UICellAccessoryCheckmark *checkmark = [UICellAccessoryCheckmark new];
            cell.accessories = @[checkmark];
            [checkmark release];
        } else {
            cell.accessories = @[];
        }
    }];
    
    return cellRegistration;
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [self.viewModel updateLocaleFromIndexPath:indexPath];
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
}

@end
