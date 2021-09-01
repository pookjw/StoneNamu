//
//  DeckDetailsViewController.m
//  DeckDetailsViewController
//
//  Created by Jinwoo Kim on 8/17/21.
//

#import "DeckDetailsViewController.h"
#import "DeckDetailsViewModel.h"
#import "UIViewController+presentErrorAlert.h"
#import "DeckDetailsCardContentConfiguration.h"
#import "DeckDetailsManaCostContentConfiguration.h"
#import "CardDetailsViewController.h"
#import "UIViewController+SpinnerView.h"

#define CardsSectionHeaderViewTag 300

@interface DeckDetailsViewController () <UICollectionViewDelegate, UICollectionViewDragDelegate, UICollectionViewDropDelegate>
@property (retain) UICollectionView *collectionView;
@property (retain) UICollectionViewSupplementaryRegistration *headerCellRegistration;
@property (retain) UIBarButtonItem *exportBarButtonItem;
@property (retain) UIBarButtonItem *editBarButtonItem;
@property (retain) DeckDetailsViewModel *viewModel;
@end

@implementation DeckDetailsViewController

- (instancetype)initWithLocalDeck:(LocalDeck *)localDeck {
    self = [self init];
    
    if (self) {
        [self loadViewIfNeeded];
        [self addSpinnerView];
        [self.viewModel requestDataSourceWithLocalDeck:localDeck];
    }
    
    return self;
}

- (void)dealloc {
    [_collectionView release];
    [_headerCellRegistration release];
    [_exportBarButtonItem release];
    [_viewModel release];
    [_exportBarButtonItem release];
    [_editBarButtonItem release];
    [super dealloc];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setAttributes];
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
    self.navigationItem.largeTitleDisplayMode = UINavigationItemLargeTitleDisplayModeNever;
}

- (void)configureRightBarButtonItems {
    UIBarButtonItem *exportBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage systemImageNamed:@"square.and.arrow.up"]
                                                                            style:UIBarButtonItemStylePlain
                                                                           target:self
                                                                           action:@selector(exportBarButtonItemTriggered:)];
    self.exportBarButtonItem = exportBarButtonItem;
    exportBarButtonItem.enabled = NO;
    
    //
    
    UIBarButtonItem *editBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage systemImageNamed:@"pencil"]
                                                                          style:UIBarButtonItemStylePlain
                                                                         target:self
                                                                         action:@selector(editBarButtonItemTriggered:)];
    self.editBarButtonItem = editBarButtonItem;
    
    //
    
    self.navigationItem.rightBarButtonItems = @[exportBarButtonItem, editBarButtonItem];
    
    [exportBarButtonItem release];
    [editBarButtonItem release];
}

- (void)exportBarButtonItemTriggered:(UIBarButtonItem *)sender {
    [self addSpinnerView];
    
    [self.viewModel exportDeckCodeWithCompletion:^(NSString * _Nullable deckCode) {
        [NSOperationQueue.mainQueue addOperationWithBlock:^{
            [self removeAllSpinnerview];
            
            if (deckCode) {
                UIActivityViewController *activity = [[UIActivityViewController alloc] initWithActivityItems:@[deckCode] applicationActivities:nil];
                activity.popoverPresentationController.barButtonItem = self.exportBarButtonItem;
                [self presentViewController:activity animated:YES completion:^{}];
            }
        }];
    }];
}

- (void)editBarButtonItemTriggered:(UIBarButtonItem *)sender {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"EDIT_DECK_NAME_TITLE", @"")
                                                                   message:nil
                                                            preferredStyle:UIAlertControllerStyleAlert];
    
    [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.text = self.viewModel.localDeck.name;
    }];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"CANCEL", @"")
                                                           style:UIAlertActionStyleCancel
                                                         handler:^(UIAlertAction * _Nonnull action) {}];
    
    UIAlertAction *doneAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"DONE", @"")
                                                         style:UIAlertActionStyleDefault
                                                       handler:^(UIAlertAction * _Nonnull action) {
        [self.viewModel updateDeckName:alert.textFields.firstObject.text];
    }];
    
    [alert addAction:cancelAction];
    [alert addAction:doneAction];
    
    [self presentViewController:alert animated:YES completion:^{}];
}

