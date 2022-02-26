//
//  DeckAddCardOptionsViewController.m
//  StoneNamu
//
//  Created by Jinwoo Kim on 7/24/21.
//

#import "DeckAddCardOptionsViewController.h"
#import "DeckAddCardOptionsViewModel.h"
#import "PickerViewController.h"
#import "UIViewController+SpinnerView.h"
#import "UIViewController+presentErrorAlert.h"
#import "UIViewController+animatedForSelectedIndexPath.h"
#import <StoneNamuResources/StoneNamuResources.h>

@interface DeckAddCardOptionsViewController () <UICollectionViewDelegate>
@property (retain) UICollectionView *collectionView;
@property (retain) UIBarButtonItem *cancelButton;
@property (retain) UIBarButtonItem *resetButton;
@property (retain) UIViewController * _Nullable contextViewController;
@property (retain) DeckAddCardOptionsViewModel *viewModel;
@end

@implementation DeckAddCardOptionsViewController

- (instancetype)init {
    self = [super init];
    
    if (self) {
        self.contextViewController = nil;
    }
    
    return self;
}

- (instancetype)initWithOptions:(NSDictionary<NSString *,NSSet<NSString *> *> *)options localDeck:(nonnull LocalDeck *)localDeck {
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
    [_contextViewController release];
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
    [self animatedForSelectedIndexPathWithCollectionView:self.collectionView];
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
    [self.delegate deckAddCardOptionsViewController:self defaultOptionsAreNeededWithCompletion:^(NSDictionary<NSString *, NSSet<NSString *> *> * _Nonnull options) {
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
            UICellAccessoryLabel *label = [[UICellAccessoryLabel alloc] initWithText:itemModel.accessoryText];
            cell.accessories = @[label];
            [label release];
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
                                           selector:@selector(startedLoadingDataSourceReceived:)
                                               name:NSNotificationNameDeckAddCardOptionsViewModelStartedLoadingDataSource
                                             object:self.viewModel];
    
    [NSNotificationCenter.defaultCenter addObserver:self
                                           selector:@selector(endedLoadingDataSourceReceived:)
                                               name:NSNotificationNameDeckAddCardOptionsViewModelEndedLoadingDataSource
                                             object:self.viewModel];
    
    [NSNotificationCenter.defaultCenter addObserver:self
                                           selector:@selector(errorOccuredReceived:)
                                               name:NSNotificationNameDeckAddCardOptionsViewModelErrorOccured
                                             object:self.viewModel];
}

- (void)presentTextFieldEventReceived:(NSNotification *)notification {
    BlizzardHSAPIOptionType _Nullable optionType = notification.userInfo[DeckAddCardOptionsViewModelPresentTextFieldOptionTypeItemKey];
    
    if (optionType == nil) return;
    
    NSString * _Nullable text = notification.userInfo[DeckAddCardOptionsViewModelPresentTextFieldTextItemKey];
    NSIndexPath * _Nullable indexPath = notification.userInfo[DeckAddCardOptionsViewModelPresentTextFieldIndexPathItemKey];
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
        
        [self presentViewController:vc animated:YES completion:^{
            if (indexPath) {
                [self.collectionView deselectItemAtIndexPath:indexPath animated:YES];
            }
        }];
        [vc release];
    }];
}

