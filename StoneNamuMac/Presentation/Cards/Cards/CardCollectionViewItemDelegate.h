//
//  CardCollectionViewItemDelegate.h
//  StoneNamu
//
//  Created by Jinwoo Kim on 11/19/21.
//

#import <Cocoa/Cocoa.h>

@class CardCollectionViewItem;

NS_ASSUME_NONNULL_BEGIN

@protocol CardCollectionViewItemDelegate <NSObject>
- (void)cardCollectionViewItem:(CardCollectionViewItem *)cardCollectionViewItem didDoubleClickWithRecognizer:(NSClickGestureRecognizer *)recognizer;
@end

NS_ASSUME_NONNULL_END
