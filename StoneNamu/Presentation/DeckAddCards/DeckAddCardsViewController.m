//
//  DeckAddCardsViewController.m
//  StoneNamu
//
//  Created by Jinwoo Kim on 7/23/21.
//

#import "DeckAddCardsViewController.h"
#import "UIViewController+presentErrorAlert.h"
#import "DeckAddCardContentConfiguration.h"
#import "DeckAddCardContentView.h"
#import "DeckAddCardCollectionViewCompositionalLayout.h"
#import "PhotosService.h"
#import "DeckAddCardOptionsViewController.h"
#import "CardOptionsViewControllerDelegate.h"
#import "SheetNavigationController.h"
#import "UIViewController+SpinnerView.h"
#import "DeckAddCardsViewModel.h"
#import "DeckDetailsViewController.h"
#import "CardDetailsViewController.h"
#import "UIViewController+targetedPreviewWithClearBackgroundForView.h"

@interface DeckAddCardsViewController () <UICollectionViewDelegate, UICollectionViewDragDelegate, UIDropInteractionDelegate, UIContextMenuInteractionDelegate>
@property (retain) DeckAddCardsViewModel *viewModel;
@property (retain) UICollectionView *collectionView;
@property (retain) UIButton *deckDetailsButton;
@property (retain) UIBarButtonItem *doneBarButton;
@property (retain) UIBarButtonItem *optionsBarButtonItem;
@property (retain) UIViewController * _Nullable contextViewController;
@end

@implementation DeckAddCardsViewController

- (instancetype)initWithLocalDeck:(id)localDeck {
    self = [self init];
    
    if (self) {
        self.contextViewController = nil;
        [self loadViewIfNeeded];
        self.viewModel.localDeck = localDeck;
        [self.viewModel requestDataSourceWithOptions:nil reset:YES];
        [self updateDeckDetailButtonText];
    }
    
    return self;
}

- (void)dealloc {
    [_collectionView release];
    [_deckDetailsButton release];
    [_doneBarButton release];
    [_optionsBarButtonItem release];
    [_viewModel release];
    [_contextViewController release];
    [super dealloc];
}

- (LocalDeck * _Nullable)setDeckDetailsButtonHidden:(BOOL)hidden {
    self.deckDetailsButton.hidden = hidden;
    return self.viewModel.localDeck;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setAttributes];
    [self configureLeftBarButtonItems];
    [self configureRightBarButtonItems];
    [self configureCollectionView];
    [self configureDeckDetailsButton];
    [self configureViewModel];
    [self bind];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self configureNavigation];
}

- (void)requestDataSourceWithOptions:(NSDictionary<NSString *,NSString *> * _Nullable)options {
    [self addSpinnerView];
    [self.viewModel requestDataSourceWithOptions:options reset:YES];
}

- (void)setAttributes {
    
}

- (void)configureLeftBarButtonItems {
    UIBarButtonItem *optionsBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage systemImageNamed:@"magnifyingglass"]
                                                                             style:UIBarButtonItemStylePlain
                                                                            target:self
                                                                            action:@selector(optionsBarButtonItemTriggered:)];
    
    self.optionsBarButtonItem = optionsBarButtonItem;
    self.navigationItem.leftBarButtonItems = @[optionsBarButtonItem];
    
    [optionsBarButtonItem release];
}

- (void)configureRightBarButtonItems {
    UIBarButtonItem *doneBarButton = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"DONE", @"")
                                                                      style:UIBarButtonItemStyleDone
                                                                     target:self
                                                                     action:@selector(doneBarButtonTriggered:)];
    self.doneBarButton = doneBarButton;

    self.navigationItem.rightBarButtonItems = @[doneBarButton];
    [doneBarButton release];
}

