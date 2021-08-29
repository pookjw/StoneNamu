//
//  DecksViewController.m
//  DecksViewController
//
//  Created by Jinwoo Kim on 8/17/21.
//

#import "DecksViewController.h"
#import "DecksViewModel.h"
#import "DeckDetailsViewController.h"
#import "UIViewController+presentErrorAlert.h"
#import "UIViewController+animatedForSelectedIndexPath.h"
#import "DeckBaseContentConfiguration.h"
#import "ImageService.h"

@interface DecksViewController () <UICollectionViewDelegate, UITextFieldDelegate>
@property (retain) UICollectionView *collectionView;
@property (retain) UIBarButtonItem *addBarButtonItem;
@property (retain) DecksViewModel *viewModel;
@property (weak) UITextField * _Nullable deckCodeTextField;
@property (weak) UIAlertAction * _Nullable deckCodeAlertAction;
@end

@implementation DecksViewController

- (void)dealloc {
    [_collectionView release];
    [_addBarButtonItem release];
    [_viewModel release];
    [super dealloc];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configureCollectionView];
    [self configureViewModel];
    [self configureRightBarButtonItems];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self configureNavigation];
    [self animatedForSelectedIndexPathWithCollectionView:self.collectionView];
}

- (void)setAttributes {
    self.view.backgroundColor = UIColor.systemBackgroundColor;
}

- (void)configureRightBarButtonItems {
    UIBarButtonItem *addBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage systemImageNamed:@"plus"]
                                                                         style:UIBarButtonItemStylePlain
                                                                        target:self
                                                                        action:nil];
    self.addBarButtonItem = addBarButtonItem;
    
    //
    
    NSMutableArray<UIAction *> *createStandardDeckActions = [@[] mutableCopy];
    NSMutableArray<UIAction *> *createWildDeckActions = [@[] mutableCopy];
    NSMutableArray<UIAction *> *createClassicDeckActions = [@[] mutableCopy];
    
    NSDictionary<NSString *, NSString *> *localizable = hsCardClassesWithLocalizable();
    
    for (NSString *key in hsCardClassesForFormat(HSDeckFormatStandard)) {
        @autoreleasepool {
            UIAction *standardAction = [UIAction actionWithTitle:localizable[key]
                                                   image:nil
                                              identifier:nil
                                                 handler:^(__kindof UIAction * _Nonnull action) {
                [self.viewModel makeLocalDeckWithClass:HSCardClassFromNSString(key)
                                            deckFormat:HSDeckFormatStandard
                                            completion:^(LocalDeck * _Nonnull localDeck) {
                    [NSOperationQueue.mainQueue addOperationWithBlock:^{
                        [self presentDeckDetailsWithLocalDeck:localDeck];
                    }];
                }];
            }];
            
            [createStandardDeckActions addObject:standardAction];
        }
    }
    
    for (NSString *key in hsCardClassesForFormat(HSDeckFormatWild)) {
        @autoreleasepool {
            UIAction *wildAction = [UIAction actionWithTitle:localizable[key]
                                                   image:nil
                                              identifier:nil
                                                 handler:^(__kindof UIAction * _Nonnull action) {
                [self.viewModel makeLocalDeckWithClass:HSCardClassFromNSString(key)
                                            deckFormat:HSDeckFormatWild
                                            completion:^(LocalDeck * _Nonnull localDeck) {
                    [NSOperationQueue.mainQueue addOperationWithBlock:^{
                        [self presentDeckDetailsWithLocalDeck:localDeck];
                    }];
                }];
            }];
            
            [createWildDeckActions addObject:wildAction];
        }
    }
    
    for (NSString *key in hsCardClassesForFormat(HSDeckFormatClassic)) {
        @autoreleasepool {
            UIAction *classicAction = [UIAction actionWithTitle:localizable[key]
                                                   image:nil
                                              identifier:nil
                                                 handler:^(__kindof UIAction * _Nonnull action) {
                [self.viewModel makeLocalDeckWithClass:HSCardClassFromNSString(key)
                                            deckFormat:HSDeckFormatClassic
                                            completion:^(LocalDeck * _Nonnull localDeck) {
                    [NSOperationQueue.mainQueue addOperationWithBlock:^{
                        [self presentDeckDetailsWithLocalDeck:localDeck];
                    }];
                }];
            }];
            
            [createClassicDeckActions addObject:classicAction];
        }
    }
    
    //
    
    UIMenu *createDeckMenu = [UIMenu menuWithTitle:NSLocalizedString(@"CREATE_NEW_DECK", @"")
                                              children:@[
        
        [UIMenu menuWithTitle:hsDeckFormatsWithLocalizable()[HSDeckFormatStandard]
                        image:[ImageService.sharedInstance imageOfDeckFormat:HSDeckFormatStandard]
                   identifier:nil
                      options:UIMenuOptionsSingleSelection
                     children:createStandardDeckActions],
        
        [UIMenu menuWithTitle:hsDeckFormatsWithLocalizable()[HSDeckFormatWild]
                        image:[ImageService.sharedInstance imageOfDeckFormat:HSDeckFormatWild]
                   identifier:nil
                      options:UIMenuOptionsSingleSelection
                     children:createWildDeckActions],
        
        [UIMenu menuWithTitle:hsDeckFormatsWithLocalizable()[HSDeckFormatClassic]
                        image:[ImageService.sharedInstance imageOfDeckFormat:HSDeckFormatClassic]
                   identifier:nil
                      options:UIMenuOptionsSingleSelection
                     children:createClassicDeckActions]
    ]];
    
    [createStandardDeckActions release];
    [createWildDeckActions release];
    [createClassicDeckActions release];
    
    addBarButtonItem.menu = [UIMenu menuWithChildren:@[
        createDeckMenu,
        
        [UIAction actionWithTitle:NSLocalizedString(@"LOAD_FROM_DECK_CODE", @"")
                            image:[UIImage systemImageNamed:@"arrow.down.square"]
                       identifier:nil
                          handler:^(__kindof UIAction * _Nonnull action) {
            [self presentTextFieldAndFetchDeckCode];
        }]
    ]];
    
    self.navigationItem.rightBarButtonItems = @[addBarButtonItem];
    [addBarButtonItem release];
}

