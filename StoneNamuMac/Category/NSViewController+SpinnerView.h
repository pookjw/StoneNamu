//
//  NSViewController+SpinnerView.h
//  StoneNamuMac
//
//  Created by Jinwoo Kim on 10/27/21.
//

#import <Cocoa/Cocoa.h>
#import "SpinnerView.h"

NS_ASSUME_NONNULL_BEGIN

@interface NSViewController (SpinnerView)
- (void)addSpinnerView;
- (void)removeAllSpinnerview;
@end

NS_ASSUME_NONNULL_END
