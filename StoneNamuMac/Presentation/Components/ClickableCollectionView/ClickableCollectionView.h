//
//  ClickableCollectionView.h
//  StoneNamuMac
//
//  Created by Jinwoo Kim on 12/19/21.
//

#import <Cocoa/Cocoa.h>
#import "ClickableCollectionViewDelegate.h"

NS_ASSUME_NONNULL_BEGIN

@interface ClickableCollectionView : NSCollectionView
@property (copy, readonly) NSIndexPath * _Nullable clickedIndexPath;
@end

NS_ASSUME_NONNULL_END
