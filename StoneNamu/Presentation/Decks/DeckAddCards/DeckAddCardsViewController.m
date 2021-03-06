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
#import "DeckAddCardCollectionViewLayout.h"
#import "DeckAddCardOptionsViewController.h"
#import "SheetNavigationController.h"
#import "UIViewController+SpinnerView.h"
#import "DeckAddCardsViewModel.h"
#import "DeckDetailsViewController.h"
#import "CardDetailsViewController.h"
#import "UIViewController+targetedPreviewWithClearBackgroundForView.h"
#import <StoneNamuResources/StoneNamuResources.h>

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
        
        [self.viewModel countOfLocalDeckCardsWithCompletion:^(NSNumber * _Nullable countOfLocalDeckCards, BOOL isFull) {
            [NSOperationQueue.mainQueue addOperationWithBlock:^{
                [self updateDeckDetailButtonTextWithCount:countOfLocalDeckCards];
            }];
        }];
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

- (void)setDeckDetailsButtonHidden:(BOOL)hidden {
    self.deckDetailsButton.hidden = hidden;
}

- (LocalDeck *)localDeck {
    return self.viewModel.localDeck;
}

- (void)setRightBarButtons:(DeckAddCardsViewControllerRightBarButtonType)type {
    NSMutableArray<UIBarButtonItem *> *rightBarButtonItems = [NSMutableArray<UIBarButtonItem *> new];
    
    if (type & DeckAddCardsViewControllerRightBarButtonTypeDone) {
        [rightBarButtonItems addObject:self.doneBarButton];
    }
    
    self.navigationItem.rightBarButtonItems = rightBarButtonItems;
    [rightBarButtonItems release];
}

- (void)requestDismissWithPromptIfNeeded {
    [self.viewModel countOfLocalDeckCardsWithCompletion:^(NSNumber * _Nullable countOfLocalDeckCards, BOOL isFull) {
        [NSOperationQueue.mainQueue addOperationWithBlock:^{
            if ((isFull) || (countOfLocalDeckCards == nil)) {
                [self dismissViewControllerAnimated:YES completion:^{}];
            } else {
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:[ResourcesService localizationForKey:LocalizableKeyDeckAddCardsNotFullTitle]
                                                                               message:[NSString stringWithFormat:[ResourcesService localizationForKey:LocalizableKeyDeckAddCardsNotFullDescription], HSDECK_MAX_TOTAL_CARDS, countOfLocalDeckCards.unsignedIntegerValue]
                                                                        preferredStyle:UIAlertControllerStyleAlert];
                
                UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:[ResourcesService localizationForKey:LocalizableKeyNo]
                                                                       style:UIAlertActionStyleCancel
                                                                     handler:^(UIAlertAction * _Nonnull action) {}];
                
                UIAlertAction *dismissAction = [UIAlertAction actionWithTitle:[ResourcesService localizationForKey:LocalizableKeyYes]
                                                                        style:UIAlertActionStyleDefault
                                                                      handler:^(UIAlertAction * _Nonnull action) {
                    [self dismissViewControllerAnimated:YES completion:^{}];
                }];
                
                [alert addAction:cancelAction];
                [alert addAction:dismissAction];
                
                [self presentViewController:alert animated:YES completion:^{}];
            }
        }];
    }];
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

- (void)setAttributes {
    
}

- (void)configureLeftBarButtonItems {
    UIBarButtonItem *optionsBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage systemImageNamed:@"magnifyingglass"]
                                                                             style:UIBarButtonItemStylePlain
                                                                            target:self
                                                                            action:@selector(optionsBarButtonItemTriggered:)];
    
    self.navigationItem.leftBarButtonItems = @[optionsBarButtonItem];
    self.optionsBarButtonItem = optionsBarButtonItem;
    [optionsBarButtonItem release];
}

- (void)configureRightBarButtonItems {
    UIBarButtonItem *doneBarButton = [[UIBarButtonItem alloc] initWithTitle:[ResourcesService localizationForKey:LocalizableKeyDone]
                                                                      style:UIBarButtonItemStyleDone
                                                                     target:self
                                                                     action:@selector(doneBarButtonTriggered:)];

    self.navigationItem.rightBarButtonItems = @[doneBarButton];
    self.doneBarButton = doneBarButton;
    [doneBarButton release];
}

- (void)doneBarButtonTriggered:(UIBarButtonItem *)sender {
    [self requestDismissWithPromptIfNeeded];
}

- (void)optionsBarButtonItemTriggered:(UIBarButtonItem *)sender {
    DeckAddCardOptionsViewController *vc = [[DeckAddCardOptionsViewController alloc] initWithOptions:self.viewModel.options localDeck:self.viewModel.localDeck];
    vc.delegate = self;
    SheetNavigationController *nvc = [[SheetNavigationController alloc] initWithRootViewController:vc];
    nvc.detents = @[[UISheetPresentationControllerDetent largeDetent]];
    [self presentViewController:nvc animated:YES completion:^{}];
    [vc release];
    [nvc release];
}

