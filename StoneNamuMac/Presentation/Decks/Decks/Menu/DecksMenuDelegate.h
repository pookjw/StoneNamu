//
//  DecksMenuDelegate.h
//  StoneNamu
//
//  Created by Jinwoo Kim on 11/27/21.
//

#import <Cocoa/Cocoa.h>
#import <StoneNamuCore/StoneNamuCore.h>

NS_ASSUME_NONNULL_BEGIN

@class DecksMenu;

@protocol DecksMenuDelegate <NSObject>
- (void)decksMenu:(DecksMenu *)decksMenu createNewDeckWithDeckFormat:(HSDeckFormat)deckFormat classSlug:(NSString *)classSlug;
- (void)decksMenu:(DecksMenu *)decksMenu createNewDeckFromDeckCodeWithIdentifier:(NSUserInterfaceItemIdentifier)identifier;
@end

NS_ASSUME_NONNULL_END
