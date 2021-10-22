//
//  DynamicAnimatedTransitioning.h
//  DynamicAnimatedTransitioning
//
//  Created by Jinwoo Kim on 10/19/21.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface DynamicAnimatedTransitioning : NSObject <UIViewControllerAnimatedTransitioning>
+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithIsPresenting:(BOOL)isPresenting;
@end

NS_ASSUME_NONNULL_END
