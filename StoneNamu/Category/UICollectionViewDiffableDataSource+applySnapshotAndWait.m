//
//  UICollectionViewDiffableDataSource+applySnapshotAndWait.m
//  StoneNamu
//
//  Created by Jinwoo Kim on 9/19/21.
//

#import "UICollectionViewDiffableDataSource+applySnapshotAndWait.h"
#import <StoneNamuCore/StoneNamuCore.h>

@implementation UICollectionViewDiffableDataSource (applySnapshotAndWait)

- (void)applySnapshotAndWait:(NSDiffableDataSourceSnapshot *)snapshot animatingDifferences:(BOOL)animatingDifferences completion:(void (^)(void))completion {
    NSSemaphoreCondition * _Nullable semaphore = nil;
    
    if (!NSThread.isMainThread) {
        semaphore = [[NSSemaphoreCondition alloc] initWithValue:0];
    }
    
    [NSOperationQueue.mainQueue addOperationWithBlock:^{
        [self applySnapshot:snapshot animatingDifferences:animatingDifferences completion:^{
            completion();
            [semaphore signal];
        }];
    }];
    
    [semaphore wait];
    [semaphore release];
}

@end
