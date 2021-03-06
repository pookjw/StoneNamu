//
//  PrefsViewController.m
//  PrefsViewController
//
//  Created by Jinwoo Kim on 8/10/21.
//

#import <SafariServices/SafariServices.h>
#import "PrefsViewController.h"
#import "PrefsViewModel.h"
#import "PrefsLocaleViewController.h"
#import "PrefsRegionHostViewController.h"
#import "UIViewController+animatedForSelectedIndexPath.h"
#import <StoneNamuResources/StoneNamuResources.h>

@interface PrefsViewController () <UICollectionViewDelegate>
@property (retain) UICollectionView *collectionView;
@property (retain) PrefsViewModel *viewModel;
@property (retain) UICollectionViewSupplementaryRegistration *headerCellRegistration;
@property (retain) UICollectionViewSupplementaryRegistration *footerCellRegistration;
@property (retain) UIViewController * _Nullable contextViewController;
@property (retain) UIBarButtonItem *doneBarButtonItem;
@end

@implementation PrefsViewController

- (instancetype)init {
    self = [super init];
    
    if (self) {
        self.contextViewController = nil;
    }
    
    return self;
}

- (void)dealloc {
    [_collectionView release];
    [_viewModel release];
    [_headerCellRegistration release];
    [_footerCellRegistration release];
    [_contextViewController release];
    [_doneBarButtonItem release];
    [super dealloc];
}

- (void)setDoneButtonHidden:(BOOL)hidden {
    [self loadViewIfNeeded];
    
    if (hidden) {
        self.navigationItem.rightBarButtonItems = @[];
    } else {
        self.navigationItem.rightBarButtonItems = @[self.doneBarButtonItem];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setAttributes];
    [self configureRightBarButtonItems];
    [self configureCollectionView];
    [self configureViewModel];
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
    UIBarButtonItem *doneBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:[ResourcesService localizationForKey:LocalizableKeyDone]
                                                                          style:UIBarButtonItemStylePlain
                                                                         target:self
                                                                         action:@selector(triggeredDoneBarButtonItem:)];
    self.doneBarButtonItem = doneBarButtonItem;
    
    [doneBarButtonItem release];
}

- (void)triggeredDoneBarButtonItem:(UIBarButtonItem *)sender {
    [self dismissViewControllerAnimated:YES completion:^{}];
}

- (void)configureNavigation {
    self.title = [ResourcesService localizationForKey:LocalizableKeyPreferences];
    self.navigationItem.largeTitleDisplayMode = UINavigationItemLargeTitleDisplayModeAlways;
    self.navigationController.navigationBar.prefersLargeTitles = YES;
}

- (void)configureCollectionView {
    UICollectionLayoutListConfiguration *layoutConfiguration = [[UICollectionLayoutListConfiguration alloc] initWithAppearance:UICollectionLayoutListAppearanceInsetGrouped];
    layoutConfiguration.headerMode = UICollectionLayoutListHeaderModeSupplementary;
    layoutConfiguration.footerMode = UICollectionLayoutListFooterModeSupplementary;
    
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
    PrefsViewModel *viewModel = [[PrefsViewModel alloc] initWithDataSource:[self makeDataSource]];
    self.viewModel = viewModel;
    [viewModel autorelease];
}

- (PrefsDataSource *)makeDataSource {
    UICollectionViewCellRegistration *cellRegistration = [self makeCellRegistration];
    
    PrefsDataSource *dataSource = [[PrefsDataSource alloc] initWithCollectionView:self.collectionView cellProvider:^UICollectionViewCell * _Nullable(UICollectionView * _Nonnull collectionView, NSIndexPath * _Nonnull indexPath, id  _Nonnull itemIdentifier) {
        
        UICollectionViewCell *cell = [collectionView dequeueConfiguredReusableCellWithRegistration:cellRegistration forIndexPath:indexPath item:itemIdentifier];
        
        return cell;
    }];
    
    dataSource.supplementaryViewProvider = [self makeSupplementaryViewProvider];
    
    return [dataSource autorelease];
}

