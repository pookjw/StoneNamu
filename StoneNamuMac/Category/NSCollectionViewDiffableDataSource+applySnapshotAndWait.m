//
//  NSCollectionViewDiffableDataSource+applySnapshotAndWait.m
//  NSCollectionViewDiffableDataSource+applySnapshotAndWait
//
//  Created by Jinwoo Kim on 9/26/21.
//

#import "NSCollectionViewDiffableDataSource+applySnapshotAndWait.h"
#import <StoneNamuCore/StoneNamuCore.h>
#import "NSCollectionViewDiffableDataSource+Private.h"
#import "NSProcessInfo+isEnabledThreadSleepAtDDS.h"

@implementation NSCollectionViewDiffableDataSource (applySnapshotAndWait)

- (void)applySnapshotAndWait:(NSDiffableDataSourceSnapshot *)snapshot animatingDifferences:(BOOL)animatingDifferences completion:(void (^)(void))completion {
    SemaphoreCondition * _Nullable semaphore = nil;
    
    if (!NSThread.isMainThread) {
        semaphore = [[SemaphoreCondition alloc] initWithValue:0];
    }
    
    [NSOperationQueue.mainQueue addOperationWithBlock:^{
        [self applySnapshot:snapshot animatingDifferences:animatingDifferences completion:^{
            completion();
            if (NSProcessInfo.processInfo.isEnabledThreadSleepAtDDS) {
                [semaphore signal];
            }
        }];
    }];
    
    if (NSProcessInfo.processInfo.isEnabledThreadSleepAtDDS) {
        [semaphore wait];
    }
    [semaphore release];
}

@end
