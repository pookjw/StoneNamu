//
//  NSViewController+splitViewController.h
//  StoneNamuMac
//
//  Created by Jinwoo Kim on 11/28/21.
//

#import <Cocoa/Cocoa.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSViewController (splitViewController)
@property (readonly, nonatomic) __kindof NSSplitViewController * _Nullable splitViewController;
@end

NS_ASSUME_NONNULL_END
