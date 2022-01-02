//
//  StepperViewController.m
//  StepperViewController
//
//  Created by Jinwoo Kim on 7/29/21.
//

#import "StepperViewController.h"
#import <StoneNamuResources/StoneNamuResources.h>

@interface StepperViewController ()
@property (retain) UIStackView *stackView;
@property (retain) UILabel *label;
@property (retain) UIStepper *stepper;
@property NSRange range;
@property NSUInteger initialValue;
@property (copy) StepperViewControllerClearCompletion clearCompletion;
@property (copy) StepperViewControllerDoneCompletion doneCompletion;
@end

@implementation StepperViewController

- (instancetype)initWithRange:(NSRange)range
                        title:(NSString *)title
                        value:(NSUInteger)value
              clearCompletion:(StepperViewControllerClearCompletion)clearCompletion
               doneCompletion:(StepperViewControllerDoneCompletion)doneCompletion {
    self = [self init];
    
    if (self) {
        self.showPlusMarkWhenReachedToMax = NO;
        self.range = range;
        self.navigationItem.title = title;
        self.initialValue = value;
        self.clearCompletion = clearCompletion;
        self.doneCompletion = doneCompletion;
    }
    
    return self;
}

- (void)dealloc {
    [_stackView release];
    [_label release];
    [_stepper release];
    [_clearCompletion release];
    [_doneCompletion release];
    [super dealloc];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setAttributes];
    [self configureViews];
    [self configureBarButtonItems];
}

- (void)setAttributes {
    self.view.backgroundColor = UIColor.systemBackgroundColor;
}

- (void)configureViews {
    UIStackView *stackView = [UIStackView new];
    [self.view addSubview:stackView];
    stackView.axis = UILayoutConstraintAxisVertical;
    stackView.spacing = 30;
    stackView.translatesAutoresizingMaskIntoConstraints = NO;
    [NSLayoutConstraint activateConstraints:@[
        [stackView.centerXAnchor constraintEqualToAnchor:self.view.centerXAnchor],
        [stackView.centerYAnchor constraintEqualToAnchor:self.view.centerYAnchor]
    ]];
    
    UILabel *label = [UILabel new];
    [stackView addArrangedSubview:label];
    label.text = [NSString stringWithFormat:@"%lu", (NSUInteger)self.initialValue];
    label.textAlignment = NSTextAlignmentCenter;
    label.adjustsFontForContentSizeCategory = YES;
    label.font = [UIFont preferredFontForTextStyle:UIFontTextStyleTitle2];
    self.label = label;
    [label release];
    
    UIStepper *stepper = [UIStepper new];
    [stackView addArrangedSubview:stepper];
    stepper.continuous = YES;
    [stepper addTarget:self action:@selector(stepperValueChanged:) forControlEvents:UIControlEventValueChanged];
    stepper.stepValue = 1;
    stepper.value = self.initialValue;
    stepper.minimumValue = self.range.location;
    stepper.maximumValue = self.range.location + self.range.length;
    self.stepper = stepper;
    [stepper release];
    
    self.stackView = stackView;
    [stackView release];
}

- (void)stepperValueChanged:(UIStepper *)sender {
    if (self.showPlusMarkWhenReachedToMax) {
        if ((NSUInteger)sender.value == (self.range.location + self.range.length)) {
            self.label.text = [NSString stringWithFormat:@"%lu+", (NSUInteger)sender.value];
        } else {
            self.label.text = [NSString stringWithFormat:@"%lu", (NSUInteger)sender.value];
        }
    } else {
        self.label.text = [NSString stringWithFormat:@"%lu", (NSUInteger)sender.value];
    }
}

- (void)configureBarButtonItems {
    UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithTitle:[ResourcesService localizationForKey:LocalizableKeyCancel]
                                                                     style:UIBarButtonItemStylePlain
                                                                    target:self
                                                                    action:@selector(cancelButtonTriggered:)];
    
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithTitle:[ResourcesService localizationForKey:LocalizableKeyDone]
                                                                   style:UIBarButtonItemStylePlain
                                                                  target:self
                                                                  action:@selector(doneButtonTriggered:)];
    
    UIBarButtonItem *clearButton = [[UIBarButtonItem alloc] initWithTitle:[ResourcesService localizationForKey:LocalizableKeyClear]
                                                                    style:UIBarButtonItemStylePlain
                                                                   target:self
                                                                   action:@selector(clearButtonTriggered:)];
    
    self.navigationItem.leftBarButtonItems = @[cancelButton];
    self.navigationItem.rightBarButtonItems = @[doneButton, clearButton];
    
    [cancelButton release];
    [doneButton release];
    [clearButton release];
}

- (void)cancelButtonTriggered:(UIBarButtonItem *)sender {
    [self dismissViewControllerAnimated:YES completion:^{}];
}

- (void)doneButtonTriggered:(UIBarButtonItem *)sender {
    NSUInteger value = (NSUInteger)self.stepper.value;
    self.doneCompletion(value);
    [self dismissViewControllerAnimated:YES completion:^{}];
}

- (void)clearButtonTriggered:(UIBarButtonItem *)sender {
    self.clearCompletion();
    [self dismissViewControllerAnimated:YES completion:^{}];
}

@end
