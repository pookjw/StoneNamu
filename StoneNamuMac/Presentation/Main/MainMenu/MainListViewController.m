//
//  MainListViewController.m
//  MainListViewController
//
//  Created by Jinwoo Kim on 9/26/21.
//

#import "MainListViewController.h"
#import "MainListTableCellView.h"
#import "MainListViewModel.h"

static NSUserInterfaceItemIdentifier const NSUserInterfaceItemIdentifierMainListTableColumn = @"NSUserInterfaceItemIdentifierMainListTableColumn";

@interface MainListViewController () <NSTableViewDelegate>
@property (weak) id<MainListViewControllerDelegate> delegate;
@property (retain) NSScrollView *scrollView;
@property (retain) NSClipView *clipView;
@property (retain) NSTableView *tableView;
@property (retain) NSTableColumn *tableColumn;
@property (retain) MainListViewModel *viewModel;
@end

@implementation MainListViewController

- (instancetype)initWithDelegate:(id<MainListViewControllerDelegate>)delegate {
    self = [self init];
    
    if (self) {
        self.delegate = delegate;
    }
    
    return self;
}

- (void)dealloc {
    [_scrollView release];
    [_clipView release];
    [_tableView release];
    [_tableColumn release];
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
    [self configureTableView];
    [self configureViewModel];
}

- (void)selectItemModelType:(MainListItemModelType)type {
    [self.viewModel rowForItemModelType:type completion:^(NSInteger row) {
        if (row < 0) return;
        
        NSIndexSet *indexSet = [[NSIndexSet alloc] initWithIndex:row];
        
        [NSOperationQueue.mainQueue addOperationWithBlock:^{
            [self.tableView selectRowIndexes:indexSet byExtendingSelection:NO];
            [indexSet release];
        }];
    }];
}

- (void)setAttributes {
    NSLayoutConstraint *widthLayout = [self.view.widthAnchor constraintGreaterThanOrEqualToConstant:200];
    [NSLayoutConstraint activateConstraints:@[
        widthLayout
    ]];
}

- (void)configureTableView {
    NSScrollView *scrollView = [NSScrollView new];
    NSClipView *clipView = [NSClipView new];
    NSTableView *tableView = [NSTableView new];
    
    self.scrollView = scrollView;
    self.clipView = clipView;
    self.tableView = tableView;
    
    scrollView.contentView = clipView;
    clipView.documentView = tableView;
    clipView.postsBoundsChangedNotifications = YES;

    [self.view addSubview:scrollView];
    scrollView.translatesAutoresizingMaskIntoConstraints = NO;
    [NSLayoutConstraint activateConstraints:@[
        [scrollView.topAnchor constraintEqualToAnchor:self.view.topAnchor],
        [scrollView.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor],
        [scrollView.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor],
        [scrollView.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor]
    ]];
    
    //
    
    NSNib *nib = [[NSNib alloc] initWithNibNamed:NSStringFromClass([MainListTableCellView class]) bundle:NSBundle.mainBundle];
    [tableView registerNib:nib forIdentifier:NSStringFromClass([MainListTableCellView class])];
    [nib release];
    
    NSTableColumn *tableColumn = [[NSTableColumn alloc] initWithIdentifier:NSUserInterfaceItemIdentifierMainListTableColumn];
    self.tableColumn = tableColumn;
    [tableView addTableColumn:tableColumn];
    [tableColumn release];
    
    tableView.headerView = nil;
    tableView.wantsLayer = YES;
    tableView.layer.backgroundColor = NSColor.clearColor.CGColor;
    tableView.style = NSTableViewStyleSourceList;
    tableView.rowSizeStyle = NSTableViewRowSizeStyleDefault;
    tableView.delegate = self;
    tableView.allowsEmptySelection = NO;
    
    [scrollView release];
    [clipView release];
    [tableView release];
}

- (void)configureViewModel {
    MainListViewModel *viewModel = [[MainListViewModel alloc] initWithDataSource:[self makeDataSource]];
    self.viewModel = viewModel;
    [viewModel release];
}

- (MainListDataSource *)makeDataSource {
    MainListDataSource *dataSource = [[MainListDataSource alloc] initWithTableView:self.tableView cellProvider:^NSView * _Nonnull(NSTableView * _Nonnull tableView, NSTableColumn * _Nonnull column, NSInteger row, MainListItemModel * _Nonnull itemModel) {
        
        MainListTableCellView *view = (MainListTableCellView *)[tableView makeViewWithIdentifier:NSStringFromClass([MainListTableCellView class]) owner:self];
        
        view.imageView.image = itemModel.image;
        view.textField.stringValue = itemModel.primaryText;
        
        return view;
    }];
    
    return [dataSource autorelease];
}

#pragma mark - NSTableViewDelegate

- (void)tableViewSelectionDidChange:(NSNotification *)notification {
    NSTableView *tableView = (NSTableView *)notification.object;
    
    if ((tableView == nil) || (![tableView isKindOfClass:[NSTableView class]])) return;
    
    MainListItemModel * _Nullable itemModel = [self.viewModel.dataSource itemIdentifierForRow:tableView.selectedRow];
    
    if (itemModel == nil) return;
    
    [self.delegate mainListViewController:self didChangeSelectedItemModelType:itemModel.type];
}

@end
