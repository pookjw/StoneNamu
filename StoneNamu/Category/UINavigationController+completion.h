//
//  UINavigationController+completion.h
//  StoneNamu
//
//  Created by Jinwoo Kim on 2/26/22.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UINavigationController (completion)
- (void)setViewControllers:(NSArray<UIViewController *> *)viewControllers animated:(BOOL)animated completion:(void (^)(void))completion;
- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated completion:(void (^)(void))completion;
@end

NS_ASSUME_NONNULL_END