- (void)configureNavigation {
    self.title = NSLocalizedString(@"DECKS", @"");
    self.navigationItem.largeTitleDisplayMode = UINavigationItemLargeTitleDisplayModeAlways;
    self.navigationController.navigationBar.prefersLargeTitles = YES;
}

- (void)configureCollectionView {
    UICollectionLayoutListConfiguration *layoutConfiguration = [[UICollectionLayoutListConfiguration alloc] initWithAppearance:UICollectionLayoutListAppearanceInsetGrouped];
    
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
    
    [collectionView release];
}

- (void)configureViewModel {
    DecksViewModel *viewModel = [[DecksViewModel alloc] initWithDataSource:[self makeDataSource]];
    self.viewModel = viewModel;
    [viewModel release];
}

- (DecksDataSource *)makeDataSource {
    UICollectionViewCellRegistration *cellRegistration = [self makeCellRegistration];
    
    DecksDataSource *dataSource = [[DecksDataSource alloc] initWithCollectionView:self.collectionView cellProvider:^UICollectionViewCell * _Nullable(UICollectionView * _Nonnull collectionView, NSIndexPath * _Nonnull indexPath, id  _Nonnull itemIdentifier) {
        
        UICollectionViewCell *cell = [collectionView dequeueConfiguredReusableCellWithRegistration:cellRegistration forIndexPath:indexPath item:itemIdentifier];
        
        return cell;
    }];
    
    return [dataSource autorelease];
}

- (UICollectionViewCellRegistration *)makeCellRegistration {
    UICollectionViewCellRegistration *cellRegistration = [UICollectionViewCellRegistration registrationWithCellClass:[UICollectionViewListCell class] configurationHandler:^(__kindof UICollectionViewListCell * _Nonnull cell, NSIndexPath * _Nonnull indexPath, id  _Nonnull item) {
        
        if (![item isKindOfClass:[DecksItemModel class]]) {
            return;
        }
        
        DecksItemModel *itemModel = (DecksItemModel *)item;
        
        DeckBaseContentConfiguration *configuration = [[DeckBaseContentConfiguration alloc] initWithLocalDeck:itemModel.localDeck];
        cell.contentConfiguration = configuration;
        [configuration release];
    }];
    
    return cellRegistration;
}

