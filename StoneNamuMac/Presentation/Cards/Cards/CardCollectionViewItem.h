//
//  CardCollectionViewItem.h
//  StoneNamuMac
//
//  Created by Jinwoo Kim on 10/24/21.
//

#import "ClickableCollectionViewItem.h"
#import "CardCollectionViewItemDelegate.h"
#import <StoneNamuCore/StoneNamuCore.h>

NS_ASSUME_NONNULL_BEGIN

@interface CardCollectionViewItem : ClickableCollectionViewItem
- (void)configureWithHSCard:(HSCard *)hsCard delegate:(id<CardCollectionViewItemDelegate>)delegate;
@end

NS_ASSUME_NONNULL_END
