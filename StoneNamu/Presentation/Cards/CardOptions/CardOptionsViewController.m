//
//  CardOptionsViewController.m
//  StoneNamu
//
//  Created by Jinwoo Kim on 7/24/21.
//

#import "CardOptionsViewController.h"
#import "CardOptionsViewModel.h"
#import "SheetNavigationController.h"
#import "PickerViewController.h"
#import "UIViewController+SpinnerView.h"
#import "UIViewController+presentErrorAlert.h"
#import <StoneNamuResources/StoneNamuResources.h>

@interface CardOptionsViewController () <UICollectionViewDelegate>
@property (retain) UICollectionView *collectionView;
@property (retain) UIBarButtonItem *cancelButton;
@property (retain) UIBarButtonItem *resetButton;
@property (retain) CardOptionsViewModel *viewModel;
@end

@implementation CardOptionsViewController

- (instancetype)initWithOptions:(NSDictionary<NSString *, NSSet<NSString *> *> *)options {
    self = [self init];
    
    if (self) {
        [self loadViewIfNeeded];
        [self.viewModel updateDataSourceWithOptions:options];
    }
    
    return self;
}

- (void)dealloc {
    [_collectionView release];
    [_cancelButton release];
    [_resetButton release];
    [_viewModel release];
    [super dealloc];
}

- (void)setCancelButtonHidden:(BOOL)hidden {
    if (hidden) {
        self.navigationItem.leftBarButtonItems = @[self.resetButton];
    } else {
        self.navigationItem.leftBarButtonItems = @[self.cancelButton, self.resetButton];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setAttributes];
    [self configureLeftBarButtonItems];
    [self configureRightBarButtonItems];
    [self configureCollectionView];
    [self configureViewModel];
    [self bind];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self configureNavigation];
}

- (void)setAttributes {
    self.view.backgroundColor = UIColor.systemBackgroundColor;
}

- (void)configureNavigation {
    self.title = [ResourcesService localizationForKey:LocalizableKeyCardOptionsTitle];
}

- (void)configureLeftBarButtonItems {
    UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithTitle:[ResourcesService localizationForKey:LocalizableKeyCancel]
                                                                     style:UIBarButtonItemStylePlain
                                                                    target:self
                                                                    action:@selector(cancelButtonTriggered:)];
    
    UIBarButtonItem *resetButton = [[UIBarButtonItem alloc] initWithTitle:[ResourcesService localizationForKey:LocalizableKeyReset]
                                                                    style:UIBarButtonItemStylePlain
                                                                   target:self
                                                                   action:@selector(resetButtonTriggered:)];
    
    self.navigationItem.leftBarButtonItems = @[cancelButton, resetButton];
    self.cancelButton = cancelButton;
    self.resetButton = resetButton;
    [cancelButton release];
    [resetButton release];
}

- (void)configureRightBarButtonItems {
    UIBarButtonItem *fetchButton = [[UIBarButtonItem alloc] initWithTitle:[ResourcesService localizationForKey:LocalizableKeyDone]
                                                                    style:UIBarButtonItemStyleDone
                                                                   target:self
                                                                   action:@selector(fetchButtonTriggered:)];
    
    self.navigationItem.rightBarButtonItems = @[fetchButton];
    [fetchButton release];
}

- (void)cancelButtonTriggered:(UIBarButtonItem *)sender {
    [self dismissViewControllerAnimated:YES completion:^{}];
}

- (void)resetButtonTriggered:(UIBarButtonItem *)sender {
    [self.delegate cardOptionsViewController:self defaultOptionsAreNeededWithCompletion:^(NSDictionary<NSString *, NSSet<NSString *> *> * _Nonnull options) {
        [self.viewModel updateDataSourceWithOptions:options];
    }];
}

- (void)fetchButtonTriggered:(UIBarButtonItem *)sender {
    [self.delegate cardOptionsViewController:self doneWithOptions:self.viewModel.options];
}

