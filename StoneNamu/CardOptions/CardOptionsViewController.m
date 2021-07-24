//
//  CardOptionsViewController.m
//  StoneNamu
//
//  Created by Jinwoo Kim on 7/24/21.
//

#import "CardOptionsViewController.h"
#import "CardOptionsViewModel.h"
#import "CardsViewController.h"

@interface CardOptionsViewController ()
@property (assign) UICollectionView *collectionView;
@property (retain) CardOptionsViewModel *viewModel;
@end

@implementation CardOptionsViewController

- (void)dealloc {
    [_viewModel release];
    [super dealloc];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setAttributes];
    [self configureFetchButton];
    [self configureCollectionView];
    [self configureViewModel];
}

- (void)setAttributes {
    self.view.backgroundColor = UIColor.systemBackgroundColor;
}

- (void)configureFetchButton {
    UIBarButtonItem *fetchButton = [[UIBarButtonItem alloc] initWithImage:[UIImage systemImageNamed:@"play.fill"]
                                                                    style:UIBarButtonItemStylePlain
                                                                   target:self
                                                                   action:@selector(fetchButtonTriggered:)];
    
    self.navigationItem.rightBarButtonItems = @[fetchButton];
    [fetchButton release];
}

- (void)fetchButtonTriggered:(UIBarButtonItem *)sender {
    CardsViewController *vc = [[CardsViewController alloc] initWithOptions:@{}];
    [self.navigationController pushViewController:vc animated:YES];
    [vc release];
}

- (void)configureCollectionView {
    UICollectionLayoutListConfiguration *layoutConfiguration = [[UICollectionLayoutListConfiguration alloc] initWithAppearance:UICollectionLayoutListAppearanceInsetGrouped];
    UICollectionViewCompositionalLayout *layout = [UICollectionViewCompositionalLayout layoutWithListConfiguration:layoutConfiguration];
    [layoutConfiguration release];
    
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    self.collectionView = collectionView;
    [self.view addSubview:collectionView];
    [collectionView release];
    
    [collectionView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [NSLayoutConstraint activateConstraints:@[
        [collectionView.topAnchor constraintEqualToAnchor:self.view.topAnchor],
        [collectionView.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor],
        [collectionView.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor],
        [collectionView.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor]
    ]];
    
    collectionView.backgroundColor = UIColor.systemBackgroundColor;
}

- (void)configureViewModel {
    CardOptionsViewModel *viewModel = [[CardOptionsViewModel alloc] initWithDataSource:[self makeDataSource]];
    self.viewModel = viewModel;
    [viewModel release];
}

- (CardOptionsDataSource *)makeDataSource {
    CardOptionsDataSource *dataSource = [[CardOptionsDataSource alloc] initWithCollectionView:self.collectionView
                                                                     cellProvider:^UICollectionViewCell * _Nullable(UICollectionView * _Nonnull collectionView, NSIndexPath * _Nonnull indexPath, id  _Nonnull itemIdentifier) {
        
        UICollectionViewCell *cell = [collectionView dequeueConfiguredReusableCellWithRegistration:[self makeCellRegistration]
                                                                                      forIndexPath:indexPath
                                                                                              item:itemIdentifier];
        return cell;
    }];
    
    [dataSource autorelease];
    return dataSource;
}

- (UICollectionViewCellRegistration *)makeCellRegistration {
    UICollectionViewCellRegistration *cellRegistration = [UICollectionViewCellRegistration registrationWithCellClass:[UICollectionViewListCell class]
                                                                                                configurationHandler:^(__kindof UICollectionViewCell * _Nonnull cell, NSIndexPath * _Nonnull indexPath, id  _Nonnull item) {
        if (![item isKindOfClass:[CardOptionsItemModel class]]) {
            return;
        }
        CardOptionsItemModel *itemModel = (CardOptionsItemModel *)item;
        
        UIListContentConfiguration *configuration = [UIListContentConfiguration subtitleCellConfiguration];
        configuration.text = itemModel.text;
        configuration.secondaryText = itemModel.secondaryText;
        cell.contentConfiguration = configuration;
    }];
    
    return cellRegistration;
}

@end
