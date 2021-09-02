//
//  DeckDetailsViewController.m
//  DeckDetailsViewController
//
//  Created by Jinwoo Kim on 8/17/21.
//

#define CardsSectionHeaderViewTag 300

#import "DeckDetailsViewController.h"
#import "DeckDetailsViewModel.h"
#import "UIViewController+presentErrorAlert.h"
#import "DeckDetailsCardContentConfiguration.h"
#import "DeckDetailsManaCostContentConfiguration.h"
#import "CardDetailsViewController.h"
#import "UIViewController+SpinnerView.h"
#import "DeckAddCardsViewController.h"

@interface DeckDetailsViewController () <UICollectionViewDelegate, UICollectionViewDragDelegate, UICollectionViewDropDelegate>
@property (retain) UICollectionView *collectionView;
@property (retain) UICollectionViewSupplementaryRegistration *headerCellRegistration;
@property (retain) UIBarButtonItem *exportBarButtonItem;
@property (retain) UIBarButtonItem *addCardsBarButtonItem;
@property (retain) UIBarButtonItem *doneBarButtonItem;
@property (retain) DeckDetailsViewModel *viewModel;
@end

@implementation DeckDetailsViewController

- (instancetype)initWithLocalDeck:(LocalDeck *)localDeck presentEditorIfNoCards:(BOOL)shouldPresentDeckEditor; {
    self = [self init];
    
    if (self) {
        [self loadViewIfNeeded];
        [self addSpinnerView];
        self.viewModel.shouldPresentDeckEditor = shouldPresentDeckEditor;
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
    [_addCardsBarButtonItem release];
    [_doneBarButtonItem release];
    [super dealloc];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setAttributes];
    [self configureRightBarButtonItems];
    [self setRightBarButtons:DeckDetailsViewControllerBarButtonTypeAddCards | DeckDetailsViewControllerBarButtonTypeExport];
    [self configureCollectionView];
    [self configureViewModel];
    [self bind];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self configureNavigation];
}

- (void)setRightBarButtons:(DeckDetailsViewControllertBarButtonType)type {
    NSMutableArray<UIBarButtonItem *> *rightBarButtomItems = [@[] mutableCopy];
    
    if (type & DeckDetailsViewControllerBarButtonTypeDone) {
        [rightBarButtomItems addObject:self.doneBarButtonItem];
    }
    
    if (type & DeckDetailsViewControllerBarButtonTypeExport) {
        [rightBarButtomItems addObject:self.exportBarButtonItem];
    }
    
    if (type & DeckDetailsViewControllerBarButtonTypeAddCards) {
        [rightBarButtomItems addObject:self.addCardsBarButtonItem];
    }
    
    self.navigationItem.rightBarButtonItems = rightBarButtomItems;
    [rightBarButtomItems release];
}

- (void)addHSCardsToLocalDeck:(NSArray<HSCard *> *)hsCards {
    [self.viewModel addHSCards:hsCards];
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
    
    UIBarButtonItem *addCardsBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage systemImageNamed:@"plus"]
                                                                              style:UIBarButtonItemStylePlain
                                                                             target:self
                                                                             action:@selector(addCardsBarButtonItemTriggered:)];
    self.addCardsBarButtonItem = addCardsBarButtonItem;
    
    //
    
    UIBarButtonItem *doneBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"DONE", @"")
                                                                          style:UIBarButtonItemStyleDone
                                                                         target:self
                                                                         action:@selector(doneBarButtonItemTriggered:)];
    self.doneBarButtonItem = doneBarButtonItem;
    
    //
    
    [exportBarButtonItem release];
    [addCardsBarButtonItem release];
    [doneBarButtonItem release];
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

- (void)addCardsBarButtonItemTriggered:(UIBarButtonItem *)sender {
    [self presentDeckAddCardsViewController];
}

- (void)doneBarButtonItemTriggered:(UIBarButtonItem *)sender {
    [self dismissViewControllerAnimated:YES completion:^{}];
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
        
        DeckDetailsSectionModel *sectionModel = [self.viewModel.dataSource sectionIdentifierForIndex:indexPath.section];
        NSString * _Nullable headerText = nil;
        NSUInteger tag = 0;
        
        switch (sectionModel.type) {
            case DeckDetailsSectionModelTypeCards:
                headerText = sectionModel.headerText;
                tag = CardsSectionHeaderViewTag;
                break;
            default:
                break;
        }
        
        //
        
        UIListContentConfiguration *configuration = [UIListContentConfiguration groupedHeaderConfiguration];
        configuration.text = headerText;
        
        supplementaryView.contentConfiguration = configuration;
        supplementaryView.tag = tag;
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
            BOOL shouldPresent;
            
            if (self.delegate != nil) {
                shouldPresent = [self.delegate deckDetailsViewController:self shouldPresentErrorAlertWithError:[[error retain] autorelease]];
            } else {
                shouldPresent = YES;
            }
            
            if (shouldPresent) {
                [self presentErrorAlertWithError:error];
            }
            
            [error release];
        }];
    }
}

- (void)applyingSnapshotToDataSourceWasDoneReceived:(NSNotification *)notification {
    BOOL hasCards = [(NSNumber *)notification.userInfo[DeckDetailsViewModelApplyingSnapshotToDataSourceWasDoneHasAnyCardsItemKey] boolValue];
    NSString * _Nullable headerText = [notification.userInfo[DeckDetailsViewModelApplyingSnapshotToDataSourceWasDoneCardsHeaderTextKey] copy];
    
    [NSOperationQueue.mainQueue addOperationWithBlock:^{
        [self removeAllSpinnerview];
        [self dealWithDataSourceHasCards:hasCards];
        [self updateSectionHeaderViewWithHeaderText:headerText];
        [headerText release];
    }];
}

- (void)presentCardDetailsViewControllerWithHSCard:(HSCard *)hsCard {
    if (hsCard == nil) return;
    
    CardDetailsViewController *vc = [[CardDetailsViewController alloc] initWithHSCard:hsCard sourceImageView:nil];
    [vc loadViewIfNeeded];
    [self presentViewController:vc animated:YES completion:^{}];
}

- (void)presentDeckAddCardsViewController {
    DeckAddCardsViewController *vc = [[DeckAddCardsViewController alloc] initWithLocalDeck:self.viewModel.localDeck];
    UINavigationController *nvc = [[UINavigationController alloc] initWithRootViewController:vc];
    nvc.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:nvc animated:YES completion:^{}];
    [vc release];
    [nvc release];
}

- (void)updateSectionHeaderViewWithHeaderText:(NSString *)headerText {
    UICollectionViewListCell *cell = [self.collectionView viewWithTag:300];
    UIListContentConfiguration *configuration = [UIListContentConfiguration groupedHeaderConfiguration];
    configuration.text = headerText;
    
    cell.contentConfiguration = configuration;
}

- (void)dealWithDataSourceHasCards:(BOOL)hasCards {
    self.exportBarButtonItem.enabled = hasCards;
    
    if (hasCards) {
        self.viewModel.shouldPresentDeckEditor = NO;
    } else if (self.viewModel.shouldPresentDeckEditor == YES) {
        self.viewModel.shouldPresentDeckEditor = NO;
        [self presentDeckAddCardsViewController];
    }
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
    
    [self presentCardDetailsViewControllerWithHSCard:itemModel.hsCard];
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
                [self presentCardDetailsViewControllerWithHSCard:itemModel.hsCard];
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
        [self addHSCardsToLocalDeck:objects];
    }];
}

@end