- (void)configureNavigation {
    self.title = [ResourcesService localizationForKey:LocalizableKeyAddCards];
    self.navigationItem.largeTitleDisplayMode = UINavigationItemLargeTitleDisplayModeNever;
}

- (void)configureCollectionView {
    DeckAddCardCollectionViewLayout *layout = [[DeckAddCardCollectionViewLayout alloc] init];
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:layout];
    [layout release];
    
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
    
    self.collectionView = collectionView;
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
    
    return [dataSource autorelease];
}

- (UICollectionViewCellRegistration *)makeCellRegistration {
    UICollectionViewCellRegistration *cellRegistration = [UICollectionViewCellRegistration registrationWithCellClass:[UICollectionViewCell class]
                                                                                                configurationHandler:^(__kindof UICollectionViewCell * _Nonnull cell, NSIndexPath * _Nonnull indexPath, id  _Nonnull item) {
        if (![item isKindOfClass:[DeckAddCardItemModel class]]) {
            return;
        }
        DeckAddCardItemModel *itemModel = (DeckAddCardItemModel *)item;
        
        DeckAddCardContentConfiguration *configuration = [[DeckAddCardContentConfiguration alloc] initWithHSCard:itemModel.hsCard count:itemModel.count isLegendary:itemModel.isLegendary];
        cell.contentConfiguration = configuration;
        [configuration release];
    }];
    
    return cellRegistration;
}

- (void)configureDeckDetailsButton {
    DeckAddCardsViewController * __block unretainedSelf = self;
    
    UIAction *action = [UIAction actionWithHandler:^(__kindof UIAction * _Nonnull action) {
        [unretainedSelf presentDeckDetailsViewController];
    }];

    UIButton *deckDetailsButton = [UIButton buttonWithConfiguration:[self makeDeckDetailButtonConfiguration] primaryAction:action];

    [self.view addSubview:deckDetailsButton];
    deckDetailsButton.translatesAutoresizingMaskIntoConstraints = NO;

    [NSLayoutConstraint activateConstraints:@[
        [deckDetailsButton.bottomAnchor constraintEqualToAnchor:self.view.layoutMarginsGuide.bottomAnchor constant:-10],
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
    
    self.deckDetailsButton = deckDetailsButton;
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
                                               name:NSNotificationNameDeckAddCardsViewModelError
                                             object:self.viewModel];
    
    [NSNotificationCenter.defaultCenter addObserver:self
                                           selector:@selector(startedLoadingDataSourceReceived:)
                                               name:NSNotificationNameDeckAddCardsViewModelStartedLoadingDataSource
                                             object:self.viewModel];
    
    [NSNotificationCenter.defaultCenter addObserver:self
                                           selector:@selector(endedLoadingDataSourceReceived:)
                                               name:NSNotificationNameDeckAddCardsViewModelEndedLoadingDataSource
                                             object:self.viewModel];
    
    [NSNotificationCenter.defaultCenter addObserver:self
                                           selector:@selector(localDeckHasChangedReceived:)
                                               name:NSNotificationNameDeckAddCardsViewModelLocalDeckHasChanged
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

- (void)localDeckHasChangedReceived:(NSNotification *)notification {
    NSNumber * _Nullable count = notification.userInfo[DeckAddCardsViewModelLocalDeckHasChangedCountOfLocalDeckCardsItemKey];
    
    if (count != nil) {
        [NSOperationQueue.mainQueue addOperationWithBlock:^{
            [self updateDeckDetailButtonTextWithCount:count];
        }];
    }
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

- (void)presentCardDetailsViewControllerWithHSCard:(HSCard *)hsCard sourceImageView:(UIImageView *)imageView {
    CardDetailsViewController *vc = [[CardDetailsViewController alloc] initWithHSCard:hsCard hsGameModeSlugType:HSCardGameModeSlugTypeConstructed isGold:NO sourceImageView:imageView];
    [vc loadViewIfNeeded];
    [self presentViewController:vc animated:YES completion:^{}];
    [vc release];
}

- (void)presentCardDetailsViewControllerFromIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell * _Nullable cell = [self.collectionView cellForItemAtIndexPath:indexPath];
    if (cell == nil) return;
    
    DeckAddCardContentView *contentView = (DeckAddCardContentView *)cell.contentView;
    if (![contentView isKindOfClass:[DeckAddCardContentView class]]) return;
    
    UIImageView *sourceImageView = contentView.imageView;
    
    CardDetailsViewController *vc = [[CardDetailsViewController alloc] initWithHSCard:nil hsGameModeSlugType:HSCardGameModeSlugTypeConstructed isGold:NO sourceImageView:sourceImageView];
    
    [self.viewModel hsCardFromIndexPath:indexPath completion:^(HSCard * _Nonnull hsCard) {
        [NSOperationQueue.mainQueue addOperationWithBlock:^{
            [vc requestHSCard:hsCard];
        }];
    }];
    
    [self presentViewController:vc animated:YES completion:^{}];
    [vc release];
}

- (void)presentDeckDetailsViewController {
    [self presentViewController:[self makeDeckDetailsViewController] animated:YES completion:^{}];
}

- (SheetNavigationController *)makeDeckDetailsViewController {
    DeckDetailsViewController *vc = [[DeckDetailsViewController alloc] initWithLocalDeck:self.viewModel.localDeck presentEditorIfNoCards:NO];
    [vc setRightBarButtons:DeckDetailsViewControllerRightBarButtonTypeDone];
    SheetNavigationController *nvc = [[SheetNavigationController alloc] initWithRootViewController:vc];
    nvc.detents = @[[UISheetPresentationControllerDetent mediumDetent]];
    [vc release];
    return [nvc autorelease];
}

- (void)updateDeckDetailButtonTextWithCount:(NSNumber *)count {
    UIButtonConfiguration *buttonConfiguration = [self makeDeckDetailButtonConfiguration];
    NSAttributedString *title = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@ / %d", count.stringValue, HSDECK_MAX_TOTAL_CARDS]
                                                                attributes:@{NSFontAttributeName: [UIFont preferredFontForTextStyle:UIFontTextStyleTitle2],
                                                                             NSForegroundColorAttributeName: UIColor.whiteColor}];
    buttonConfiguration.attributedTitle = title;
    [title release];
    
    self.deckDetailsButton.configuration = buttonConfiguration;
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [collectionView deselectItemAtIndexPath:indexPath animated:NO];
    
    [self.viewModel addHSCardsFromIndexPathes:[NSSet setWithObject:indexPath]];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if (![self.collectionView isEqual:scrollView]) return;
    
    CGSize contentSize = self.collectionView.contentSize;
    CGPoint contentOffset = self.collectionView.contentOffset;
    CGRect bounds = self.collectionView.bounds;
    
    if ((contentOffset.y + bounds.size.height) >= (contentSize.height)) {
       [self.viewModel requestDataSourceWithOptions:self.viewModel.options reset:NO];
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
        
        UIAction *addButton = [UIAction actionWithTitle:[ResourcesService localizationForKey:LocalizableKeyAddToDeck]
                                                  image:[UIImage systemImageNamed:@"plus"]
                                             identifier:nil
                                                handler:^(__kindof UIAction * _Nonnull action) {
            
            [self.viewModel addHSCards:[NSSet setWithObject:itemModel.hsCard]];
        }];
        
        UIMenu *menu = [UIMenu menuWithTitle:itemModel.hsCard.name
                                    children:@[addButton]];
        
        return menu;
    }];
    
    return configuration;
}

- (void)collectionView:(UICollectionView *)collectionView willEndContextMenuInteractionWithConfiguration:(UIContextMenuConfiguration *)configuration animator:(id<UIContextMenuInteractionAnimating>)animator {
    [animator addCompletion:^{
        self.viewModel.contextMenuIndexPath = nil;
    }];
}

- (void)collectionView:(UICollectionView *)collectionView willPerformPreviewActionForMenuWithConfiguration:(UIContextMenuConfiguration *)configuration animator:(id<UIContextMenuInteractionCommitAnimating>)animator {
    NSIndexPath * _Nullable indexPath = self.viewModel.contextMenuIndexPath;
    
    if (indexPath == nil) {
        return;
    }
    
    [animator addAnimations:^{
        [self presentCardDetailsViewControllerFromIndexPath:indexPath];
    }];
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
        [self.viewModel addHSCards:[NSSet setWithArray:objects]];
    }];
}

