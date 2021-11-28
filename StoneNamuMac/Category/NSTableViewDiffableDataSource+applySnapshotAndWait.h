//
//  NSTableViewDiffableDataSource+applySnapshotAndWait.h
//  StoneNamu
//
//  Created by Jinwoo Kim on 11/28/21.
//

#import <Cocoa/Cocoa.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSTableViewDiffableDataSource (applySnapshotAndWait)
- (void)applySnapshotAndWait:(NSDiffableDataSourceSnapshot *)snapshot animatingDifferences:(BOOL)animatingDifferences completion:(void(^ _Nullable)(void))completion NS_SWIFT_DISABLE_ASYNC;
@end

NS_ASSUME_NONNULL_END
