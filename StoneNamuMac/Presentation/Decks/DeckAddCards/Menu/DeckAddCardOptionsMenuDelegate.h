//
//  DeckAddCardOptionsMenuDelegate.h
//  StoneNamu
//
//  Created by Jinwoo Kim on 12/3/21.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class DeckAddCardOptionsMenu;

@protocol DeckAddCardOptionsMenuDelegate <NSObject>
- (void)deckAddCardOptionsMenu:(DeckAddCardOptionsMenu *)menu changedOption:(NSDictionary<NSString *, NSSet<NSString *> *> *)options;
- (void)deckAddCardOptionsMenu:(DeckAddCardOptionsMenu *)menu defaultOptionsAreNeedWithSender:(NSMenuItem *)sender;
@end

NS_ASSUME_NONNULL_END
