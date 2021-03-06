//
//  PickerSheetViewController.m
//  PickerSheetViewController
//
//  Created by Jinwoo Kim on 7/25/21.
//

#import "OldPickerViewController.h"
#import "OldPickerItemView.h"
#import <StoneNamuResources/StoneNamuResources.h>

@interface OldPickerViewController () <UIPickerViewDataSource, UIPickerViewDelegate>
@property (retain) UIPickerView *pickerView;
@property (copy) NSArray<OldPickerItemModel *> *dataSource;
@property (readonly) BOOL showEmptyRow;
@property (copy) OldPickerViewControllerDoneCompletion doneCompletion;
@end

@implementation OldPickerViewController

- (void)dealloc {
    [_pickerView release];
    [_dataSource release];
    [_doneCompletion release];
    [super dealloc];
}

- (instancetype)initWithDataSource:(NSArray<OldPickerItemModel *> *)dataSource title:(NSString *)title showEmptyRow:(BOOL)showEmptyRow doneCompletion:(OldPickerViewControllerDoneCompletion)doneCompletion {
    self = [self init];
    
    if (self) {
        self.dataSource = dataSource;
        self.navigationItem.title = title;
        self->_showEmptyRow = showEmptyRow;
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
    
    [self.dataSource enumerateObjectsUsingBlock:^(OldPickerItemModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
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
    
    self.pickerView = pickerView;
    [pickerView release];
}

- (void)configureCancelButton {
    UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithTitle:[ResourcesService localizationForKey:LocalizableKeyCancel]
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
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithTitle:[ResourcesService localizationForKey:LocalizableKeyDone]
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
            OldPickerItemModel *itemModel = self.dataSource[selectedRow - 1];
            self.doneCompletion(itemModel);
        }
    } else {
        OldPickerItemModel *itemModel = self.dataSource[selectedRow];
        self.doneCompletion(itemModel);
    }
    
    [self dismissViewControllerAnimated:YES completion:^{}];
}

#pragma mark - UIPickerViewDataSource

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

#pragma mark - UIPickerViewDelegate

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view {
    
    OldPickerItemView *pickerItemView;
    
    if ((view) && ([view isKindOfClass:[OldPickerItemView class]])) {
        pickerItemView = (OldPickerItemView *)view;
    } else {
        pickerItemView = [[OldPickerItemView new] autorelease];
    }
    
    if (self.showEmptyRow) {
        if (row == 0) {
            [pickerItemView configureWithImage:nil
                                   primaryText:[ResourcesService localizationForKey:LocalizableKeyAll]
                                 secondaryText:nil];
        } else {
#if DEBUG
            [pickerItemView configureWithImage:self.dataSource[row - 1].image
                                   primaryText:self.dataSource[row - 1].title
                                 secondaryText:self.dataSource[row - 1].identity];
#else
            [pickerItemView configureWithImage:self.dataSource[row - 1].image
                                   primaryText:self.dataSource[row - 1].title
                                 secondaryText:nil];
#endif
        }
    } else {
#if DEBUG
        [pickerItemView configureWithImage:self.dataSource[row].image
                               primaryText:self.dataSource[row].title
                             secondaryText:self.dataSource[row].identity];
#else
        [pickerItemView configureWithImage:self.dataSource[row].image
                               primaryText:self.dataSource[row].title
                             secondaryText:nil];
#endif
    }
    
    return pickerItemView;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component {
    return [OldPickerItemView getHeightUsingWidth:pickerView.frame.size.width];
}

@end
