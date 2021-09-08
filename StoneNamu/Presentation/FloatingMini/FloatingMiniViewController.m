//
//  FloatingMiniViewController.m
//  FloatingMiniViewController
//
//  Created by Jinwoo Kim on 9/7/21.
//

#import "FloatingMiniViewController.h"
#import "UIView+removeAllSubviews.h"
#import "ZoomAnimatedTransitioning.h"

@interface FloatingMiniViewController () <UIViewControllerTransitioningDelegate>
@property (retain) ZoomAnimatedTransitioning *presentingController;
@property (retain) ZoomAnimatedTransitioning *dismissingController;
@property (retain) UIVisualEffectView *backgroundView;
@property (retain) UIVisualEffectView *contentView;
@property (retain) NSLayoutConstraint *contentViewWidthLayout;
@property (retain) NSLayoutConstraint *contentViewHeightLayout;
@property (retain) NSLayoutConstraint *contentViewBottomLayout;
@property (retain) NSLayoutConstraint *contentViewCenterYLayout;
@property (retain, nonatomic) UIViewController *contentViewController;
@end

@implementation FloatingMiniViewController

- (instancetype)initWithContentViewController:(__kindof UIViewController *)viewController {
    self = [self init];
    
    if (self) {
        [self loadViewIfNeeded];
        self.contentViewController = viewController;
    }
    
    return self;
}

- (instancetype)initWithContentViewController:(__kindof UIViewController *)viewController sizeOfContentView:(CGSize)sizeOfContentView {
    self = [self initWithContentViewController:viewController];
    
    if (self) {
        self.contentViewWidthLayout.constant = sizeOfContentView.width;
        self.contentViewHeightLayout.constant = sizeOfContentView.height;
    }
    
    return self;
}
- (void)dealloc {
    [_presentingController release];
    [_dismissingController release];
    [_backgroundView release];
    [_contentView release];
    [_contentViewWidthLayout release];
    [_contentViewHeightLayout release];
    [_contentViewBottomLayout release];
    [_contentViewCenterYLayout release];
    [_contentViewController release];
    [super dealloc];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setAttributes];
    [self configurePresentationControllers];
    [self configureBackgroundView];
    [self configureContentView];
    [self bind];
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (void)setAttributes {
    self.view.backgroundColor = UIColor.clearColor;
    self.modalPresentationCapturesStatusBarAppearance = YES;
    self.transitioningDelegate = self;
}

- (void)configurePresentationControllers {
    ZoomAnimatedTransitioning *presentingController = [[ZoomAnimatedTransitioning alloc] initWithAnimateForPresenting:YES];
    self.presentingController = presentingController;
    [presentingController release];
    
    ZoomAnimatedTransitioning *dismissingController = [[ZoomAnimatedTransitioning alloc] initWithAnimateForPresenting:NO];
    self.dismissingController = dismissingController;
    [dismissingController release];
}

- (void)configureBackgroundView {
    UIVisualEffectView *backgroundView = [[UIVisualEffectView alloc] initWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleDark]];
    self.backgroundView = backgroundView;
    
    backgroundView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:backgroundView];
    [NSLayoutConstraint activateConstraints:@[
        [backgroundView.topAnchor constraintEqualToAnchor:self.view.topAnchor],
        [backgroundView.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor],
        [backgroundView.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor],
        [backgroundView.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor]
    ]];
    
    [backgroundView release];
}

