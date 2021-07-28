//
//  CardOptionsViewController.m
//  StoneNamu
//
//  Created by Jinwoo Kim on 7/24/21.
//

#import "CardOptionsViewController.h"
#import "CardOptionsViewModel.h"
#import "CardsViewController.h"
#import "SheetNavigationController.h"
#import "PickerViewController.h"

@interface CardOptionsViewController () <UICollectionViewDelegate>
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
    [self bind];
}

- (void)setAttributes {
    self.view.backgroundColor = UIColor.systemBackgroundColor;
    self.title = @"StoneNamu (번역)";
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
    CardsViewController *vc = [[CardsViewController alloc] initWithOptions:self.viewModel.options];
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
    CardOptionsViewModel *viewModel = [[CardOptionsViewModel alloc] initWithDataSource:[self makeDataSource]];
    self.viewModel = viewModel;
    [viewModel release];
}

- (CardOptionsDataSource *)makeDataSource {
    UICollectionViewCellRegistration *cellRegistration = [self makeCellRegistration];
    
    CardOptionsDataSource *dataSource = [[CardOptionsDataSource alloc] initWithCollectionView:self.collectionView
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
    UICollectionViewCellRegistration *cellRegistration = [UICollectionViewCellRegistration registrationWithCellClass:[UICollectionViewListCell class]
                                                                                                configurationHandler:^(__kindof UICollectionViewListCell * _Nonnull cell, NSIndexPath * _Nonnull indexPath, id  _Nonnull item) {
        if (![item isKindOfClass:[CardOptionsItemModel class]]) {
            return;
        }
        CardOptionsItemModel *itemModel = (CardOptionsItemModel *)item;
        
        UIListContentConfiguration *configuration = [UIListContentConfiguration subtitleCellConfiguration];
        configuration.text = itemModel.text;
        configuration.secondaryText = itemModel.secondaryText;
        cell.contentConfiguration = configuration;
        
        if (itemModel.value) {
            cell.accessories = @[
                [[[UICellAccessoryLabel alloc] initWithText:itemModel.value] autorelease]
            ];
        } else {
            cell.accessories = @[];
        }
    }];
    
    return cellRegistration;
}

- (void)bind {
    [NSNotificationCenter.defaultCenter addObserver:self
                                           selector:@selector(presentTextFieldEventReceived:)
                                               name:CardOptionsViewModelPresentTextFieldNotificationName
                                             object:self.viewModel];
    
    [NSNotificationCenter.defaultCenter addObserver:self
                                           selector:@selector(presentPickerEventReceived:)
                                               name:CardOptionsViewModelPresentPickerNotificationName
                                             object:self.viewModel];
}

- (void)presentTextFieldEventReceived:(NSNotification *)notification {
    CardOptionsItemModel *itemModel = notification.userInfo[CardOptionsViewModelNotificationItemKey];
    
    [NSOperationQueue.mainQueue addOperationWithBlock:^{
        UIAlertController *vc = [UIAlertController alertControllerWithTitle:@"테스트"
                                                                    message:@"테스트"
                                                             preferredStyle:UIAlertControllerStyleAlert];
        
        [vc addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
            textField.text = itemModel.value;
        }];
        
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"취소 (번역)"
                                                               style:UIAlertActionStyleCancel
                                                             handler:^(UIAlertAction * _Nonnull action) {}];
        
        UIAlertAction *doneAction = [UIAlertAction actionWithTitle:@"완료 (번역)"
                                                             style:UIAlertActionStyleDefault
                                                           handler:^(UIAlertAction * _Nonnull action) {
            
            UITextField * _Nullable textField = vc.textFields.firstObject;
            
            if (textField) {
                [[itemModel retain] autorelease];
                [self.viewModel updateItem:itemModel withValue:textField.text];
            }
        }];
        
        [vc addAction:cancelAction];
        [vc addAction:doneAction];
        
        [self presentViewController:vc animated:YES completion:^{}];
        [vc release];
    }];
}

- (void)presentPickerEventReceived:(NSNotification *)notification {
    CardOptionsItemModel *itemModel = notification.userInfo[CardOptionsViewModelNotificationItemKey];
    BOOL showEmptyRow = [(NSNumber *)notification.userInfo[CardOptionsViewModelPickerShowEmptyRowNotificationItemKey] boolValue];
    
    [NSOperationQueue.mainQueue addOperationWithBlock:^{
        PickerViewController *vc = [[PickerViewController alloc] initWithDataSource:itemModel.pickerDataSource
                                                                              title:@"테스트"
                                                                       showEmptyRow:showEmptyRow
                                                                     doneCompletion:^(PickerItemModel * _Nullable pickerItemModel) {
            [self.viewModel updateItem:itemModel withValue:pickerItemModel.identity];
        }];
        SheetNavigationController *nvc = [[SheetNavigationController alloc] initWithRootViewController:vc];
        [nvc loadViewIfNeeded];
        
        [self presentViewController:nvc animated:YES completion:^{
            [vc selectIdentity:itemModel.value animated:YES];
        }];
        
        [vc release];
        [nvc release];
    }];
}

#pragma mark UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [self.viewModel handleSelectionForIndexPath:indexPath];
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
}

@end
