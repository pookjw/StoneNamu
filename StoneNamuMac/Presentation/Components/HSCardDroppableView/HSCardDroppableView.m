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
    NSArray<NSPasteboardItem *> *items = pasteboard.pasteboardItems;
    
    if (self.queue == nil) {
        NSArray<HSCard *> *hsCards = [self hsCardsFromPasteboardItems:items];
        [self.delegate hsCardDroppableView:self didAcceptDropWithHSCards:hsCards];
    } else {
        [self.queue addOperationWithBlock:^{
            NSArray<HSCard *> *hsCards = [self hsCardsFromPasteboardItems:items];
            [self.delegate hsCardDroppableView:self didAcceptDropWithHSCards:hsCards];
        }];
    }
    
    return YES;
}

- (NSArray<HSCard *> *)hsCardsFromPasteboardItems:(NSArray<NSPasteboardItem *> *)pasteboardItems {
    NSMutableArray<HSCard *> *hsCards = [@[] mutableCopy];
    
    [pasteboardItems enumerateObjectsUsingBlock:^(NSPasteboardItem * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSData *data = [obj dataForType:NSPasteboardTypeHSCard];
        HSCard *hsCard = [NSKeyedUnarchiver unarchivedObjectOfClasses:HSCard.unarchvingClasses fromData:data error:nil];
        [hsCards addObject:hsCard];
    }];
    
    return [hsCards autorelease];
}

@end