- (UICollectionViewCellRegistration *)makeCellRegistration {
    UICollectionViewCellRegistration *cellRegistration = [UICollectionViewCellRegistration registrationWithCellClass:[UICollectionViewListCell class] configurationHandler:^(__kindof UICollectionViewListCell * _Nonnull cell, NSIndexPath * _Nonnull indexPath, id  _Nonnull item) {
        
        if (![item isKindOfClass:[PrefsItemModel class]]) {
            return;
        }
        
        PrefsItemModel *itemModel = (PrefsItemModel *)item;
        
        UIListContentConfiguration *configuration = [UIListContentConfiguration cellConfiguration];
        configuration.image = itemModel.primaryImage;
        configuration.text = itemModel.primaryText;
        configuration.textProperties.alignment = itemModel.primaryTextAlignment;
        configuration.secondaryText = itemModel.secondaryText;
        configuration.imageProperties.maximumSize = CGSizeMake(50, 50);
        configuration.imageProperties.cornerRadius = 25;
        cell.contentConfiguration = configuration;
        
        //
        
        NSMutableArray<UICellAccessory *> *accessories = [NSMutableArray<UICellAccessory *> new];
        
        if (itemModel.hasDisclosure) {
            [accessories addObject:[[UICellAccessoryDisclosureIndicator new] autorelease]];
        }
        
        if (itemModel.accessoryText) {
            [accessories addObject:[[[UICellAccessoryLabel alloc] initWithText:itemModel.accessoryText] autorelease]];
        }
        
        cell.accessories = accessories;
        [accessories release];
    }];
    
    return cellRegistration;
}

- (UICollectionViewDiffableDataSourceSupplementaryViewProvider)makeSupplementaryViewProvider {
    self.headerCellRegistration = [self makeHeaderCellRegistration];
    self.footerCellRegistration = [self makeFooterCellRegistration];
    
    PrefsViewController * __block unretainedSelf = self;
    
    UICollectionViewDiffableDataSourceSupplementaryViewProvider provider = ^UICollectionReusableView * _Nullable(UICollectionView * _Nonnull collectionView, NSString * _Nonnull elementKind, NSIndexPath * _Nonnull indexPath) {
        
        if ([elementKind isEqualToString:UICollectionElementKindSectionHeader]) {
            return [collectionView dequeueConfiguredReusableSupplementaryViewWithRegistration:unretainedSelf.headerCellRegistration forIndexPath:indexPath];
        } else if ([elementKind isEqualToString:UICollectionElementKindSectionFooter]) {
            return [collectionView dequeueConfiguredReusableSupplementaryViewWithRegistration:unretainedSelf.footerCellRegistration forIndexPath:indexPath];
        } else {
            return nil;
        }
    };
    
    return [[provider copy] autorelease];
}

- (UICollectionViewSupplementaryRegistration *)makeHeaderCellRegistration {
    PrefsViewController * __block unretainedSelf = self;
    
    UICollectionViewSupplementaryRegistration *registration = [UICollectionViewSupplementaryRegistration registrationWithSupplementaryClass:[UICollectionViewListCell class]
                                                                                                                                elementKind:UICollectionElementKindSectionHeader
                                                                                                                       configurationHandler:^(__kindof UICollectionViewListCell * _Nonnull supplementaryView, NSString * _Nonnull elementKind, NSIndexPath * _Nonnull indexPath) {
        
        NSString * _Nullable text = [unretainedSelf.viewModel headerTextFromIndexPath:indexPath];
        
        UIListContentConfiguration *configuration = [UIListContentConfiguration groupedHeaderConfiguration];
        configuration.text = text;
        
        supplementaryView.contentConfiguration = configuration;
    }];
    
    return registration;
}

- (UICollectionViewSupplementaryRegistration *)makeFooterCellRegistration {
    PrefsViewController * __block unretainedSelf = self;
    
    UICollectionViewSupplementaryRegistration *registration = [UICollectionViewSupplementaryRegistration registrationWithSupplementaryClass:[UICollectionViewListCell class]
                                                                                                                                elementKind:UICollectionElementKindSectionFooter
                                                                                                                       configurationHandler:^(__kindof UICollectionViewListCell * _Nonnull supplementaryView, NSString * _Nonnull elementKind, NSIndexPath * _Nonnull indexPath) {
        
        NSString * _Nullable text = [unretainedSelf.viewModel footerTextFromIndexPath:indexPath];
        
        UIListContentConfiguration *configuration = [UIListContentConfiguration groupedFooterConfiguration];
        configuration.text = text;
        configuration.textProperties.alignment = UIListContentTextAlignmentCenter;
        
        supplementaryView.contentConfiguration = configuration;
    }];
    
    return registration;
}

