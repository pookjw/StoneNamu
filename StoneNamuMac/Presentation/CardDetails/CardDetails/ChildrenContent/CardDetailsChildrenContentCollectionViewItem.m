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
#import "HSCardPromiseProvider.h"

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
    
    [innerCollectionView registerForDraggedTypes:HSCardPromiseProvider.pasteboardTypes];
    [innerCollectionView setDraggingSourceOperationMask:NSDragOperationCopy forLocal:NO];
    
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

- (BOOL)collectionView:(NSCollectionView *)collectionView canDragItemsAtIndexPaths:(NSSet<NSIndexPath *> *)indexPaths withEvent:(NSEvent *)event {
    BOOL result __block = YES;

    [indexPaths enumerateObjectsUsingBlock:^(NSIndexPath * _Nonnull obj, BOOL * _Nonnull stop) {
        CardDetailsChildrenContentCollectionViewItemItemModel * _Nullable itemModel = [self.viewModel.dataSource itemIdentifierForIndexPath:obj];

        if (itemModel == nil) {
            result = NO;
            *stop = YES;
            return;
        }
    }];

    return result;
}

- (id<NSPasteboardWriting>)collectionView:(NSCollectionView *)collectionView pasteboardWriterForItemAtIndexPath:(NSIndexPath *)indexPath {
    CardDetailsChildrenContentImageContentCollectionViewItem * _Nullable item = (CardDetailsChildrenContentImageContentCollectionViewItem *)[collectionView itemAtIndexPath:indexPath];
    
    if (item == nil) return nil;
    
    CardDetailsChildrenContentCollectionViewItemItemModel * _Nullable itemModel = [self.viewModel.dataSource itemIdentifierForIndexPath:indexPath];
    
    if (itemModel == nil) return nil;
    
    HSCardPromiseProvider *provider = [[HSCardPromiseProvider alloc] initWithHSCard:itemModel.hsCard image:item.imageView.image];
    
    return [provider autorelease];
}

#pragma mark - CardDetailsChildrenContentImageContentCollectionViewItemDelegate

- (void)cardDetailsChildrenContentImageContentCollectionViewItem:(CardDetailsChildrenContentImageContentCollectionViewItem *)cardDetailsChildrenContentImageContentCollectionViewItem didDoubleClickWithRecognizer:(NSClickGestureRecognizer *)recognizer {
    @autoreleasepool {
        NSArray<NSIndexPath *> *selectionIndexPaths = self.innerCollectionView.selectionIndexPaths.allObjects;
        
        [selectionIndexPaths enumerateObjectsUsingBlock:^(NSIndexPath * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            HSCard * _Nullable hsCard = [self.viewModel.dataSource itemIdentifierForIndexPath:obj].hsCard;
            
            if (hsCard == nil) return;
            
            [(AppDelegate *)NSApp.delegate presentCardDetailsWindowWithHSCard:hsCard];
        }];
    }
}

@end
