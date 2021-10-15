//
//  CardsSplitViewController.h
//  CardsSplitViewController
//
//  Created by Jinwoo Kim on 8/16/21.
//

#import <UIKit/UIKit.h>
#import "HSCardGameMode.h"

NS_ASSUME_NONNULL_BEGIN

@interface CardsOneBesideSecondarySplitViewController : UISplitViewController
+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithHSCardGameMode:(HSCardGameMode)hsCardGameMode;
@end

NS_ASSUME_NONNULL_END