- (void)presentPickerEventReceived:(NSNotification *)notification {
    NSString * _Nullable title = notification.userInfo[DeckAddCardOptionsViewModelPresentPickerNotificationTitleItemKey];
    BlizzardHSAPIOptionType _Nullable optionType = notification.userInfo[DeckAddCardOptionsViewModelPresentPickerNotificationOptionTypeItemKey];
    NSDictionary<PickerSectionModel *, NSSet<PickerItemModel *> *> * _Nullable pickers = notification.userInfo[DeckAddCardOptionsViewModelPresentPickerNotificationPickersItemKey];
    NSNumber * _Nullable allowsMultipleSelection = notification.userInfo[DeckAddCardOptionsViewModelPresentPickerNotificationAllowsMultipleSelectionItemKey];
    NSComparisonResult (^comparator)(NSString *, NSString *) = notification.userInfo[DeckAddCardOptionsViewModelPresentPickerNotificationComparatorItemKey];
    void (^didSelectItems)(NSSet<PickerItemModel *> *) = ^(NSSet<PickerItemModel *> * _Nonnull selectedItems) {
        dispatch_queue_t queue = dispatch_get_global_queue(QOS_CLASS_USER_INTERACTIVE, 0);
        
        dispatch_async(queue, ^{
            if (selectedItems.count == 0) {
                [self.viewModel updateOptionType:optionType withValues:nil];
                return;
            } else if (selectedItems.count == 1) {
                BOOL isEmptyItem = (selectedItems.allObjects.firstObject.type == PickerItemModelTypeEmpty);
                
                if (isEmptyItem) {
                    [self.viewModel updateOptionType:optionType withValues:nil];
                    return;
                }
            }
            
            NSMutableSet<NSString *> *results = [NSMutableSet<NSString *> new];
            
            [selectedItems enumerateObjectsUsingBlock:^(PickerItemModel * _Nonnull obj, BOOL * _Nonnull stop) {
                [results addObject:obj.key];
            }];
            
            [self.viewModel updateOptionType:optionType withValues:results];
            [results release];
        });
    };
    
    if (optionType && pickers && allowsMultipleSelection && comparator) {
        [NSOperationQueue.mainQueue addOperationWithBlock:^{
            if ((self.contextViewController) && ([self.contextViewController isKindOfClass:[PickerViewController class]])) {
                PickerViewController *vc = (PickerViewController *)self.contextViewController;
                vc.title = title;
                
                [vc requestWithItems:pickers allowsMultipleSelection:allowsMultipleSelection.boolValue comparator:comparator didSelectItems:didSelectItems];
            } else {
                PickerViewController *vc = [[PickerViewController alloc] initWithItems:pickers allowsMultipleSelection:allowsMultipleSelection.boolValue comparator:comparator didSelectItems:didSelectItems];
                vc.title = title;
                
                [self.navigationController pushViewController:vc animated:YES];
                
                [vc release];
            }
        }];
    }
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
    NSError * _Nullable error = notification.userInfo[DeckAddCardOptionsViewModelErrorOccuredErrorItemKey];
    
    if (error) {
        [NSOperationQueue.mainQueue addOperationWithBlock:^{
            [self presentErrorAlertWithError:error];
        }];
    }
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [self.viewModel handleSelectionForIndexPath:indexPath];
}

- (UIContextMenuConfiguration *)collectionView:(UICollectionView *)collectionView contextMenuConfigurationForItemAtIndexPath:(NSIndexPath *)indexPath point:(CGPoint)point {
    self.contextViewController = nil;
    self.viewModel.contextMenuIndexPath = nil;
    
    DeckAddCardOptionItemModel * _Nullable itemModel = [self.viewModel.dataSource itemIdentifierForIndexPath:indexPath];
    if (itemModel == nil) return nil;
    
    if ([itemModel.optionType isEqualToString:BlizzardHSAPIOptionTypeTextFilter]) return nil;
    
    UIContextMenuConfiguration *configuration = [UIContextMenuConfiguration configurationWithIdentifier:nil previewProvider:^UIViewController * _Nullable{
        self.viewModel.contextMenuIndexPath = indexPath;
        
        PickerViewController *vc = [PickerViewController new];
        self.contextViewController = vc;
        [self.viewModel handleSelectionForIndexPath:indexPath];
        return [vc autorelease];
    } actionProvider:nil];
    
    return configuration;
}

- (void)collectionView:(UICollectionView *)collectionView willEndContextMenuInteractionWithConfiguration:(UIContextMenuConfiguration *)configuration animator:(id<UIContextMenuInteractionAnimating>)animator {
    [animator addCompletion:^{
        self.contextViewController = nil;
        self.viewModel.contextMenuIndexPath = nil;
    }];
}

- (void)collectionView:(UICollectionView *)collectionView willPerformPreviewActionForMenuWithConfiguration:(UIContextMenuConfiguration *)configuration animator:(id<UIContextMenuInteractionCommitAnimating>)animator {
    [animator addAnimations:^{
        [self.navigationController pushViewController:self.contextViewController animated:YES];
    }];
}

@end
