//
//  DeckAddCardOptionsViewControllerDelegate.h
//  DeckAddCardOptionsViewControllerDelegate
//
//  Created by Jinwoo Kim on 8/16/21.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class DeckAddCardOptionsViewController;

typedef void (^DeckAddCardOptionsViewControllerDelegateDefaultOptionsAreNeededCompletion)(NSDictionary<NSString *, NSString *> *options);

@protocol DeckAddCardOptionsViewControllerDelegate <NSObject>
- (void)deckAddCardOptionsViewController:(DeckAddCardOptionsViewController *)viewController doneWithOptions:(NSDictionary<NSString *, NSString *> *)options;
- (void)deckAddCardOptionsViewController:(DeckAddCardOptionsViewController *)viewController defaultOptionsAreNeededWithCompletion:(DeckAddCardOptionsViewControllerDelegateDefaultOptionsAreNeededCompletion)completion;
@end

NS_ASSUME_NONNULL_END