- (void)doneBarButtonTriggered:(UIBarButtonItem *)sender {
    if (self.viewModel.isLocalDeckCardFull) {
        [self dismissViewControllerAnimated:YES completion:^{}];
    } else {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"DECK_ADD_CARDS_NOT_FULL_TITLE", @"")
                                                                       message:[NSString stringWithFormat:NSLocalizedString(@"DECK_ADD_CARDS_NOT_FULL_DESCRIPTION", @""), HSDECK_MAX_TOTAL_CARDS, self.viewModel.countOfLocalDeckCards]
                                                                preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"NO", @"")
                                                               style:UIAlertActionStyleCancel
                                                             handler:^(UIAlertAction * _Nonnull action) {}];
        
        UIAlertAction *dismissAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"YES", @"")
                                                                style:UIAlertActionStyleDefault
                                                              handler:^(UIAlertAction * _Nonnull action) {
            [self dismissViewControllerAnimated:YES completion:^{}];
        }];
        
        [alert addAction:cancelAction];
        [alert addAction:dismissAction];
        
        [self presentViewController:alert animated:YES completion:^{}];
    }
}

- (void)optionsBarButtonItemTriggered:(UIBarButtonItem *)sender {
    DeckAddCardOptionsViewController *vc = [[DeckAddCardOptionsViewController alloc] initWithOptions:self.viewModel.options];
    vc.delegate = self;
    SheetNavigationController *nvc = [[SheetNavigationController alloc] initWithRootViewController:vc];
    nvc.supportsLargeDetent = YES;
    [self presentViewController:nvc animated:YES completion:^{}];
    [vc release];
    [nvc release];
}

- (void)configureNavigation {
    self.title = NSLocalizedString(@"CARDS", @"");
    self.navigationItem.largeTitleDisplayMode = UINavigationItemLargeTitleDisplayModeNever;
}

- (void)configureCollectionView {
    DeckAddCardCollectionViewCompositionalLayout *layout = [[DeckAddCardCollectionViewCompositionalLayout alloc] init];
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:layout];
    [layout release];
    
    self.collectionView = collectionView;
    [self.view addSubview:collectionView];
    
    collectionView.translatesAutoresizingMaskIntoConstraints = NO;
    [NSLayoutConstraint activateConstraints:@[
        [collectionView.topAnchor constraintEqualToAnchor:self.view.topAnchor],
        [collectionView.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor],
        [collectionView.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor],
        [collectionView.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor]
    ]];
    
    collectionView.backgroundColor = UIColor.systemBackgroundColor;
    collectionView.delegate = self;
    collectionView.dragDelegate = self;
    
    [collectionView release];
}

- (void)configureViewModel {
    DeckAddCardsViewModel *viewModel = [[DeckAddCardsViewModel alloc] initWithDataSource:[self makeDataSource]];
    self.viewModel = viewModel;
    [viewModel release];
}

