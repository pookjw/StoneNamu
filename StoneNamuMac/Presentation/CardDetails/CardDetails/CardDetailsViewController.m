//
//  CardDetailsViewController.m
//  StoneNamuMac
//
//  Created by Jinwoo Kim on 11/19/21.
//

#import "CardDetailsViewController.h"
#import "CardDetailsViewModel.h"
#import "NSTextField+setLabelStyle.h"
#import "NSImageView+setAsyncImage.h"
#import "CardDetailsBaseCollectionViewItem.h"
#import "CardDetailsChildCollectionViewItem.h"
#import "CardDetailsCollectionViewLayout.h"
#import "NSViewController+SpinnerView.h"
#import "HSCardSavableImageView.h"
#import "HSCardPromiseProvider.h"
#import "HSCardSaveImageService.h"
#import "ClickableCollectionView.h"
#import "AppDelegate.h"
#import <StoneNamuResources/StoneNamuResources.h>

static NSUserInterfaceItemIdentifier const NSUserInterfaceItemIdentifierCardDetailsBaseCollectionViewItem = @"NSUserInterfaceItemIdentifierCardDetailsBaseCollectionViewItem";
static NSUserInterfaceItemIdentifier const NSUserInterfaceItemIdentifierCardDetailsChildCollectionViewItem = @"NSUserInterfaceItemIdentifierCardDetailsChildCollectionViewItem";

@interface CardDetailsViewController () <NSCollectionViewDelegate, NSMenuDelegate, CardDetailsChildCollectionViewItemDelegate>
@property (retain) NSVisualEffectView *blurView;
@property (retain) NSStackView *stackView;
@property (retain) HSCardSavableImageView *imageView;
@property (retain) NSScrollView *scrollView;
@property (retain) ClickableCollectionView *collectionView;
@property (retain) NSMenu *collectionViewMenu;
@property (retain) CardDetailsViewModel *viewModel;
@end

@implementation CardDetailsViewController

- (instancetype)initWithHSCard:(HSCard *)hsCard {
    self = [self init];
    
    if (self) {
        [self->_hsCard release];
        self->_hsCard = [hsCard copy];
    }
    
    return self;
}

