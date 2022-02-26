//
//  BattlegroundsCardOptionsViewControllerDelegate.h
//  StoneNamu
//
//  Created by Jinwoo Kim on 2/26/22.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class BattlegroundsCardOptionsViewController;

typedef void (^BattlegroundsCardOptionsViewControllerDelegateDefaultOptionsAreNeededCompletion)(NSDictionary<NSString *, NSSet<NSString *> *> *options);

@protocol BattlegroundsCardOptionsViewControllerDelegate <NSObject>
- (void)battlegroundsCardOptionsViewController:(BattlegroundsCardOptionsViewController *)viewController doneWithOptions:(NSDictionary<NSString *, NSSet<NSString *> *> *)options;
- (void)battlegroundsCardOptionsViewController:(BattlegroundsCardOptionsViewController *)viewController defaultOptionsAreNeededWithCompletion:(BattlegroundsCardOptionsViewControllerDelegateDefaultOptionsAreNeededCompletion)completion;
@end

NS_ASSUME_NONNULL_END
