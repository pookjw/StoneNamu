//
//  NSTableViewDiffableDataSource+Private.h
//  StoneNamu
//
//  Created by Jinwoo Kim on 11/28/21.
//

#import <Cocoa/Cocoa.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSTableViewDiffableDataSource (Private)
- (void)applySnapshot:(NSDiffableDataSourceSnapshot *)snapshot animatingDifferences:(BOOL)animatingDifferences completion:(void(^ _Nullable)(void))completion;
@end

NS_ASSUME_NONNULL_END
