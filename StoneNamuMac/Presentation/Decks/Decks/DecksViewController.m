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
#import "DecksMenu.h"
#import "DecksToolbar.h"
#import "DecksTouchBar.h"
#import "NSWindow+presentErrorAlert.h"
#import "AppDelegate.h"
#import "NSViewController+SpinnerView.h"
#import "ClickableCollectionView.h"
#import <StoneNamuResources/StoneNamuResources.h>

@interface DecksViewController () <NSCollectionViewDelegate, DecksMenuDelegate, DecksToolbarDelegate, DecksTouchBarDelegate, DeckBaseCollectionViewItemDelegate>
@property (retain) NSScrollView *scrollView;
@property (retain) ClickableCollectionView *collectionView;
@property (retain) NSMenu *collectionViewMenu;
@property (assign) NSTextField *titleTextField;
@property (assign) NSTextField *deckCodeTextField;
@property (retain) DecksMenu *decksMenu;
@property (retain) DecksToolbar *decksToolbar;
@property (retain) DecksTouchBar *decksTouchBar;
@property (retain) DecksViewModel *viewModel;
@end

@implementation DecksViewController

- (void)dealloc {
    [self removeObserver:self forKeyPath:@"self.view.window"];
    [_scrollView release];
    [_collectionView release];
    [_collectionViewMenu release];
    [_decksMenu release];
    [_decksToolbar release];
    [_decksTouchBar release];
    [_viewModel release];
    [super dealloc];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if (([object isEqual:self]) && ([keyPath isEqualToString:@"self.view.window"])) {
        if (self.view.window != nil) {
            [NSOperationQueue.mainQueue addOperationWithBlock:^{
                [self setDecksMenuToWindow];
                [self setDecksToolbarToWindow];
                [self setDecksTouchBarToWindow];
            }];
        }
    } else {
        return [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

- (NSTouchBar *)makeTouchBar {
    return self.decksTouchBar;
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
    [self configureCollectionViewMenu];
    [self configureDecksMenu];
    [self configureDecksToolbar];
    [self configureDecksTouchBar];
    [self configureViewModel];
    [self bind];
}

- (void)setAttributes {
    NSLayoutConstraint *widthLayout = [self.view.widthAnchor constraintGreaterThanOrEqualToConstant:300];
    [NSLayoutConstraint activateConstraints:@[
        widthLayout
    ]];
}

- (void)configureCollectionView {
    NSScrollView *scrollView = [NSScrollView new];
    ClickableCollectionView *collectionView = [ClickableCollectionView new];
    
    self.scrollView = scrollView;
    self.collectionView = collectionView;
    
    scrollView.documentView = collectionView;

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
    [collectionView release];
}

- (void)configureCollectionViewMenu {
    NSMenu *collectionViewMenu = [NSMenu new];
    self.collectionViewMenu = collectionViewMenu;
    
    //
    
    NSMenuItem *deleteItem = [[NSMenuItem alloc] initWithTitle:[ResourcesService localizationForKey:LocalizableKeyDelete]
                                                        action:@selector(collectionViewMenuDeleteItemTriggered:)
                                                 keyEquivalent:@""];
    deleteItem.image = [NSImage imageWithSystemSymbolName:@"trash" accessibilityDescription:nil];
    deleteItem.target = self;
    
    collectionViewMenu.itemArray = @[deleteItem];
    
    [deleteItem release];
    
    //
    
    self.collectionView.menu = collectionViewMenu;
    [collectionViewMenu release];
}

- (void)collectionViewMenuDeleteItemTriggered:(NSMenuItem *)sender {
    [self.collectionView.interactingIndexPaths enumerateObjectsUsingBlock:^(NSIndexPath * _Nonnull obj, BOOL * _Nonnull stop) {
        [self.viewModel deleteLocalDeckFromIndexPath:obj];
    }];
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
    DecksViewController * __block unretainedSelf = self;
    
    DecksDataSource *dataSource = [[DecksDataSource alloc] initWithCollectionView:self.collectionView itemProvider:^NSCollectionViewItem * _Nullable(NSCollectionView * _Nonnull collectionView, NSIndexPath * _Nonnull indexPath, DecksItemModel * _Nonnull itemModel) {
        DeckBaseCollectionViewItem *item = [collectionView makeItemWithIdentifier:NSStringFromClass([DeckBaseCollectionViewItem class]) forIndexPath:indexPath];
        
        [item configureWithLocalDeck:itemModel.localDeck deckBaseCollectionViewItemDelegate:unretainedSelf];
        
        return item;
    }];
    
    return [dataSource autorelease];
}

- (void)configureDecksMenu {
    DecksMenu *decksMenu = [[DecksMenu alloc] initWithDecksMenuDelegate:self];
    self.decksMenu = decksMenu;
    [decksMenu release];
}

- (void)configureDecksToolbar {
    DecksToolbar *decksToolbar = [[DecksToolbar alloc] initWithIdentifier:NSToolbarIdentifierDecksToolbar decksToolbarDelegate:self];
    self.decksToolbar = decksToolbar;
    [decksToolbar release];
}

- (void)configureDecksTouchBar {
    DecksTouchBar *decksTouchBar = [[DecksTouchBar alloc] initWithDecksTouchBarDelegate:self];
    self.decksTouchBar = decksTouchBar;
    [decksTouchBar release];
}

- (void)setDecksMenuToWindow {
    NSApp.mainMenu = self.decksMenu;
}

- (void)clearDecksMenuFromWindow {
    self.view.window.menu = nil;
}

- (void)setDecksToolbarToWindow {
    self.view.window.toolbar = self.decksToolbar;
}

- (void)clearDecksToolbarFromWindow {
    self.view.window.toolbar = nil;
}

- (void)setDecksTouchBarToWindow {
    self.view.window.touchBar = self.decksTouchBar;
}

- (void)clearDecksTouchBarFromWindow {
    self.view.window.touchBar = nil;
}

- (void)presentDeckDetailsWithLocalDeck:(LocalDeck *)localDeck {
    [(AppDelegate *)NSApp.delegate presentDeckDetailsWindowWithLocalDeck:localDeck];
}

- (void)presentCreateNewDeckFromDeckCodeAlert {
    [self.viewModel parseClipboardForDeckCodeWithCompletion:^(NSString * _Nullable title, NSString * _Nullable deckCode) {
        
        [NSOperationQueue.mainQueue addOperationWithBlock:^{
            NSAlert *alert = [NSAlert new];
            NSButton *fetchButton = [alert addButtonWithTitle:[ResourcesService localizationForKey:LocalizableKeyFetch]];
            NSButton *cancelButton = [alert addButtonWithTitle:[ResourcesService localizationForKey:LocalizableKeyCancel]];
            NSTextField *titleTextField = [[NSTextField alloc] initWithFrame:NSMakeRect(0.0f, 0.0f, 300.0f, 20.0f)];
            NSTextField *deckCodeTextField = [[NSTextField alloc] initWithFrame:NSMakeRect(0.0f, 0.0f, 300.0f, 20.0f)];
            NSView *containerView = [[NSView alloc] initWithFrame:NSMakeRect(0.0f, 0.0f, 300.0f, 40.0f)];
            
            self.titleTextField = titleTextField;
            self.deckCodeTextField = deckCodeTextField;
            
            //
            
            fetchButton.target = self;
            fetchButton.action = @selector(createNewDeckFromDeckCodeAlertFetchButtonTriggered:);
            
            //
            
            titleTextField.placeholderString = [ResourcesService localizationForKey:LocalizableKeyEnterDeckTitleHere];
            deckCodeTextField.placeholderString = [ResourcesService localizationForKey:LocalizableKeyEnterDeckCodeHere];
            
            NSString *_title;
            NSString *_deckCode;
            
            if (title == nil) {
                _title = @"";
            } else {
                _title = title;
            }
            
            if ((deckCode == nil) || ([deckCode isEqualToString:@""])) {
#if DEBUG
                _deckCode = @"AAEBAa0GHuUE9xPDFoO7ArW7Are7Ati7AtHBAt/EAonNAvDPAujQApDTApeHA+aIA/yjA5mpA/KsA5GxA5O6A9fOA/vRA/bWA+LeA/vfA/jjA6iKBMGfBJegBKGgBAAA";
#else
                _deckCode = @"";
#endif
            } else {
                _deckCode = deckCode;
            }
            
            titleTextField.stringValue = _title;
            deckCodeTextField.stringValue = _deckCode;
            
            //
            
            [containerView addSubview:titleTextField];
            [containerView addSubview:deckCodeTextField];
            
            titleTextField.translatesAutoresizingMaskIntoConstraints = NO;
            deckCodeTextField.translatesAutoresizingMaskIntoConstraints = NO;
            
            [NSLayoutConstraint activateConstraints:@[
                [titleTextField.topAnchor constraintEqualToAnchor:containerView.topAnchor],
                [titleTextField.leadingAnchor constraintEqualToAnchor:containerView.leadingAnchor],
                [titleTextField.trailingAnchor constraintEqualToAnchor:containerView.trailingAnchor],
                [titleTextField.bottomAnchor constraintEqualToAnchor:deckCodeTextField.topAnchor],
                [deckCodeTextField.leadingAnchor constraintEqualToAnchor:containerView.leadingAnchor],
                [deckCodeTextField.trailingAnchor constraintEqualToAnchor:containerView.trailingAnchor],
                [deckCodeTextField.bottomAnchor constraintEqualToAnchor:containerView.bottomAnchor]
            ]];
            
            //
            
            alert.messageText = [ResourcesService localizationForKey:LocalizableKeyLoadFromDeckCode];
            alert.informativeText = [ResourcesService localizationForKey:LocalizableKeyPleaseEnterDeckCode];
            alert.showsSuppressionButton = NO;
            alert.accessoryView = containerView;
            
            //
            
            [alert beginSheetModalForWindow:self.view.window completionHandler:^(NSModalResponse returnCode) {
                
            }];
            
            [alert release];
            [titleTextField release];
            [deckCodeTextField release];
            [containerView release];
        }];
    }];
}

- (void)createNewDeckFromDeckCodeAlertFetchButtonTriggered:(NSButton *)sender {
    NSString *title = self.titleTextField.stringValue;
    NSString *deckCode = self.deckCodeTextField.stringValue;
    
    [self.view.window endSheet:self.view.window.attachedSheet];
    [self fetchDeckCode:deckCode title:title];
}

- (void)fetchDeckCode:(NSString *)deckCode
                title:(NSString * _Nullable)title {
    [NSOperationQueue.mainQueue addOperationWithBlock:^{
        [self addSpinnerView];
        
        [self.viewModel fetchDeckCode:deckCode title:title completion:^(LocalDeck * _Nullable localDeck, HSDeck * _Nullable hsDeck, NSError * _Nullable error) {
            [NSOperationQueue.mainQueue addOperationWithBlock:^{
                if (error != nil) {
                    [self.view.window presentErrorAlertWithError:error];
                    return;
                }
                
                [self removeAllSpinnerview];
                [self presentDeckDetailsWithLocalDeck:localDeck];
            }];
        }];
    }];
}

- (void)makeLocalDeckWithClass:(HSCardClass)hsCardClass
                    deckFormat:(HSDeckFormat)deckFormat {
    [NSOperationQueue.mainQueue addOperationWithBlock:^{
        [self addSpinnerView];
        
        [self.viewModel makeLocalDeckWithClass:hsCardClass deckFormat:deckFormat completion:^(LocalDeck * _Nonnull localDeck) {
            [NSOperationQueue.mainQueue addOperationWithBlock:^{
                [self removeAllSpinnerview];
                [self presentDeckDetailsWithLocalDeck:localDeck];
            }];
        }];
    }];
}

#pragma mark - NSCollectionViewDelegate

- (void)collectionView:(NSCollectionView *)collectionView didSelectItemsAtIndexPaths:(NSSet<NSIndexPath *> *)indexPaths {
//    NSIndexPath * _Nullable indexPath = indexPaths.allObjects.lastObject;
//
//    if (indexPath == nil) return;
//
//    DecksItemModel * _Nullable itemModel = [self.viewModel.dataSource itemIdentifierForIndexPath:indexPath];
//    LocalDeck * _Nullable localDeck = itemModel.localDeck;
//
//    if (localDeck == nil) return;
//
//    //
//
//    [self presentDeckDetailsWithLocalDeck:localDeck];
}

#pragma mark - DecksMenuDelegate

- (void)decksMenu:(DecksMenu *)decksMenu createNewDeckWithDeckFormat:(HSDeckFormat)deckFormat hsCardClass:(HSCardClass)hsCardClass {
    [self makeLocalDeckWithClass:hsCardClass deckFormat:deckFormat];
}

- (void)decksMenu:(DecksMenu *)decksMenu createNewDeckFromDeckCodeWithIdentifier:(NSUserInterfaceItemIdentifier)identifier {
    [self presentCreateNewDeckFromDeckCodeAlert];
}

#pragma mark - DecksToolbarDelegate

- (void)decksToolbar:(DecksToolbar *)decksToolbar createNewDeckWithDeckFormat:(HSDeckFormat)deckFormat hsCardClass:(HSCardClass)hsCardClass {
    [self makeLocalDeckWithClass:hsCardClass deckFormat:deckFormat];
}

- (void)decksToolbar:(DecksToolbar *)decksToolbar createNewDeckFromDeckCodeWithIdentifier:(NSTouchBarItemIdentifier)identifier {
    [self presentCreateNewDeckFromDeckCodeAlert];
}

#pragma mark - DecksTouchBarDelegate

- (void)decksTouchBar:(DecksTouchBar *)touchBar createNewDeckWithDeckFormat:(HSDeckFormat)deckFormat hsCardClass:(HSCardClass)hsCardClass {
    [self makeLocalDeckWithClass:hsCardClass deckFormat:deckFormat];
}

- (void)decksTouchBar:(DecksTouchBar *)touchBar createNewDeckFromDeckCodeWithIdentifier:(nonnull NSTouchBarItemIdentifier)identifier {
    [self presentCreateNewDeckFromDeckCodeAlert];
}

#pragma mark - DeckBaseCollectionViewItemDelegate

- (void)deckBaseCollectionViewItem:(DeckBaseCollectionViewItem *)deckBaseCollectionViewItem didDoubleClickWithRecognizer:(NSClickGestureRecognizer *)recognizer {
    [self presentDeckDetailsWithLocalDeck:deckBaseCollectionViewItem.localDeck];
}

@end
