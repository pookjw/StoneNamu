//
//  UINavigationController+completion.m
//  StoneNamu
//
//  Created by Jinwoo Kim on 2/26/22.
//

#import "UINavigationController+completion.h"

@implementation UINavigationController (completion)

- (void)setViewControllers:(NSArray<UIViewController *> *)viewControllers animated:(BOOL)animated completion:(void (^)(void))completion {
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

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated completion:(void (^)(void))completion {
    [self pushViewController:viewController animated:animated];
    
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
