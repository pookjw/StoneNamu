//
//  UIViewController+targetedPreviewWithClearBackgroundForView.h
//  UIViewController+targetedPreviewWithClearBackgroundForView
//
//  Created by Jinwoo Kim on 9/3/21.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIViewController (targetedPreviewWithClearBackgroundForView)
- (UITargetedPreview *)targetedPreviewWithClearBackgroundForView:(UIView *)view;
@end

NS_ASSUME_NONNULL_END
