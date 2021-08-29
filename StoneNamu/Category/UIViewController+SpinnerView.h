//
//  UIViewController+SpinnerView.h
//  UIViewController+SpinnerView
//
//  Created by Jinwoo Kim on 8/29/21.
//

#import <UIKit/UIKit.h>
#import "SpinnerView.h"

NS_ASSUME_NONNULL_BEGIN

@interface UIViewController (SpinnerView)
- (SpinnerView *)addSpinnerView;
- (SpinnerView *)addSpinnerViewWithPreventTouch:(BOOL)preventTouch;
- (void)removeAllSpinnerview;
@end

NS_ASSUME_NONNULL_END
