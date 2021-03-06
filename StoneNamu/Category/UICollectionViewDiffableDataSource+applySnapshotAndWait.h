//
//  UICollectionViewDiffableDataSource+applySnapshotAndWait.h
//  StoneNamu
//
//  Created by Jinwoo Kim on 9/19/21.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UICollectionViewDiffableDataSource (applySnapshotAndWait)
- (void)applySnapshotAndWait:(NSDiffableDataSourceSnapshot *)snapshot animatingDifferences:(BOOL)animatingDifferences completion:(void(^ _Nullable)(void))completion NS_SWIFT_DISABLE_ASYNC UIKIT_SWIFT_ACTOR_INDEPENDENT;
- (void)applySnapshotUsingReloadDataAndWait:(NSDiffableDataSourceSnapshot *)snapshot completion:(void (^)(void))completion  NS_SWIFT_DISABLE_ASYNC UIKIT_SWIFT_ACTOR_INDEPENDENT;
@end

NS_ASSUME_NONNULL_END
