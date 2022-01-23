//
//  DeckAddCardOptionsViewController.m
//  StoneNamu
//
//  Created by Jinwoo Kim on 7/24/21.
//

#import "DeckAddCardOptionsViewController.h"
#import "DeckAddCardOptionsViewModel.h"
#import "SheetNavigationController.h"
#import "PickerViewController.h"
#import "StepperViewController.h"
#import <StoneNamuResources/StoneNamuResources.h>

@interface DeckAddCardOptionsViewController () <UICollectionViewDelegate>
@property (retain) UICollectionView *collectionView;
@property (retain) UIBarButtonItem *cancelButton;
@property (retain) UIBarButtonItem *resetButton;
@property (retain) DeckAddCardOptionsViewModel *viewModel;
@end

@implementation DeckAddCardOptionsViewController

- (instancetype)initWithOptions:(NSDictionary<NSString *,NSString *> *)options localDeck:(nonnull LocalDeck *)localDeck {
    self = [self init];
    
    if (self) {
        [self loadViewIfNeeded];
        [self.viewModel updateDataSourceWithOptions:options];
        self.viewModel.localDeck = localDeck;
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
    [self.delegate deckAddCardOptionsViewController:self defaultOptionsAreNeededWithCompletion:^(NSDictionary<NSString *,NSString *> * _Nonnull options) {
        [self.viewModel updateDataSourceWithOptions:options];
    }];
}

- (void)fetchButtonTriggered:(UIBarButtonItem *)sender {
    [self.delegate deckAddCardOptionsViewController:self doneWithOptions:self.viewModel.options];
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
    DeckAddCardOptionsViewModel *viewModel = [[DeckAddCardOptionsViewModel alloc] initWithDataSource:[self makeDataSource]];
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
    
    return [dataSource autorelease];
}

- (UICollectionViewCellRegistration *)makeCellRegistration {
    UICollectionViewCellRegistration *cellRegistration = [UICollectionViewCellRegistration registrationWithCellClass:[UICollectionViewListCell class]
                                                                                                configurationHandler:^(__kindof UICollectionViewListCell * _Nonnull cell, NSIndexPath * _Nonnull indexPath, id  _Nonnull item) {
        if (![item isKindOfClass:[DeckAddCardOptionItemModel class]]) {
            return;
        }
        DeckAddCardOptionItemModel *itemModel = (DeckAddCardOptionItemModel *)item;
        
        UIListContentConfiguration *configuration = [UIListContentConfiguration subtitleCellConfiguration];
        configuration.text = itemModel.text;
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
                                               name:NSNotificationNameDeckAddCardOptionsViewModelPresentTextField
                                             object:self.viewModel];
    
    [NSNotificationCenter.defaultCenter addObserver:self
                                           selector:@selector(presentPickerEventReceived:)
                                               name:NSNotificationNameDeckAddCardOptionsViewModelPresentPicker
                                             object:self.viewModel];
    
    [NSNotificationCenter.defaultCenter addObserver:self
                                           selector:@selector(presentStepperEventReceived:)
                                               name:NSNotificationNameDeckAddCardOptionsViewModelPresentStepper
                                             object:self.viewModel];
}

- (void)presentTextFieldEventReceived:(NSNotification *)notification {
    DeckAddCardOptionItemModel *itemModel = notification.userInfo[DeckAddCardOptionsViewModelPresentNotificationItemKey];
    
    [NSOperationQueue.mainQueue addOperationWithBlock:^{
        UIAlertController *vc = [UIAlertController alertControllerWithTitle:itemModel.text
                                                                    message:nil
                                                             preferredStyle:UIAlertControllerStyleAlert];
        
        [vc addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
            textField.text = itemModel.value;
        }];
        
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:[ResourcesService localizationForKey:LocalizableKeyCancel]
                                                               style:UIAlertActionStyleCancel
                                                             handler:^(UIAlertAction * _Nonnull action) {}];
        
        UIAlertAction *doneAction = [UIAlertAction actionWithTitle:[ResourcesService localizationForKey:LocalizableKeyDone]
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
    DeckAddCardOptionItemModel *itemModel = notification.userInfo[DeckAddCardOptionsViewModelPresentNotificationItemKey];
    BOOL showEmptyRow = [(NSNumber *)notification.userInfo[DeckAddCardOptionsViewModelPresentPickerNotificationShowEmptyRowKey] boolValue];
    
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
    DeckAddCardOptionItemModel *itemModel = notification.userInfo[DeckAddCardOptionsViewModelPresentNotificationItemKey];
    NSRange range = itemModel.stepperRange;
    BOOL showPlusMarkWhenReachedToMax = itemModel.showPlusMarkWhenReachedToMaxOnStepper;
    
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
        
        vc.showPlusMarkWhenReachedToMax = showPlusMarkWhenReachedToMax;
        SheetNavigationController *nvc = [[SheetNavigationController alloc] initWithRootViewController:vc];
        [nvc loadViewIfNeeded];
        
        [self presentViewController:nvc animated:YES completion:^{}];
        
        [vc release];
        [nvc release];
    }];
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [self.viewModel handleSelectionForIndexPath:indexPath];
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
}

@end