- (void)pushToLocaleViewController {
    PrefsLocaleViewController *vc = [PrefsLocaleViewController new];
    if (self.splitViewController != nil) {
        [self.splitViewController showDetailViewController:vc sender:self];
    } else {
        [self.navigationController pushViewController:vc animated:YES];
    }
    [vc release];
}

- (void)pushToRegionHostViewController {
    PrefsRegionHostViewController *vc = [PrefsRegionHostViewController new];
    if (self.splitViewController != nil) {
        [self.splitViewController showDetailViewController:vc sender:self];
    } else {
        [self.navigationController pushViewController:vc animated:YES];
    }
    [vc release];
}

- (void)presentInternalWebViewControllerWithURL:(NSURL *)url {
    SFSafariViewController *vc = [[SFSafariViewController alloc] initWithURL:url];
    [self presentViewController:vc animated:YES completion:^{}];
    [vc release];
}

- (void)openURL:(NSURL *)url {
    if (self.view.window.windowScene != nil) {
        [self.view.window.windowScene openURL:url options:nil completionHandler:^(BOOL success) {}];
    } else {
        [UIApplication.sharedApplication openURL:url options:@{} completionHandler:^(BOOL success) {}];
    }
}

- (void)presentActionSheetFromView:(UIView *)view withSocialInfo:(NSDictionary<NSString *, NSURL *> *)socialInfo title:(NSString *)title {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title
                                                                   message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    [socialInfo enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull key, NSURL * _Nonnull obj, BOOL * _Nonnull stop) {
        UIAlertAction *action = [UIAlertAction actionWithTitle:key
                                                         style:UIAlertActionStyleDefault
                                                       handler:^(UIAlertAction * _Nonnull action) {
            if (view.window.windowScene) {
                [view.window.windowScene openURL:obj options:nil completionHandler:^(BOOL success) {}];
            } else {
                [UIApplication.sharedApplication openURL:obj options:@{} completionHandler:^(BOOL success) {}];
            }
        }];
        [alert addAction:action];
    }];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:[ResourcesService localizationForKey:LocalizableKeyCancel]
                                                           style:UIAlertActionStyleCancel
                                                         handler:^(UIAlertAction * _Nonnull action) {}];
    [alert addAction:cancelAction];
    
    //
    
    UIPopoverPresentationController *pc = [alert popoverPresentationController];
    pc.sourceView = view;
    [self presentViewController:alert animated:YES completion:^{}];
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    PrefsItemModel * _Nullable itemModel = [self.viewModel.dataSource itemIdentifierForIndexPath:indexPath];
    
    if (itemModel == nil) {
        [collectionView deselectItemAtIndexPath:indexPath animated:YES];
        return;
    }
    
    //
    
    switch (itemModel.type) {
        case PrefsItemModelTypeLocaleSelection:
            [self pushToLocaleViewController];
            break;
        case PrefsItemModelTypeRegionSelection:
            [self pushToRegionHostViewController];
            break;
        case PrefsItemModelTypeDeleteAllCaches:
            [self.viewModel deleteAllCahces];
            [collectionView deselectItemAtIndexPath:indexPath animated:YES];
            break;
        case PrefsItemModelTypeDeleteAllLocalDecks:
            [self.viewModel deleteAllLocalDecks];
            [collectionView deselectItemAtIndexPath:indexPath animated:YES];
            break;
        case PrefsItemModelTypeJoinTestFlight:
            [self openURL:itemModel.externalWebPageURL];
            [collectionView deselectItemAtIndexPath:indexPath animated:YES];
            break;
        case PrefsItemModelTypePookjwContributor:
            [self presentInternalWebViewControllerWithURL:itemModel.internalWebPageURL];
            break;
        case PrefsItemModelTypePnamuContributor: {
            UICollectionViewCell * _Nullable cell = [collectionView cellForItemAtIndexPath:indexPath];
            if (cell) {
                [self presentActionSheetFromView:cell withSocialInfo:itemModel.socialInfo title:itemModel.primaryText];
            }
            [collectionView deselectItemAtIndexPath:indexPath animated:YES];
            break;
        }
        default:
            [collectionView deselectItemAtIndexPath:indexPath animated:YES];
            break;
    }
}

