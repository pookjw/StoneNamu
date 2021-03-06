//
//  CardDetailsViewController.m
//  StoneNamuMac
//
//  Created by Jinwoo Kim on 11/19/21.
//

#import "CardDetailsViewController.h"
#import "CardDetailsViewModel.h"
#import "NSWindow+presentErrorAlert.h"
#import "CardDetailsBaseCollectionViewItem.h"
#import "CardDetailsChildCollectionViewItem.h"
#import "CardDetailsCollectionViewLayout.h"
#import "NSViewController+SpinnerView.h"
#import "HSCardSavableImageView.h"
#import "HSCardPromiseProvider.h"
#import "PhotosService.h"
#import "ClickableCollectionView.h"
#import "WindowsService.h"
#import "NSViewController+loadViewIfNeeded.h"
#import "CardDetailsSeparatorBox.h"
#import <StoneNamuResources/StoneNamuResources.h>

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

- (instancetype)initWithHSCard:(HSCard *)hsCard hsGameModeSlugType:(HSCardGameModeSlugType)hsCardGameModeSlugType isGold:(BOOL)isGold {
    self = [self init];
    
    if (self) {
        [self loadViewIfNeeded];
        
        if (hsCard != nil) {
            [self requestWithHSCard:hsCard hsGameModeSlugType:hsCardGameModeSlugType isGold:isGold];
        }
    }
    
    return self;
}

- (void)dealloc {
    [self removeObserver:self forKeyPath:@"self.view.window"];
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
            if (self.viewModel.hsCard != nil) {
                self.view.window.title = self.viewModel.hsCard.name;
            }
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
}

- (void)encodeRestorableStateWithCoder:(NSCoder *)coder backgroundQueue:(NSOperationQueue *)queue {
    [super encodeRestorableStateWithCoder:coder backgroundQueue:queue];
    
    HSCard * _Nullable hsCard = self.viewModel.hsCard;
    HSCardGameModeSlugType _Nullable hsCardGameModeSlugType = self.viewModel.hsCardGameModeSlugType;
    BOOL isGold = self.viewModel.isGold;
    
    if (hsCard != nil) {
        [queue addOperationWithBlock:^{
            [coder encodeObject:hsCard forKey:[NSString stringWithFormat:@"%@_hsCard", NSStringFromClass(self.class)]];
            [coder encodeObject:hsCardGameModeSlugType forKey:[NSString stringWithFormat:@"%@_hsCardGameModeSlugType", NSStringFromClass(self.class)]];
            [coder encodeBool:isGold forKey:[NSString stringWithFormat:@"%@_isGold", NSStringFromClass(self.class)]];
        }];
    }
}

- (void)restoreStateWithCoder:(NSCoder *)coder {
    [super restoreStateWithCoder:coder];
    
    HSCard * _Nullable hsCard = [coder decodeObjectOfClass:[HSCard class] forKey:[NSString stringWithFormat:@"%@_hsCard", NSStringFromClass(self.class)]];
    HSCardGameModeSlugType _Nullable hsCardGameModeSlugType = [coder decodeObjectOfClass:[NSString class] forKey:[NSString stringWithFormat:@"%@_hsCardGameModeSlugType", NSStringFromClass(self.class)]];
    BOOL isGold = [coder decodeBoolForKey:[NSString stringWithFormat:@"%@_isGold", NSStringFromClass(self.class)]];
    
    if (hsCard != nil) {
        [self requestWithHSCard:hsCard hsGameModeSlugType:hsCardGameModeSlugType isGold:isGold];
    }
}

- (void)requestWithHSCard:(HSCard *)hsCard hsGameModeSlugType:(HSCardGameModeSlugType)hsCardGameModeSlugType isGold:(BOOL)isGold {
    self.view.window.title = hsCard.name;
    [self.imageView requestWithHSCard:hsCard hsGameModeSlugType:hsCardGameModeSlugType isGold:isGold];
    [self.viewModel requestDataSourceWithCard:hsCard hsGameModeSlugType:hsCardGameModeSlugType isGold:isGold];
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
    
    blurView.blendingMode = NSVisualEffectBlendingModeBehindWindow;
    blurView.translatesAutoresizingMaskIntoConstraints = NO;
    
    [self.view addSubview:blurView];
    [NSLayoutConstraint activateConstraints:@[
        [blurView.topAnchor constraintEqualToAnchor:self.view.topAnchor],
        [blurView.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor],
        [blurView.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor],
        [blurView.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor]
    ]];
    
    self.blurView = blurView;
    [blurView release];
}

- (void)configureStackView {
    NSStackView *stackView = [NSStackView new];
    
    [self.blurView addSubview:stackView];
    stackView.translatesAutoresizingMaskIntoConstraints = NO;
    [NSLayoutConstraint activateConstraints:@[
        [stackView.topAnchor constraintEqualToAnchor:self.blurView.safeAreaLayoutGuide.topAnchor],
        [stackView.leadingAnchor constraintEqualToAnchor:self.blurView.safeAreaLayoutGuide.leadingAnchor],
        [stackView.trailingAnchor constraintEqualToAnchor:self.blurView.safeAreaLayoutGuide.trailingAnchor],
        [stackView.bottomAnchor constraintEqualToAnchor:self.blurView.safeAreaLayoutGuide.bottomAnchor]
    ]];
    
    self.stackView = stackView;
    [stackView release];
}

