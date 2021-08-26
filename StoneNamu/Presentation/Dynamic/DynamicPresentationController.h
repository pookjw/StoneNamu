//
//  DynamicPresentationController.h
//  DynamicPresentationController
//
//  Created by Jinwoo Kim on 8/2/21.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface DynamicPresentationController : UIPresentationController
- (instancetype)initWithPresentedViewController:(UIViewController *)presentedViewController
                       presentingViewController:(UIViewController *)presentingViewController
                                     sourceView:(UIView * _Nullable)sourceView
                                     targetView:(UIView *)targetView
                                destinationRect:(CGRect)destinationRect;
@end

NS_ASSUME_NONNULL_END
