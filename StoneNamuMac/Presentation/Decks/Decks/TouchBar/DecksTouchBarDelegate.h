//
//  DecksTouchBarDelegate.h
//  StoneNamu
//
//  Created by Jinwoo Kim on 11/26/21.
//

#import <Cocoa/Cocoa.h>
#import <StoneNamuCore/StoneNamuCore.h>

NS_ASSUME_NONNULL_BEGIN

@class DecksTouchBar;

@protocol DecksTouchBarDelegate <NSObject>
- (void)decksTouchBar:(DecksTouchBar *)touchBar createNewDeckWithDeckFormat:(HSDeckFormat)deckFormat classSlug:(NSString *)classSlug;
- (void)decksTouchBar:(DecksTouchBar *)touchBar createNewDeckFromDeckCodeWithIdentifier:(NSTouchBarItemIdentifier)identifier;
@end

NS_ASSUME_NONNULL_END