- (void)configureImageView {
    HSCardSavableImageView *imageView = [HSCardSavableImageView new];
    [self.stackView addArrangedSubview:imageView];
    
    self.imageView = imageView;
    [imageView release];
}

- (void)configureCollectionView {
    NSScrollView *scrollView = [NSScrollView new];
    ClickableCollectionView *collectionView = [ClickableCollectionView new];

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
    
    NSNib *separatorNib = [[NSNib alloc] initWithNibNamed:NSStringFromClass([CardDetailsSeparatorBox class]) bundle:NSBundle.mainBundle];
    [collectionView registerNib:separatorNib forSupplementaryViewOfKind:NSStringFromClass([CardDetailsSeparatorBox class]) withIdentifier:NSUserInterfaceItemIdentifierCardDetailsSeparatorBox];
    [separatorNib release];
    
    collectionView.postsBoundsChangedNotifications = NO;
    collectionView.selectable = YES;
    collectionView.allowsMultipleSelection = YES;
    collectionView.allowsEmptySelection = NO;
    collectionView.delegate = self;
    collectionView.backgroundColors = @[NSColor.clearColor];
    
    [collectionView registerForDraggedTypes:HSCardPromiseProvider.pasteboardTypes];
    [collectionView setDraggingSourceOperationMask:NSDragOperationCopy forLocal:NO];
    
    scrollView.documentView = collectionView;
    
    self.scrollView = scrollView;
    self.collectionView = collectionView;
    
    [scrollView release];
    [collectionView release];
}

- (void)configureCollectionViewMenu {
    NSMenu *collectionViewMenu = [NSMenu new];
    
    collectionViewMenu.delegate = self;
    
    self.collectionView.menu = collectionViewMenu;
    self.collectionViewMenu = collectionViewMenu;
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
                                           selector:@selector(startedLoadingDataSourceReceived:)
                                               name:NSNotificationNameCardDetailsViewModelStartedLoadingDataSource
                                             object:self.viewModel];
    
    [NSNotificationCenter.defaultCenter addObserver:self
                                           selector:@selector(endedLoadingDataSourceReceived:)
                                               name:NSNotificationNameCardDetailsViewModelEndedLoadingDataSource
                                             object:self.viewModel];
}

- (void)startedLoadingDataSourceReceived:(NSNotification *)notification {
    [NSOperationQueue.mainQueue addOperationWithBlock:^{
        [self addSpinnerView];
    }];
}

