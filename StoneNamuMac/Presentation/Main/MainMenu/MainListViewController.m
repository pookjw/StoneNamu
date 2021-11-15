//
//  MainListViewController.m
//  MainListViewController
//
//  Created by Jinwoo Kim on 9/26/21.
//

#import "MainListViewController.h"
#import "MainListCollectionViewLayout.h"
#import "MainListCollectionViewCell.h"
#import "MainListViewModel.h"

@interface MainListViewController () <NSCollectionViewDelegate>
@property (retain) NSScrollView *scrollView;
@property (retain) NSClipView *clipView;
@property (retain) NSCollectionView *collectionView;
@property (retain) MainListViewModel *viewModel;
@end

@implementation MainListViewController

- (void)dealloc {
    [_scrollView release];
    [_clipView release];
    [_collectionView release];
    [_viewModel release];
    [super dealloc];
}

- (void)loadView {
    NSView *view = [NSView new];
    self.view = view;
    [view release];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setAttributes];
    [self configureCollectionView];
    [self configureViewModel];
    [self.viewModel request];
}

- (void)setAttributes {
    NSLayoutConstraint *widthLayout = [self.view.widthAnchor constraintGreaterThanOrEqualToConstant:300];
    [NSLayoutConstraint activateConstraints:@[
        widthLayout
    ]];
}

- (void)configureCollectionView {
    NSScrollView *scrollView = [NSScrollView new];
    NSClipView *clipView = [NSClipView new];
    NSCollectionView *collectionView = [NSCollectionView new];
    
    self.scrollView = scrollView;
    self.clipView = clipView;
    self.collectionView = collectionView;
    
    scrollView.backgroundColor = NSColor.clearColor;
    scrollView.contentView = clipView;
    clipView.documentView = collectionView;
    clipView.postsBoundsChangedNotifications = YES;

    [self.view addSubview:scrollView];
    scrollView.translatesAutoresizingMaskIntoConstraints = NO;
    [NSLayoutConstraint activateConstraints:@[
        [scrollView.topAnchor constraintEqualToAnchor:self.view.topAnchor],
        [scrollView.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor],
        [scrollView.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor],
        [scrollView.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor]
    ]];
    
    MainListCollectionViewLayout *layout = [MainListCollectionViewLayout new];
    collectionView.collectionViewLayout = layout;
    [layout release];
    
    NSNib *nib = [[NSNib alloc] initWithNibNamed:NSStringFromClass([MainListCollectionViewCell class]) bundle:NSBundle.mainBundle];
    [collectionView registerNib:nib forItemWithIdentifier:NSStringFromClass([MainListCollectionViewCell class])];
    [nib release];
    
    collectionView.selectable = YES;
    collectionView.allowsEmptySelection = NO;
    collectionView.delegate = self;
    collectionView.backgroundColors = @[NSColor.clearColor];
    
    [scrollView release];
    [clipView release];
    [collectionView release];
}

- (void)configureViewModel {
    MainListViewModel *viewModel = [[MainListViewModel alloc] initWithDataSource:[self makeDataSource]];
    self.viewModel = viewModel;
    [viewModel release];
}

- (MainListDataSource *)makeDataSource {
    MainListDataSource *dataSource = [[MainListDataSource alloc] initWithCollectionView:self.collectionView itemProvider:^NSCollectionViewItem * _Nullable(NSCollectionView * _Nonnull collectionView, NSIndexPath * _Nonnull indexPath, MainListItemModel * _Nonnull itemModel) {
        
        MainListCollectionViewCell *cell = (MainListCollectionViewCell *)[collectionView makeItemWithIdentifier:NSStringFromClass([MainListCollectionViewCell class]) forIndexPath:indexPath];
        
        cell.imageView.image = itemModel.image;
        cell.textField.stringValue = itemModel.primaryText;
        
        return cell;
    }];
    
    return [dataSource autorelease];
}

#pragma mark - NSCollectionViewDelegate

- (void)collectionView:(NSCollectionView *)collectionView didSelectItemsAtIndexPaths:(NSSet<NSIndexPath *> *)indexPaths {
    NSLog(@"%@", indexPaths);
}

@end
