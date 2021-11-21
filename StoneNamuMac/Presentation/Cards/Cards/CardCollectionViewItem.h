//
//  CardCollectionViewItem.h
//  StoneNamuMac
//
//  Created by Jinwoo Kim on 10/24/21.
//

#import <Cocoa/Cocoa.h>
#import <StoneNamuCore/StoneNamuCore.h>
#import "SelectedBackgroundCollectionViewCell.h"
#import "CardCollectionViewItemDelegate.h"

NS_ASSUME_NONNULL_BEGIN

@interface CardCollectionViewItem : SelectedBackgroundCollectionViewCell
- (void)configureWithHSCard:(HSCard *)hsCard delegate:(id<CardCollectionViewItemDelegate>)delegate;
@end

NS_ASSUME_NONNULL_END
