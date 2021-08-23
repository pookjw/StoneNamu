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

@interface DecksViewController () <UICollectionViewDelegate>
@property (retain) UICollectionView *collectionView;
@property (retain) UIBarButtonItem *addBarButtonItem;
@property (retain) DecksViewModel *viewModel;
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
    
    NSDictionary<NSString *, NSString *> *hsCardClasses = hsCardClassesWithTenClassesWithLocalizable();
    NSArray<NSString *> *hsCardClassesKeys = [hsCardClasses.allKeys sortedArrayUsingComparator:^NSComparisonResult(NSString *obj1, NSString *obj2) {
        HSCardClass class1 = HSCardClassFromNSString(obj1);
        HSCardClass class2 = HSCardClassFromNSString(obj2);
        
        if (class1 > class2) {
            return NSOrderedDescending;
        } else if (class1 < class2) {
            return NSOrderedAscending;
        } else {
            return NSOrderedSame;
        }
    }];
    
    NSMutableArray<UIAction *> *classSelectionActions = [@[] mutableCopy];
    
    for (NSString *key in hsCardClassesKeys) {
        @autoreleasepool {
            UIAction *action = [UIAction actionWithTitle:hsCardClasses[key]
                                                   image:nil
                                              identifier:nil
                                                 handler:^(__kindof UIAction * _Nonnull action) {
                [self.viewModel makeLocalDeckWithClass:HSCardClassFromNSString(key) completion:^(LocalDeck * _Nonnull localDeck) {
                    [NSOperationQueue.mainQueue addOperationWithBlock:^{
                        [self presentDeckDetailsWithLocalDeck:localDeck];
                    }];
                }];
            }];
            [classSelectionActions addObject:action];
        }
    }
    
    UIMenu *classSelectionMenu = [UIMenu menuWithTitle:NSLocalizedString(@"CREATE_NEW_DECK", @"")
                                              children:classSelectionActions];
    [classSelectionActions release];
    
    addBarButtonItem.menu = [UIMenu menuWithChildren:@[
        classSelectionMenu,
        
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
        
        UIListContentConfiguration *configuration = [UIListContentConfiguration subtitleCellConfiguration];
        configuration.text = itemModel.localDeck.name;
        configuration.secondaryTextProperties.numberOfLines = 0;
        cell.contentConfiguration = configuration;
    }];
    
    return cellRegistration;
}

- (void)presentTextFieldAndFetchDeckCode {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"LOAD_FROM_DECK_CODE", @"")
                                                                   message:NSLocalizedString(@"PLEASE_ENTER_DECK_CODE", @"")
                                                            preferredStyle:UIAlertControllerStyleAlert];
    [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.text = @"AAEBAa0GHuUE9xPDFoO7ArW7Are7Ati7AtHBAt/EAonNAvDPAujQApDTApeHA+aIA/yjA5mpA/KsA5GxA5O6A9fOA/vRA/bWA+LeA/vfA/jjA6iKBMGfBJegBKGgBAAA";
    }];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"CANCEL", @"")
                                                           style:UIAlertActionStyleCancel
                                                         handler:^(UIAlertAction * _Nonnull action) {}];
    
    UIAlertAction *fetchButton = [UIAlertAction actionWithTitle:NSLocalizedString(@"FETCH", @"")
                                                          style:UIAlertActionStyleDefault
                                                        handler:^(UIAlertAction * _Nonnull action) {
        UITextField * _Nullable textField = alert.textFields.firstObject;
        if (textField.text) {
            [self.viewModel fetchDeckCode:textField.text completion:^(LocalDeck * _Nonnull localDeck, HSDeck * _Nullable hsDeck, NSError * _Nullable error) {
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
    
    [alert addAction:cancelAction];
    [alert addAction:fetchButton];
    
    [self presentViewController:alert animated:YES completion:^{}];
}

- (void)presentDeckDetailsWithLocalDeck:(LocalDeck *)localDeck {
    NSIndexPath *indexPath = [self.viewModel indexPathForLocalDeck:localDeck];
    [self.collectionView selectItemAtIndexPath:indexPath animated:YES scrollPosition:UICollectionViewScrollPositionNone];
    
    DeckDetailsViewController *vc = [[DeckDetailsViewController alloc] initWithLocalDeck:localDeck];
    [self.splitViewController showDetailViewController:vc sender:nil];
    [vc release];
}

#pragma mark UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    DecksItemModel *itemModel = [self.viewModel.dataSource itemIdentifierForIndexPath:indexPath];
    [self presentDeckDetailsWithLocalDeck:itemModel.localDeck];
}

@end
