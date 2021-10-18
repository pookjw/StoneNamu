//
//  FloatingPresentationController.h
//  StoneNamu
//
//  Created by Jinwoo Kim on 10/18/21.
//

#import <UIKit/UIKit.h>

# define FLOATINGPRESENTATIONCONTROLLER_CORNERRADIUS 25.0f

NS_ASSUME_NONNULL_BEGIN

@interface FloatingPresentationController : UIPresentationController
+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithPresentedViewController:(UIViewController *)presentedViewController presentingViewController:(nullable UIViewController *)presentingViewController NS_UNAVAILABLE;
- (instancetype)initWithPresentedViewController:(UIViewController *)presentedViewController
                       presentingViewController:(UIViewController *)presentingViewController
                                 backgroundView:(UIView *)backgroundView;
@end

NS_ASSUME_NONNULL_END
