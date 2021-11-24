//
//  DecksViewController.m
//  StoneNamuMac
//
//  Created by Jinwoo Kim on 11/17/21.
//

#import "DecksViewController.h"
#import "DeckBaseCollectionViewItem.h"
#import "DecksViewModel.h"
#import "DecksCollectionViewLayout.h"

@interface DecksViewController () <NSCollectionViewDelegate>
@property (retain) NSScrollView *scrollView;
@property (retain) NSClipView *clipView;
@property (retain) NSCollectionView *collectionView;
@property (retain) DecksViewModel *viewModel;
@end

@implementation DecksViewController

- (void)dealloc {
    [self removeObserver:self forKeyPath:@"self.view.window"];
    [_scrollView release];
    [_clipView release];
    [_collectionView release];
    [_viewModel release];
    [super dealloc];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if (([object isEqual:self]) && ([keyPath isEqualToString:@"self.view.window"])) {
        if (self.view.window != nil) {
            [NSOperationQueue.mainQueue addOperationWithBlock:^{
//                [self setCardsMenuToWindow];
//                [self setCardOptionsToolbarToWindow];
//                [self setCardOptionsTouchBarToWindow];
                NSApp.menu = nil;
                self.view.window.toolbar = nil;
                self.view.window.touchBar = nil;
            }];
        }
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
    [self configureCollectionView];
    [self configureViewModel];
    [self bind];
}

- (void)setAttributes {
    
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

    [self.view addSubview:scrollView];
    scrollView.translatesAutoresizingMaskIntoConstraints = NO;
    [NSLayoutConstraint activateConstraints:@[
        [scrollView.topAnchor constraintEqualToAnchor:self.view.topAnchor],
        [scrollView.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor],
        [scrollView.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor],
        [scrollView.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor]
    ]];
    
    DecksCollectionViewLayout *layout = [DecksCollectionViewLayout new];
    collectionView.collectionViewLayout = layout;
    [layout release];
    
    NSNib *nib = [[NSNib alloc] initWithNibNamed:NSStringFromClass([DeckBaseCollectionViewItem class]) bundle:NSBundle.mainBundle];
    [collectionView registerNib:nib forItemWithIdentifier:NSStringFromClass([DeckBaseCollectionViewItem class])];
    [nib release];
    
    collectionView.selectable = YES;
    collectionView.allowsMultipleSelection = NO;
    collectionView.allowsEmptySelection = NO;
    collectionView.delegate = self;
    
    [scrollView release];
    [clipView release];
    [collectionView release];
}

- (void)configureViewModel {
    DecksViewModel *viewModel = [[DecksViewModel alloc] initWithDataSource:[self makeDataSource]];
    self.viewModel = viewModel;
    [viewModel autorelease];
}

- (void)bind {
    [self addObserver:self forKeyPath:@"self.view.window" options:NSKeyValueObservingOptionInitial | NSKeyValueObservingOptionNew context:nil];
}

- (DecksDataSource *)makeDataSource {
    DecksDataSource *dataSource = [[DecksDataSource alloc] initWithCollectionView:self.collectionView itemProvider:^NSCollectionViewItem * _Nullable(NSCollectionView * _Nonnull collectionView, NSIndexPath * _Nonnull indexPath, DecksItemModel * _Nonnull itemModel) {
        DeckBaseCollectionViewItem *item = [collectionView makeItemWithIdentifier:NSStringFromClass([DeckBaseCollectionViewItem class]) forIndexPath:indexPath];
        
        [item configureWithText:itemModel.localDeck.name];
        
        return item;
    }];
    
    return [dataSource autorelease];
}

@end
