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
#import "UIViewController+SpinnerView.h"
#import <StoneNamuResources/StoneNamuResources.h>

@interface DecksViewController () <UICollectionViewDelegate, UITextFieldDelegate>
@property (retain) UICollectionView *collectionView;
@property (retain) UIBarButtonItem *addBarButtonItem;
@property (retain) DecksViewModel *viewModel;
@property (assign) UITextField * _Nullable deckCodeTextField;
@property (assign) UIAlertAction * _Nullable deckCodeAlertAction;
@property (retain) UIViewController * _Nullable contextViewController;
@end

@implementation DecksViewController

- (void)dealloc {
    [_collectionView release];
    [_addBarButtonItem release];
    [_viewModel release];
    [_contextViewController release];
    [super dealloc];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configureCollectionView];
    [self configureViewModel];
    [self configureRightBarButtonItems];
    [self bind];
    [self.viewModel requestDataSource];
    [self.viewModel requestOptions];
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
    
    addBarButtonItem.enabled = NO;
    self.navigationItem.rightBarButtonItems = @[addBarButtonItem];
    self.addBarButtonItem = addBarButtonItem;
    [addBarButtonItem release];
}

- (void)configureNavigation {
    self.title = [ResourcesService localizationForKey:LocalizableKeyDecks];
    self.navigationItem.largeTitleDisplayMode = UINavigationItemLargeTitleDisplayModeAlways;
    self.navigationController.navigationBar.prefersLargeTitles = YES;
}

- (void)configureCollectionView {
    UICollectionLayoutListConfiguration *layoutConfiguration = [[UICollectionLayoutListConfiguration alloc] initWithAppearance:UICollectionLayoutListAppearanceInsetGrouped];
    layoutConfiguration.trailingSwipeActionsConfigurationProvider = [self makeTrailingSwipeProvider];
    
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
    DecksViewModel *viewModel = [[DecksViewModel alloc] initWithDataSource:[self makeDataSource]];
    self.viewModel = viewModel;
    [viewModel release];
}

- (void)bind {
    [NSNotificationCenter.defaultCenter addObserver:self
                                           selector:@selector(startedLoadingDataSourceReceived:)
                                               name:NSNotificationNameDecksViewModelStartedLoadingDataSource
                                             object:self.viewModel];
    
    [NSNotificationCenter.defaultCenter addObserver:self
                                           selector:@selector(endedLoadingDataSourceReceived:)
                                               name:NSNotificationNameDecksViewModelEndedLoadingDataSource
                                             object:self.viewModel];
    
    [NSNotificationCenter.defaultCenter addObserver:self
                                           selector:@selector(shouldUpdateOptionsReceived:)
                                               name:NSNotificationNameDecksViewModelShouldUpdateOptions
                                             object:self.viewModel];
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

- (void)shouldUpdateOptionsReceived:(NSNotification *)notification {
    NSDictionary<HSDeckFormat, NSDictionary<NSString *, NSString *> *> * _Nullable slugsAndNames = notification.userInfo[DecksViewModelShouldUpdateOptionsSlugsAndNamesItemKey];
    NSDictionary<HSDeckFormat, NSDictionary<NSString *, NSNumber *> *> * _Nullable slugsAndIds = notification.userInfo[DecksViewModelShouldUpdateOptionsSlugsAndIdsItemKey];
    
    if ((slugsAndNames) && (slugsAndIds)) {
        [NSOperationQueue.mainQueue addOperationWithBlock:^{
            [self replaceMenuOfAddBarButtonItem:self.addBarButtonItem slugsAndNames:slugsAndNames slugsAndIds:slugsAndIds];
        }];
    }
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
        
        DeckBaseContentConfiguration *configuration = [[DeckBaseContentConfiguration alloc] initWithLocalDeck:itemModel.localDeck classSlug:itemModel.classSlug isEasterEgg:itemModel.isEasterEgg count:itemModel.count];
        cell.contentConfiguration = configuration;
        [configuration release];
    }];
    
    return cellRegistration;
}

