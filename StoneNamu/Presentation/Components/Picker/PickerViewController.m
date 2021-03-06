//
//  PickerViewController.m
//  StoneNamu
//
//  Created by Jinwoo Kim on 2/19/22.
//

#import "PickerViewController.h"
#import "PickerViewModel.h"
#import <StoneNamuResources/StoneNamuResources.h>

@interface PickerViewController () <UICollectionViewDelegate>
@property (retain) UICollectionView *collectionView;
@property (retain) UICollectionViewSupplementaryRegistration *headerCellRegistration;
@property (retain) PickerViewModel *viewModel;
@property (assign) id<PickerViewControllerDelegate> _Nullable delegate;
@property (copy) PickerViewControllerDidSelectItems _Nullable didSelectItems;
@end

@implementation PickerViewController

- (instancetype)init {
    self = [super init];
    
    if (self) {
        self.delegate = nil;
        self.didSelectItems = nil;
    }
    
    return self;
}

- (instancetype)initWithItems:(NSDictionary<PickerSectionModel *, NSSet<PickerItemModel *> *> *)items allowsMultipleSelection:(BOOL)allowsMultipleSelection comparator:(NSComparisonResult (^)(NSString *, NSString *))comparator {
    self = [self init];
    
    if (self) {
        [self loadViewIfNeeded];
        
        self.viewModel.allowsMultipleSelection = allowsMultipleSelection;
        self.viewModel.comparator = comparator;
        [self.viewModel updateDataSourceWithItems:items];
    }
    
    return self;
}

- (instancetype)initWithItems:(NSDictionary<PickerSectionModel *, NSSet<PickerItemModel *> *> *)items allowsMultipleSelection:(BOOL)allowsMultipleSelection comparator:(NSComparisonResult (^)(NSString *, NSString *))comparator delegate:(id<PickerViewControllerDelegate>)delegate {
    self = [self initWithItems:items allowsMultipleSelection:allowsMultipleSelection comparator:comparator];
    
    if (self) {
        self.delegate = delegate;
        self.didSelectItems = nil;
    }
    
    return self;
}

- (instancetype)initWithItems:(NSDictionary<PickerSectionModel *, NSSet<PickerItemModel *> *> *)items allowsMultipleSelection:(BOOL)allowsMultipleSelection comparator:(NSComparisonResult (^)(NSString *, NSString *))comparator didSelectItems:(PickerViewControllerDidSelectItems)didSelectItems {
    self = [self initWithItems:items allowsMultipleSelection:allowsMultipleSelection comparator:comparator];
    
    if (self) {
        self.delegate = nil;
        self.didSelectItems = didSelectItems;
    }
    
    return self;
}

- (void)requestWithItems:(NSDictionary<PickerSectionModel *,NSSet<PickerItemModel *> *> *)items allowsMultipleSelection:(BOOL)allowsMultipleSelection comparator:(NSComparisonResult (^)(NSString * _Nonnull, NSString * _Nonnull))comparator delegate:(id<PickerViewControllerDelegate>)delegate {
    [self loadViewIfNeeded];
    self.delegate = delegate;
    
    [self loadViewIfNeeded];
    self.viewModel.allowsMultipleSelection = allowsMultipleSelection;
    self.viewModel.comparator = comparator;
    [self.viewModel updateDataSourceWithItems:items];
}

- (void)requestWithItems:(NSDictionary<PickerSectionModel *,NSSet<PickerItemModel *> *> *)items allowsMultipleSelection:(BOOL)allowsMultipleSelection comparator:(NSComparisonResult (^)(NSString * _Nonnull, NSString * _Nonnull))comparator didSelectItems:(PickerViewControllerDidSelectItems)didSelectItems {
    self.didSelectItems = didSelectItems;
    
    [self loadViewIfNeeded];
    self.viewModel.allowsMultipleSelection = allowsMultipleSelection;
    self.viewModel.comparator = comparator;
    [self.viewModel updateDataSourceWithItems:items];
}

- (void)dealloc {
    [_collectionView release];
    [_headerCellRegistration release];
    [_viewModel release];
    [_didSelectItems release];
    [super dealloc];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configureCollectionView];
    [self configureViewModel];
    [self bind];
}

- (void)configureCollectionView {
    UICollectionLayoutListConfiguration *layoutConfiguration = [[UICollectionLayoutListConfiguration alloc] initWithAppearance:UICollectionLayoutListAppearanceInsetGrouped];
    layoutConfiguration.headerMode = UICollectionLayoutListHeaderModeSupplementary;
    
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
    
    collectionView.backgroundColor = UIColor.systemBackgroundColor;
    collectionView.delegate = self;
    
    self.collectionView = collectionView;
    [collectionView release];
}

