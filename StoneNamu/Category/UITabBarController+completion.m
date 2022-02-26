//
//  UITabBarController+completion.m
//  StoneNamu
//
//  Created by Jinwoo Kim on 2/26/22.
//

#import "UITabBarController+completion.h"

@implementation UITabBarController (completion)

- (void)setViewControllers:(NSArray<__kindof UIViewController *> *)viewControllers animated:(BOOL)animated completion:(void (^)(void))completion {
    [self setViewControllers:viewControllers animated:animated];
    
    id<UIViewControllerTransitionCoordinator> _Nullable transitionCoordinator = self.transitionCoordinator;
    
    if ((animated) && (transitionCoordinator)) {
        [transitionCoordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext>  _Nonnull context) {
            
        } completion:^(id<UIViewControllerTransitionCoordinatorContext>  _Nonnull context) {
            completion();
        }];
    } else {
        completion();
    }
}

@end
