//
//  DeckDetailsCardCollectionViewItem.h
//  StoneNamuMac
//
//  Created by Jinwoo Kim on 12/12/21.
//

#import "ClickableCollectionViewItem.h"
#import "DeckDetailsCardCollectionViewItemDelegate.h"
#import <StoneNamuCore/StoneNamuCore.h>

NS_ASSUME_NONNULL_BEGIN

@interface DeckDetailsCardCollectionViewItem : ClickableCollectionViewItem
- (void)configureWithHSCard:(HSCard *)hsCard isLegendary:(BOOL)isLegendary hsCardCount:(NSUInteger)hsCardCount delegate:(id<DeckDetailsCardCollectionViewItemDelegate>)delegate;
@end

NS_ASSUME_NONNULL_END
