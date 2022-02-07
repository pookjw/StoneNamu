//
//  DeckImageRenderServiceCardCollectionViewItem.h
//  StoneNamuMac
//
//  Created by Jinwoo Kim on 1/3/22.
//

#import <Cocoa/Cocoa.h>
#import <StoneNamuCore/StoneNamuCore.h>

NS_ASSUME_NONNULL_BEGIN

@interface DeckImageRenderServiceCardCollectionViewItem : NSCollectionViewItem
- (void)configureWithHSCard:(HSCard *)hsCard hsCardImage:(NSImage *)haCardImage raritySlug:(HSCardRaritySlugType)raritySlug hsCardCount:(NSUInteger)hsCardCount;
@end

NS_ASSUME_NONNULL_END