- (UICollectionLayoutListSwipeActionsConfigurationProvider)makeTrailingSwipeProvider {
    DecksViewController * __block unretainedSelf = self;
    
    UICollectionLayoutListSwipeActionsConfigurationProvider provider = ^UISwipeActionsConfiguration * _Nullable(NSIndexPath *indexPath) {
        
        UIContextualAction *deleteAction = [UIContextualAction contextualActionWithStyle:UIContextualActionStyleDestructive
                                                                                   title:nil
                                                                                 handler:^(UIContextualAction * _Nonnull action, __kindof UIView * _Nonnull sourceView, void (^ _Nonnull completionHandler)(BOOL)) {
            [unretainedSelf.viewModel deleteLocalDecksFromIndexPaths:[NSSet setWithObject:indexPath]];
        }];
        
        deleteAction.image = [UIImage systemImageNamed:@"trash"];
        
        UISwipeActionsConfiguration *configuration = [UISwipeActionsConfiguration configurationWithActions:@[deleteAction]];
        configuration.performsFirstActionWithFullSwipe = NO;
        return configuration;
    };
    
    return [[provider copy] autorelease];
}

- (void)presentTextFieldAndFetchDeckCode {
    [self.viewModel parseClipboardForDeckCodeWithCompletion:^(NSString * _Nullable title, NSString * _Nullable deckCode) {
        [NSOperationQueue.mainQueue addOperationWithBlock:^{
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:[ResourcesService localizationForKey:LocalizableKeyLoadFromDeckCode]
                                                                           message:[ResourcesService localizationForKey:LocalizableKeyPleaseEnterDeckCode]
                                                                    preferredStyle:UIAlertControllerStyleAlert];
            
            [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
                textField.text = title;
                textField.placeholder = [ResourcesService localizationForKey:LocalizableKeyEnterDeckTitleHere];
            }];
            
            [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
                textField.text = deckCode;
                self.deckCodeTextField = textField;
                textField.delegate = self;
                textField.placeholder = [ResourcesService localizationForKey:LocalizableKeyEnterDeckCodeHere];
                
#if DEBUG
                if ((deckCode == nil) || ([deckCode isEqualToString:@""])) {
                    textField.text = @"AAEBAa0GHuUE9xPDFoO7ArW7Are7Ati7AtHBAt/EAonNAvDPAujQApDTApeHA+aIA/yjA5mpA/KsA5GxA5O6A9fOA/vRA/bWA+LeA/vfA/jjA6iKBMGfBJegBKGgBAAA";
                }
#endif
            }];
            
            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:[ResourcesService localizationForKey:LocalizableKeyCancel]
                                                                   style:UIAlertActionStyleCancel
                                                                 handler:^(UIAlertAction * _Nonnull action) {}];
            
            UIAlertAction *fetchButton = [UIAlertAction actionWithTitle:[ResourcesService localizationForKey:LocalizableKeyFetch]
                                                                  style:UIAlertActionStyleDefault
                                                                handler:^(UIAlertAction * _Nonnull action) {
                UITextField * _Nullable firstTextField = alert.textFields[0];
                UITextField * _Nullable secondTextField = alert.textFields[1];
                if ((secondTextField.text != nil) && (![secondTextField.text isEqualToString:@""])) {
                    [self addSpinnerView];
                    
                    [self.viewModel fetchDeckCode:secondTextField.text
                                            title:firstTextField.text
                                       completion:^(LocalDeck * _Nonnull localDeck, HSDeck * _Nullable hsDeck, NSError * _Nullable error) {
                        [NSOperationQueue.mainQueue addOperationWithBlock:^{
                            [self removeAllSpinnerview];
                            
                            if (error) {
                                [self presentErrorAlertWithError:error];
                            } else {
                                [self presentDeckDetailsWithLocalDeck:localDeck indexPath:nil scrollToItem:YES];
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

- (DeckDetailsViewController *)makeDeckDetailsWithLocalDeck:(LocalDeck *)localDeck {
    DeckDetailsViewController *vc = [[DeckDetailsViewController alloc] initWithLocalDeck:localDeck presentEditorIfNoCards:YES];
    return [vc autorelease];
}

- (void)presentDeckDetailsWithLocalDeck:(LocalDeck *)localDeck indexPath:(NSIndexPath * _Nullable)indexPath scrollToItem:(BOOL)scrollToItem {
    DeckDetailsViewController *vc = [self makeDeckDetailsWithLocalDeck:localDeck];
    
    if (scrollToItem) {
        NSIndexPath *_indexPath;
        
        if (indexPath == nil) {
            _indexPath = [self.viewModel indexPathForLocalDeck:localDeck];
        } else {
            _indexPath = indexPath;
        }
        
        [self.collectionView selectItemAtIndexPath:_indexPath animated:YES scrollPosition:UICollectionViewScrollPositionNone];
    }
    
    if ((self.splitViewController == nil) || (self.splitViewController.isCollapsed)) {
        [self.navigationController pushViewController:vc animated:YES];
    } else {
        if (self.splitViewController.style == UISplitViewControllerStyleTripleColumn) {
            [self.splitViewController setViewController:vc forColumn:UISplitViewControllerColumnSecondary];
            [vc.navigationController setViewControllers:@[vc] animated:NO];
        } else {
            [self.splitViewController showDetailViewController:vc sender:self];
        }
    }
}

- (void)replaceMenuOfAddBarButtonItem:(UIBarButtonItem *)addBarButtonItem
                        slugsAndNames:(NSDictionary<HSDeckFormat, NSDictionary<NSString *, NSString *> *> * _Nullable)slugsAndNames
                          slugsAndIds:(NSDictionary<HSDeckFormat, NSDictionary<NSString *, NSNumber *> *> * _Nullable)slugsAndIds {
    
    /* UIMenu initializer doesn't copy children so should mark __block */
    NSMutableArray<UIAction *> * __block createStandardDeckActions = [NSMutableArray<UIAction *> new];
    NSMutableArray<UIAction *> * __block createWildDeckActions = [NSMutableArray<UIAction *> new];
    NSMutableArray<UIAction *> * __block createClassicDeckActions = [NSMutableArray<UIAction *> new];
    
    DecksViewController * __block unretainedSelf = self;
    
    [slugsAndNames[HSDeckFormatStandard] enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull key, NSString * _Nonnull obj, BOOL * _Nonnull stop) {
        UIAction *standardAction = [UIAction actionWithTitle:obj
                                                       image:nil
                                                  identifier:nil
                                                     handler:^(__kindof UIAction * _Nonnull action) {
            
            [unretainedSelf replaceMenuOfAddBarButtonItem:unretainedSelf.addBarButtonItem
                                            slugsAndNames:slugsAndNames
                                              slugsAndIds:slugsAndIds];
            
            [unretainedSelf.viewModel makeLocalDeckWithClassSlug:key
                                                      deckFormat:HSDeckFormatStandard
                                                      completion:^(LocalDeck * _Nonnull localDeck) {
                [NSOperationQueue.mainQueue addOperationWithBlock:^{
                    [unretainedSelf presentDeckDetailsWithLocalDeck:localDeck indexPath:nil scrollToItem:YES];
                }];
            }];
        }];
        
        [createStandardDeckActions addObject:standardAction];
    }];
    
    [slugsAndNames[HSDeckFormatWild] enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull key, NSString * _Nonnull obj, BOOL * _Nonnull stop) {
        UIAction *wildAction = [UIAction actionWithTitle:obj
                                                       image:nil
                                                  identifier:nil
                                                     handler:^(__kindof UIAction * _Nonnull action) {
            
            [unretainedSelf replaceMenuOfAddBarButtonItem:unretainedSelf.addBarButtonItem
                                            slugsAndNames:slugsAndNames
                                              slugsAndIds:slugsAndIds];
            
            [unretainedSelf.viewModel makeLocalDeckWithClassSlug:key
                                                      deckFormat:HSDeckFormatWild
                                                      completion:^(LocalDeck * _Nonnull localDeck) {
                [NSOperationQueue.mainQueue addOperationWithBlock:^{
                    [unretainedSelf presentDeckDetailsWithLocalDeck:localDeck indexPath:nil scrollToItem:YES];
                }];
            }];
        }];
        
        [createWildDeckActions addObject:wildAction];
    }];
    
    [slugsAndNames[HSDeckFormatClassic] enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull key, NSString * _Nonnull obj, BOOL * _Nonnull stop) {
        UIAction *classicAction = [UIAction actionWithTitle:obj
                                                       image:nil
                                                  identifier:nil
                                                     handler:^(__kindof UIAction * _Nonnull action) {
            
            [unretainedSelf replaceMenuOfAddBarButtonItem:unretainedSelf.addBarButtonItem
                                            slugsAndNames:slugsAndNames
                                              slugsAndIds:slugsAndIds];
            
            [unretainedSelf.viewModel makeLocalDeckWithClassSlug:key
                                                      deckFormat:HSDeckFormatClassic
                                                      completion:^(LocalDeck * _Nonnull localDeck) {
                [NSOperationQueue.mainQueue addOperationWithBlock:^{
                    [unretainedSelf presentDeckDetailsWithLocalDeck:localDeck indexPath:nil scrollToItem:YES];
                }];
            }];
        }];
        
        [createClassicDeckActions addObject:classicAction];
    }];
    
    //
    
    UIMenu *createDeckMenu = [UIMenu menuWithTitle:[ResourcesService localizationForKey:LocalizableKeyCreateANewDeck]
                                              children:@[
        
        [UIMenu menuWithTitle:[ResourcesService localizationForHSDeckFormat:HSDeckFormatStandard]
                        image:[ResourcesService imageForDeckFormat:HSDeckFormatStandard]
                   identifier:nil
                      options:UIMenuOptionsSingleSelection
                     children:createStandardDeckActions],
        
        [UIMenu menuWithTitle:[ResourcesService localizationForHSDeckFormat:HSDeckFormatWild]
                        image:[ResourcesService imageForDeckFormat:HSDeckFormatWild]
                   identifier:nil
                      options:UIMenuOptionsSingleSelection
                     children:createWildDeckActions],
        
        [UIMenu menuWithTitle:[ResourcesService localizationForHSDeckFormat:HSDeckFormatClassic]
                        image:[ResourcesService imageForDeckFormat:HSDeckFormatClassic]
                   identifier:nil
                      options:UIMenuOptionsSingleSelection
                     children:createClassicDeckActions]
    ]];
    
    [createStandardDeckActions release];
    [createWildDeckActions release];
    [createClassicDeckActions release];
    
    addBarButtonItem.menu = [UIMenu menuWithChildren:@[
        createDeckMenu,
        
        [UIAction actionWithTitle:[ResourcesService localizationForKey:LocalizableKeyLoadFromDeckCode]
                            image:[UIImage systemImageNamed:@"arrow.down.square"]
                       identifier:nil
                          handler:^(__kindof UIAction * _Nonnull action) {
            [unretainedSelf presentTextFieldAndFetchDeckCode];
        }]
    ]];
    addBarButtonItem.enabled = YES;
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [self.viewModel localDecksFromIndexPaths:[NSSet setWithObject:indexPath] completion:^(NSSet<LocalDeck *> * _Nonnull localDecks) {
        [NSOperationQueue.mainQueue addOperationWithBlock:^{
            [localDecks enumerateObjectsUsingBlock:^(LocalDeck * _Nonnull obj, BOOL * _Nonnull stop) {
                [self presentDeckDetailsWithLocalDeck:obj indexPath:indexPath scrollToItem:NO];
            }];
        }];
    }];
}

- (UIContextMenuConfiguration *)collectionView:(UICollectionView *)collectionView contextMenuConfigurationForItemAtIndexPath:(NSIndexPath *)indexPath point:(CGPoint)point {
    self.contextViewController = nil;
    self.viewModel.contextMenuIndexPath = nil;
    
    DecksItemModel * _Nullable itemModel = [self.viewModel.dataSource itemIdentifierForIndexPath:indexPath];
    
    if (itemModel == nil) {
        return nil;
    }
    
    self.viewModel.contextMenuIndexPath = indexPath;
    
    UIContextMenuConfiguration *configuration = [UIContextMenuConfiguration configurationWithIdentifier:nil
                                                                                        previewProvider:^UIViewController * _Nullable{
        DeckDetailsViewController *vc = [self makeDeckDetailsWithLocalDeck:itemModel.localDeck];
        self.contextViewController = vc;
        return vc;
    }
                                                                                         actionProvider:nil];
    
    return configuration;
}

- (void)collectionView:(UICollectionView *)collectionView willEndContextMenuInteractionWithConfiguration:(UIContextMenuConfiguration *)configuration animator:(id<UIContextMenuInteractionAnimating>)animator {
    [animator addCompletion:^{
        self.contextViewController = nil;
        self.viewModel.contextMenuIndexPath = nil;
    }];
}

- (void)collectionView:(UICollectionView *)collectionView willPerformPreviewActionForMenuWithConfiguration:(UIContextMenuConfiguration *)configuration animator:(id<UIContextMenuInteractionCommitAnimating>)animator {
    if (self.contextViewController == nil) return;
    
    NSIndexPath * _Nullable indexPath = self.viewModel.contextMenuIndexPath;
    
    if (indexPath) {
        [collectionView selectItemAtIndexPath:indexPath animated:YES scrollPosition:UICollectionViewScrollPositionNone];
    }
    
    [animator addAnimations:^{
        if (self.splitViewController == nil) {
            [self.navigationController pushViewController:self.contextViewController animated:YES];
        } else {
            [self.splitViewController setViewController:self.contextViewController forColumn:UISplitViewControllerColumnSecondary];
            [self.contextViewController.navigationController setViewControllers:@[self.contextViewController] animated:NO];
        }
    }];
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
