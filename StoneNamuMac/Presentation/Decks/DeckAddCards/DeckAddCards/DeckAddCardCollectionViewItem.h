//
//  DeckAddCardCollectionViewItem.h
//  StoneNamuMac
//
//  Created by Jinwoo Kim on 12/3/21.
//

#import "ClickableCollectionViewItem.h"
#import "DeckAddCardCollectionViewItemDelegate.h"
#import <StoneNamuCore/StoneNamuCore.h>

NS_ASSUME_NONNULL_BEGIN

@interface DeckAddCardCollectionViewItem : ClickableCollectionViewItem
@property (readonly, nonatomic) NSImage * _Nullable cardImage;
@property (readonly, copy) HSCard * _Nullable hsCard;
- (void)configureWithHSCard:(HSCard *)hsCard count:(NSUInteger)count isLegendary:(BOOL)isLegendary delegate:(nonnull id<DeckAddCardCollectionViewItemDelegate>)delegate;
@end

NS_ASSUME_NONNULL_END
