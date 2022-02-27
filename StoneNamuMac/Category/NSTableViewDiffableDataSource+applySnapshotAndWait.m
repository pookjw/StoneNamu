//
//  NSTableViewDiffableDataSource+applySnapshotAndWait.m
//  StoneNamuMac
//
//  Created by Jinwoo Kim on 11/28/21.
//

#import "NSTableViewDiffableDataSource+applySnapshotAndWait.h"
#import <StoneNamuCore/StoneNamuCore.h>
#import "NSTableViewDiffableDataSource+Private.h"

@implementation NSTableViewDiffableDataSource (applySnapshotAndWait)

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

@end
