//
//  DragItemService.m
//  DragItemService
//
//  Created by Jinwoo Kim on 8/23/21.
//

#import "DragItemService.h"

@implementation DragItemService

+ (DragItemService *)sharedInstance {
    static DragItemService *sharedInstance = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        sharedInstance = [DragItemService new];
    });
    
    return sharedInstance;
}

- (UIDragItem *)makeDragItemsFromHSCard:(HSCard *)hsCard image:(UIImage *)image {
    UIDragItem *dragItem;
    
    if (image) {
        NSItemProvider *itemProvider = [[NSItemProvider alloc] initWithObject:image];
        HSCard *copyHSCard = [hsCard copy];
        [itemProvider registerObject:copyHSCard visibility:NSItemProviderRepresentationVisibilityOwnProcess];
        [copyHSCard release];
        dragItem = [[UIDragItem alloc] initWithItemProvider:itemProvider];
        [itemProvider release];
    } else {
        HSCard *copyHSCard = [hsCard copy];
        NSItemProvider *itemProvider = [[NSItemProvider alloc] initWithObject:copyHSCard];
        [copyHSCard release];
        dragItem = [[UIDragItem alloc] initWithItemProvider:itemProvider];
        [itemProvider release];
    }
    
    return [dragItem autorelease];
}

@end
