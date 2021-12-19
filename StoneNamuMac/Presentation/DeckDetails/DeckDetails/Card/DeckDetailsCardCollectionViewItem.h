//
//  DeckDetailsCardCollectionViewItem.h
//  StoneNamuMac
//
//  Created by Jinwoo Kim on 12/12/21.
//

#import "SelectedBackgroundCollectionViewItem.h"
#import "DeckDetailsCardCollectionViewItemDelegate.h"
#import <StoneNamuCore/StoneNamuCore.h>

NS_ASSUME_NONNULL_BEGIN

@interface DeckDetailsCardCollectionViewItem : SelectedBackgroundCollectionViewItem
- (void)configureWithHSCard:(HSCard *)hsCard hsCardCount:(NSUInteger)hsCardCount delegate:(id<DeckDetailsCardCollectionViewItemDelegate>)delegate;
@end

NS_ASSUME_NONNULL_END
