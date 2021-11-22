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
#import "AppDelegate.h"

@interface CardDetailsChildrenContentCollectionViewItem () <NSCollectionViewDelegate, CardDetailsChildrenContentImageContentCollectionViewItemDelegate>
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
    
    innerCollectionView.postsBoundsChangedNotifications = NO;
    innerCollectionView.selectable = YES;
    innerCollectionView.allowsMultipleSelection = YES;
    innerCollectionView.allowsEmptySelection = YES;
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
        
        CardDetailsChildrenContentImageContentCollectionViewItem *item = [collectionView makeItemWithIdentifier:NSStringFromClass([CardDetailsChildrenContentImageContentCollectionViewItem class]) forIndexPath:indexPath];

        [item configureWithHSCard:itemModel.hsCard delegate:self];

        return item;
    }];
    
    return [dataSource autorelease];
}

#pragma mark - NSCollectionViewDelegate

#pragma mark - CardDetailsChildrenContentImageContentCollectionViewItemDelegate

- (void)cardDetailsChildrenContentImageContentCollectionViewItem:(CardDetailsChildrenContentImageContentCollectionViewItem *)cardDetailsChildrenContentImageContentCollectionViewItem didDoubleClickWithRecognizer:(NSClickGestureRecognizer *)recognizer {
    @autoreleasepool {
        NSArray<NSIndexPath *> *selectionIndexPaths = self.innerCollectionView.selectionIndexPaths.allObjects;
        
        [selectionIndexPaths enumerateObjectsUsingBlock:^(NSIndexPath * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            HSCard * _Nullable hsCard = [self.viewModel.dataSource itemIdentifierForIndexPath:obj].hsCard;
            
            if (hsCard == nil) return;
            
            [(AppDelegate *)NSApp.delegate presentCardDetailsWithHSCard:hsCard];
        }];
    }
}

@end
