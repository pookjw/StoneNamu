//
//  CardDetailsChildCollectionViewItemDelegate.h
//  StoneNamu
//
//  Created by Jinwoo Kim on 11/23/21.
//

#import <Cocoa/Cocoa.h>

@class CardDetailsChildCollectionViewItem;

NS_ASSUME_NONNULL_BEGIN

@protocol CardDetailsChildCollectionViewItemDelegate <NSObject>
- (void)cardDetailsChildrenContentImageContentCollectionViewItem:(CardDetailsChildCollectionViewItem *)cardDetailsChildrenContentImageContentCollectionViewItem didDoubleClickWithRecognizer:(NSClickGestureRecognizer *)recognizer;
@end

NS_ASSUME_NONNULL_END
