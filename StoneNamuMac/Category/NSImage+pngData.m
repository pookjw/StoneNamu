//
//  NSImage+pngData.m
//  StoneNamuMac
//
//  Created by Jinwoo Kim on 11/24/21.
//

#import "NSImage+pngData.h"

@implementation NSImage (pngData)

- (NSData *)pngData {
    NSBitmapImageRep *bitmap = [NSBitmapImageRep imageRepWithData:self.TIFFRepresentation];
    NSData *pngData = [bitmap representationUsingType:NSBitmapImageFileTypePNG properties:@{}];
    
    return pngData;
}

@end
