//
//  PickerSheetViewController.m
//  PickerSheetViewController
//
//  Created by Jinwoo Kim on 7/25/21.
//

#import "PickerViewController.h"
#import "PickerItemView.h"

@interface PickerViewController () <UIPickerViewDataSource, UIPickerViewDelegate>
@property (retain) UIPickerView *pickerView;
@property (retain) NSArray<PickerItemModel *> *dataSource;
@property (readonly) BOOL showEmptyRow;
@property (copy) PickerViewControllerDoneCompletion doneCompletion;
@end

@implementation PickerViewController

- (void)dealloc {
    [_pickerView release];
    [_dataSource release];
    [_doneCompletion release];
    [super dealloc];
}

- (instancetype)initWithDataSource:(NSArray<PickerItemModel *> *)dataSource title:(NSString *)title showEmptyRow:(BOOL)showEmptyRow doneCompletion:(PickerViewControllerDoneCompletion)doneCompletion {
    self = [self init];
    
    if (self) {
        self.dataSource = dataSource;
        self.title = title;
        _showEmptyRow = showEmptyRow;
        self.doneCompletion = doneCompletion;
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setAttributes];
    [self configurePickerView];
    [self configureCancelButton];
    [self configureDoneButton];
}

- (void)selectIdentity:(NSString *)identity animated:(BOOL)animated {
    NSUInteger __block index = 0;
    BOOL __block found = NO;
    
    [self.dataSource enumerateObjectsUsingBlock:^(PickerItemModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj.identity isEqualToString:identity]) {
            index = idx;
            found = YES;
            *stop = YES;
        }
    }];
    
    if ((self.showEmptyRow) && (found)) {
        index += 1;
    }
    
    if (!found) {
        NSLog(@"No identity found: %@", identity);
    }
    
    [self.pickerView selectRow:index inComponent:0 animated:YES];
}

- (void)setAttributes {
    self.view.backgroundColor = UIColor.systemBackgroundColor;
}

- (void)configurePickerView {
    UIPickerView *pickerView = [UIPickerView new];
    self.pickerView = pickerView;
    [self.view addSubview:pickerView];
    
    pickerView.translatesAutoresizingMaskIntoConstraints = NO;
    
    [NSLayoutConstraint activateConstraints:@[
        [pickerView.topAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.topAnchor],
        [pickerView.bottomAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.bottomAnchor],
        [pickerView.leadingAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.leadingAnchor],
        [pickerView.trailingAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.trailingAnchor]
    ]];
    
    pickerView.dataSource = self;
    pickerView.delegate = self;
    
    [pickerView release];
}

- (void)configureCancelButton {
    UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"CANCEL", @"")
                                                                     style:UIBarButtonItemStylePlain
                                                                    target:self
                                                                    action:@selector(cancelButtonTriggered:)];
    
    self.navigationItem.leftBarButtonItems = @[cancelButton];
    [cancelButton release];
}

- (void)cancelButtonTriggered:(UIBarButtonItem *)sender {
    [self dismissViewControllerAnimated:YES completion:^{}];
}

- (void)configureDoneButton {
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"DONE", @"")
                                                                   style:UIBarButtonItemStylePlain
                                                                  target:self
                                                                  action:@selector(doneButtonTriggered:)];
    
    self.navigationItem.rightBarButtonItems = @[doneButton];
    [doneButton release];
}

- (void)doneButtonTriggered:(UIBarButtonItem *)sender {
    NSInteger selectedRow = [self.pickerView selectedRowInComponent:0];
    if (self.showEmptyRow) {
        if (selectedRow == 0) {
            self.doneCompletion(nil);
        } else {
            PickerItemModel *itemModel = self.dataSource[selectedRow - 1];
            self.doneCompletion(itemModel);
        }
    } else {
        PickerItemModel *itemModel = self.dataSource[selectedRow];
        self.doneCompletion(itemModel);
    }
    
    [self dismissViewControllerAnimated:YES completion:^{}];
}

#pragma mark UIPickerViewDataSource

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    if (self.showEmptyRow) {
        return self.dataSource.count + 1;
    } else {
        return self.dataSource.count;
    }
}

#pragma mark UIPickerViewDelegate

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view {
    
    PickerItemView *pickerItemView;
    
    if ((view) && ([view isKindOfClass:[PickerItemView class]])) {
        pickerItemView = (PickerItemView *)view;
    } else {
        pickerItemView = [[PickerItemView new] autorelease];
    }
    
    if (self.showEmptyRow) {
        if (row == 0) {
            [pickerItemView configureWithImage:nil
                                   primaryText:NSLocalizedString(@"ALL", @"")
                                 secondaryText:nil];
        } else {
            [pickerItemView configureWithImage:self.dataSource[row - 1].image
                                   primaryText:self.dataSource[row - 1].title
                                 secondaryText:self.dataSource[row - 1].identity];
        }
    } else {
        [pickerItemView configureWithImage:self.dataSource[row].image
                               primaryText:self.dataSource[row].title
                             secondaryText:self.dataSource[row].identity];
    }
    
    return pickerItemView;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component {
    return [PickerItemView getHeightUsingWidth:pickerView.frame.size.width];
}

@end
