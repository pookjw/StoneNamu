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
#import "CardDetailsChildrenContentCollectionViewItem.h"
#import "CardDetailsCollectionViewLayout.h"
#import "NSViewController+SpinnerView.h"
#import "HSCardDraggableImageView.h"

@interface CardDetailsViewController () <NSCollectionViewDelegate>
@property (retain) NSVisualEffectView *blurView;
@property (retain) NSStackView *stackView;
@property (retain) HSCardDraggableImageView *imageView;
@property (retain) NSScrollView *scrollView;
@property (retain) NSClipView *clipView;
@property (retain) NSCollectionView *collectionView;
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
    [_clipView release];
    [_collectionView release];
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
    [self configureViewModel];
    [self bind];
    [self.viewModel requestDataSourceWithCard:self.hsCard];
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
    HSCardDraggableImageView *imageView = [[HSCardDraggableImageView alloc] initWithHSCard:self.hsCard];
    self.imageView = imageView;
    [imageView setAsyncImageWithURL:self.hsCard.image indicator:YES];
    
    [self.stackView addArrangedSubview:imageView];
    [imageView release];
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
    clipView.postsBoundsChangedNotifications = YES;

    [self.stackView addArrangedSubview:scrollView];

    CardDetailsCollectionViewLayout *layout = [CardDetailsCollectionViewLayout new];
    collectionView.collectionViewLayout = layout;
    [layout release];

    NSNib *baseNib = [[NSNib alloc] initWithNibNamed:NSStringFromClass([CardDetailsBaseCollectionViewItem class]) bundle:NSBundle.mainBundle];
    [collectionView registerNib:baseNib forItemWithIdentifier:NSStringFromClass([CardDetailsBaseCollectionViewItem class])];
    [baseNib release];
    
    NSNib *childrenContentNib = [[NSNib alloc] initWithNibNamed:NSStringFromClass([CardDetailsChildrenContentCollectionViewItem class]) bundle:NSBundle.mainBundle];
    [collectionView registerNib:childrenContentNib forItemWithIdentifier:NSStringFromClass([CardDetailsChildrenContentCollectionViewItem class])];
    [childrenContentNib release];
    
    collectionView.postsBoundsChangedNotifications = YES;
    collectionView.selectable = YES;
    collectionView.allowsMultipleSelection = NO;
    collectionView.allowsEmptySelection = NO;
    collectionView.delegate = self;
    collectionView.backgroundColors = @[NSColor.clearColor];
    
    [scrollView release];
    [clipView release];
    [collectionView release];
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
            case CardDetailsItemModelTypeChildren: {
                CardDetailsChildrenContentCollectionViewItem *item = (CardDetailsChildrenContentCollectionViewItem *)[collectionView makeItemWithIdentifier:NSStringFromClass([CardDetailsChildrenContentCollectionViewItem class]) forIndexPath:indexPath];
                
                [item configureWithChildCards:itemModel.childCards];
                
                return item;
            }
            default: {
                CardDetailsBaseCollectionViewItem *item = (CardDetailsBaseCollectionViewItem *)[collectionView makeItemWithIdentifier:NSStringFromClass([CardDetailsBaseCollectionViewItem class]) forIndexPath:indexPath];
                
                [item configureWithLeadingText:itemModel.primaryText trailingText:itemModel.secondaryText];
                
                return item;
            }
        }
    }];
    
    return [dataSource autorelease];
}

#pragma mark - NSCollectionViewDelegate

@end
