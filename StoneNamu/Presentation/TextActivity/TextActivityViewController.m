//
//  TextActivityViewController.m
//  TextActivityViewController
//
//  Created by Jinwoo Kim on 9/8/21.
//

#import "TextActivityViewController.h"
#import "FloatingMiniViewController.h"

@interface TextActivityViewController () <UITextViewDelegate>
@property (retain) UIBarButtonItem *cancelBarButtonItem;
@property (retain) UIBarButtonItem *shareBarButtonItem;
@property (retain) UITextView *textView;
@end

@implementation TextActivityViewController

- (instancetype)initWithText:(NSString *)text {
    self = [self init];
    
    if (self) {
        [self loadViewIfNeeded];
        [self setTextViewText:text];
    }
    
    return self;
}

- (void)dealloc {
    [_cancelBarButtonItem release];
    [_shareBarButtonItem release];
    [_textView release];
    [super dealloc];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setAttributes];
    [self configureLeftBarButtonItems];
    [self configureRightBarButtonItems];
    [self configureTextView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self configureNavigation];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self updateTextView];
}

- (void)setAttributes {
    self.view.backgroundColor = UIColor.clearColor;
}

- (void)configureLeftBarButtonItems {
    UIBarButtonItem *cancelBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"CANCEL", @"")
                                                                            style:UIBarButtonItemStylePlain
                                                                           target:self
                                                                           action:@selector(cancelBarButtonTriggered:)];
    self.cancelBarButtonItem = cancelBarButtonItem;
    
    self.navigationItem.leftBarButtonItems = @[cancelBarButtonItem];
    [cancelBarButtonItem release];
}

- (void)configureRightBarButtonItems {
    UIBarButtonItem *shareBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"SHARE", @"")
                                                                           style:UIBarButtonItemStylePlain
                                                                          target:self
                                                                          action:@selector(shareBarButtonTriggered:)];
    self.shareBarButtonItem = shareBarButtonItem;
    shareBarButtonItem.enabled = NO;
    
    self.navigationItem.rightBarButtonItems = @[shareBarButtonItem];
    [shareBarButtonItem release];
}

- (void)cancelBarButtonTriggered:(UIBarButtonItem *)sender {
    [self dismissViewControllerAnimated:YES completion:^{}];
}

- (void)shareBarButtonTriggered:(UIBarButtonItem *)sender {
    UIActivityViewController *activity = [[UIActivityViewController alloc] initWithActivityItems:@[self.textView.text] applicationActivities:nil];
    activity.popoverPresentationController.barButtonItem = sender;
    [self presentViewController:activity animated:YES completion:^{}];
    [activity release];
}

- (void)configureTextView {
    UITextView *textView = [UITextView new];
    self.textView = textView;
    
    textView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentAlways;
    textView.delegate = self;
    textView.font = [UIFont preferredFontForTextStyle:UIFontTextStyleCallout];
    textView.backgroundColor = UIColor.clearColor;
    textView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:textView];
    [NSLayoutConstraint activateConstraints:@[
        [textView.topAnchor constraintEqualToAnchor:self.view.topAnchor],
        [textView.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor],
        [textView.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor],
        [textView.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor]
    ]];
    
    [textView release];
}

- (void)configureNavigation {
    self.title = NSLocalizedString(@"RESULT", @"");
    self.navigationItem.largeTitleDisplayMode = UINavigationItemLargeTitleDisplayModeNever;
}

- (void)setTextViewText:(NSString *)text {
    self.textView.text = text;
    if (text.length > 0) {
        self.shareBarButtonItem.enabled = YES;
    } else {
        self.shareBarButtonItem.enabled = NO;
    }
}

- (void)updateTextView {
    [self.textView becomeFirstResponder];
    
    if ([self.parentViewController.parentViewController isKindOfClass:[FloatingMiniViewController class]]) {
        UIEdgeInsets edgeInsets = UIEdgeInsetsMake(0,
                                                   0,
                                                   FLOATINGMINIVIEWCONTROLLER_CONTENTVIEW_CORNER_RADIUS,
                                                   0);
        self.textView.contentInset = edgeInsets;
        self.textView.scrollIndicatorInsets = edgeInsets;
    }
}

#pragma mark - UITextViewDelegate

- (void)textViewDidChange:(UITextView *)textView {
    if (textView.text.length > 0) {
        self.shareBarButtonItem.enabled = YES;
    } else {
        self.shareBarButtonItem.enabled = NO;
    }
}

@end
