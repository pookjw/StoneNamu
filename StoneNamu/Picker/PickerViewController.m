//
//  PickerSheetViewController.m
//  PickerSheetViewController
//
//  Created by Jinwoo Kim on 7/25/21.
//

#import "PickerViewController.h"

@interface PickerViewController () <UIPickerViewDataSource, UIPickerViewDelegate>
@property UIPickerView *pickerView;
@property (retain) NSArray<PickerItemModel *> *dataSource;
@property (readonly) BOOL showEmptyRow;
@property (copy) PickerViewControllerDoneCompletion doneCompletion;
@end

@implementation PickerViewController

- (instancetype)init {
    self = [super init];
    
    if (self) {
        self.dataSource = @[];
        _showEmptyRow = NO;
        self.doneCompletion = ^(PickerItemModel * _){};
    }
    
    return self;
}

- (void)dealloc {
    [_dataSource release];
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

- (void)selectRow:(NSInteger)row animated:(BOOL)animated {
    if (self.view == nil) {
        [self loadViewIfNeeded];
    }
    
    [self.pickerView selectRow:row inComponent:0 animated:animated];
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
        [pickerView.topAnchor constraintEqualToAnchor:self.view.topAnchor],
        [pickerView.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor],
        [pickerView.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor],
        [pickerView.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor]
    ]];
    
    pickerView.dataSource = self;
    pickerView.delegate = self;
    
    [pickerView release];
}

- (void)configureCancelButton {
    UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithTitle:@"취소 (번역)"
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
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithTitle:@"완료 (번역)"
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

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    if (self.showEmptyRow) {
        if (row == 0) {
            return @"(비어 있음 (번역))";
        } else {
            return self.dataSource[row - 1].title;
        }
    } else {
        return self.dataSource[row].title;
    }
}

@end
