//
//  DeckBaseCollectionViewItemDelegate.h
//  StoneNamu
//
//  Created by Jinwoo Kim on 11/28/21.
//

#import <Cocoa/Cocoa.h>

@class DeckBaseCollectionViewItem;

NS_ASSUME_NONNULL_BEGIN

@protocol DeckBaseCollectionViewItemDelegate <NSObject>
- (void)deckBaseCollectionViewItem:(DeckBaseCollectionViewItem *)deckBaseCollectionViewItem didDoubleClickWithRecognizer:(NSClickGestureRecognizer *)recognizer;
@end

NS_ASSUME_NONNULL_END
