//
//  NSView+imageRendered.m
//  StoneNamuMac
//
//  Created by Jinwoo Kim on 12/25/21.
//

#import "NSView+imageRendered.h"

@implementation NSView (imageRendered)

- (NSImage *)imageRendered {
    NSSize size = self.bounds.size;
    NSBitmapImageRep *bitRep = [self bitmapImageRepForCachingDisplayInRect:self.bounds];
    bitRep.size = size;
    [self cacheDisplayInRect:self.bounds toBitmapImageRep:bitRep];
    
    NSImage *image= [[NSImage alloc] initWithSize:size];
    [image addRepresentation:bitRep];
    
    return [image autorelease];
}

@end
