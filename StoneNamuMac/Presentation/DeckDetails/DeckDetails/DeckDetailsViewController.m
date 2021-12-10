//
//  DeckDetailsViewController.m
//  StoneNamuMac
//
//  Created by Jinwoo Kim on 11/28/21.
//

#import "DeckDetailsViewController.h"
#import "HSCardPromiseProvider.h"
#import <StoneNamuCore/StoneNamuCore.h>
#import <StoneNamuResources/StoneNamuResources.h>

@interface DeckDetailsViewController () <NSCollectionViewDelegate>
@property (retain) NSScrollView *scrollView;
@property (retain) NSClipView *clipView;
@property (retain) NSCollectionView *collectionView;
@end

@implementation DeckDetailsViewController

- (instancetype)initWithLocalDeck:(LocalDeck *)localDeck {
    self = [self init];
    
    if (self) {
        
    }
    
    return self;
}

- (void)dealloc {
    [_scrollView release];
    [_clipView release];
    [_collectionView release];
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
    
    scrollView.contentView = clipView;
    clipView.documentView = collectionView;
    clipView.postsBoundsChangedNotifications = NO;

    [self.view addSubview:scrollView];
    scrollView.translatesAutoresizingMaskIntoConstraints = NO;
    [NSLayoutConstraint activateConstraints:@[
        [scrollView.topAnchor constraintEqualToAnchor:self.view.topAnchor],
        [scrollView.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor],
        [scrollView.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor],
        [scrollView.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor]
    ]];
    
    NSCollectionViewFlowLayout *flowLayout = [NSCollectionViewFlowLayout new];
    flowLayout.itemSize = NSMakeSize(200, 270);
    flowLayout.minimumLineSpacing = 0.0f;
    collectionView.collectionViewLayout = flowLayout;
    [flowLayout release];
    
//    NSNib *nib = [[NSNib alloc] initWithNibNamed:NSStringFromClass([CardCollectionViewItem class]) bundle:NSBundle.mainBundle];
//    [collectionView registerNib:nib forItemWithIdentifier:NSUserInterfaceItemIdentifierCardCollectionViewItem];
//    [nib release];

    collectionView.selectable = YES;
    collectionView.allowsMultipleSelection = YES;
    collectionView.allowsEmptySelection = YES;
    collectionView.delegate = self;
    
    [collectionView registerForDraggedTypes:HSCardPromiseProvider.pasteboardTypes];
    [collectionView setDraggingSourceOperationMask:NSDragOperationCopy forLocal:NO];
    
    [scrollView release];
    [clipView release];
    [collectionView release];
}

#pragma mark - NSCollectionViewDelegate

- (NSDragOperation)collectionView:(NSCollectionView *)collectionView validateDrop:(id<NSDraggingInfo>)draggingInfo proposedIndexPath:(NSIndexPath * _Nonnull *)proposedDropIndexPath dropOperation:(NSCollectionViewDropOperation *)proposedDropOperation {
    return NSDragOperationCopy;
}

- (BOOL)collectionView:(NSCollectionView *)collectionView acceptDrop:(id<NSDraggingInfo>)draggingInfo indexPath:(NSIndexPath *)indexPath dropOperation:(NSCollectionViewDropOperation)dropOperation {
    
    NSPasteboard *pasteboard = draggingInfo.draggingPasteboard;
    NSArray<NSPasteboardItem *> *items = pasteboard.pasteboardItems;
    
    [items enumerateObjectsUsingBlock:^(NSPasteboardItem * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSData *data = [obj dataForType:NSPasteboardTypeHSCard];
        HSCard *hsCard = [NSKeyedUnarchiver unarchivedObjectOfClasses:HSCard.unarchvingClasses fromData:data error:nil];
        
        NSLog(@"result: %@", hsCard.name);
    }];
    
    return YES;
}

@end
