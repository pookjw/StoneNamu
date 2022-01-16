//
//  ClickableCollectionViewItem.h
//  StoneNamuMac
//
//  Created by Jinwoo Kim on 11/19/21.
//

#import <Cocoa/Cocoa.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_OPTIONS(NSUInteger, ClickableCollectionViewItemAppearanceType) {
    ClickableCollectionViewItemAppearanceTypeClicked = 1 << 0,
    ClickableCollectionViewItemAppearanceTypeSelected = 1 << 1,
    ClickableCollectionViewItemAppearanceTypeHighlighted = 1 << 2
};

@interface ClickableCollectionViewItem : NSCollectionViewItem
@property ClickableCollectionViewItemAppearanceType appearanceTypes;
@property (getter=isClicked, nonatomic) BOOL clicked;
@end

NS_ASSUME_NONNULL_END