- (CardsDataSource *)makeDataSource {
    UICollectionViewCellRegistration *cellRegistration = [self makeCellRegistration];
    
    CardsDataSource *dataSource = [[CardsDataSource alloc] initWithCollectionView:self.collectionView
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
    UICollectionViewCellRegistration *cellRegistration = [UICollectionViewCellRegistration registrationWithCellClass:[UICollectionViewCell class]
                                                                                                configurationHandler:^(__kindof UICollectionViewCell * _Nonnull cell, NSIndexPath * _Nonnull indexPath, id  _Nonnull item) {
        if (![item isKindOfClass:[DeckAddCardItemModel class]]) {
            return;
        }
        DeckAddCardItemModel *itemModel = (DeckAddCardItemModel *)item;
        
        DeckAddCardContentConfiguration *configuration = [DeckAddCardContentConfiguration new];
        configuration.hsCard = itemModel.card;
        
        cell.contentConfiguration = configuration;
        [configuration release];
    }];
    
    return cellRegistration;
}

- (void)configureDeckDetailsButton {
    UIAction *action = [UIAction actionWithHandler:^(__kindof UIAction * _Nonnull action) {
        [self presentDeckDetailsViewController];
    }];

    UIButton *deckDetailsButton = [UIButton buttonWithConfiguration:[self makeDeckDetailButtonConfiguration] primaryAction:action];
    self.deckDetailsButton = deckDetailsButton;

    [self.view addSubview:self.deckDetailsButton];
    deckDetailsButton.translatesAutoresizingMaskIntoConstraints = NO;

    [NSLayoutConstraint activateConstraints:@[
        [deckDetailsButton.bottomAnchor constraintEqualToAnchor:self.view.layoutMarginsGuide.bottomAnchor],
        [deckDetailsButton.centerXAnchor constraintEqualToAnchor:self.view.layoutMarginsGuide.centerXAnchor]
    ]];

    //

    UIDropInteraction *dropInteraction = [[UIDropInteraction alloc] initWithDelegate:self];
    [deckDetailsButton addInteraction:dropInteraction];
    [dropInteraction release];
    
    //
    
    UIContextMenuInteraction *contextMenuInteraction = [[UIContextMenuInteraction alloc] initWithDelegate:self];
    [deckDetailsButton addInteraction:contextMenuInteraction];
    [contextMenuInteraction release];

    //

    [deckDetailsButton release];
}

- (UIButtonConfiguration *)makeDeckDetailButtonConfiguration {
    UIBackgroundConfiguration *backgroundConfiguration = [UIBackgroundConfiguration clearConfiguration];
    UIView *backgroundView = [UIView new];
    backgroundView.backgroundColor = [UIColor.tintColor colorWithAlphaComponent:0.5];
    backgroundConfiguration.customView = backgroundView;
    [backgroundView release];
    backgroundConfiguration.visualEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
    
    //
    
    UIButtonConfiguration *buttonConfiguration = UIButtonConfiguration.plainButtonConfiguration;
    buttonConfiguration.cornerStyle = UIButtonConfigurationCornerStyleCapsule;
    buttonConfiguration.baseForegroundColor = UIColor.whiteColor;
    buttonConfiguration.background = backgroundConfiguration;
    // seems like UIVibrancyEffect doesn't work...
    buttonConfiguration.image = [UIImage systemImageNamed:@"list.bullet"];
    buttonConfiguration.imagePlacement = NSDirectionalRectEdgeTop;
    
    return buttonConfiguration;
}

- (void)bind {
    [NSNotificationCenter.defaultCenter addObserver:self
                                           selector:@selector(errorEventReceived:)
                                               name:DeckAddCardsViewModelErrorNotificationName
                                             object:self.viewModel];
    
    [NSNotificationCenter.defaultCenter addObserver:self
                                           selector:@selector(presentDetailReceived:)
                                               name:DeckAddCardsViewModelPresentDetailNotificationName
                                             object:self.viewModel];
    
    [NSNotificationCenter.defaultCenter addObserver:self
                                           selector:@selector(applyingSnapshotWasDoneReceived:)
                                               name:DeckAddCardsViewModelApplyingSnapshotToDataSourceWasDoneNotificationName
                                             object:self.viewModel];
    
    [NSNotificationCenter.defaultCenter addObserver:self
                                           selector:@selector(localDeckHasChangedReceived:)
                                               name:DeckAddCardsViewModelLocalDeckHasChangedNotificationName
                                             object:self.viewModel];
}

- (void)errorEventReceived:(NSNotification *)notification {
    NSError * _Nullable error = notification.userInfo[DeckAddCardsViewModelErrorNotificationErrorKey];
    
    if (error) {
        [NSOperationQueue.mainQueue addOperationWithBlock:^{
            [self presentErrorAlertWithError:error];
        }];
    } else {
        NSLog(@"No error found but the notification was posted: %@", notification.userInfo);
    }
}

- (void)presentDetailReceived:(NSNotification *)notification {
    HSCard * _Nullable hsCard = notification.userInfo[DeckAddCardsViewModelPresentDetailNotificationHSCardKey];
    NSIndexPath * _Nullable indexPath = notification.userInfo[DeckAddCardsViewModelPresentDetailNotificationIndexPathKey];

    if (!(hsCard && indexPath)) return;

    [NSOperationQueue.mainQueue addOperationWithBlock:^{
        UICollectionViewCell * _Nullable cell = [self.collectionView cellForItemAtIndexPath:indexPath];

        if (cell == nil) return;

        DeckAddCardContentView *contentView = (DeckAddCardContentView *)cell.contentView;

        if (![contentView isKindOfClass:[DeckAddCardContentView class]]) return;

        CardDetailsViewController *vc = [[CardDetailsViewController alloc] initWithHSCard:hsCard sourceImageView:contentView.imageView];
        [vc autorelease];
        [vc loadViewIfNeeded];
        [self presentViewController:vc animated:YES completion:^{}];
    }];
}

- (void)applyingSnapshotWasDoneReceived:(NSNotification *)notification {
    [NSOperationQueue.mainQueue addOperationWithBlock:^{
        [self removeAllSpinnerview];
    }];
}

- (void)localDeckHasChangedReceived:(NSNotification *)notification {
    [NSOperationQueue.mainQueue addOperationWithBlock:^{
        [self updateDeckDetailButtonText];
    }];
}

- (NSArray<UIDragItem *> *)makeDragItemsFromIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell * _Nullable cell = [self.collectionView cellForItemAtIndexPath:indexPath];
    DeckAddCardContentView *contentView = (DeckAddCardContentView *)cell.contentView;
    
    UIImage * _Nullable image;
    
    if ([contentView isKindOfClass:[DeckAddCardContentView class]]) {
        image = contentView.imageView.image;
    } else {
        image = nil;
    }
    
    return [self.viewModel makeDragItemFromIndexPath:indexPath image:image];
}

