//
//  HSCardDraggableImageView.m
//  StoneNamuMac
//
//  Created by Jinwoo Kim on 11/25/21.
//

#import "HSCardDraggableImageView.h"
#import "HSCardPromiseProvider.h"

@interface HSCardDraggableImageView () <NSDraggingSource>
@property (copy) HSCard *hsCard;
@end

@implementation HSCardDraggableImageView

- (instancetype)initWithHSCard:(HSCard *)hsCard {
    self = [self init];
    
    if (self) {
        self.hsCard = hsCard;
    }
    
    return self;
}

- (void)dealloc {
    [_hsCard release];
    [super dealloc];
}

- (void)mouseDown:(NSEvent *)event {
    [super mouseDown:event];
    
    HSCardPromiseProvider *pasteboardItem = [[HSCardPromiseProvider alloc] initWithHSCard:self.hsCard image:self.image];
    NSDraggingItem *draggingItem = [[NSDraggingItem alloc] initWithPasteboardWriter:pasteboardItem];
    
    [draggingItem setDraggingFrame:self.bounds contents:self.image];
    
    [self beginDraggingSessionWithItems:@[draggingItem] event:event source:self];
}

#pragma mark - NSDraggingSource

- (NSDragOperation)draggingSession:(NSDraggingSession *)session sourceOperationMaskForDraggingContext:(NSDraggingContext)context {
    return NSDragOperationCopy;
}

@end
