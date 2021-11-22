//
//  CardDetailsChildrenContentImageContentCollectionViewItem.h
//  StoneNamuMac
//
//  Created by Jinwoo Kim on 11/22/21.
//

#import <Cocoa/Cocoa.h>
#import <StoneNamuCore/StoneNamuCore.h>
#import "SelectedBackgroundCollectionViewCell.h"
#import "CardDetailsChildrenContentImageContentCollectionViewItemDelegate.h"

NS_ASSUME_NONNULL_BEGIN

@interface CardDetailsChildrenContentImageContentCollectionViewItem : SelectedBackgroundCollectionViewCell
- (void)configureWithHSCard:(HSCard *)hsCard delegate:(id<CardDetailsChildrenContentImageContentCollectionViewItemDelegate>)delegate;
@end

NS_ASSUME_NONNULL_END