- (void)presentDeckDetailsViewController {
    [self presentViewController:[self makeDeckDetailsViewController] animated:YES completion:^{}];
}

- (SheetNavigationController *)makeDeckDetailsViewController {
    DeckDetailsViewController *vc = [[DeckDetailsViewController alloc] initWithLocalDeck:self.viewModel.localDeck presentEditorIfNoCards:NO];
    [vc setRightBarButtons:DeckDetailsViewControllerBarButtonTypeDone];
    SheetNavigationController *nvc = [[SheetNavigationController alloc] initWithRootViewController:vc];
    [vc release];
    return [nvc autorelease];
}

- (void)updateDeckDetailButtonText {
    UIButtonConfiguration *buttonConfiguration = [self makeDeckDetailButtonConfiguration];
    NSAttributedString *title = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%lu / %d", self.viewModel.countOfLocalDeckCards, HSDECK_MAX_TOTAL_CARDS]
                                                                attributes:@{NSFontAttributeName: [UIFont preferredFontForTextStyle:UIFontTextStyleTitle2],
                                                                             NSForegroundColorAttributeName: UIColor.whiteColor}];
    buttonConfiguration.attributedTitle = title;
    [title release];
    
    self.deckDetailsButton.configuration = buttonConfiguration;
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [collectionView deselectItemAtIndexPath:indexPath animated:NO];
    [self.viewModel handleSelectionForIndexPath:indexPath];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if (![self.collectionView isEqual:scrollView]) return;
    
    CGSize contentSize = self.collectionView.contentSize;
    CGPoint contentOffset = self.collectionView.contentOffset;
    CGRect bounds = self.collectionView.bounds;
    
    if ((contentOffset.y + bounds.size.height) >= (contentSize.height)) {
        BOOL requested = [self.viewModel requestDataSourceWithOptions:self.viewModel.options reset:NO];
        
        if (requested) {
            [self addSpinnerView];
        }
    }
}

- (UIContextMenuConfiguration *)collectionView:(UICollectionView *)collectionView contextMenuConfigurationForItemAtIndexPath:(NSIndexPath *)indexPath point:(CGPoint)point {
    self.viewModel.contextMenuIndexPath = nil;
    
    DeckAddCardItemModel * _Nullable itemModel = [self.viewModel.dataSource itemIdentifierForIndexPath:indexPath];
    if (itemModel == nil) return nil;
    
    self.viewModel.contextMenuIndexPath = indexPath;
    
    UIContextMenuConfiguration *configuration = [UIContextMenuConfiguration configurationWithIdentifier:nil
                                                                                        previewProvider:nil
                                                                                         actionProvider:^UIMenu * _Nullable(NSArray<UIMenuElement *> * _Nonnull suggestedActions) {
        
        UIAction *saveAction = [UIAction actionWithTitle:NSLocalizedString(@"SAVE", @"")
                                                   image:[UIImage systemImageNamed:@"square.and.arrow.down"]
                                              identifier:nil
                                                 handler:^(__kindof UIAction * _Nonnull action) {
            [PhotosService.sharedInstance saveImageURL:itemModel.card.image fromViewController:self completionHandler:^(BOOL success, NSError * _Nonnull error) {}];
        }];
        
        UIMenu *menu = [UIMenu menuWithTitle:itemModel.card.name
                                    children:@[saveAction]];
        
        return menu;
    }];
    
    return configuration;
}

