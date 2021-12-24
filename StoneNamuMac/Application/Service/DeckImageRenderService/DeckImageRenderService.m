//
//  DeckImageRenderService.m
//  StoneNamuMac
//
//  Created by Jinwoo Kim on 12/25/21.
//

#import "DeckImageRenderService.h"
#import "NSView+imageRendered.h"

@interface DeckImageRenderService ()
@property (retain) NSOperationQueue *queue;
@end

@implementation DeckImageRenderService

- (instancetype)init {
    self = [super init];
    
    if (self) {
        NSOperationQueue *queue = [NSOperationQueue new];
        self.queue = queue;
        queue.qualityOfService = NSQualityOfServiceUserInitiated;
        [queue release];
    }
    
    return self;
}

- (void)imageFromLocalDeck:(LocalDeck *)localDeck completion:(DeckImageRenderServiceCompletion)completion {
    NSView *view = [[NSView alloc] initWithFrame:NSMakeRect(0.0f, 0.0f, 300.0f, 300.0f)];
    view.wantsLayer = YES;
    view.layer.backgroundColor = NSColor.systemTealColor.CGColor;
    NSImage *image = view.imageRendered;
    [view release];
    completion(image);
}

@end
