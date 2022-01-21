//
//  DeckBaseCollectionViewItem.h
//  StoneNamuMac
//
//  Created by Jinwoo Kim on 11/25/21.
//

#import <Cocoa/Cocoa.h>
#import "ClickableCollectionViewItem.h"
#import "DeckBaseCollectionViewItemDelegate.h"
#import <StoneNamuCore/StoneNamuCore.h>

NS_ASSUME_NONNULL_BEGIN

@interface DeckBaseCollectionViewItem : ClickableCollectionViewItem
@property (readonly) LocalDeck * _Nullable localDeck;
- (void)configureWithLocalDeck:(LocalDeck *)localDeck isEasterEgg:(BOOL)isEasterEgg deckBaseCollectionViewItemDelegate:(id<DeckBaseCollectionViewItemDelegate>)deckBaseCollectionViewItemDelegate;
@end

NS_ASSUME_NONNULL_END
