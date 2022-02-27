//
//  ClickableCollectionView.h
//  StoneNamuMac
//
//  Created by Jinwoo Kim on 12/19/21.
//

#import <Cocoa/Cocoa.h>

NS_ASSUME_NONNULL_BEGIN

@interface ClickableCollectionView : NSCollectionView
@property (readonly, copy) NSIndexPath * _Nullable clickedIndexPath;
@property (readonly, nonatomic) NSSet<NSIndexPath *> *interactingIndexPaths;
@end

NS_ASSUME_NONNULL_END