- (void)collectionView:(UICollectionView *)collectionView willPerformPreviewActionForMenuWithConfiguration:(UIContextMenuConfiguration *)configuration animator:(id<UIContextMenuInteractionCommitAnimating>)animator {
    NSIndexPath * _Nullable indexPath = self.viewModel.contextMenuIndexPath;
    
    if (indexPath == nil) {
        return;
    }
    
    self.viewModel.contextMenuIndexPath = nil;
    
    [self.viewModel handleSelectionForIndexPath:indexPath];
}

#pragma mark - UICollectionViewDragDelegate

- (NSArray<UIDragItem *> *)collectionView:(UICollectionView *)collectionView itemsForBeginningDragSession:(id<UIDragSession>)session atIndexPath:(NSIndexPath *)indexPath {
    return [self makeDragItemsFromIndexPath:indexPath];
}

- (NSArray<UIDragItem *> *)collectionView:(UICollectionView *)collectionView itemsForAddingToDragSession:(id<UIDragSession>)session atIndexPath:(NSIndexPath *)indexPath point:(CGPoint)point {
    return [self makeDragItemsFromIndexPath:indexPath];
}

#pragma mark - UIDropInteractionDelegate

- (BOOL)dropInteraction:(UIDropInteraction *)interaction canHandleSession:(id<UIDropSession>)session {
    BOOL canHandleSession = [session canLoadObjectsOfClass:[HSCard class]];
    return canHandleSession;
}

- (void)dropInteraction:(UIDropInteraction *)interaction performDrop:(id<UIDropSession>)session {
    [session loadObjectsOfClass:[HSCard class] completion:^(NSArray<__kindof id<NSItemProviderReading>> * _Nonnull objects) {
        [self.viewModel addHSCards:objects];
    }];
}

- (UIDropProposal *)dropInteraction:(UIDropInteraction *)interaction sessionDidUpdate:(id<UIDropSession>)session {
    return [[[UIDropProposal alloc] initWithDropOperation:UIDropOperationMove] autorelease];
}

#pragma mark - DeckAddCardOptionsViewControllerDelegate

- (void)deckAddCardOptionsViewController:(DeckAddCardOptionsViewController *)viewController doneWithOptions:(NSDictionary<NSString *,NSString *> *)options {
    if (self.splitViewController.isCollapsed) {
//    if ([self.navigationItem.leftBarButtonItems containsObject:self.optionsBarButtonItem]) {
        [viewController dismissViewControllerAnimated:YES completion:^{}];
    }
    [self addSpinnerView];
    [self.viewModel requestDataSourceWithOptions:options reset:YES];
}

#pragma mark - UIContextMenuInteractionDelegate

- (nullable UIContextMenuConfiguration *)contextMenuInteraction:(nonnull UIContextMenuInteraction *)interaction configurationForMenuAtLocation:(CGPoint)location {
    UIContextMenuConfiguration *configuration = [UIContextMenuConfiguration configurationWithIdentifier:nil
                                                                                        previewProvider:^UIViewController * _Nullable{
        self.contextViewController = [self makeDeckDetailsViewController];
        return self.contextViewController;
    }
                                                                                         actionProvider:nil];
    
    return configuration;
}

- (void)contextMenuInteraction:(UIContextMenuInteraction *)interaction willPerformPreviewActionForMenuWithConfiguration:(UIContextMenuConfiguration *)configuration animator:(id<UIContextMenuInteractionCommitAnimating>)animator {
    if (self.contextViewController != nil) {
        [animator addAnimations:^{
            [self presentViewController:self.contextViewController animated:YES completion:^{}];
        }];
        
        [animator addCompletion:^{
            self.contextViewController = nil;
        }];
    }
}

- (UITargetedPreview *)contextMenuInteraction:(UIContextMenuInteraction *)interaction previewForHighlightingMenuWithConfiguration:(UIContextMenuConfiguration *)configuration {
    return [self targetedPreviewWithClearBackgroundForView:self.deckDetailsButton];
}

- (UITargetedPreview *)contextMenuInteraction:(UIContextMenuInteraction *)interaction previewForDismissingMenuWithConfiguration:(UIContextMenuConfiguration *)configuration {
    return [self targetedPreviewWithClearBackgroundForView:self.deckDetailsButton];
}

@end