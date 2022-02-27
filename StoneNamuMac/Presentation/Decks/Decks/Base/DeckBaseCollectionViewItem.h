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

static NSUserInterfaceItemIdentifier const NSUserInterfaceItemIdentifierCardDeckBaseCollectionViewItem = @"NSUserInterfaceItemIdentifierCardDeckBaseCollectionViewItem";

@interface DeckBaseCollectionViewItem : ClickableCollectionViewItem
- (void)configureWithLocalDeck:(LocalDeck *)localDeck classSlug:(NSString *)classSlug isEasterEgg:(BOOL)isEasterEgg count:(NSUInteger)count deckBaseCollectionViewItemDelegate:(id<DeckBaseCollectionViewItemDelegate>)deckBaseCollectionViewItemDelegate;
@end

NS_ASSUME_NONNULL_END
