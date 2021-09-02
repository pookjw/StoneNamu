//
//  UIViewController+animatedForSelectedIndexPath.m
//  UIViewController+animatedForSelectedIndexPath
//
//  Created by Jinwoo Kim on 8/15/21.
//

#import "UIViewController+animatedForSelectedIndexPath.h"

@implementation UIViewController (animatedForSelectedIndexPath)

- (void)animatedForSelectedIndexPathWithCollectionView:(UICollectionView *)collectionView {
    if (!self.splitViewController.isCollapsed) return;
    
    for (NSIndexPath *indexPath in collectionView.indexPathsForSelectedItems) {
        id<UIViewControllerTransitionCoordinator> coordinator = self.transitionCoordinator;
        
        if (coordinator) {
            [coordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext>  _Nonnull context) {
                [collectionView deselectItemAtIndexPath:indexPath animated:YES];
            } completion:^(id<UIViewControllerTransitionCoordinatorContext>  _Nonnull context) {
                if (context.isCancelled) {
                    [collectionView selectItemAtIndexPath:indexPath animated:YES scrollPosition:UICollectionViewScrollPositionNone];
                }
            }];
        } else {
            [collectionView deselectItemAtIndexPath:indexPath animated:YES];
        }
    }
}

@end
