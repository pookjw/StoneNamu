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
#import "StepperViewController.h"

@interface CardOptionsViewController () <UICollectionViewDelegate>
@property (retain) UICollectionView *collectionView;
@property (retain) CardOptionsViewModel *viewModel;
@end

@implementation CardOptionsViewController

- (void)dealloc {
    [_collectionView release];
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
    self.title = NSLocalizedString(@"APP_NAME", @"");
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
        if (![item isKindOfClass:[CardOptionItemModel class]]) {
            return;
        }
        CardOptionItemModel *itemModel = (CardOptionItemModel *)item;
        
        UIListContentConfiguration *configuration = [UIListContentConfiguration subtitleCellConfiguration];
        configuration.text = itemModel.text;
        configuration.secondaryText = itemModel.secondaryText;
        cell.contentConfiguration = configuration;
        
        if (itemModel.value) {
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
                                               name:CardOptionsViewModelPresentTextFieldNotificationName
                                             object:self.viewModel];
    
    [NSNotificationCenter.defaultCenter addObserver:self
                                           selector:@selector(presentPickerEventReceived:)
                                               name:CardOptionsViewModelPresentPickerNotificationName
                                             object:self.viewModel];
    
    [NSNotificationCenter.defaultCenter addObserver:self
                                           selector:@selector(presentStepperEventReceived:)
                                               name:CardOptionsViewModelPresentStepperNotificationName
                                             object:self.viewModel];
}

- (void)presentTextFieldEventReceived:(NSNotification *)notification {
    CardOptionItemModel *itemModel = notification.userInfo[CardOptionsViewModelNotificationItemKey];
    
    [NSOperationQueue.mainQueue addOperationWithBlock:^{
        UIAlertController *vc = [UIAlertController alertControllerWithTitle:itemModel.text
                                                                    message:nil
                                                             preferredStyle:UIAlertControllerStyleAlert];
        
        [vc addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
            textField.text = itemModel.value;
        }];
        
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"CANCEL", @"")
                                                               style:UIAlertActionStyleCancel
                                                             handler:^(UIAlertAction * _Nonnull action) {}];
        
        UIAlertAction *doneAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"DONE", @"")
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
    CardOptionItemModel *itemModel = notification.userInfo[CardOptionsViewModelNotificationItemKey];
    BOOL showEmptyRow = [(NSNumber *)notification.userInfo[CardOptionsViewModelPickerShowEmptyRowNotificationItemKey] boolValue];
    
    [NSOperationQueue.mainQueue addOperationWithBlock:^{
        PickerViewController *vc = [[PickerViewController alloc] initWithDataSource:itemModel.pickerDataSource
                                                                              title:itemModel.text
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

- (void)presentStepperEventReceived:(NSNotification *)notification {
    CardOptionItemModel *itemModel = notification.userInfo[CardOptionsViewModelNotificationItemKey];
    NSRange range = itemModel.stepperRange;
    
    NSUInteger value;
    if (itemModel.value) {
        value = (NSUInteger)[itemModel.value integerValue];
    } else {
        value = 0;
    }
    
    [NSOperationQueue.mainQueue addOperationWithBlock:^{
        StepperViewController *vc = [[StepperViewController alloc] initWithRange:range
                                                                           title:itemModel.text
                                                                           value:value
                                                                 clearCompletion:^{
            [self.viewModel updateItem:itemModel withValue:nil];
        }
                                                                  doneCompletion:^(NSUInteger value) {
            [self.viewModel updateItem:itemModel withValue:[[NSNumber numberWithUnsignedInteger:value] stringValue]];
        }];
        SheetNavigationController *nvc = [[SheetNavigationController alloc] initWithRootViewController:vc];
        [nvc loadViewIfNeeded];
        
        [self presentViewController:nvc animated:YES completion:^{}];
        
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
