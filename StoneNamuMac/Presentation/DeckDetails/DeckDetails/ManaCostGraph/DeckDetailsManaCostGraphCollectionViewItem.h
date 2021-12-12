//
//  DeckDetailsManaCostGraphCollectionViewItem.h
//  StoneNamuMac
//
//  Created by Jinwoo Kim on 12/12/21.
//

#import "SelectedBackgroundCollectionViewItem.h"

NS_ASSUME_NONNULL_BEGIN

@interface DeckDetailsManaCostGraphCollectionViewItem : SelectedBackgroundCollectionViewItem
- (void)configureWithManaCost:(NSUInteger)manaCost percentage:(float)percentage cardCount:(NSUInteger)cardCount;
@end

NS_ASSUME_NONNULL_END
