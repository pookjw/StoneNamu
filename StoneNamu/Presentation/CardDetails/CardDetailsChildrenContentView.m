//
//  CardDetailsChildrenContentView.m
//  CardDetailsChildrenContentView
//
//  Created by Jinwoo Kim on 8/9/21.
//

#import "CardDetailsChildrenContentView.h"
#import "CardDetailsChildrenContentConfiguration.h"
#import "CardDetailsChildrenContentCollectionViewCompositionalLayout.h"
#import "CardDetailsChildrenContentViewModel.h"
#import "CardDetailsChildrenContentImageConfiguration.h"
#import "CardDetailsChildrenContentImageContentView.h"

@interface CardDetailsChildrenContentView () <UICollectionViewDelegate>
@property (retain) UIVisualEffectView *visualEffectView;
@property (retain) UICollectionView *collectionView;
@property (retain) CardDetailsChildrenContentViewModel *viewModel;
@end

@implementation CardDetailsChildrenContentView

@synthesize configuration;

- (instancetype)init {
    self = [super init];
    
    if (self) {
        [self setAttributes];
        [self configureVisualEffectView];
        [self configureCollectionView];
        [self configureViewModel];
    }
    
    return self;
}

- (void)dealloc {
    [configuration release];
    [_visualEffectView release];
    [_collectionView release];
    [_viewModel release];
    [super dealloc];
}

- (void)setAttributes {
    self.backgroundColor = UIColor.clearColor;
}

- (void)configureVisualEffectView {
    UIVisualEffectView *visualEffectView = [[UIVisualEffectView alloc] initWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleLight]];
    self.visualEffectView = visualEffectView;
    
    visualEffectView.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:visualEffectView];
    [NSLayoutConstraint activateConstraints:@[
        [visualEffectView.topAnchor constraintEqualToAnchor:self.topAnchor],
        [visualEffectView.trailingAnchor constraintEqualToAnchor:self.trailingAnchor],
        [visualEffectView.leadingAnchor constraintEqualToAnchor:self.leadingAnchor],
        [visualEffectView.bottomAnchor constraintEqualToAnchor:self.bottomAnchor]
    ]];
    
    [visualEffectView release];
}

- (void)configureCollectionView {
    CardDetailsChildrenContentCollectionViewCompositionalLayout *layout = [[CardDetailsChildrenContentCollectionViewCompositionalLayout alloc] init];
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:layout];
    
    [layout release];
    
    self.collectionView = collectionView;
    [self.visualEffectView.contentView addSubview:collectionView];
    
    collectionView.translatesAutoresizingMaskIntoConstraints = NO;
    [NSLayoutConstraint activateConstraints:@[
        [collectionView.topAnchor constraintEqualToAnchor:self.visualEffectView.contentView.topAnchor],
        [collectionView.bottomAnchor constraintEqualToAnchor:self.visualEffectView.contentView.bottomAnchor],
        [collectionView.leadingAnchor constraintEqualToAnchor:self.visualEffectView.contentView.leadingAnchor],
        [collectionView.trailingAnchor constraintEqualToAnchor:self.visualEffectView.contentView.trailingAnchor],
        [collectionView.heightAnchor constraintEqualToConstant:CardDetailsChildrenContentViewHeight]
    ]];
    
    collectionView.backgroundColor = UIColor.clearColor;
    collectionView.delegate = self;
    
    [collectionView release];
}

- (void)configureViewModel {
    CardDetailsChildrenContentViewModel *viewModel = [[CardDetailsChildrenContentViewModel alloc] initWithDataSource:[self makeDataSource]];
    self.viewModel = viewModel;
    [viewModel release];
}

- (CardDetailsChildrenContentDataSource *)makeDataSource {
    UICollectionViewCellRegistration *cellRegistration = [self makeCellRegistration];
    
    CardDetailsChildrenContentDataSource *dataSource = [[CardDetailsChildrenContentDataSource alloc] initWithCollectionView:self.collectionView
                                                                                                               cellProvider:^UICollectionViewCell * _Nullable(UICollectionView * _Nonnull collectionView, NSIndexPath * _Nonnull indexPath, id  _Nonnull itemIdentifier) {
        UICollectionViewCell *cell = [collectionView dequeueConfiguredReusableCellWithRegistration:cellRegistration
                                                                                      forIndexPath:indexPath
                                                                                              item:itemIdentifier];
        return cell;
    }];
    
    return dataSource;
}

- (UICollectionViewCellRegistration *)makeCellRegistration {
    UICollectionViewCellRegistration *cellRegistration = [UICollectionViewCellRegistration registrationWithCellClass:[UICollectionViewCell class]
                                                                                                configurationHandler:^(__kindof UICollectionViewCell * _Nonnull cell, NSIndexPath * _Nonnull indexPath, id  _Nonnull item) {
        
        if (![item isKindOfClass:[CardDetailsChildrenContentItemModel class]]) {
            return;
        }
        CardDetailsChildrenContentItemModel *itemModel = (CardDetailsChildrenContentItemModel *)item;
        
        CardDetailsChildrenContentImageConfiguration *configuration = [[CardDetailsChildrenContentImageConfiguration alloc] initWithHSCard:itemModel.hsCard];
        
        cell.contentConfiguration = configuration;
        [configuration release];
    }];
    
    return cellRegistration;
}

- (void)setConfiguration:(id<UIContentConfiguration>)configuration {
    [self.configuration release];
    CardDetailsChildrenContentConfiguration *content = [(CardDetailsChildrenContentConfiguration *)configuration copy];
    self->configuration = content;
    
    [self.viewModel requestChildCards:content.childCards];
}

#pragma mark UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    UICollectionViewCell *cell = [collectionView cellForItemAtIndexPath:indexPath];
    CardDetailsChildrenContentImageContentView *contentView = (CardDetailsChildrenContentImageContentView *)cell.contentView;
    
    if ((contentView == nil) || (![contentView isKindOfClass:[CardDetailsChildrenContentImageContentView class]])) {
        return;
    }
    
    CardDetailsChildrenContentItemModel *itemModel = [self.viewModel itemModelOfIndexPath:indexPath];
    
    if (itemModel.hsCard == nil) {
        return;
    }
    
    CardDetailsChildrenContentConfiguration *content = (CardDetailsChildrenContentConfiguration *)self.configuration;
    
    [content.delegate cardDetailsChildrenContentConfigurationDidTapImageView:contentView.imageView hsCard:itemModel.hsCard];
}

@end
