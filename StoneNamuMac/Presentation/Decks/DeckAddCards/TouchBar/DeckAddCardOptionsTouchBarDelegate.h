//
//  DeckAddCardOptionsTouchBarDelegate.h
//  StoneNamu
//
//  Created by Jinwoo Kim on 12/3/21.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class DeckAddCardOptionsTouchBar;

@protocol DeckAddCardOptionsTouchBarDelegate <NSObject>
- (void)deckAddCardOptionsTouchBar:(DeckAddCardOptionsTouchBar *)touchBar changedOption:(NSDictionary<NSString *, NSSet<NSString *> *> *)options;
@end

NS_ASSUME_NONNULL_END
