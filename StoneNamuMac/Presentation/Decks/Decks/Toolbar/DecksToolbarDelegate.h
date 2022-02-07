//
//  DecksToolbarDelegate.h
//  StoneNamu
//
//  Created by Jinwoo Kim on 11/26/21.
//

#import <Cocoa/Cocoa.h>
#import <StoneNamuCore/StoneNamuCore.h>

NS_ASSUME_NONNULL_BEGIN

@class DecksToolbar;

@protocol DecksToolbarDelegate <NSObject>
- (void)decksToolbar:(DecksToolbar *)decksToolbar createNewDeckWithDeckFormat:(HSDeckFormat)deckFormat classSlug:(NSString *)classSlug;
- (void)decksToolbar:(DecksToolbar *)decksToolbar createNewDeckFromDeckCodeWithIdentifier:(NSTouchBarItemIdentifier)identifier;
@end

NS_ASSUME_NONNULL_END
