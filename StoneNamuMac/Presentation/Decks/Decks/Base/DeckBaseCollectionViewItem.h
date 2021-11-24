//
//  DeckBaseCollectionViewItem.h
//  StoneNamuMac
//
//  Created by Jinwoo Kim on 11/25/21.
//

#import <Cocoa/Cocoa.h>
#import "SelectedBackgroundCollectionViewCell.h"

NS_ASSUME_NONNULL_BEGIN

@interface DeckBaseCollectionViewItem : SelectedBackgroundCollectionViewCell
- (void)configureWithText:(NSString *)text;
@end

NS_ASSUME_NONNULL_END