- (void)endedLoadingDataSourceReceived:(NSNotification *)notification {
    [NSOperationQueue.mainQueue addOperationWithBlock:^{
        [self.collectionView.collectionViewLayout invalidateLayout];
        [self removeAllSpinnerview];
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
    CardDetailsViewController * __block unretainedSelf = self;
    
    CardDetailsDataSource *dataSource = [[CardDetailsDataSource alloc] initWithCollectionView:self.collectionView itemProvider:^NSCollectionViewItem * _Nullable(NSCollectionView * _Nonnull collectionView, NSIndexPath * _Nonnull indexPath, CardDetailsItemModel * _Nonnull itemModel) {
        
        switch (itemModel.type) {
            case CardDetailsItemModelTypeChild: {
                CardDetailsChildCollectionViewItem *item = (CardDetailsChildCollectionViewItem *)[collectionView makeItemWithIdentifier:NSUserInterfaceItemIdentifierCardDetailsChildCollectionViewItem forIndexPath:indexPath];
                
                [item configureWithHSCard:itemModel.childHSCard hsCardGameModeSlugType:itemModel.hsCardGameModeSlugType isGold:itemModel.isGold imageURL:itemModel.imageURL delegate:unretainedSelf];
                
                return item;
            }
            default: {
                CardDetailsBaseCollectionViewItem *item = (CardDetailsBaseCollectionViewItem *)[collectionView makeItemWithIdentifier:NSUserInterfaceItemIdentifierCardDetailsBaseCollectionViewItem forIndexPath:indexPath];
                
                [item configureWithLeadingText:itemModel.primaryText trailingText:itemModel.secondaryText];
                
                return item;
            }
        }
    }];
    
    dataSource.supplementaryViewProvider = ^NSView * _Nullable(NSCollectionView * _Nonnull collectionView, NSString * _Nonnull elementKind, NSIndexPath * _Nonnull indexPath) {
        if ([elementKind isEqualToString:NSStringFromClass([CardDetailsSeparatorBox class])]) {
            NSUInteger numberOfItems = [collectionView numberOfItemsInSection:indexPath.section];
            
            if (indexPath.item == (numberOfItems - 1)) {
                return nil;
            }
            
            CardDetailsSeparatorBox *view = (CardDetailsSeparatorBox *)[collectionView makeSupplementaryViewOfKind:elementKind withIdentifier:NSUserInterfaceItemIdentifierCardDetailsSeparatorBox forIndexPath:indexPath];
            return view;
        } else {
            return nil;
        }
    };
    
    return [dataSource autorelease];
}

- (void)saveImageItemTriggered:(NSMenuItem *)sender {
    NSSet<NSIndexPath *> *interactingIndexPaths = self.collectionView.interactingIndexPaths;
    
    [self.viewModel photoServiceModelsFromIndexPaths:interactingIndexPaths completion:^(NSSet<HSCard *> * _Nonnull hsCards, NSDictionary<HSCard *,HSCardGameModeSlugType> * _Nonnull hsCardGameModeSlugTypes, NSDictionary<HSCard *,NSNumber *> * _Nonnull isGolds) {
        [NSOperationQueue.mainQueue addOperationWithBlock:^{
            PhotosService *service = [[PhotosService alloc] initWithHSCards:hsCards hsGameModeSlugTypes:hsCardGameModeSlugTypes isGolds:isGolds];
            
            [service beginSheetModalForWindow:self.view.window completion:^(BOOL success, NSError * _Nullable error) {
                if (error != nil) {
                    [NSOperationQueue.mainQueue addOperationWithBlock:^{
                        [self.view.window presentErrorAlertWithError:error];
                    }];
                }
            }];
            
            [service release];
        }];
    }];
}

- (void)shareImageItemTriggered:(NSMenuItem *)sender {
    NSSet<NSIndexPath *> *interactingIndexPaths = self.collectionView.interactingIndexPaths;
    
    
    [self.viewModel photoServiceModelsFromIndexPaths:interactingIndexPaths completion:^(NSSet<HSCard *> * _Nonnull hsCards, NSDictionary<HSCard *,HSCardGameModeSlugType> * _Nonnull hsCardGameModeSlugTypes, NSDictionary<HSCard *,NSNumber *> * _Nonnull isGolds) {
        [NSOperationQueue.mainQueue addOperationWithBlock:^{
            NSView * _Nullable fromView = [self.collectionView itemAtIndexPath:interactingIndexPaths.allObjects.lastObject].view;
            if (fromView == nil) {
                fromView = self.view;
            }
            
            PhotosService *service = [[PhotosService alloc] initWithHSCards:hsCards hsGameModeSlugTypes:hsCardGameModeSlugTypes isGolds:isGolds];
            [service beginSharingServiceOfView:fromView];
            [service release];
        }];
    }];
}

#pragma mark - NSCollectionViewDelegate

- (NSSet<NSIndexPath *> *)collectionView:(NSCollectionView *)collectionView shouldSelectItemsAtIndexPaths:(NSSet<NSIndexPath *> *)indexPaths {
    NSMutableSet<NSIndexPath *> *mutableIndexPaths = [indexPaths mutableCopy];
    
    [indexPaths enumerateObjectsUsingBlock:^(NSIndexPath * _Nonnull obj, BOOL * _Nonnull stop) {
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
            
            NSMenuItem *shareImageItem = [[NSMenuItem alloc] initWithTitle:[ResourcesService localizationForKey:LocalizableKeyShare]
                                                                    action:@selector(shareImageItemTriggered:)
                                                             keyEquivalent:@""];
            shareImageItem.image = [NSImage imageWithSystemSymbolName:@"square.and.arrow.up" accessibilityDescription:nil];
            shareImageItem.target = self;
            
            menu.itemArray = @[saveImageItem, shareImageItem];
            
            [saveImageItem release];
        } else {
            menu.itemArray = @[];
        }
    }
}

#pragma mark - CardDetailsChildCollectionViewItemDelegate

- (void)cardDetailsChildrenContentImageContentCollectionViewItem:(CardDetailsChildCollectionViewItem *)cardDetailsChildrenContentImageContentCollectionViewItem didDoubleClickWithRecognizer:(NSClickGestureRecognizer *)recognizer {
    NSSet<NSIndexPath *> *selectionIndexPaths = self.collectionView.selectionIndexPaths;
    
    [self.viewModel itemModelsFromIndexPaths:selectionIndexPaths completion:^(NSSet<CardDetailsItemModel *> * _Nonnull itemModels) {
        [itemModels enumerateObjectsUsingBlock:^(CardDetailsItemModel * _Nonnull obj, BOOL * _Nonnull stop) {
            HSCard * _Nullable childHSCard = obj.childHSCard;
            
            if (childHSCard) {
                [NSOperationQueue.mainQueue addOperationWithBlock:^{
                    [WindowsService.sharedInstance presentCardDetailsWindowWithHSCard:childHSCard hsGameModeSlugType:obj.hsCardGameModeSlugType isGold:obj.isGold];
                }];
            }
        }];
    }];
}

@end
