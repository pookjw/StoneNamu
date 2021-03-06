//
//  DeckImageRenderServiceIntroCollectionViewItem.h
//  StoneNamuMac
//
//  Created by Jinwoo Kim on 1/3/22.
//

#import <Cocoa/Cocoa.h>
#import <StoneNamuCore/StoneNamuCore.h>

NS_ASSUME_NONNULL_BEGIN

static NSUserInterfaceItemIdentifier const NSUserInterfaceItemIdentifierDeckImageRenderServiceIntroCollectionViewItem = @"NSUserInterfaceItemIdentifierDeckImageRenderServiceIntroCollectionViewItem";

@interface DeckImageRenderServiceIntroCollectionViewItem : NSCollectionViewItem
- (void)configureWithClassSlug:(NSString *)classSlug className:(NSString *)className deckName:(NSString *)deckName deckFormat:(HSDeckFormat)deckFormat isEasterEgg:(BOOL)isEasterEgg;
@end

NS_ASSUME_NONNULL_END