- (void)configureCollectionView {
    UICollectionLayoutListConfiguration *layoutConfiguration = [[UICollectionLayoutListConfiguration alloc] initWithAppearance:UICollectionLayoutListAppearanceInsetGrouped];
    layoutConfiguration.headerMode = UICollectionLayoutListHeaderModeSupplementary;
    layoutConfiguration.trailingSwipeActionsConfigurationProvider = [self makeTrailingSwipeProvider];
    
    UIListSeparatorConfiguration *separatorConfiguration = [[UIListSeparatorConfiguration alloc] initWithListAppearance:UICollectionLayoutListAppearancePlain];
    separatorConfiguration.topSeparatorInsets = NSDirectionalEdgeInsetsZero;
    separatorConfiguration.bottomSeparatorInsets = NSDirectionalEdgeInsetsZero;
    layoutConfiguration.separatorConfiguration = separatorConfiguration;
    [separatorConfiguration release];
    
    UICollectionViewCompositionalLayout *layout = [UICollectionViewCompositionalLayout layoutWithListConfiguration:layoutConfiguration];
    [layoutConfiguration release];
    
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:layout];
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
    collectionView.dragDelegate = self;
    collectionView.dropDelegate = self;
    
    [collectionView release];
}

- (void)configureViewModel {
    DeckDetailsViewModel *viewModel = [[DeckDetailsViewModel alloc] initWithDataSource:[self makeDataSource]];
    self.viewModel = viewModel;
    [viewModel release];
}

- (DecksDetailsDataSource *)makeDataSource {
    UICollectionViewCellRegistration *cellRegistration = [self makeCellRegistration];
    
    DecksDetailsDataSource *dataSource = [[DecksDetailsDataSource alloc] initWithCollectionView:self.collectionView cellProvider:^UICollectionViewCell * _Nullable(UICollectionView * _Nonnull collectionView, NSIndexPath * _Nonnull indexPath, id  _Nonnull itemIdentifier) {
        
        UICollectionViewCell *cell = [collectionView dequeueConfiguredReusableCellWithRegistration:cellRegistration forIndexPath:indexPath item:itemIdentifier];
        
        return cell;
    }];
    
    dataSource.supplementaryViewProvider = [self makeSupplementaryViewProvider];
    
    return [dataSource autorelease];
}

- (UICollectionViewCellRegistration *)makeCellRegistration {
    UICollectionViewCellRegistration *cellRegistration = [UICollectionViewCellRegistration registrationWithCellClass:[UICollectionViewListCell class] configurationHandler:^(__kindof UICollectionViewListCell * _Nonnull cell, NSIndexPath * _Nonnull indexPath, id  _Nonnull item) {
        
        if (![item isKindOfClass:[DeckDetailsItemModel class]]) {
            return;
        }
        
        DeckDetailsItemModel *itemModel = (DeckDetailsItemModel *)item;
        
        switch (itemModel.type) {
            case DeckDetailsItemModelTypeCost: {
                DeckDetailsManaCostContentConfiguration *configuration = [[DeckDetailsManaCostContentConfiguration alloc] initWithManaDictionary:itemModel.manaDictionary];
                cell.contentConfiguration = configuration;
                [configuration release];
                break;
            }
            case DeckDetailsItemModelTypeCard: {
                DeckDetailsCardContentConfiguration *configuration = [[DeckDetailsCardContentConfiguration alloc] initWithHSCard:itemModel.hsCard
                                                                                                                     hsCardCount:itemModel.hsCardCount];
                cell.contentConfiguration = configuration;
                [configuration release];
                break;
            }
            default:
                break;
        }
    }];
    
    return cellRegistration;
}

- (UICollectionViewDiffableDataSourceSupplementaryViewProvider)makeSupplementaryViewProvider {
    self.headerCellRegistration = [self makeHeaderCellRegistration];
    
    UICollectionViewDiffableDataSourceSupplementaryViewProvider provider = ^UICollectionReusableView * _Nullable(UICollectionView * _Nonnull collectionView, NSString * _Nonnull elementKind, NSIndexPath * _Nonnull indexPath) {
        
        if ([elementKind isEqualToString:UICollectionElementKindSectionHeader]) {
            return [collectionView dequeueConfiguredReusableSupplementaryViewWithRegistration:self.headerCellRegistration forIndexPath:indexPath];
        } else {
            return nil;
        }
    };
    
    return [[provider copy] autorelease];
}

