//
//  CardOptionsViewControllerDelegate.h
//  CardOptionsViewControllerDelegate
//
//  Created by Jinwoo Kim on 8/16/21.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class CardOptionsViewController;

typedef void (^CardOptionsViewControllerDelegateDefaultOptionsIsNeededCompletion)(NSDictionary<NSString *, NSString *> *options);

@protocol CardOptionsViewControllerDelegate <NSObject>
- (void)cardOptionsViewController:(CardOptionsViewController *)viewController doneWithOptions:(NSDictionary<NSString *, NSString *> *)options;
- (void)cardOptionsViewController:(CardOptionsViewController *)viewController defaultOptionsIsNeededWithCompletion:(CardOptionsViewControllerDelegateDefaultOptionsIsNeededCompletion)completion;
@end

NS_ASSUME_NONNULL_END
