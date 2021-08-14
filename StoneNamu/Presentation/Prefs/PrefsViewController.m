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
#import "PrefsRegionViewController.h"
#import "UIViewController+animatedForSelectedIndexPath.h"

@interface PrefsViewController () <UICollectionViewDelegate>
@property (retain) UICollectionView *collectionView;
@property (retain) PrefsViewModel *viewModel;
@property (retain) UICollectionViewSupplementaryRegistration *headerCellRegistration;
@property (retain) UICollectionViewSupplementaryRegistration *footerCellRegistration;
@end

@implementation PrefsViewController

- (void)dealloc {
    [_collectionView release];
    [_viewModel release];
    [_headerCellRegistration release];
    [_footerCellRegistration release];
    [super dealloc];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setAttributes];
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

- (void)configureNavigation {
    self.title = NSLocalizedString(@"PREFERENCES", @"");
}

- (void)configureCollectionView {
    UICollectionLayoutListConfiguration *layoutConfiguration = [[UICollectionLayoutListConfiguration alloc] initWithAppearance:UICollectionLayoutListAppearanceInsetGrouped];
    layoutConfiguration.headerMode = UICollectionLayoutListHeaderModeSupplementary;
    layoutConfiguration.footerMode = UICollectionLayoutListFooterModeSupplementary;
    
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
    
    self.headerCellRegistration = [self makeHeaderCellRegistration];
    self.footerCellRegistration = [self makeFooterCellRegistration];
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
        configuration.secondaryText = itemModel.secondaryText;
        configuration.imageProperties.maximumSize = CGSizeMake(50, 50);
        configuration.imageProperties.cornerRadius = 25;
        cell.contentConfiguration = configuration;
        
        //
        
        NSMutableArray<UICellAccessory *> *accessories = [@[] mutableCopy];
        
        if (itemModel.hasDisclosure) {
            [accessories addObject:[[UICellAccessoryDisclosureIndicator new] autorelease]];
        }
        
        if (itemModel.accessoryText) {
            [accessories addObject:[[[UICellAccessoryLabel alloc] initWithText:itemModel.accessoryText] autorelease]];
        }
        
        NSArray<UICellAccessory *> *results = [accessories copy];
        [accessories release];
        cell.accessories = results;
        
        [results release];
    }];
    
    return cellRegistration;
}

- (UICollectionViewDiffableDataSourceSupplementaryViewProvider)makeSupplementaryViewProvider {
    UICollectionViewDiffableDataSourceSupplementaryViewProvider provider = ^UICollectionReusableView * _Nullable(UICollectionView * _Nonnull collectionView, NSString * _Nonnull elementKind, NSIndexPath * _Nonnull indexPath) {
        
        if ([elementKind isEqualToString:UICollectionElementKindSectionHeader]) {
            return [collectionView dequeueConfiguredReusableSupplementaryViewWithRegistration:self.headerCellRegistration forIndexPath:indexPath];
        } else if ([elementKind isEqualToString:UICollectionElementKindSectionFooter]) {
            return [collectionView dequeueConfiguredReusableSupplementaryViewWithRegistration:self.footerCellRegistration forIndexPath:indexPath];
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
        
        NSString * _Nullable text = [self.viewModel headerTextFromIndexPath:indexPath];
        
        UIListContentConfiguration *configuration = [UIListContentConfiguration groupedHeaderConfiguration];
        configuration.text = text;
        
        supplementaryView.contentConfiguration = configuration;
    }];
    
    return registration;
}

- (UICollectionViewSupplementaryRegistration *)makeFooterCellRegistration {
    UICollectionViewSupplementaryRegistration *registration = [UICollectionViewSupplementaryRegistration registrationWithSupplementaryClass:[UICollectionViewListCell class]
                                                                                                                                elementKind:UICollectionElementKindSectionFooter
                                                                                                                       configurationHandler:^(__kindof UICollectionViewListCell * _Nonnull supplementaryView, NSString * _Nonnull elementKind, NSIndexPath * _Nonnull indexPath) {
        
        NSString * _Nullable text = [self.viewModel footerTextFromIndexPath:indexPath];
        
        UIListContentConfiguration *configuration = [UIListContentConfiguration groupedFooterConfiguration];
        configuration.text = text;
        
        supplementaryView.contentConfiguration = configuration;
    }];
    
    return registration;
}

- (void)pushToLocaleViewController {
    PrefsLocaleViewController *vc = [PrefsLocaleViewController new];
    [self.navigationController pushViewController:vc animated:YES];
    [vc release];
}

- (void)pushToRegionViewController {
    PrefsRegionViewController *vc = [PrefsRegionViewController new];
    [self.navigationController pushViewController:vc animated:YES];
    [vc release];
}

- (void)presentWebViewControllerWithURL:(NSURL *)url {
    SFSafariViewController *vc = [[SFSafariViewController alloc] initWithURL:url];
    [self presentViewController:vc animated:YES completion:^{}];
    [vc release];
}

- (void)presentPnamuActionSheetFromView:(UIView *)view {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"PNAMU", @"")
                                                                   message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"CANCEL", @"")
                                                           style:UIAlertActionStyleCancel
                                                         handler:^(UIAlertAction * _Nonnull action) {}];
    
    UIAlertAction *twitterAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"TWITTER", @"")
                                                            style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction * _Nonnull action) {
        NSURL *url = [NSURL URLWithString:PnamuTwitter];
        [UIApplication.sharedApplication openURL:url options:@{} completionHandler:^(BOOL success) {}];
    }];
    
    UIAlertAction *twitchAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"TWITCH", @"")
                                                           style:UIAlertActionStyleDefault
                                                         handler:^(UIAlertAction * _Nonnull action) {
        NSURL *url = [NSURL URLWithString:PnamuTwitch];
        [UIApplication.sharedApplication openURL:url options:@{} completionHandler:^(BOOL success) {}];
    }];
    
    UIAlertAction *youTubeAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"YOUTUBE", @"")
                                                            style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction * _Nonnull action) {
        NSURL *url = [NSURL URLWithString:PnamuYouTube];
        [UIApplication.sharedApplication openURL:url options:@{} completionHandler:^(BOOL success) {}];
    }];
    
    [alert addAction:cancelAction];
    [alert addAction:twitterAction];
    [alert addAction:twitchAction];
    [alert addAction:youTubeAction];
    
    //
    
    UIPopoverPresentationController *pc = [alert popoverPresentationController];
    pc.sourceView = view;
    [self presentViewController:alert animated:YES completion:^{}];
}

#pragma mark UICollectionViewDelegate

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
            [self pushToRegionViewController];
            break;
        case PrefsItemModelTypeJinwooKimContributor:
            [self presentWebViewControllerWithURL:[NSURL URLWithString:PookjwGitHub]];
            break;
        case PrefsItemModelTypePnamuContributor: {
            UICollectionViewCell * _Nullable cell = [collectionView cellForItemAtIndexPath:indexPath];
            if (cell) {
                [self presentPnamuActionSheetFromView:cell];
            }
            [collectionView deselectItemAtIndexPath:indexPath animated:YES];
            break;
        }
        default:
            [collectionView deselectItemAtIndexPath:indexPath animated:YES];
            break;
    }
}

@end
