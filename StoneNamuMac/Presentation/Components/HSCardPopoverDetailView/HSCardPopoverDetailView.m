//
//  HSCardPopoverDetailView.m
//  StoneNamuMac
//
//  Created by Jinwoo Kim on 1/29/22.
//

#import "HSCardPopoverDetailView.h"
#import "CardDetailsViewController.h"

@interface HSCardPopoverDetailView () <NSPopoverDelegate>
@property (retain) NSPopover * _Nullable popover;
@end

@implementation HSCardPopoverDetailView

- (void)dealloc {
    [_hsCard release];
    [_popover release];
    [super dealloc];
}

- (BOOL)isShown {
    return ((self.popover != nil) && (self.popover.isShown));
}

- (void)mouseDown:(NSEvent *)event {
    [super mouseDown:event];
    
    [self.popover performClose:nil];
}

- (void)pressureChangeWithEvent:(NSEvent *)event {
    [super pressureChangeWithEvent:event];
    
    if (event.stage == 2) {
        if (self.hsCard == nil) return;
        if (self.isShown) return;
        
        if (self.popover == nil) {
            NSPopover *popover = [NSPopover new];
            CardDetailsViewController *vc = [[CardDetailsViewController alloc] initWithHSCard:self.hsCard];
            
            popover.contentViewController = vc;
            [vc release];
            
            popover.delegate = self;
            popover.behavior = NSPopoverBehaviorSemitransient;
            
            self.popover = popover;
            [popover release];
        }
        
        [self.popover showRelativeToRect:self.frame ofView:self preferredEdge:NSRectEdgeMinY];
    }
}

#pragma mark - <NSPopoverDelegate>

- (void)didCloseMenu:(NSMenu *)menu withEvent:(NSEvent *)event {
    self.popover = nil;
}

@end
