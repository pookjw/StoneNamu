//
//  CardDetailsViewController.m
//  CardDetailsViewController
//
//  Created by Jinwoo Kim on 8/2/21.
//

#import "CardDetailsViewController.h"
#import "DynamicViewPresentationController.h"

@interface CardDetailsViewController () <UIViewControllerTransitioningDelegate>
@property (retain) UIImageView *cardImageView;
@end

@implementation CardDetailsViewController

- (instancetype)initWithCardImageView:(UIImageView *)cardImageView {
    self = [self init];
    
    if (self) {
        self.cardImageView = cardImageView;
    }
    
    return self;
}

- (void)dealloc {
    [_cardImageView release];
    [super dealloc];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setAttributes];
}

- (void)dismissViewControllerAnimated:(BOOL)flag completion:(void (^)(void))completion {
    [super dismissViewControllerAnimated:flag completion:^(){
        completion();
        [self.delegate cardDetailsViewControllerDidDismiss:self cardImageView:self.cardImageView];
    }];
}

- (void)setAttributes {
    self.modalPresentationStyle = UIModalPresentationCustom;
    self.transitioningDelegate = self;
    self.view.backgroundColor = UIColor.clearColor;
    self.view.userInteractionEnabled = NO;
}

#pragma mark - UIViewControllerTransitioningDelegate
- (UIPresentationController *)presentationControllerForPresentedViewController:(UIViewController *)presented presentingViewController:(UIViewController *)presenting sourceViewController:(UIViewController *)source {
    DynamicViewPresentationController *pc = [[DynamicViewPresentationController alloc] initWithPresentedViewController:presented presentingViewController:presenting dynamicView:self.cardImageView destinationRect:CGRectMake(0, 0, 800, 800)];
    
    return [pc autorelease];
}

@end
