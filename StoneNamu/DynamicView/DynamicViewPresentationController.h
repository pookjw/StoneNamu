//
//  DynamicViewPresentationController.h
//  DynamicViewPresentationController
//
//  Created by Jinwoo Kim on 8/2/21.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface DynamicViewPresentationController : UIPresentationController

- (instancetype)initWithPresentedViewController:(UIViewController *)presentedViewController
                       presentingViewController:(UIViewController *)presentingViewController
                                    dynamicView:(UIView *)dynamicView
                                destinationRect:(CGRect)destinationRect;

@end

NS_ASSUME_NONNULL_END
