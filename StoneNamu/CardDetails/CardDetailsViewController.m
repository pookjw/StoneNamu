//
//  CardDetailsViewController.m
//  CardDetailsViewController
//
//  Created by Jinwoo Kim on 8/2/21.
//

#import "CardDetailsViewController.h"
#import "DynamicViewPresentationController.h"
#import "UIImageView+setAsyncImage.h"

@interface CardDetailsViewController () <UIViewControllerTransitioningDelegate>
@property (retain) UIImageView *sourceImageView;
@property (retain) UIImageView *primaryImageView;
@property (copy) HSCard *hsCard;
@end

@implementation CardDetailsViewController

- (instancetype)initWithHSCard:(HSCard *)hsCard sourceImageView:(UIImageView *)sourceImageView {
    self = [self init];
    
    if (self) {
        self.sourceImageView = sourceImageView;
        self.hsCard = hsCard;
    }
    
    return self;
}

- (void)dealloc {
    [_sourceImageView release];
    [_primaryImageView release];
    [_hsCard release];
    [super dealloc];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setAttributes];
    [self configurePrimaryImageView];
}

- (void)setAttributes {
    self.modalPresentationStyle = UIModalPresentationCustom;
    self.transitioningDelegate = self;
    self.view.backgroundColor = UIColor.clearColor;
    
    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(triggeredVViewTapGesgure:)];
    [self.view addGestureRecognizer:gesture];
    [gesture release];
}

- (void)triggeredVViewTapGesgure:(UITapGestureRecognizer *)sender {
    [self dismissViewControllerAnimated:YES completion:^{}];
}

- (void)configurePrimaryImageView {
    UIImageView *primaryImageView = [UIImageView new];
    self.primaryImageView = primaryImageView;
    
    primaryImageView.userInteractionEnabled = NO;
    primaryImageView.contentMode = UIViewContentModeScaleAspectFit;
    
    if (self.sourceImageView.image) {
        primaryImageView.image = self.sourceImageView.image;
    } else {
        [primaryImageView setAsyncImageWithURL:self.hsCard.image indicator:YES];
    }
    
    [primaryImageView release];
}

#pragma mark - UIViewControllerTransitioningDelegate
- (UIPresentationController *)presentationControllerForPresentedViewController:(UIViewController *)presented presentingViewController:(UIViewController *)presenting sourceViewController:(UIViewController *)source {
    DynamicViewPresentationController *pc = [[DynamicViewPresentationController alloc] initWithPresentedViewController:presented
                                                                                              presentingViewController:presenting
                                                                                                            sourceView:self.sourceImageView
                                                                                                            targetView:self.primaryImageView
                                                                                                       destinationRect:CGRectMake(30, 70, 400, 400)];
    
    return [pc autorelease];
}

@end
