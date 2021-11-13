//
//  TextActivityViewController.m
//  TextActivityViewController
//
//  Created by Jinwoo Kim on 9/8/21.
//

#import "TextActivityViewController.h"
#import "FloatingPresentationController.h"
#import <StoneNamuResources/StoneNamuResources.h>

@interface TextActivityViewController () <UITextViewDelegate>
@property (retain) UIBarButtonItem *cancelBarButtonItem;
@property (retain) UIBarButtonItem *shareBarButtonItem;
@property (retain) UIVisualEffectView *blurView;
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
    [_blurView release];
    [_textView release];
    [super dealloc];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setAttributes];
    [self configureLeftBarButtonItems];
    [self configureRightBarButtonItems];
    [self configureBlurView];
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
    UIBarButtonItem *cancelBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:[ResourcesService localizationForKey:LocalizableKeyCancel]
                                                                            style:UIBarButtonItemStylePlain
                                                                           target:self
                                                                           action:@selector(cancelBarButtonTriggered:)];
    self.cancelBarButtonItem = cancelBarButtonItem;
    
    self.navigationItem.leftBarButtonItems = @[cancelBarButtonItem];
    [cancelBarButtonItem release];
}

- (void)configureRightBarButtonItems {
    UIBarButtonItem *shareBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:[ResourcesService localizationForKey:LocalizableKeyShare]
                                                                           style:UIBarButtonItemStyleDone
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

- (void)configureBlurView {
    UIVisualEffectView *blurView = [[UIVisualEffectView alloc] initWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleSystemChromeMaterial]];
    self.blurView = blurView;
    
    [self.view addSubview:blurView];
    blurView.translatesAutoresizingMaskIntoConstraints = NO;
    
    [NSLayoutConstraint activateConstraints:@[
        [blurView.topAnchor constraintEqualToAnchor:self.view.topAnchor],
        [blurView.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor],
        [blurView.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor],
        [blurView.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor]
    ]];
    
    [blurView release];
}

- (void)configureTextView {
    UITextView *textView = [UITextView new];
    self.textView = textView;
    
    textView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentAlways;
    textView.delegate = self;
    textView.font = [UIFont preferredFontForTextStyle:UIFontTextStyleCallout];
    textView.backgroundColor = UIColor.clearColor;
    textView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.blurView.contentView addSubview:textView];
    [NSLayoutConstraint activateConstraints:@[
        [textView.topAnchor constraintEqualToAnchor:self.blurView.contentView.topAnchor],
        [textView.trailingAnchor constraintEqualToAnchor:self.blurView.contentView.trailingAnchor],
        [textView.leadingAnchor constraintEqualToAnchor:self.blurView.contentView.leadingAnchor],
        [textView.bottomAnchor constraintEqualToAnchor:self.blurView.contentView.bottomAnchor]
    ]];
    
    [textView release];
}

- (void)configureNavigation {
    self.title = [ResourcesService localizationForKey:LocalizableKeyResult];
    self.navigationItem.largeTitleDisplayMode = UINavigationItemLargeTitleDisplayModeNever;
    
    UINavigationBarAppearance *appearance = [UINavigationBarAppearance new];
    [appearance configureWithOpaqueBackground];
    self.navigationController.navigationBar.scrollEdgeAppearance = appearance;
    [appearance release];
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
    
    if ([self.parentViewController.presentationController isKindOfClass:[FloatingPresentationController class]]) {
        UIEdgeInsets edgeInsets = UIEdgeInsetsMake(0,
                                                   0,
                                                   FLOATINGPRESENTATIONCONTROLLER_CORNERRADIUS,
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
