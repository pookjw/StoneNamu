//
//  NSCollectionViewDiffableDataSource+applySnapshotAndWait.m
//  NSCollectionViewDiffableDataSource+applySnapshotAndWait
//
//  Created by Jinwoo Kim on 9/26/21.
//

#import "NSCollectionViewDiffableDataSource+applySnapshotAndWait.h"
#import <StoneNamuCore/StoneNamuCore.h>
#import "NSCollectionViewDiffableDataSource+Private.h"

@implementation NSCollectionViewDiffableDataSource (applySnapshotAndWait)

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
