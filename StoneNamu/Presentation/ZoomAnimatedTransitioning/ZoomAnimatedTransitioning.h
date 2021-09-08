//
//  ZoomAnimatedTransitioning.h
//  ZoomAnimatedTransitioning
//
//  Created by Jinwoo Kim on 9/8/21.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZoomAnimatedTransitioning : NSObject <UIViewControllerAnimatedTransitioning>
+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithAnimateForPresenting:(BOOL)animateForPresenting;
@end

NS_ASSUME_NONNULL_END
