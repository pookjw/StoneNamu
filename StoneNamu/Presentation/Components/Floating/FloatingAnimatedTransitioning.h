//
//  FloatingAnimatedTransitioning.h
//  FloatingAnimatedTransitioning
//
//  Created by Jinwoo Kim on 9/8/21.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface FloatingAnimatedTransitioning : NSObject <UIViewControllerAnimatedTransitioning>
+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithAnimateForPresenting:(BOOL)animateForPresenting maxWidth:(CGFloat)maxWidth;
- (instancetype)initWithAnimateForPresenting:(BOOL)animateForPresenting maxHeight:(CGFloat)maxHeight;
- (instancetype)initWithAnimateForPresenting:(BOOL)animateForPresenting maxWidth:(CGFloat)maxWidth maxHeight:(CGFloat)maxHeight;
@end

NS_ASSUME_NONNULL_END