- (void)presentTextFieldAndFetchDeckCode {
    [self.viewModel parseClipboardForDeckCodeWithCompletion:^(NSString * _Nullable title, NSString * _Nullable deckCode) {
        [NSOperationQueue.mainQueue addOperationWithBlock:^{
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"LOAD_FROM_DECK_CODE", @"")
                                                                           message:NSLocalizedString(@"PLEASE_ENTER_DECK_CODE", @"")
                                                                    preferredStyle:UIAlertControllerStyleAlert];
            
            [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
                textField.text = title;
                textField.placeholder = NSLocalizedString(@"ENTER_DECK_TITLE_HERE", @"");
            }];
            
            [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
                textField.text = deckCode;
                self.deckCodeTextField = textField;
                textField.delegate = self;
                textField.placeholder = NSLocalizedString(@"ENTER_DECK_CODE_HERE", @"");
                
#if DEBUG
                if (deckCode == nil) {
                    textField.text = @"AAEBAa0GHuUE9xPDFoO7ArW7Are7Ati7AtHBAt/EAonNAvDPAujQApDTApeHA+aIA/yjA5mpA/KsA5GxA5O6A9fOA/vRA/bWA+LeA/vfA/jjA6iKBMGfBJegBKGgBAAA";
                }
#endif
            }];
            
            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"CANCEL", @"")
                                                                   style:UIAlertActionStyleCancel
                                                                 handler:^(UIAlertAction * _Nonnull action) {}];
            
            UIAlertAction *fetchButton = [UIAlertAction actionWithTitle:NSLocalizedString(@"FETCH", @"")
                                                                  style:UIAlertActionStyleDefault
                                                                handler:^(UIAlertAction * _Nonnull action) {
                UITextField * _Nullable firstTextField = alert.textFields[0];
                UITextField * _Nullable secondTextField = alert.textFields[1];
                if ((secondTextField.text != nil) && (![secondTextField.text isEqualToString:@""])) {
                    [self.viewModel fetchDeckCode:secondTextField.text
                                            title:firstTextField.text
                                       completion:^(LocalDeck * _Nonnull localDeck, HSDeck * _Nullable hsDeck, NSError * _Nullable error) {
                        [NSOperationQueue.mainQueue addOperationWithBlock:^{
                            if (error) {
                                [self presentErrorAlertWithError:error];
                            } else {
                                [self presentDeckDetailsWithLocalDeck:localDeck];
                            }
                        }];
                    }];
                }
            }];
            self.deckCodeAlertAction = fetchButton;
            
            if ((self.deckCodeTextField.text == nil) || ([self.deckCodeTextField.text isEqualToString:@""])) {
                fetchButton.enabled = NO;
            } else {
                fetchButton.enabled = YES;
            }
            
            [alert addAction:cancelAction];
            [alert addAction:fetchButton];
            
            [self presentViewController:alert animated:YES completion:^{}];
        }];
    }];
}

- (void)presentDeckDetailsWithLocalDeck:(LocalDeck *)localDeck {
    NSIndexPath *indexPath = [self.viewModel indexPathForLocalDeck:localDeck];
    [self.collectionView selectItemAtIndexPath:indexPath animated:YES scrollPosition:UICollectionViewScrollPositionNone];
    
    DeckDetailsViewController *vc = [[DeckDetailsViewController alloc] initWithLocalDeck:localDeck];
    [self.splitViewController showDetailViewController:vc sender:nil];
    [vc release];
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    DecksItemModel *itemModel = [self.viewModel.dataSource itemIdentifierForIndexPath:indexPath];
    [self presentDeckDetailsWithLocalDeck:itemModel.localDeck];
}

#pragma mark - UITextFieldDelegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    if ([textField isEqual:self.deckCodeTextField]) {
        if (([string isEqualToString:@""]) && (textField.text.length == range.length)) {
            self.deckCodeAlertAction.enabled = NO;
        } else {
            self.deckCodeAlertAction.enabled = YES;
        }
    }
    return YES;
}

@end
