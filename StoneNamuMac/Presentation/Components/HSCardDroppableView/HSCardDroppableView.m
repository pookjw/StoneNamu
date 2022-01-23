//
//  HSCardDroppableView.m
//  StoneNamuMac
//
//  Created by Jinwoo Kim on 1/17/22.
//

#import "HSCardDroppableView.h"
#import "HSCardPromiseProvider.h"

@interface HSCardDroppableView ()
@property (assign) id<HSCardDroppableViewDelegate> delegate;
@property (retain) NSOperationQueue * _Nullable queue;
@end

@implementation HSCardDroppableView

- (instancetype)initWithDelegate:(id<HSCardDroppableViewDelegate>)delegate asynchronous:(BOOL)asynchronous {
    self = [self init];
    
    if (self) {
        self.delegate = delegate;
        
        if (asynchronous) {
            NSOperationQueue *queue = [NSOperationQueue new];
            queue.qualityOfService = NSQualityOfServiceUserInitiated;
            self.queue = queue;
            [queue release];
        }
        
        [self registerForDraggedTypes:@[NSPasteboardTypeHSCard]];
    }
    
    return self;
}

- (void)dealloc {
    [_queue release];
    [super dealloc];
}

- (NSView *)hitTest:(NSPoint)point {
    return nil;
}

- (NSDragOperation)draggingEntered:(id<NSDraggingInfo>)sender {
    return NSDragOperationCopy;
}

- (BOOL)performDragOperation:(id<NSDraggingInfo>)sender {
    NSPasteboard *pasteboard = sender.draggingPasteboard;
    
    if (self.queue == nil) {
        [self processWithPasteboard:pasteboard];
    } else {
        [self.queue addOperationWithBlock:^{
            [self processWithPasteboard:pasteboard];
        }];
    }
    
    return YES;
}

- (void)processWithPasteboard:(NSPasteboard *)pasteboard {
    NSArray<HSCard *> *hsCards = [pasteboard readObjectsForClasses:@[[HSCard class]] options:nil];
    [self.delegate hsCardDroppableView:self didAcceptDropWithHSCards:hsCards];
}

@end
