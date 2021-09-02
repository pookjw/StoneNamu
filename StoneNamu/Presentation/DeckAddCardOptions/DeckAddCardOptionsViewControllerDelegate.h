//
//  DeckAddCardOptionsViewControllerDelegate.h
//  DeckAddCardOptionsViewControllerDelegate
//
//  Created by Jinwoo Kim on 8/16/21.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class DeckAddCardOptionsViewController;

@protocol DeckAddCardOptionsViewControllerDelegate <NSObject>
- (void)deckAddCardOptionsViewController:(DeckAddCardOptionsViewController *)viewController doneWithOptions:(NSDictionary<NSString *, NSString *> *)options;
@end

NS_ASSUME_NONNULL_END
