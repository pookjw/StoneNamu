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
- (void)deckAddCardOptionsMenu:(DeckAddCardOptionsMenu *)menu changedOption:(NSDictionary<NSString *, NSString *> *)options;
@end

NS_ASSUME_NONNULL_END
