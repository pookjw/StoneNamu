//
//  MainListViewController.m
//  MainListViewController
//
//  Created by Jinwoo Kim on 9/26/21.
//

#import "MainListViewController.h"
#import "MainListTableHeaderView.h"
#import "MainListTableCellView.h"
#import "MainListViewModel.h"

static NSUserInterfaceItemIdentifier const NSUserInterfaceItemIdentifierMainListTableColumn = @"NSUserInterfaceItemIdentifierMainListTableColumn";

@interface MainListViewController () <NSTableViewDelegate>
@property (assign) id<MainListViewControllerDelegate> delegate;
@property (retain) NSScrollView *scrollView;
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

- (void)encodeRestorableStateWithCoder:(NSCoder *)coder backgroundQueue:(NSOperationQueue *)queue {
    [super encodeRestorableStateWithCoder:coder backgroundQueue:queue];
    
    NSIndexSet *selectedRowIndexes = self.tableView.selectedRowIndexes;
    
    [queue addOperationWithBlock:^{
        [coder encodeObject:selectedRowIndexes forKey:@"selectedRowIndexes"];
    }];
}

- (void)restoreStateWithCoder:(NSCoder *)coder {
    [super restoreStateWithCoder:coder];
    
    NSIndexSet *selectedRowIndexes = [coder decodeObjectOfClass:[NSIndexSet class] forKey:@"selectedRowIndexes"];
    
    if (selectedRowIndexes.count > 1) {
        [self.viewModel.queue addBarrierBlock:^{
            [NSOperationQueue.mainQueue addOperationWithBlock:^{
                [self.tableView selectRowIndexes:selectedRowIndexes byExtendingSelection:NO];
            }];
        }];
    }
}

- (void)selectItemModelType:(MainListItemModelType)type {
    [self.viewModel rowForItemModelType:type completion:^(NSInteger row) {
        if (row < 0) return;

        NSIndexSet *indexSet = [NSIndexSet indexSetWithIndex:row];

        [NSOperationQueue.mainQueue addOperationWithBlock:^{
            [self.tableView selectRowIndexes:indexSet byExtendingSelection:NO];
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
    NSTableView *tableView = [NSTableView new];
    
    scrollView.documentView = tableView;
    
    [self.view addSubview:scrollView];
    scrollView.translatesAutoresizingMaskIntoConstraints = NO;
    [NSLayoutConstraint activateConstraints:@[
        [scrollView.topAnchor constraintEqualToAnchor:self.view.topAnchor],
        [scrollView.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor],
        [scrollView.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor],
        [scrollView.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor]
    ]];
    
    //
    
    NSNib *headerNib = [[NSNib alloc] initWithNibNamed:NSStringFromClass([MainListTableHeaderView class]) bundle:NSBundle.mainBundle];
    [tableView registerNib:headerNib forIdentifier:NSUserInterfaceItemIdentifierMainListTableHeaderView];
    [headerNib release];
    
    NSNib *cellNib = [[NSNib alloc] initWithNibNamed:NSStringFromClass([MainListTableCellView class]) bundle:NSBundle.mainBundle];
    [tableView registerNib:cellNib forIdentifier:NSUserInterfaceItemIdentifierMainListTableCellView];
    [cellNib release];
    
    NSTableColumn *tableColumn = [[NSTableColumn alloc] initWithIdentifier:NSUserInterfaceItemIdentifierMainListTableColumn];
    [tableView addTableColumn:tableColumn];
    [tableColumn release];
    
    tableView.headerView = nil;
    tableView.wantsLayer = YES;
    tableView.layer.backgroundColor = NSColor.clearColor.CGColor;
    tableView.style = NSTableViewStyleSourceList;
    tableView.rowSizeStyle = NSTableViewRowSizeStyleDefault;
    tableView.delegate = self;
    tableView.allowsEmptySelection = NO;
    
    self.scrollView = scrollView;
    self.tableView = tableView;
    self.tableColumn = tableColumn;
    
    [scrollView release];
    [tableView release];
}

- (void)configureViewModel {
    MainListViewModel *viewModel = [[MainListViewModel alloc] initWithDataSource:[self makeDataSource]];
    self.viewModel = viewModel;
    [viewModel release];
}

- (MainListDataSource *)makeDataSource {
    MainListViewController * __block unretainedSelf = self;
    
    MainListDataSource *dataSource = [[MainListDataSource alloc] initWithTableView:self.tableView cellProvider:^NSView * _Nonnull(NSTableView * _Nonnull tableView, NSTableColumn * _Nonnull column, NSInteger row, MainListItemModel * _Nonnull itemModel) {
        
        MainListTableCellView *view = (MainListTableCellView *)[tableView makeViewWithIdentifier:NSUserInterfaceItemIdentifierMainListTableCellView owner:unretainedSelf];
        
        view.imageView.image = itemModel.image;
        view.textField.stringValue = itemModel.primaryText;
        
        return view;
    }];
    
    dataSource.sectionHeaderViewProvider = ^NSView * _Nonnull(NSTableView * _Nonnull tableView, NSInteger row, id  _Nonnull sectionId) {
        MainListTableHeaderView *view = (MainListTableHeaderView *)[tableView makeViewWithIdentifier:NSUserInterfaceItemIdentifierMainListTableHeaderView owner:unretainedSelf];
        MainListSectionModel *sectionModel = [unretainedSelf.viewModel.dataSource sectionIdentifierForRow:row];
        
        view.textField.stringValue = sectionModel.title;
        
        return view;
    };
    
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

- (BOOL)tableView:(NSTableView *)tableView shouldSelectRow:(NSInteger)row {
    MainListItemModel * _Nullable itemModel = [self.viewModel.dataSource itemIdentifierForRow:row];
    return (itemModel != nil);
}

@end
