//
//  DeckAddCardCollectionViewItem.h
//  StoneNamuMac
//
//  Created by Jinwoo Kim on 12/3/21.
//

#import "SelectedBackgroundCollectionViewItem.h"
#import "DeckAddCardCollectionViewItemDelegate.h"
#import <StoneNamuCore/StoneNamuCore.h>

NS_ASSUME_NONNULL_BEGIN

@interface DeckAddCardCollectionViewItem : SelectedBackgroundCollectionViewItem
- (void)configureWithHSCard:(HSCard *)hsCard count:(NSUInteger)count delegate:(nonnull id<DeckAddCardCollectionViewItemDelegate>)delegate;
@end

NS_ASSUME_NONNULL_END