- (UICollectionViewSupplementaryRegistration *)makeHeaderCellRegistration {
    UICollectionViewSupplementaryRegistration *registration = [UICollectionViewSupplementaryRegistration registrationWithSupplementaryClass:[UICollectionViewListCell class]
                                                                                                                                elementKind:UICollectionElementKindSectionHeader
                                                                                                                       configurationHandler:^(__kindof UICollectionViewListCell * _Nonnull supplementaryView, NSString * _Nonnull elementKind, NSIndexPath * _Nonnull indexPath) {
        
        
        
        UIListContentConfiguration *configuration = [UIListContentConfiguration groupedHeaderConfiguration];
        configuration.text = [self.viewModel headerTextForIndexPath:indexPath];
        
        supplementaryView.contentConfiguration = configuration;
        supplementaryView.tag = CardsSectionHeaderViewTag;
    }];
    
    return registration;
}

- (UICollectionLayoutListSwipeActionsConfigurationProvider)makeTrailingSwipeProvider {
    UICollectionLayoutListSwipeActionsConfigurationProvider provider = ^UISwipeActionsConfiguration * _Nullable(NSIndexPath *indexPath) {
        
        DeckDetailsItemModel *itemModel = [self.viewModel.dataSource itemIdentifierForIndexPath:indexPath];
        
        if (itemModel.type != DeckDetailsItemModelTypeCard) {
            return nil;
        }
        
        //
        
        UIContextualAction *decrementAction = [UIContextualAction contextualActionWithStyle:UIContextualActionStyleNormal
                                                                                      title:nil
                                                                                    handler:^(UIContextualAction * _Nonnull action, __kindof UIView * _Nonnull sourceView, void (^ _Nonnull completionHandler)(BOOL)) {
            [self.viewModel decreaseAtIndexPath:indexPath];
        }];
        
        decrementAction.image = [UIImage systemImageNamed:@"minus"];
        decrementAction.backgroundColor = UIColor.systemOrangeColor;
        
        //
        
        UIContextualAction *incrementAction = [UIContextualAction contextualActionWithStyle:UIContextualActionStyleNormal
                                                                                      title:nil
                                                                                    handler:^(UIContextualAction * _Nonnull action, __kindof UIView * _Nonnull sourceView, void (^ _Nonnull completionHandler)(BOOL)) {
            [self.viewModel increaseAtIndexPath:indexPath];
        }];
        
        incrementAction.image = [UIImage systemImageNamed:@"plus"];
        incrementAction.backgroundColor = UIColor.systemGreenColor;
        
        //
        
        UIContextualAction *deleteAction = [UIContextualAction contextualActionWithStyle:UIContextualActionStyleDestructive
                                                                                   title:nil
                                                                                 handler:^(UIContextualAction * _Nonnull action, __kindof UIView * _Nonnull sourceView, void (^ _Nonnull completionHandler)(BOOL)) {
            [self.viewModel deleteAtIndexPath:indexPath];
        }];
        
        deleteAction.image = [UIImage systemImageNamed:@"trash"];
        
        //
        
        UISwipeActionsConfiguration *configuration = [UISwipeActionsConfiguration configurationWithActions:@[deleteAction, incrementAction, decrementAction]];
        configuration.performsFirstActionWithFullSwipe = NO;
        return configuration;
    };
    
    return [[provider copy] autorelease];
}

