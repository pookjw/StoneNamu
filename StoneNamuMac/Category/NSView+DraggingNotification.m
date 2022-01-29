//
//  NSView+DraggingNotification.m
//  StoneNamuMac
//
//  Created by Jinwoo Kim on 1/29/22.
//

#import "NSView+DraggingNotification.h"
#import <objc/runtime.h>

static BOOL _postsBeganDraggingSessionNotifications = NO;
static BOOL _hooked = NO;

@implementation NSView (DraggingNotification)

+ (BOOL)postsBeganDraggingSessionNotifications {
    return _postsBeganDraggingSessionNotifications;
}

+ (void)setPostsBeganDraggingSessionNotifications:(BOOL)postsBeganDraggingSessionNotifications {
    
    _postsBeganDraggingSessionNotifications = postsBeganDraggingSessionNotifications;
    
    if (!_hooked) {
        Method method = class_getInstanceMethod([NSView class], @selector(beginDraggingSessionWithItems:event:source:));
        
        IMP original = method_getImplementation(method);
        
        NSDraggingSession *(^block)(id, NSArray<NSDraggingItem *> *, NSEvent *, id<NSDraggingSource>) = ^NSDraggingSession *(id object, NSArray<NSDraggingItem *> *items, NSEvent *event, id<NSDraggingSource> source) {
            
            if (_postsBeganDraggingSessionNotifications) {
                [NSNotificationCenter.defaultCenter postNotificationName:NSViewDidBeginDraggingSession object:object];
            }
            
            typedef NSDraggingSession * (*fn)(id, SEL, NSArray<NSDraggingItem *> *, NSEvent *, id<NSDraggingSource>);
            
            fn f = (fn)original;
            return f(object, @selector(beginDraggingSessionWithItems:event:source:), items, event, source);
        };
        
        IMP new = imp_implementationWithBlock(block);
        method_setImplementation(method, new);
        
        _hooked = YES;
    }
}

@end
