//
//  HSCardDroppableView.h
//  StoneNamuMac
//
//  Created by Jinwoo Kim on 1/17/22.
//

#import <Cocoa/Cocoa.h>
#import "HSCardDroppableViewDelegate.h"

NS_ASSUME_NONNULL_BEGIN

@interface HSCardDroppableView : NSView
+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithDelegate:(id<HSCardDroppableViewDelegate>)delegate asynchronous:(BOOL)asynchronous;
@end

NS_ASSUME_NONNULL_END
