//
//  MainListViewController.h
//  MainListViewController
//
//  Created by Jinwoo Kim on 9/26/21.
//

#import <Cocoa/Cocoa.h>
#import "MainListViewControllerDelegate.h"

NS_ASSUME_NONNULL_BEGIN

@interface MainListViewController : NSViewController
+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithDelegate:(id<MainListViewControllerDelegate>)delegate;
- (void)selectItemModelType:(MainListItemModelType)type;
@end

NS_ASSUME_NONNULL_END
