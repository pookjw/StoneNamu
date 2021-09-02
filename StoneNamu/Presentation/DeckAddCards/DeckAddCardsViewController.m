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
#import "BlizzardHSAPIKeys.h"

@interface DeckAddCardsViewController () <DeckDetailsViewControllerDelegate>
@property (retain) UIBarButtonItem *doneBarButton;
@property (retain) UIButton *deckDetailsButton;
@property (retain) LocalDeck *localDeck;
@end

@implementation DeckAddCardsViewController

- (instancetype)initWithLocalDeck:(LocalDeck *)localDeck {
    self = [self init];
    
    if (self) {
        self.localDeck = localDeck;
        [self loadViewIfNeeded];
        [self requestDataSourceWithClassCards];
    }
    
    return self;
}

- (void)dealloc {
    [_doneBarButton release];
    [_deckDetailsButton release];
    [_localDeck release];
    [super dealloc];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configureDeckDetailsButton];
    [self configureRightBarButtonItems];
}

- (void)requestDataSourceWithClassCards {
    NSMutableDictionary<NSString *, NSString *> *options = [BlizzardHSAPIDefaultOptions() mutableCopy];
    options[BlizzardHSAPIOptionTypeClass] = NSStringFromHSCardClass(self.localDeck.classId.unsignedIntegerValue);
    
    HSCardSet cardSet;
    if ([self.localDeck.format isEqualToString:HSDeckFormatStandard]) {
        cardSet = HSCardSetStandardCards;
    } else if ([self.localDeck.format isEqualToString:HSDeckFormatWild]) {
        cardSet = HSCardSetWildCards;
    } else if ([self.localDeck.format isEqualToString:HSDeckFormatClassic]) {
        cardSet = HSCardSetClassicCards;
    } else {
        cardSet = HSCardSetWildCards;
    }
    options[BlizzardHSAPIOptionTypeSet] = NSStringFromHSCardSet(cardSet);
    
    [self requestDataSourceWithOptions:options];
    [options release];
}

- (void)requestDataSourceWithNeurtalCards {
    NSMutableDictionary<NSString *, NSString *> *options = [BlizzardHSAPIDefaultOptions() mutableCopy];
    options[BlizzardHSAPIOptionTypeClass] = NSStringFromHSCardClass(HSCardClassNeutral);
    [self requestDataSourceWithOptions:options];
    [options release];
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

- (void)presentDeckDetailsViewController {
    DeckDetailsViewController *vc = [[DeckDetailsViewController alloc] initWithLocalDeck:self.localDeck presentEditorIfNoCards:NO];
    [vc setRightBarButtons:DeckDetailsViewControllerBarButtonTypeDone];
    vc.delegate = self;
    SheetNavigationController *nvc = [[SheetNavigationController alloc] initWithRootViewController:vc];
    [vc release];
    [self presentViewController:nvc animated:YES completion:^{}];
    [nvc release];
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    CardItemModel *itemModel = [self.viewModel.dataSource itemIdentifierForIndexPath:indexPath];
    HSCard *hsCard = itemModel.card;
    
}

#pragma mark - DeckDetailsViewControllerDelegate

- (BOOL)deckDetailsViewController:(DeckDetailsViewController *)viewController shouldPresentErrorAlertWithError:(NSError *)error {
    return YES;
}

@end