- (void)bind {
    [NSNotificationCenter.defaultCenter addObserver:self
                                           selector:@selector(shouldDismissReceived:)
                                               name:DeckDetailsViewModelShouldDismissNotificationName
                                             object:self.viewModel];
    
    [NSNotificationCenter.defaultCenter addObserver:self
                                           selector:@selector(hasAnyCardsReceived:)
                                               name:DeckDetailsViewModelHasAnyCardsNotificationName
                                             object:self.viewModel];
    
    [NSNotificationCenter.defaultCenter addObserver:self
                                           selector:@selector(didChangeLocalDeckNameReceived:)
                                               name:DeckDetailsViewModelDidChangeLocalDeckNameNoficationName
                                             object:self.viewModel];
    
    [NSNotificationCenter.defaultCenter addObserver:self
                                           selector:@selector(errorOccuredReceived:)
                                               name:DeckDetailsViewModelErrorOccuredNoficiationName
                                             object:self.viewModel];
    
    [NSNotificationCenter.defaultCenter addObserver:self
                                           selector:@selector(applyingSnapshotToDataSourceWasDoneReceived:)
                                               name:DeckDetailsViewModelApplyingSnapshotToDataSourceWasDoneNotificationName
                                             object:self.viewModel];
}

- (void)shouldDismissReceived:(NSNotification *)notification {
    [NSOperationQueue.mainQueue addOperationWithBlock:^{
        if (self.splitViewController.isCollapsed) {
            [self.navigationController popViewControllerAnimated:YES];
        } else {
            self.navigationController.viewControllers = @[];
        }
    }];
}

- (void)hasAnyCardsReceived:(NSNotification *)notification {
    BOOL hasCards = [(NSNumber *)notification.userInfo[DeckDetailsViewModelHasAnyCardsItemKey] boolValue];
    
    [NSOperationQueue.mainQueue addOperationWithBlock:^{
        self.exportBarButtonItem.enabled = hasCards;
    }];
}

- (void)didChangeLocalDeckNameReceived:(NSNotification *)noficiation {
    NSString *name = [noficiation.userInfo[DeckDetailsViewModelDidChangeLocalDeckNameItemKey] copy];
    
    [NSOperationQueue.mainQueue addOperationWithBlock:^{
        self.title = name;
        [name release];
    }];
}

- (void)errorOccuredReceived:(NSNotification *)notification {
    NSError *error = [(NSError *)notification.userInfo[DeckDetailsViewModelErrorOccuredItemKey] copy];
    
    if (error) {
        [NSOperationQueue.mainQueue addOperationWithBlock:^{
            [self presentErrorAlertWithError:error];
            [error release];
        }];
    }
}

- (void)applyingSnapshotToDataSourceWasDoneReceived:(NSNotification *)notification {
    NSString * _Nullable headerText = [notification.userInfo[DeckDetailsViewModelApplyingSnapshotToDataSourceWasDoneCardsHeaderTextKey] copy];
    
    [NSOperationQueue.mainQueue addOperationWithBlock:^{
        [self removeAllSpinnerview];
        [self updateSectionHeaderViewWithHeaderText:headerText];
        [headerText release];
    }];
}

- (void)presentCardDetailsVCWithHSCard:(HSCard *)hsCard {
    if (hsCard == nil) return;
    
    CardDetailsViewController *vc = [[CardDetailsViewController alloc] initWithHSCard:hsCard sourceImageView:nil];
    [vc loadViewIfNeeded];
    [self presentViewController:vc animated:YES completion:^{}];
}

- (void)updateSectionHeaderViewWithHeaderText:(NSString *)headerText {
    UICollectionViewListCell *cell = [self.collectionView viewWithTag:300];
    UIListContentConfiguration *configuration = [UIListContentConfiguration groupedHeaderConfiguration];
    configuration.text = headerText;
    
    cell.contentConfiguration = configuration;
}

#pragma mark - UICollectionViewDelegate

- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
    DeckDetailsItemModel * _Nullable itemModel = [self.viewModel.dataSource itemIdentifierForIndexPath:indexPath];
    
    if (itemModel == nil) return NO;
    
    switch (itemModel.type) {
        case DeckDetailsItemModelTypeCard:
            return YES;
        default:
            return NO;
    }
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    
    DeckDetailsItemModel * _Nullable itemModel = [self.viewModel.dataSource itemIdentifierForIndexPath:indexPath];
    
    if ((itemModel == nil) || (itemModel.type != DeckDetailsItemModelTypeCard)) {
        return;
    }
    
    //
    
    [self presentCardDetailsVCWithHSCard:itemModel.hsCard];
}

