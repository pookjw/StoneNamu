//
//  UITabBarController+completion.h
//  StoneNamu
//
//  Created by Jinwoo Kim on 2/26/22.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UITabBarController (completion)
- (void)setViewControllers:(NSArray<__kindof UIViewController *> *)viewControllers animated:(BOOL)animated completion:(void (^)(void))completion;
@end

NS_ASSUME_NONNULL_END
