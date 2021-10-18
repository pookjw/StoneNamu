//
//  DeckDetailsManaCostContentView.m
//  DeckDetailsManaCostContentView
//
//  Created by Jinwoo Kim on 8/24/21.
//

#import "DeckDetailsManaCostContentView.h"
#import "DeckDetailsManaCostContentConfiguration.h"
#import "DeckDetailsManaCostContentViewModel.h"
#import "DeckDetailsManaCostGraphContentView.h"
#import "DeckDetailsManaCostGraphContentConfiguration.h"

@interface DeckDetailsManaCostContentView ()
@property (retain) UICollectionView *collectionView;
@property (readonly, nonatomic) NSDictionary<NSNumber *, NSNumber *> * _Nullable manaDictionary;
@property (retain) DeckDetailsManaCostContentViewModel *viewModel;
@end

@implementation DeckDetailsManaCostContentView

@synthesize configuration;

- (instancetype)init {
    self = [super init];
    
    if (self) {
        [self setAttributes];
        [self configureCollectionView];
        [self configureViewModel];
    }
    
    return self;
}

- (void)dealloc {
    [configuration release];
    [_collectionView release];
    [_viewModel release];
    [super dealloc];
}

- (void)setAttributes {
    self.backgroundColor = nil;
}

- (void)configureCollectionView {
    UICollectionLayoutListConfiguration *layoutConfiguration = [[UICollectionLayoutListConfiguration alloc] initWithAppearance:UICollectionLayoutListAppearancePlain];
    layoutConfiguration.backgroundColor = UIColor.clearColor;
    
    UIListSeparatorConfiguration *separatorConfiguration = [[UIListSeparatorConfiguration alloc] initWithListAppearance:UICollectionLayoutListAppearancePlain];
    separatorConfiguration.topSeparatorInsets = NSDirectionalEdgeInsetsZero;
    separatorConfiguration.bottomSeparatorInsets = NSDirectionalEdgeInsetsZero;
    layoutConfiguration.separatorConfiguration = separatorConfiguration;
    [separatorConfiguration release];
    
    UICollectionViewCompositionalLayout *layout = [UICollectionViewCompositionalLayout layoutWithListConfiguration:layoutConfiguration];
    [layoutConfiguration release];
    
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:layout];
    self.collectionView = collectionView;
    [self addSubview:collectionView];
    
    collectionView.translatesAutoresizingMaskIntoConstraints = NO;
    [NSLayoutConstraint activateConstraints:@[
        [collectionView.topAnchor constraintEqualToAnchor:self.topAnchor],
        [collectionView.leadingAnchor constraintEqualToAnchor:self.leadingAnchor],
        [collectionView.trailingAnchor constraintEqualToAnchor:self.trailingAnchor],
        [collectionView.heightAnchor constraintEqualToConstant:ceilf(DeckDetailsManaCostGraphContentView.preferredLabelRect.size.height) * DeckDetailsManaCostContentViewModelCountOfData]
    ]];
    
    NSLayoutConstraint *bottomLayout = [collectionView.bottomAnchor constraintEqualToAnchor:self.bottomAnchor];
    bottomLayout.priority = UILayoutPriorityDefaultHigh;
    bottomLayout.active = YES;
    
    collectionView.backgroundColor = UIColor.clearColor;
    collectionView.userInteractionEnabled = NO;
    collectionView.scrollEnabled = NO;
    
    [collectionView release];
}

- (void)configureViewModel {
    DeckDetailsManaCostContentViewModel *viewModel = [[DeckDetailsManaCostContentViewModel alloc] initWithDataSource:[self makeDataSource]];
    self.viewModel = viewModel;
    [viewModel release];
}

- (DeckDetailsManaCostContentDataSource *)makeDataSource {
    UICollectionViewCellRegistration *cellRegistration = [self makeCellRegistration];
    
    DeckDetailsManaCostContentDataSource *dataSource = [[DeckDetailsManaCostContentDataSource alloc] initWithCollectionView:self.collectionView cellProvider:^UICollectionViewCell * _Nullable(UICollectionView * _Nonnull collectionView, NSIndexPath * _Nonnull indexPath, id  _Nonnull itemIdentifier) {
        
        UICollectionViewCell *cell = [collectionView dequeueConfiguredReusableCellWithRegistration:cellRegistration forIndexPath:indexPath item:itemIdentifier];
        
        return cell;
    }];
    
    return [dataSource autorelease];
}

- (UICollectionViewCellRegistration *)makeCellRegistration {
    UICollectionViewCellRegistration *cellRegistration = [UICollectionViewCellRegistration registrationWithCellClass:[UICollectionViewListCell class] configurationHandler:^(__kindof UICollectionViewListCell * _Nonnull cell, NSIndexPath * _Nonnull indexPath, id  _Nonnull item) {
        
        if (![item isKindOfClass:[DeckDetailsManaCostContentItemModel class]]) {
            return;
        }
        
        DeckDetailsManaCostContentItemModel *itemModel = (DeckDetailsManaCostContentItemModel *)item;
        
        DeckDetailsManaCostGraphContentConfiguration *configuration = [[DeckDetailsManaCostGraphContentConfiguration alloc] initWithCost:itemModel.cardManaCost percentage:itemModel.percentage cardCount:itemModel.cardCount];
        cell.contentConfiguration = configuration;
        [configuration release];
        
        UIBackgroundConfiguration *backgroundConfiguration = [UIBackgroundConfiguration listPlainCellConfiguration];
        backgroundConfiguration.backgroundColor = UIColor.clearColor;
        cell.backgroundConfiguration = backgroundConfiguration;
    }];
    
    return cellRegistration;
}

- (void)setConfiguration:(id<UIContentConfiguration>)configuration {
    DeckDetailsManaCostContentConfiguration *oldContentConfig = (DeckDetailsManaCostContentConfiguration *)self.configuration;
    DeckDetailsManaCostContentConfiguration *newContentConfig = [(DeckDetailsManaCostContentConfiguration *)configuration copy];
    self->configuration = newContentConfig;
    
    if (![newContentConfig.manaDictionary isEqualToDictionary:oldContentConfig.manaDictionary]) {
        [self updateCollectionView];
    }
    
    [oldContentConfig release];
}

- (NSDictionary<NSNumber *, NSNumber *> * _Nullable)manaDictionary {
    DeckDetailsManaCostContentConfiguration *contentConfig = (DeckDetailsManaCostContentConfiguration *)self.configuration;
    
    if (![contentConfig isKindOfClass:[DeckDetailsManaCostContentConfiguration class]]) return nil;
    
    return contentConfig.manaDictionary;
}

- (void)updateCollectionView {
    [self.viewModel requestDataSourceWithManaDictionary:self.manaDictionary];
}

@end
