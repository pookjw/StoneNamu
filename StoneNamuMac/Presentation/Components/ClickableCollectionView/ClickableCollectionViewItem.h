//
//  ClickableCollectionViewItem.h
//  StoneNamuMac
//
//  Created by Jinwoo Kim on 11/19/21.
//

#import <Cocoa/Cocoa.h>

NS_ASSUME_NONNULL_BEGIN

@interface ClickableCollectionViewItem : NSCollectionViewItem
@property (getter=isClicked, nonatomic) BOOL clicked;
@end

NS_ASSUME_NONNULL_END