- (UIContextMenuConfiguration *)collectionView:(UICollectionView *)collectionView contextMenuConfigurationForItemAtIndexPath:(NSIndexPath *)indexPath point:(CGPoint)point {
    self.viewModel.contextMenuIndexPath = indexPath;
    
    DeckDetailsItemModel * _Nullable itemModel = [self.viewModel.dataSource itemIdentifierForIndexPath:indexPath];
    if (itemModel == nil) return nil;
    
    switch (itemModel.type) {
        case DeckDetailsItemModelTypeCard: {
            UIContextMenuConfiguration *configuration = [UIContextMenuConfiguration configurationWithIdentifier:nil
                                                                                                previewProvider:nil
                                                                                                 actionProvider:^UIMenu * _Nullable(NSArray<UIMenuElement *> * _Nonnull suggestedActions) {
                
                UIAction *incrementAction = [UIAction actionWithTitle:NSLocalizedString(@"INCREASE_CARD_COUNT", @"")
                                                                image:[UIImage systemImageNamed:@"plus"]
                                                           identifier:nil
                                                              handler:^(__kindof UIAction * _Nonnull action) {
                    [self.viewModel increaseAtIndexPath:indexPath];
                }];
                
                UIAction *decrementAction = [UIAction actionWithTitle:NSLocalizedString(@"DECREASE_CARD_COUNT", @"")
                                                                image:[UIImage systemImageNamed:@"minus"]
                                                           identifier:nil
                                                              handler:^(__kindof UIAction * _Nonnull action) {
                    [self.viewModel decreaseAtIndexPath:indexPath];
                }];
                
                UIAction *deleteAction = [UIAction actionWithTitle:NSLocalizedString(@"DELETE", @"")
                                                             image:[UIImage systemImageNamed:@"trash"]
                                                        identifier:nil
                                                           handler:^(__kindof UIAction * _Nonnull action) {
                    [self.viewModel deleteAtIndexPath:indexPath];
                }];
                deleteAction.attributes = UIMenuElementAttributesDestructive;
                
                UIMenu *menu = [UIMenu menuWithChildren:@[incrementAction, decrementAction, deleteAction]];
                
                return menu;
            }];
            
            return configuration;
        }
        default: {
            return nil;
        }
    }
}

- (void)collectionView:(UICollectionView *)collectionView willPerformPreviewActionForMenuWithConfiguration:(UIContextMenuConfiguration *)configuration animator:(id<UIContextMenuInteractionCommitAnimating>)animator {
    NSIndexPath * _Nullable indexPath = self.viewModel.contextMenuIndexPath;
    
    if (indexPath == nil) {
        return;
    }
    
    DeckDetailsItemModel * _Nullable itemModel = [self.viewModel.dataSource itemIdentifierForIndexPath:indexPath];
    
    switch (itemModel.type) {
        case DeckDetailsItemModelTypeCard: {
            [animator addAnimations:^{
                [self presentCardDetailsVCWithHSCard:itemModel.hsCard];
            }];
            break;
        }
        default:
            break;
    }
    
    [animator addCompletion:^{
        self.viewModel.contextMenuIndexPath = nil;
    }];
}

#pragma mark - UICollectionViewDragDelegate

- (NSArray<UIDragItem *> *)collectionView:(UICollectionView *)collectionView itemsForBeginningDragSession:(id<UIDragSession>)session atIndexPath:(NSIndexPath *)indexPath {
    return [self.viewModel makeDragItemFromIndexPath:indexPath];
}

- (NSArray<UIDragItem *> *)collectionView:(UICollectionView *)collectionView itemsForAddingToDragSession:(id<UIDragSession>)session atIndexPath:(NSIndexPath *)indexPath point:(CGPoint)point {
    return [self.viewModel makeDragItemFromIndexPath:indexPath];
}

#pragma mark - UICollectionViewDropDelegate

- (BOOL)collectionView:(UICollectionView *)collectionView canHandleDropSession:(id<UIDropSession>)session {
    return [session canLoadObjectsOfClass:[HSCard class]];
}

- (void)collectionView:(UICollectionView *)collectionView performDropWithCoordinator:(id<UICollectionViewDropCoordinator>)coordinator {
    [coordinator.session loadObjectsOfClass:[HSCard class] completion:^(NSArray<__kindof id<NSItemProviderReading>> * _Nonnull objects) {
        [self.viewModel addHSCards:objects];
    }];
}

@end
