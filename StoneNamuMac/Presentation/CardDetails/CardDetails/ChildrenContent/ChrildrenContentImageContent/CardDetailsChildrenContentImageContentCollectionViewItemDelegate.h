//
//  CardDetailsChildrenContentImageContentCollectionViewItemDelegate.h
//  StoneNamu
//
//  Created by Jinwoo Kim on 11/23/21.
//

#import <Cocoa/Cocoa.h>

@class CardDetailsChildrenContentImageContentCollectionViewItem;

NS_ASSUME_NONNULL_BEGIN

@protocol CardDetailsChildrenContentImageContentCollectionViewItemDelegate <NSObject>
- (void)cardDetailsChildrenContentImageContentCollectionViewItem:(CardDetailsChildrenContentImageContentCollectionViewItem *)cardDetailsChildrenContentImageContentCollectionViewItem didDoubleClickWithRecognizer:(NSClickGestureRecognizer *)recognizer;
@end

NS_ASSUME_NONNULL_END