- (void)configureViewModel {
    PickerViewModel *viewModel = [[PickerViewModel alloc] initWithDataSource:[self makeDataSource]];
    self.viewModel = viewModel;
    [viewModel release];
}

- (PickerDataSource *)makeDataSource {
    UICollectionViewCellRegistration *cellRegistration = [self makeCellRegistration];
    
    PickerDataSource *dataSource = [[PickerDataSource alloc] initWithCollectionView:self.collectionView cellProvider:^UICollectionViewCell * _Nullable(UICollectionView * _Nonnull collectionView, NSIndexPath * _Nonnull indexPath, id  _Nonnull itemIdentifier) {
        
        UICollectionViewCell *cell = [collectionView dequeueConfiguredReusableCellWithRegistration:cellRegistration forIndexPath:indexPath item:itemIdentifier];
        
        return cell;
    }];
    
    dataSource.supplementaryViewProvider = [self makeSupplementaryViewProvider];
    
    return [dataSource autorelease];
}

- (UICollectionViewCellRegistration *)makeCellRegistration {
    UICollectionViewCellRegistration *cellRegistration = [UICollectionViewCellRegistration registrationWithCellClass:[UICollectionViewListCell class] configurationHandler:^(__kindof UICollectionViewListCell * _Nonnull cell, NSIndexPath * _Nonnull indexPath, id  _Nonnull item) {
        
        if (![item isKindOfClass:[PickerItemModel class]]) {
            return;
        }
        
        PickerItemModel *itemModel = (PickerItemModel *)item;
        
        UIListContentConfiguration *configuration = [UIListContentConfiguration subtitleCellConfiguration];
        
        switch (itemModel.type) {
            case PickerItemModelTypeEmpty: {
                configuration.text = [ResourcesService localizationForKey:LocalizableKeyEmpty];
                break;
            }
            case PickerItemModelTypeItems: {
                configuration.text = itemModel.text;
                break;
            }
            default:
                break;
        }
        
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

- (UICollectionViewDiffableDataSourceSupplementaryViewProvider)makeSupplementaryViewProvider {
    self.headerCellRegistration = [self makeHeaderCellRegistration];
    
    PickerViewController * __block unretainedSelf = self;
    
    UICollectionViewDiffableDataSourceSupplementaryViewProvider provider = ^UICollectionReusableView * _Nullable(UICollectionView * _Nonnull collectionView, NSString * _Nonnull elementKind, NSIndexPath * _Nonnull indexPath) {
        
        if ([elementKind isEqualToString:UICollectionElementKindSectionHeader]) {
            return [collectionView dequeueConfiguredReusableSupplementaryViewWithRegistration:unretainedSelf.headerCellRegistration forIndexPath:indexPath];
        } else {
            return nil;
        }
    };
    
    return [[provider copy] autorelease];
}

- (UICollectionViewSupplementaryRegistration *)makeHeaderCellRegistration {
    PickerViewController * __block unretainedSelf = self;
    
    UICollectionViewSupplementaryRegistration *registration = [UICollectionViewSupplementaryRegistration registrationWithSupplementaryClass:[UICollectionViewListCell class]
                                                                                                                                elementKind:UICollectionElementKindSectionHeader
                                                                                                                       configurationHandler:^(__kindof UICollectionViewListCell * _Nonnull supplementaryView, NSString * _Nonnull elementKind, NSIndexPath * _Nonnull indexPath) {
        
        NSString * _Nullable text = [unretainedSelf.viewModel.dataSource sectionIdentifierForIndex:indexPath.section].title;
        
        UIListContentConfiguration *configuration = [UIListContentConfiguration groupedHeaderConfiguration];
        configuration.text = text;
        
        supplementaryView.contentConfiguration = configuration;
    }];
    
    return registration;
}

- (void)bind {
    [NSNotificationCenter.defaultCenter addObserver:self
                                           selector:@selector(endedLoadingDataSourceReceived:)
                                               name:NSNotificationNamePickerViewModelEndedLoadingDataSource
                                             object:self.viewModel];
}

- (void)endedLoadingDataSourceReceived:(NSNotification *)notification {
    NSSet<PickerItemModel *> * _Nullable items = notification.userInfo[PickerViewModelEndedLoadingDataSourceItemsKey];
    
    if (items) {
        [self.delegate pickerViewController:self didSelectItems:items];
        self.didSelectItems(items);
    }
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [self.viewModel handleSelectionAtIndexPath:indexPath];
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
}

@end
