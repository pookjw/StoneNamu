//
//  DeckAddCardCollectionViewItemDelegate.h
//  StoneNamu
//
//  Created by Jinwoo Kim on 12/3/21.
//

#import <Cocoa/Cocoa.h>

@class DeckAddCardCollectionViewItem;

NS_ASSUME_NONNULL_BEGIN

@protocol DeckAddCardCollectionViewItemDelegate <NSObject>
- (void)deckAddCardCollectionViewItem:(DeckAddCardCollectionViewItem *)deckAddCardCollectionViewItem didClickWithRecognizer:(NSClickGestureRecognizer *)recognizer;
@end

NS_ASSUME_NONNULL_END
