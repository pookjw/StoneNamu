//
//  HSCardPopoverDetailView.m
//  StoneNamuMac
//
//  Created by Jinwoo Kim on 1/29/22.
//

#import "HSCardPopoverDetailView.h"
#import "CardDetailsViewController.h"
#import "NSPopover+Private.h"
#import "NSView+DraggingNotification.h"

@interface HSCardPopoverDetailView () <NSPopoverDelegate>
@property (copy) HSCard * _Nullable hsCard;
@property (copy) HSCardGameModeSlugType _Nullable hsCardGameModeSlugType;
@property BOOL isGold;
@property (retain) NSPopover * _Nullable popover;
@property BOOL completed;
@end

@implementation HSCardPopoverDetailView

- (instancetype)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
    
    if (self) {
        [self bind];
    }
    
    return self;
}

- (instancetype)initWithFrame:(NSRect)frameRect {
    self = [super initWithFrame:frameRect];
    
    if (self) {
        [self bind];
    }
    
    return self;
}

- (void)dealloc {
    [_hsCard release];
    [_hsCardGameModeSlugType release];
    [_popover release];
    [super dealloc];
}

- (BOOL)isShown {
    return ((self.popover != nil) && (self.popover.isShown));
}

- (void)mouseDown:(NSEvent *)event {
    [super mouseDown:event];
    [self reset];
}

- (void)pressureChangeWithEvent:(NSEvent *)event {
    [super pressureChangeWithEvent:event];
    
    if (self.hsCard == nil) return;
    
    if ((event.pressure >= 0.5f) && (self.popover == nil)) {
        NSPopover *popover = [NSPopover new];
        CardDetailsViewController *vc = [[CardDetailsViewController alloc] initWithHSCard:self.hsCard hsGameModeSlugType:self.hsCardGameModeSlugType isGold:self.isGold];
        
        popover.contentViewController = vc;
        [vc release];
        
        popover.delegate = self;
        popover.behavior = NSPopoverBehaviorSemitransient;
        
        [popover showRelativeToRect:self.frame ofView:self preferredEdge:NSRectEdgeMinY];
        
        self.popover = popover;
        [popover release];
    } else if (self.popover != nil) {
        if (!self.completed) {
            if (event.stage == 2) {
                self.popover._popoverWindow.alphaValue = 1.0f;
                self.completed = YES;
            } else if (event.stage == 0) {
                [self reset];
            } else {
                self.popover._popoverWindow.alphaValue = event.pressure;
            }
        }
    }
}

- (BOOL)performDragOperation:(id<NSDraggingInfo>)sender {
    return [super performDragOperation:sender];
}

- (void)setHSCard:(HSCard *)hsCard hsGameModeSlugType:(HSCardGameModeSlugType)hsCardGameModeSlugType isGold:(BOOL)isGold {
    self.hsCard = hsCard;
    self.hsCardGameModeSlugType = hsCardGameModeSlugType;
    self.isGold = isGold;
}

- (void)reset {
    self.completed = NO;
    [self.popover performClose:nil];
    self.popover = nil;
}

- (void)bind {
    [NSNotificationCenter.defaultCenter addObserver:self
                                           selector:@selector(didBeginDraggingSessionReceived:)
                                               name:NSViewDidBeginDraggingSession
                                             object:nil];
}

- (void)didBeginDraggingSessionReceived:(NSNotification *)notification {
    NSView * _Nullable targetView = notification.object;
    
    if (targetView != nil) {
        [NSOperationQueue.mainQueue addOperationWithBlock:^{
            if ([targetView.window isEqual:self.window]) {
                [self reset];
            }
        }];
    }
}

#pragma mark - <NSPopoverDelegate>

- (void)popoverWillShow:(NSNotification *)notification {
    _NSPopoverWindow *window = ((NSPopover *)notification.object)._popoverWindow;
    window.alphaValue = 0.0f;
}

- (void)didCloseMenu:(NSMenu *)menu withEvent:(NSEvent *)event {
    [self reset];
}

@end