- (void)dealloc {
    [self removeObserver:self forKeyPath:@"self.view.window"];
    [_hsCard release];
    [_blurView release];
    [_stackView release];
    [_imageView release];
    [_scrollView release];
    [_collectionView release];
    [_collectionViewMenu release];
    [_viewModel release];
    [super dealloc];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if (([object isEqual:self]) && ([keyPath isEqualToString:@"self.view.window"])) {
        [NSOperationQueue.mainQueue addOperationWithBlock:^{
            self.view.window.title = self.hsCard.name;
        }];
    } else {
        return [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

- (void)loadView {
    NSView *view = [NSView new];
    self.view = view;
    [view release];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setAttributes];
    [self configureBlurView];
    [self configureStackView];
    [self configureImageView];
    [self configureCollectionView];
    [self configureCollectionViewMenu];
    [self configureViewModel];
    [self bind];
    [self.viewModel requestDataSourceWithCard:self.hsCard];
    
    NSLog(@"keyword: %@", self.hsCard.slug);
}

- (void)setAttributes {
    NSLayoutConstraint *widthLayout = [self.view.widthAnchor constraintGreaterThanOrEqualToConstant:800];
    NSLayoutConstraint *heightLayout = [self.view.heightAnchor constraintGreaterThanOrEqualToConstant:600];
    
    [NSLayoutConstraint activateConstraints:@[
        widthLayout,
        heightLayout
    ]];
}

- (void)configureBlurView {
    NSVisualEffectView *blurView = [NSVisualEffectView new];
    self.blurView = blurView;
    
    blurView.blendingMode = NSVisualEffectBlendingModeBehindWindow;
    blurView.translatesAutoresizingMaskIntoConstraints = NO;
    
    [self.view addSubview:blurView];
    [NSLayoutConstraint activateConstraints:@[
        [blurView.topAnchor constraintEqualToAnchor:self.view.topAnchor],
        [blurView.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor],
        [blurView.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor],
        [blurView.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor]
    ]];
    
    [blurView release];
}

- (void)configureStackView {
    NSStackView *stackView = [NSStackView new];
    self.stackView = stackView;
    
    [self.blurView addSubview:stackView];
    stackView.translatesAutoresizingMaskIntoConstraints = NO;
    [NSLayoutConstraint activateConstraints:@[
        [stackView.topAnchor constraintEqualToAnchor:self.blurView.safeAreaLayoutGuide.topAnchor],
        [stackView.leadingAnchor constraintEqualToAnchor:self.blurView.safeAreaLayoutGuide.leadingAnchor],
        [stackView.trailingAnchor constraintEqualToAnchor:self.blurView.safeAreaLayoutGuide.trailingAnchor],
        [stackView.bottomAnchor constraintEqualToAnchor:self.blurView.safeAreaLayoutGuide.bottomAnchor]
    ]];
    
    [stackView release];
}

- (void)configureImageView {
    HSCardSavableImageView *imageView = [[HSCardSavableImageView alloc] initWithHSCard:self.hsCard];
    self.imageView = imageView;
    [imageView setAsyncImageWithURL:self.hsCard.image indicator:YES];
    
    [self.stackView addArrangedSubview:imageView];
    [imageView release];
}

- (void)configureCollectionView {
    NSScrollView *scrollView = [NSScrollView new];
    ClickableCollectionView *collectionView = [ClickableCollectionView new];
    
    self.scrollView = scrollView;
    self.collectionView = collectionView;
    
    scrollView.documentView = collectionView;

    [self.stackView addArrangedSubview:scrollView];

    CardDetailsCollectionViewLayout *layout = [CardDetailsCollectionViewLayout new];
    collectionView.collectionViewLayout = layout;
    [layout release];

    NSNib *baseNib = [[NSNib alloc] initWithNibNamed:NSStringFromClass([CardDetailsBaseCollectionViewItem class]) bundle:NSBundle.mainBundle];
    [collectionView registerNib:baseNib forItemWithIdentifier:NSUserInterfaceItemIdentifierCardDetailsBaseCollectionViewItem];
    [baseNib release];
    
    NSNib *childNib = [[NSNib alloc] initWithNibNamed:NSStringFromClass([CardDetailsChildCollectionViewItem class]) bundle:NSBundle.mainBundle];
    [collectionView registerNib:childNib forItemWithIdentifier:NSUserInterfaceItemIdentifierCardDetailsChildCollectionViewItem];
    [childNib release];
    
    collectionView.postsBoundsChangedNotifications = NO;
    collectionView.selectable = YES;
    collectionView.allowsMultipleSelection = YES;
    collectionView.allowsEmptySelection = NO;
    collectionView.delegate = self;
    collectionView.backgroundColors = @[NSColor.clearColor];
    
    [collectionView registerForDraggedTypes:HSCardPromiseProvider.pasteboardTypes];
    [collectionView setDraggingSourceOperationMask:NSDragOperationCopy forLocal:NO];
    
    [scrollView release];
    [collectionView release];
}

- (void)configureCollectionViewMenu {
    NSMenu *collectionViewMenu = [NSMenu new];
    
    collectionViewMenu.delegate = self;
    
    self.collectionViewMenu = collectionViewMenu;
    self.collectionView.menu = collectionViewMenu;
    
    [collectionViewMenu release];
}

- (void)configureViewModel {
    CardDetailsViewModel *viewModel = [[CardDetailsViewModel alloc] initWithDataSource:[self makeDataSource]];
    self.viewModel = viewModel;
    [viewModel release];
}

- (void)bind {
    [self addObserver:self forKeyPath:@"self.view.window" options:NSKeyValueObservingOptionInitial | NSKeyValueObservingOptionNew context:nil];
    
    [NSNotificationCenter.defaultCenter addObserver:self
                                           selector:@selector(endedLoadingDataSourceReceived:)
                                               name:NSNotificationNameCardDetailsViewModelEndedLoadingDataSource
                                             object:self.viewModel];
    
    [NSNotificationCenter.defaultCenter addObserver:self
                                           selector:@selector(startFetchingChildCardsReceived:)
                                               name:NSNotificationNameCardDetailsViewModelStartedFetchingChildCards
                                             object:self.viewModel];
    
    [NSNotificationCenter.defaultCenter addObserver:self
                                           selector:@selector(endedChildCardsReceived:)
                                               name:NSNotificationNameCardDetailsViewModelEndedFetchingChildCards
                                             object:self.viewModel];
}

- (void)endedLoadingDataSourceReceived:(NSNotification *)notification {
    [NSOperationQueue.mainQueue addOperationWithBlock:^{
        [self.collectionView.collectionViewLayout invalidateLayout];
    }];
}

- (void)startFetchingChildCardsReceived:(NSNotification *)notification {
    [NSOperationQueue.mainQueue addOperationWithBlock:^{
        [self addSpinnerView];
    }];
}

- (void)endedChildCardsReceived:(NSNotification *)notification {
    [NSOperationQueue.mainQueue addOperationWithBlock:^{
        [self removeAllSpinnerview];
    }];
}

- (CardDetailsDataSource *)makeDataSource {
    CardDetailsDataSource *dataSource = [[CardDetailsDataSource alloc] initWithCollectionView:self.collectionView itemProvider:^NSCollectionViewItem * _Nullable(NSCollectionView * _Nonnull collectionView, NSIndexPath * _Nonnull indexPath, CardDetailsItemModel * _Nonnull itemModel) {
        
        switch (itemModel.type) {
            case CardDetailsItemModelTypeChild: {
                CardDetailsChildCollectionViewItem *item = (CardDetailsChildCollectionViewItem *)[collectionView makeItemWithIdentifier:NSUserInterfaceItemIdentifierCardDetailsChildCollectionViewItem forIndexPath:indexPath];
                
                [item configureWithHSCard:itemModel.childHSCard delegate:self];
                
                return item;
            }
            default: {
                CardDetailsBaseCollectionViewItem *item = (CardDetailsBaseCollectionViewItem *)[collectionView makeItemWithIdentifier:NSUserInterfaceItemIdentifierCardDetailsBaseCollectionViewItem forIndexPath:indexPath];
                
                [item configureWithLeadingText:itemModel.primaryText trailingText:itemModel.secondaryText];
                
                return item;
            }
        }
    }];
    
    return [dataSource autorelease];
}

- (void)saveImageItemTriggered:(NSMenuItem *)sender {
    NSSet<NSIndexPath *> *interactingIndexPaths = self.collectionView.interactingIndexPaths;
    
    [self.viewModel hsCardsFromIndexPaths:interactingIndexPaths completion:^(NSSet<HSCard *> * _Nonnull hsCards) {
        [NSOperationQueue.mainQueue addOperationWithBlock:^{
            HSCardSaveImageService *service = [[HSCardSaveImageService alloc] initWithHSCards:hsCards];
            
            [service beginSheetModalForWindow:self.view.window completion:^(BOOL success, NSError * _Nullable error) {
                
            }];
            
            [service release];
        }];
    }];
}

#pragma mark - NSCollectionViewDelegate

- (NSSet<NSIndexPath *> *)collectionView:(NSCollectionView *)collectionView shouldSelectItemsAtIndexPaths:(NSSet<NSIndexPath *> *)indexPaths {
    NSMutableSet<NSIndexPath *> *mutableIndexPaths = [indexPaths mutableCopy];
    
    [mutableIndexPaths enumerateObjectsUsingBlock:^(NSIndexPath * _Nonnull obj, BOOL * _Nonnull stop) {
        HSCard * _Nullable hsCard = [self.viewModel.dataSource itemIdentifierForIndexPath:obj].childHSCard;
        
        if (hsCard == nil) {
            [mutableIndexPaths removeObject:obj];
        }
    }];
    
    return [mutableIndexPaths autorelease];
}

- (BOOL)collectionView:(NSCollectionView *)collectionView canDragItemsAtIndexPaths:(NSSet<NSIndexPath *> *)indexPaths withEvent:(NSEvent *)event {
    BOOL result __block = NO;

    [indexPaths enumerateObjectsUsingBlock:^(NSIndexPath * _Nonnull obj, BOOL * _Nonnull stop) {
        HSCard * _Nullable hsCard = [self.viewModel.dataSource itemIdentifierForIndexPath:obj].childHSCard;

        if (hsCard != nil) {
            result = YES;
            *stop = YES;
            return;
        }
    }];

    return result;
}

- (id<NSPasteboardWriting>)collectionView:(NSCollectionView *)collectionView pasteboardWriterForItemAtIndexPath:(NSIndexPath *)indexPath {
    CardDetailsChildCollectionViewItem * _Nullable item = (CardDetailsChildCollectionViewItem *)[collectionView itemAtIndexPath:indexPath];
    
    if (item == nil) return nil;
    if (![item isKindOfClass:[CardDetailsChildCollectionViewItem class]]) return nil;
    
    HSCard * _Nullable hsCard = [self.viewModel.dataSource itemIdentifierForIndexPath:indexPath].childHSCard;
    
    if (hsCard == nil) return nil;
    
    HSCardPromiseProvider *provider = [[HSCardPromiseProvider alloc] initWithHSCard:hsCard image:item.imageView.image];
    
    return [provider autorelease];
}

#pragma mark - NSMenuDelegate

- (void)menuWillOpen:(NSMenu *)menu {
    if ([menu isEqual:self.collectionViewMenu]) {
        NSSet<NSIndexPath *> *interactingIndexPaths = self.collectionView.interactingIndexPaths;
        NSSet<HSCard *> *hsCards = [self.viewModel hsCardsFromIndexPaths:interactingIndexPaths];
        
        if (hsCards.count > 0) {
            NSMenuItem *saveImageItem = [[NSMenuItem alloc] initWithTitle:[ResourcesService localizationForKey:LocalizableKeySave]
                                                                   action:@selector(saveImageItemTriggered:)
                                                            keyEquivalent:@""];
            saveImageItem.image = [NSImage imageWithSystemSymbolName:@"square.and.arrow.down" accessibilityDescription:nil];
            saveImageItem.target = self;
            
            menu.itemArray = @[saveImageItem];
            
            [saveImageItem release];
        } else {
            menu.itemArray = @[];
        }
    }
}

#pragma mark - CardDetailsChildCollectionViewItemDelegate

- (void)cardDetailsChildrenContentImageContentCollectionViewItem:(CardDetailsChildCollectionViewItem *)cardDetailsChildrenContentImageContentCollectionViewItem didDoubleClickWithRecognizer:(NSClickGestureRecognizer *)recognizer {
    NSSet<NSIndexPath *> *selectionIndexPaths = self.collectionView.selectionIndexPaths;
    
    [self.viewModel hsCardsFromIndexPaths:selectionIndexPaths completion:^(NSSet<HSCard *> * _Nonnull hsCards) {
        [hsCards enumerateObjectsUsingBlock:^(HSCard * _Nonnull obj, BOOL * _Nonnull stop) {
            [NSOperationQueue.mainQueue addOperationWithBlock:^{
                [(AppDelegate *)NSApp.delegate presentCardDetailsWindowWithHSCard:obj];
            }];
        }];
    }];
}

@end
