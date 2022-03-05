//
//  UICollectionViewDiffableDataSource+applySnapshotAndWait.h
//  StoneNamuWatch WatchKit Extension
//
//  Created by Jinwoo Kim on 3/6/22.
//

#import "UICollectionViewDiffableDataSource.h"

NS_ASSUME_NONNULL_BEGIN

@interface UICollectionViewDiffableDataSource (applySnapshotAndWait)
- (void)applySnapshotAndWait:(id)snapshot animatingDifferences:(BOOL)animatingDifferences completion:(void(^ _Nullable)(void))completion NS_SWIFT_DISABLE_ASYNC UIKIT_SWIFT_ACTOR_INDEPENDENT;
- (void)applySnapshotUsingReloadDataAndWait:(id)snapshot completion:(void (^)(void))completion  NS_SWIFT_DISABLE_ASYNC UIKIT_SWIFT_ACTOR_INDEPENDENT;
@end

NS_ASSUME_NONNULL_END
