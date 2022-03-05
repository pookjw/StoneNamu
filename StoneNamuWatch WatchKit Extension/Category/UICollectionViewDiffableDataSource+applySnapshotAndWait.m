//
//  UICollectionViewDiffableDataSource+applySnapshotAndWait.m
//  StoneNamuWatch WatchKit Extension
//
//  Created by Jinwoo Kim on 3/6/22.
//

#import "UICollectionViewDiffableDataSource+applySnapshotAndWait.h"
#import <StoneNamuCore/StoneNamuCore.h>

@implementation UICollectionViewDiffableDataSource (applySnapshotAndWait)

- (void)applySnapshotAndWait:(NSDiffableDataSourceSnapshot *)snapshot animatingDifferences:(BOOL)animatingDifferences completion:(void (^)(void))completion {
    SemaphoreCondition * _Nullable semaphore = nil;
    
    if (!NSThread.isMainThread) {
        semaphore = [[SemaphoreCondition alloc] initWithValue:0];
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

- (void)applySnapshotUsingReloadDataAndWait:(NSDiffableDataSourceSnapshot *)snapshot completion:(void (^)(void))completion {
    SemaphoreCondition * _Nullable semaphore = nil;
    
    if (!NSThread.isMainThread) {
        semaphore = [[SemaphoreCondition alloc] initWithValue:0];
    }
    
    [NSOperationQueue.mainQueue addOperationWithBlock:^{
        [self applySnapshotUsingReloadData:snapshot completion:^{
            completion();
            [semaphore signal];
        }];
    }];
    
    [semaphore wait];
    [semaphore release];
}

@end
