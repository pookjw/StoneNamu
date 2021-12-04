//
//  DeckBaseCollectionViewItem.h
//  StoneNamuMac
//
//  Created by Jinwoo Kim on 11/25/21.
//

#import <Cocoa/Cocoa.h>
#import "SelectedBackgroundCollectionViewItem.h"
#import "DeckBaseCollectionViewItemDelegate.h"
#import <StoneNamuCore/StoneNamuCore.h>

NS_ASSUME_NONNULL_BEGIN

@interface DeckBaseCollectionViewItem : SelectedBackgroundCollectionViewItem
@property (readonly) LocalDeck * _Nullable localDeck;
- (void)configureWithLocalDeck:(LocalDeck *)localDeck deckBaseCollectionViewItemDelegate:(id<DeckBaseCollectionViewItemDelegate>)deckBaseCollectionViewItemDelegate;
@end

NS_ASSUME_NONNULL_END
