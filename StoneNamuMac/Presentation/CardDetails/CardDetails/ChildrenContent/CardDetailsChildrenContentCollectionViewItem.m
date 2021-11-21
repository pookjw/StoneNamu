//
//  CardDetailsChildrenContentCollectionViewItem.m
//  StoneNamuMac
//
//  Created by Jinwoo Kim on 11/22/21.
//

#import "CardDetailsChildrenContentCollectionViewItem.h"
#import "CardDetailsChildrenContentCollectionViewItemModel.h"
#import "CardDetailsChildrenContentCollectionViewItemCollectionViewLayout.h"
#import "CardDetailsChildrenContentImageContentCollectionViewItem.h"

@interface CardDetailsChildrenContentCollectionViewItem () <NSCollectionViewDelegate>
@property (retain) NSScrollView *scrollView;
@property (retain) NSClipView *clipView;
@property (retain) NSCollectionView *innerCollectionView;
@property (retain) CardDetailsChildrenContentCollectionViewItemModel *viewModel;
@end

@implementation CardDetailsChildrenContentCollectionViewItem

- (void)dealloc {
    [_scrollView release];
    [_clipView release];
    [_innerCollectionView release];
    [_viewModel release];
    [super dealloc];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    [self configureInnerCollectionView];
    [self configureViewModel];
}

- (void)configureWithChildCards:(NSArray<HSCard *> *)childCards {
    [self.viewModel requestChildCards:childCards];
}

- (void)configureInnerCollectionView {
    NSScrollView *scrollView = [NSScrollView new];
    NSClipView *clipView = [NSClipView new];
    NSCollectionView *innerCollectionView = [NSCollectionView new];
    
    self.scrollView = scrollView;
    self.clipView = clipView;
    self.innerCollectionView = innerCollectionView;
    
    scrollView.contentView = clipView;
    clipView.documentView = innerCollectionView;
    clipView.postsBoundsChangedNotifications = YES;

    [self.view addSubview:scrollView];
    scrollView.translatesAutoresizingMaskIntoConstraints = NO;
    [NSLayoutConstraint activateConstraints:@[
        [scrollView.topAnchor constraintEqualToAnchor:self.view.topAnchor],
        [scrollView.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor],
        [scrollView.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor],
        [scrollView.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor]
    ]];

    CardDetailsChildrenContentCollectionViewItemCollectionViewLayout *layout = [CardDetailsChildrenContentCollectionViewItemCollectionViewLayout new];
    innerCollectionView.collectionViewLayout = layout;
    [layout release];

    NSNib *nib = [[NSNib alloc] initWithNibNamed:NSStringFromClass([CardDetailsChildrenContentImageContentCollectionViewItem class]) bundle:NSBundle.mainBundle];
    [innerCollectionView registerNib:nib forItemWithIdentifier:NSStringFromClass([CardDetailsChildrenContentImageContentCollectionViewItem class])];
    [nib release];
    
    innerCollectionView.postsBoundsChangedNotifications = YES;
    innerCollectionView.selectable = YES;
    innerCollectionView.allowsMultipleSelection = NO;
    innerCollectionView.allowsEmptySelection = NO;
    innerCollectionView.delegate = self;
    innerCollectionView.backgroundColors = @[NSColor.clearColor];
    
    [scrollView release];
    [clipView release];
    [innerCollectionView release];
}

- (void)configureViewModel {
    CardDetailsChildrenContentCollectionViewItemModel *viewModel = [[CardDetailsChildrenContentCollectionViewItemModel alloc] initWithDataSource:[self makeDataSource]];
    self.viewModel = viewModel;
    [viewModel release];
}

- (CardDetailsChildrenContentCollectionViewItemDataSource *)makeDataSource {
    CardDetailsChildrenContentCollectionViewItemDataSource *dataSource = [[CardDetailsChildrenContentCollectionViewItemDataSource alloc] initWithCollectionView:self.innerCollectionView itemProvider:^NSCollectionViewItem * _Nullable(NSCollectionView * _Nonnull collectionView, NSIndexPath * _Nonnull indexPath, CardDetailsChildrenContentCollectionViewItemItemModel * _Nonnull itemModel) {
        
        // using `collectionView` instead of `self.innerCollectionView` causes crashes when closing window. Why...?
        CardDetailsChildrenContentImageContentCollectionViewItem *item = [self.innerCollectionView makeItemWithIdentifier:NSStringFromClass([CardDetailsChildrenContentImageContentCollectionViewItem class]) forIndexPath:indexPath];

        [item configureWithHSCard:itemModel.hsCard];

        return item;
    }];
    
    return [dataSource autorelease];
}

#pragma mark - NSCollectionViewDelegate

@end