- (UIDropProposal *)dropInteraction:(UIDropInteraction *)interaction sessionDidUpdate:(id<UIDropSession>)session {
    return [[[UIDropProposal alloc] initWithDropOperation:UIDropOperationMove] autorelease];
}

#pragma mark - DeckAddCardOptionsViewControllerDelegate

- (void)deckAddCardOptionsViewController:(DeckAddCardOptionsViewController *)viewController doneWithOptions:(NSDictionary<NSString *, NSSet<NSString *> *> *)options {
    [viewController dismissViewControllerAnimated:YES completion:^{}];
    [self.viewModel requestDataSourceWithOptions:options reset:YES];
}

- (void)deckAddCardOptionsViewController:(DeckAddCardOptionsViewController *)viewController defaultOptionsAreNeededWithCompletion:(DeckAddCardOptionsViewControllerDelegateDefaultOptionsAreNeededCompletion)completion {
    [self.viewModel defaultOptionsWithCompletion:^(NSDictionary<NSString *, NSSet<NSString *> *> * _Nonnull options) {
        completion(options);
    }];
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

- (void)contextMenuInteraction:(UIContextMenuInteraction *)interaction willEndForConfiguration:(UIContextMenuConfiguration *)configuration animator:(id<UIContextMenuInteractionAnimating>)animator {
    [animator addCompletion:^{
        self.contextViewController = nil;
    }];
}

- (void)contextMenuInteraction:(UIContextMenuInteraction *)interaction willPerformPreviewActionForMenuWithConfiguration:(UIContextMenuConfiguration *)configuration animator:(id<UIContextMenuInteractionCommitAnimating>)animator {
    if (self.contextViewController != nil) {
        [animator addAnimations:^{
            [self presentViewController:self.contextViewController animated:YES completion:^{}];
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
