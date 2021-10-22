//
//  MainSplitViewController.h
//  MainSplitViewController
//
//  Created by Jinwoo Kim on 10/15/21.
//

#import <UIKit/UIKit.h>
#import "MainLayoutProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@interface MainSplitViewController : UISplitViewController <MainLayoutProtocol>
- (instancetype)initWithStyle:(UISplitViewControllerStyle)style NS_UNAVAILABLE;
@end

NS_ASSUME_NONNULL_END
