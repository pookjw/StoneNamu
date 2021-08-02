//
//  DynamicViewPresentationController.h
//  DynamicViewPresentationController
//
//  Created by Jinwoo Kim on 8/2/21.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface DynamicViewPresentationController : UIPresentationController
@property CGRect departureRect;
@property CGRect destinationRect;
@property BOOL dynamicAnimating;
- (instancetype)initWithPresentedViewController:(UIViewController *)presentedViewController
                       presentingViewController:(UIViewController *)presentingViewController
                                    dynamicView:(UIView *)dynamicView
                                  departureRect:(CGRect)departureRect
                                destinationRect:(CGRect)destinationRect;

@end

NS_ASSUME_NONNULL_END
