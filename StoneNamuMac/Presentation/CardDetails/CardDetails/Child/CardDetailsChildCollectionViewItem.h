//
//  CardDetailsChildCollectionViewItem.h
//  StoneNamuMac
//
//  Created by Jinwoo Kim on 11/22/21.
//

#import <Cocoa/Cocoa.h>
#import <StoneNamuCore/StoneNamuCore.h>
#import "ClickableCollectionViewItem.h"
#import "CardDetailsChildCollectionViewItemDelegate.h"

NS_ASSUME_NONNULL_BEGIN

@interface CardDetailsChildCollectionViewItem : ClickableCollectionViewItem
- (void)configureWithHSCard:(HSCard *)hsCard delegate:(id<CardDetailsChildCollectionViewItemDelegate>)delegate;
@end

NS_ASSUME_NONNULL_END
