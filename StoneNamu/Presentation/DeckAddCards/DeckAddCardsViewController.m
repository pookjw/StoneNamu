//
//  DeckAddCardsViewController.m
//  DeckAddCardsViewController
//
//  Created by Jinwoo Kim on 9/1/21.
//

#import "DeckAddCardsViewController.h"
#import "SheetNavigationController.h"
#import "DeckDetailsViewController.h"
#import "UIViewController+presentErrorAlert.h"
#import "DeckAddCardsViewModel.h"
#import "UIViewController+presentErrorAlert.h"

@interface DeckAddCardsViewController () <UIDropInteractionDelegate>
@property (retain) UIBarButtonItem *doneBarButton;
@property (retain) UIButton *deckDetailsButton;
@property (retain) DeckAddCardsViewModel *viewModel2;
@end

@implementation DeckAddCardsViewController

- (instancetype)initWithLocalDeck:(LocalDeck *)localDeck {
    self = [self init];
    
    if (self) {
        [self loadViewIfNeeded];
        self.viewModel2.localDeck = localDeck;
        [self requestDataSourceWithClassCards];
    }
    
    return self;
}

- (void)dealloc {
    [_doneBarButton release];
    [_deckDetailsButton release];
    [_viewModel2 release];
    [super dealloc];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configureDeckDetailsButton];
    [self configureRightBarButtonItems];
    [self configureViewModel2];
    [self bind2];
}

- (void)requestDataSourceWithClassCards {
    [self requestDataSourceWithOptions:[self.viewModel2 optionsForLocalDeckClassId]];
}

- (void)configureDeckDetailsButton {
    UIBackgroundConfiguration *backgroundConfiguration = [UIBackgroundConfiguration clearConfiguration];
    UIVisualEffectView *blurView = [[UIVisualEffectView alloc] initWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleLight]];
    backgroundConfiguration.customView = blurView;
    backgroundConfiguration.backgroundColor = UIColor.clearColor;
    [blurView release];
    backgroundConfiguration.visualEffect = [UIVibrancyEffect effectForBlurEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleDark]];
    
    UIButtonConfiguration *buttonConfiguration = UIButtonConfiguration.tintedButtonConfiguration;
    buttonConfiguration.cornerStyle = UIButtonConfigurationCornerStyleCapsule;
    buttonConfiguration.baseForegroundColor = UIColor.whiteColor;
    buttonConfiguration.background = backgroundConfiguration;
    // seems like UIVibrancyEffect doesn't work...
    buttonConfiguration.image = [UIImage systemImageNamed:@"list.bullet"];
    
    UIAction *action = [UIAction actionWithHandler:^(__kindof UIAction * _Nonnull action) {
        [self presentDeckDetailsViewController];
    }];
    
    UIButton *deckDetailsButton = [UIButton buttonWithConfiguration:buttonConfiguration primaryAction:action];
    self.deckDetailsButton = deckDetailsButton;
    
    [self.view addSubview:self.deckDetailsButton];
    deckDetailsButton.translatesAutoresizingMaskIntoConstraints = NO;
    
    [NSLayoutConstraint activateConstraints:@[
        [deckDetailsButton.bottomAnchor constraintEqualToAnchor:self.view.layoutMarginsGuide.bottomAnchor],
        [deckDetailsButton.trailingAnchor constraintEqualToAnchor:self.view.layoutMarginsGuide.trailingAnchor],
        [deckDetailsButton.widthAnchor constraintEqualToConstant:80],
        [deckDetailsButton.heightAnchor constraintEqualToConstant:80]
    ]];
    
    //
    
    UIDropInteraction *dropInteraction = [[UIDropInteraction alloc] initWithDelegate:self];
    [deckDetailsButton addInteraction:dropInteraction];
    [dropInteraction release];
    
    //
    
    [deckDetailsButton release];
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
    [self dismissViewControllerAnimated:YES completion:^{}];
}

- (void)configureViewModel2 {
    DeckAddCardsViewModel *viewModel2 = [DeckAddCardsViewModel new];
    self.viewModel2 = viewModel2;
    [viewModel2 release];
}

- (void)bind2 {
    [NSNotificationCenter.defaultCenter addObserver:self
                                           selector:@selector(errorOccurredReceived:)
                                               name:DeckAddCardsViewModelErrorOccurredNotificationKey
                                             object:self.viewModel2];
}

- (void)errorOccurredReceived:(NSNotification *)notification {
    NSError * _Nullable error = [notification.userInfo[DeckAddCardsViewModelErrorOccurredErrorItemKey] copy];
    
    if (error != nil) {
        [NSOperationQueue.mainQueue addOperationWithBlock:^{
            [self presentErrorAlertWithError:error];
            [error release];
        }];
    }
}

- (void)presentDeckDetailsViewController {
    DeckDetailsViewController *vc = [[DeckDetailsViewController alloc] initWithLocalDeck:self.viewModel2.localDeck presentEditorIfNoCards:NO];
    [vc setRightBarButtons:DeckDetailsViewControllerBarButtonTypeDone];
    SheetNavigationController *nvc = [[SheetNavigationController alloc] initWithRootViewController:vc];
    [vc release];
    [self presentViewController:nvc animated:YES completion:^{}];
    [nvc release];
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    CardItemModel *itemModel = [self.viewModel.dataSource itemIdentifierForIndexPath:indexPath];
    HSCard *hsCard = itemModel.card;
    [self.viewModel2 addHSCards:@[hsCard]];
}

#pragma mark - UIDropInteractionDelegate

- (BOOL)dropInteraction:(UIDropInteraction *)interaction canHandleSession:(id<UIDropSession>)session {
    BOOL canHandleSession = [session canLoadObjectsOfClass:[HSCard class]];
    return canHandleSession;
}

- (void)dropInteraction:(UIDropInteraction *)interaction performDrop:(id<UIDropSession>)session {
    [session loadObjectsOfClass:[HSCard class] completion:^(NSArray<__kindof id<NSItemProviderReading>> * _Nonnull objects) {
        [self.viewModel2 addHSCards:objects];
    }];
}

- (UIDropProposal *)dropInteraction:(UIDropInteraction *)interaction sessionDidUpdate:(id<UIDropSession>)session {
    return [[[UIDropProposal alloc] initWithDropOperation:UIDropOperationMove] autorelease];
}

@end
