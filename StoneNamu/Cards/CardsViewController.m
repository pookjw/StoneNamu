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
    [_collectionView release];
    [_options release];
    [_viewModel release];
    [super dealloc];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configureCollectionView];
    [self configureViewModel];
    [self bind];
}

- (void)configureCollectionView {
    CardsCollectionViewCompositionalLayout *layout = [[CardsCollectionViewCompositionalLayout alloc] init];
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:layout];
    [layout release];
    
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
    CardsViewModel *viewModel = [[CardsViewModel alloc] initWithDataSource:[self makeDataSource] options:self.options];
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
        
        self.viewModel.presentingDetailCell = cell;
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

@end
