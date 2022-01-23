//
//  DeckDetailsCardCollectionViewItemDelegate.h
//  StoneNamu
//
//  Created by Jinwoo Kim on 12/19/21.
//

#import <Cocoa/Cocoa.h>

@class DeckDetailsCardCollectionViewItem;

@protocol DeckDetailsCardCollectionViewItemDelegate <NSObject>
- (void)deckDetailsCardCollectionViewItem:(DeckDetailsCardCollectionViewItem *)deckDetailsCardCollectionViewItem didDoubleClickWithRecognizer:(NSClickGestureRecognizer *)recognizer;
@end
