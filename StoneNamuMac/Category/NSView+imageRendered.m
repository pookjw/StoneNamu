//
//  NSView+imageRendered.m
//  StoneNamuMac
//
//  Created by Jinwoo Kim on 12/25/21.
//

#import "NSView+imageRendered.h"

@implementation NSView (imageRendered)

- (NSImage *)imageRendered {
    NSBitmapImageRep *bitRep = [self bitmapImageRepForCachingDisplayInRect:self.bounds];
    [self cacheDisplayInRect:self.bounds toBitmapImageRep:bitRep];

//    NSImage *image = [[NSImage alloc] initWithSize:self.bounds.size];
//    [image addRepresentation:bitRep];

    return [[[NSImage alloc] initWithCGImage:bitRep.CGImage size:self.bounds.size] autorelease];
    
//    NSData *data = [self dataWithPDFInsideRect:self.bounds];
//    NSPDFImageRep *pdfRep = [NSPDFImageRep imageRepWithData:data];
//
//    NSImage *pdfImage = [[NSImage alloc] initWithSize:self.bounds.size];
//    [pdfImage addRepresentation:pdfRep];
//
//    return [pdfImage autorelease];
}

@end