- (void)configureCollectionView {
    UICollectionLayoutListConfiguration *layoutConfiguration = [[UICollectionLayoutListConfiguration alloc] initWithAppearance:UICollectionLayoutListAppearanceInsetGrouped];
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
        if (![item isKindOfClass:[CardOptionItemModel class]]) {
            return;
        }
        CardOptionItemModel *itemModel = (CardOptionItemModel *)item;
        
        UIListContentConfiguration *configuration = [UIListContentConfiguration subtitleCellConfiguration];
        configuration.text = itemModel.title;
        cell.contentConfiguration = configuration;
        
        //
        
        [cell.interactions enumerateObjectsUsingBlock:^(id<UIInteraction>  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj isKindOfClass:[UIToolTipInteraction class]]) {
                [cell removeInteraction:obj];
            }
        }];
        
        if (itemModel.toolTip != nil) {
            UIToolTipInteraction *toolTipInteraction = [[UIToolTipInteraction alloc] initWithDefaultToolTip:itemModel.toolTip];
            [cell addInteraction:toolTipInteraction];
            [toolTipInteraction release];
        }
        
        //
        
        if (itemModel.accessoryText) {
            cell.accessories = @[
                [[[UICellAccessoryLabel alloc] initWithText:itemModel.accessoryText] autorelease]
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
                                               name:NSNotificationNameCardOptionsViewModelPresentTextField
                                             object:self.viewModel];
    
    [NSNotificationCenter.defaultCenter addObserver:self
                                           selector:@selector(presentPickerEventReceived:)
                                               name:NSNotificationNameCardOptionsViewModelPresentPicker
                                             object:self.viewModel];
    
    [NSNotificationCenter.defaultCenter addObserver:self
                                           selector:@selector(startedLoadingDataSourceReceived:)
                                               name:NSNotificationNameCardOptionsViewModelStartedLoadingDataSource
                                             object:self.viewModel];
    
    [NSNotificationCenter.defaultCenter addObserver:self
                                           selector:@selector(endedLoadingDataSourceReceived:)
                                               name:NSNotificationNameCardOptionsViewModelEndedLoadingDataSource
                                             object:self.viewModel];
    
    [NSNotificationCenter.defaultCenter addObserver:self
                                           selector:@selector(errorOccuredReceived:)
                                               name:NSNotificationNameCardOptionsViewModelErrorOccured
                                             object:self.viewModel];
}

- (void)presentTextFieldEventReceived:(NSNotification *)notification {
    BlizzardHSAPIOptionType _Nullable optionType = notification.userInfo[CardOptionsViewModelPresentTextFieldOptionTypeItemKey];
    
    if (optionType == nil) return;
    
    NSString * _Nullable text = notification.userInfo[CardOptionsViewModelPresentTextFieldTextItemKey];
    NSString *title = [ResourcesService localizationForBlizzardHSAPIOptionType:optionType];
    
    [NSOperationQueue.mainQueue addOperationWithBlock:^{
        UIAlertController *vc = [UIAlertController alertControllerWithTitle:title
                                                                    message:nil
                                                             preferredStyle:UIAlertControllerStyleAlert];
        
        [vc addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
            textField.text = text;
        }];
        
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:[ResourcesService localizationForKey:LocalizableKeyCancel]
                                                               style:UIAlertActionStyleCancel
                                                             handler:^(UIAlertAction * _Nonnull action) {}];
        
        UIAlertAction *doneAction = [UIAlertAction actionWithTitle:[ResourcesService localizationForKey:LocalizableKeyDone]
                                                             style:UIAlertActionStyleDefault
                                                           handler:^(UIAlertAction * _Nonnull action) {
            
            NSString * _Nullable text = vc.textFields.firstObject.text;
            
            if (text != nil) {
                [self.viewModel updateOptionType:optionType withValues:[NSSet setWithObject:text]];
            } else {
                [self.viewModel updateOptionType:optionType withValues:nil];
            }
        }];
        
        [vc addAction:cancelAction];
        [vc addAction:doneAction];
        
        [self presentViewController:vc animated:YES completion:^{}];
        [vc release];
    }];
}

- (void)presentPickerEventReceived:(NSNotification *)notification {
//    CardOptionItemModel *itemModel = notification.userInfo[CardOptionsViewModelPresentNotificationItemKey];
//    BOOL showEmptyRow = [(NSNumber *)notification.userInfo[CardOptionsViewModelPresentPickerNotificationShowEmptyRowKey] boolValue];
//
//    [NSOperationQueue.mainQueue addOperationWithBlock:^{
//        PickerViewController *vc = [[PickerViewController alloc] initWithDataSource:itemModel.pickerDataSource
//                                                                              title:itemModel.text
//                                                                       showEmptyRow:showEmptyRow
//                                                                     doneCompletion:^(PickerItemModel * _Nullable pickerItemModel) {
//            [self.viewModel updateItem:itemModel withValues:[NSSet setWithObject:pickerItemModel.identity]];
//        }];
//        SheetNavigationController *nvc = [[SheetNavigationController alloc] initWithRootViewController:vc];
//        [nvc loadViewIfNeeded];
//
//        [self presentViewController:nvc animated:YES completion:^{
//            [vc selectIdentity:itemModel.values animated:YES];
//        }];
//
//        [vc release];
//        [nvc release];
//    }];
}

- (void)startedLoadingDataSourceReceived:(NSNotification *)notification {
    [NSOperationQueue.mainQueue addOperationWithBlock:^{
        [self addSpinnerView];
    }];
}

- (void)endedLoadingDataSourceReceived:(NSNotification *)notification {
    [NSOperationQueue.mainQueue addOperationWithBlock:^{
        [self removeAllSpinnerview];
    }];
}

- (void)errorOccuredReceived:(NSNotification *)notification {
    NSError * _Nullable error = notification.userInfo[CardOptionsViewModelErrorOccuredErrorItemKey];
    
    if (error) {
        [NSOperationQueue.mainQueue addOperationWithBlock:^{
            [self presentErrorAlertWithError:error];
        }];
    }
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [self.viewModel handleSelectionForIndexPath:indexPath];
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
}

@end