- (void)configureContentView {
    UIVisualEffectView *contentView = [[UIVisualEffectView alloc] initWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleSystemChromeMaterial]];
    self.contentView = contentView;
    contentView.backgroundColor = UIColor.clearColor;
    contentView.layer.masksToBounds = YES;
    contentView.layer.cornerRadius = FLOATINGMINIVIEWCONTROLLER_CONTENTVIEW_CORNER_RADIUS;
    contentView.layer.cornerCurve = kCACornerCurveContinuous;
    contentView.translatesAutoresizingMaskIntoConstraints = NO;
    
    [self.view addSubview:contentView];
    
    NSLayoutConstraint *widthLayout = [contentView.widthAnchor constraintLessThanOrEqualToConstant:320];
    self.contentViewWidthLayout = widthLayout;
    
    NSLayoutConstraint *heightLayout = [contentView.heightAnchor constraintLessThanOrEqualToConstant:200];
    self.contentViewHeightLayout = heightLayout;
    
    NSLayoutConstraint *topLayout = [contentView.topAnchor constraintEqualToAnchor:self.view.layoutMarginsGuide.topAnchor constant:0];
    topLayout.priority = UILayoutPriorityDefaultHigh;
    
    NSLayoutConstraint *leadingLayout = [contentView.leadingAnchor constraintEqualToAnchor:self.view.layoutMarginsGuide.leadingAnchor constant:0];
    leadingLayout.priority = UILayoutPriorityDefaultHigh;
    
    NSLayoutConstraint *bottomLayout = [contentView.bottomAnchor constraintEqualToAnchor:self.view.layoutMarginsGuide.bottomAnchor constant:0];
    self.contentViewBottomLayout = bottomLayout;
    bottomLayout.priority = UILayoutPriorityDefaultHigh;
    
    NSLayoutConstraint *trailingLayout = [contentView.trailingAnchor constraintEqualToAnchor:self.view.layoutMarginsGuide.trailingAnchor constant:0];
    trailingLayout.priority = UILayoutPriorityDefaultHigh;
    
    NSLayoutConstraint *centerXLayout = [contentView.centerXAnchor constraintEqualToAnchor:self.view.layoutMarginsGuide.centerXAnchor];
    centerXLayout.priority = UILayoutPriorityDefaultHigh;
    
    NSLayoutConstraint *centerYLayout = [contentView.centerYAnchor constraintEqualToAnchor:self.view.layoutMarginsGuide.centerYAnchor];
    self.contentViewCenterYLayout = centerYLayout;
    centerYLayout.priority = UILayoutPriorityDefaultHigh;
    
    [NSLayoutConstraint activateConstraints:@[
        centerXLayout,
        centerYLayout,
        widthLayout,
        heightLayout,
        topLayout,
        leadingLayout,
        bottomLayout,
        trailingLayout
    ]];
    
    [contentView release];
}

- (void)setContentViewController:(__kindof UIViewController *)viewController {
    [self->_contentViewController removeFromParentViewController];
    [self->_contentViewController release];
    self->_contentViewController = [viewController retain];
    
    [self.contentView.contentView removeAllSubviews];
    [self addChildViewController:viewController];
    
    viewController.view.translatesAutoresizingMaskIntoConstraints = NO;
    [self.contentView.contentView addSubview:viewController.view];
    [NSLayoutConstraint activateConstraints:@[
        [viewController.view.topAnchor constraintEqualToAnchor:self.contentView.contentView.topAnchor],
        [viewController.view.leadingAnchor constraintEqualToAnchor:self.contentView.contentView.leadingAnchor],
        [viewController.view.bottomAnchor constraintEqualToAnchor:self.contentView.contentView.bottomAnchor],
        [viewController.view.trailingAnchor constraintEqualToAnchor:self.contentView.contentView.trailingAnchor]
    ]];
}

- (void)bind {
    [NSNotificationCenter.defaultCenter addObserver:self
                                           selector:@selector(keyboardWillShowReceived:)
                                               name:UIKeyboardWillShowNotification
                                             object:nil];
    
    [NSNotificationCenter.defaultCenter addObserver:self
                                           selector:@selector(keyboardWillHideReceived:)
                                               name:UIKeyboardWillHideNotification
                                             object:nil];
    
    [NSNotificationCenter.defaultCenter addObserver:self
                                           selector:@selector(keyboardWillChangeFrameReceived:)
                                               name:UIKeyboardDidChangeFrameNotification
                                             object:nil];
}

- (void)keyboardWillShowReceived:(NSNotification *)notification {
    [self handleKeyboardEvent:notification];
}

- (void)keyboardWillHideReceived:(NSNotification *)notification {
    [self handleKeyboardEvent:notification];
}

- (void)keyboardWillChangeFrameReceived:(NSNotification *)notification {
    [self handleKeyboardEvent:notification];
}

- (void)handleKeyboardEvent:(NSNotification *)notification {
    UIViewAnimationCurve curve = [(NSNumber *)notification.userInfo[UIKeyboardAnimationCurveUserInfoKey] integerValue];
    double duration = [(NSNumber *)notification.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    CGRect endFrame = [(NSValue *)notification.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
    // getting height from frame is not accurate because it's not actually height of presented on current window.
    CGFloat height = self.view.window.bounds.size.height - endFrame.origin.y;
    
    if (height < 0) {
        height = 0;
    }
    
    [NSOperationQueue.mainQueue addOperationWithBlock:^{
        [UIView animateWithDuration:duration
                              delay:0
                            options:curve << 16
                         animations:^{
            self.contentViewCenterYLayout.constant = -height / 2;
            self.contentViewBottomLayout.constant = -height;
            [self.view layoutIfNeeded];
        } completion:^(BOOL finished) {
            
        }];
    }];
}

#pragma mark - UIViewControllerTransitioningDelegate

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source {
    return self.presentingController;
}

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed {
    return self.dismissingController;
}

@end
