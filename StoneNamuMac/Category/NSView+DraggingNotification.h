//
//  NSView+DraggingNotification.h
//  StoneNamu
//
//  Created by Jinwoo Kim on 1/29/22.
//

#import <Cocoa/Cocoa.h>

NS_ASSUME_NONNULL_BEGIN

static NSNotificationName const NSViewDidBeginDraggingSession = @"NSViewDidBeginDraggingSession";

@interface NSView (DraggingNotification)
@property (class) BOOL postsBeganDraggingSessionNotifications;
@end

NS_ASSUME_NONNULL_END