- (UIContextMenuConfiguration *)collectionView:(UICollectionView *)collectionView contextMenuConfigurationForItemAtIndexPath:(NSIndexPath *)indexPath point:(CGPoint)point {
    self.contextViewController = nil;
    self.viewModel.contextMenuIndexPath = nil;
    
    PrefsItemModel * _Nullable itemModel = [self.viewModel.dataSource itemIdentifierForIndexPath:indexPath];
    if (itemModel == nil) return nil;
    
    switch (itemModel.type) {
        case PrefsItemModelTypeLocaleSelection: {
            self.viewModel.contextMenuIndexPath = indexPath;
            UIContextMenuConfiguration *configuration = [UIContextMenuConfiguration configurationWithIdentifier:nil
                                                                                                previewProvider:^UIViewController * _Nullable{
                PrefsLocaleViewController *vc = [PrefsLocaleViewController new];
                self.contextViewController = vc;
                return [vc autorelease];
            }
                                                                                                 actionProvider:nil];
            return configuration;
        }
        case PrefsItemModelTypeRegionSelection: {
            self.viewModel.contextMenuIndexPath = indexPath;
            UIContextMenuConfiguration *configuration = [UIContextMenuConfiguration configurationWithIdentifier:nil
                                                                                                previewProvider:^UIViewController * _Nullable{
                PrefsRegionHostViewController *vc = [PrefsRegionHostViewController new];
                self.contextViewController = vc;
                return [vc autorelease];
            }
                                                                                                 actionProvider:nil];
            return configuration;
        }
        case PrefsItemModelTypePookjwContributor: {
            self.viewModel.contextMenuIndexPath = indexPath;
            UIContextMenuConfiguration *configuration = [UIContextMenuConfiguration configurationWithIdentifier:nil
                                                                                                previewProvider:^UIViewController * _Nullable{
                SFSafariViewController *vc = [[SFSafariViewController alloc] initWithURL:itemModel.internalWebPageURL];
                self.contextViewController = vc;
                return [vc autorelease];
            }
                                                                                                 actionProvider:nil];
            return configuration;
        }
        case PrefsItemModelTypePnamuContributor: {
            UIContextMenuConfiguration *configuration = [UIContextMenuConfiguration configurationWithIdentifier:nil
                                                                                                previewProvider:nil
                                                                                                 actionProvider:^UIMenu * _Nullable(NSArray<UIMenuElement *> * _Nonnull suggestedActions) {
                NSMutableArray<UIAction *> *children = [NSMutableArray<UIAction *> new];
                [itemModel.socialInfo enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull key, NSURL * _Nonnull obj, BOOL * _Nonnull stop) {
                    [children addObject:[UIAction actionWithTitle:key image:nil identifier:nil handler:^(__kindof UIAction * _Nonnull action) {
                        if (self.view.window.windowScene) {
                            [self.view.window.windowScene openURL:obj options:nil completionHandler:^(BOOL success) {}];
                        } else {
                            [UIApplication.sharedApplication openURL:obj options:@{} completionHandler:^(BOOL success){}];
                        }
                    }]];
                }];
                
                UIMenu *menu = [UIMenu menuWithTitle:itemModel.primaryText
                                            children:children];
                [children release];
                
                return menu;
            }];
            return configuration;
        }
        default:
            return nil;
    }
}

- (void)collectionView:(UICollectionView *)collectionView willEndContextMenuInteractionWithConfiguration:(UIContextMenuConfiguration *)configuration animator:(id<UIContextMenuInteractionAnimating>)animator {
    [animator addCompletion:^{
        self.contextViewController = nil;
        self.viewModel.contextMenuIndexPath = nil;
    }];
}

- (void)collectionView:(UICollectionView *)collectionView willPerformPreviewActionForMenuWithConfiguration:(UIContextMenuConfiguration *)configuration animator:(id<UIContextMenuInteractionCommitAnimating>)animator {
    NSIndexPath * _Nullable indexPath = self.viewModel.contextMenuIndexPath;
    
    if (indexPath) {
        [collectionView selectItemAtIndexPath:indexPath animated:YES scrollPosition:UICollectionViewScrollPositionNone];
    }
    
    if (self.contextViewController == nil) return;
    
    [animator addAnimations:^{
        if ([self.contextViewController isKindOfClass:[SFSafariViewController class]]) {
            [self presentViewController:self.contextViewController animated:YES completion:^{}];
        } else {
            if (self.splitViewController != nil) {
                [self.splitViewController showDetailViewController:self.contextViewController sender:self];
            } else {
                [self.navigationController pushViewController:self.contextViewController animated:YES];
            }
        }
    }];
}

@end
