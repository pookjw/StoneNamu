//
//  NSImage+dataUsingType.m
//  StoneNamuMac
//
//  Created by Jinwoo Kim on 12/23/21.
//

#import "NSImage+dataUsingType.h"
#import <UniformTypeIdentifiers/UniformTypeIdentifiers.h>

@implementation NSImage (dataUsingType)

- (NSData *)dataUsingType:(NSBitmapImageFileType)storageType {
    NSBitmapImageRep *bitmap = [NSBitmapImageRep imageRepWithData:self.TIFFRepresentation];
    NSData *data = [bitmap representationUsingType:storageType properties:@{}];
    
    return data;
}

- (NSData * _Nullable)dataUsingUniformType:(UTType *)uniformType {
    if ([uniformType isEqual:UTTypeTIFF]) {
        return [self dataUsingType:NSBitmapImageFileTypeTIFF];
    } else if ([uniformType isEqual:UTTypeBMP]) {
        return [self dataUsingType:NSBitmapImageFileTypeBMP];
    } else if ([uniformType isEqual:UTTypeGIF]) {
        return [self dataUsingType:NSBitmapImageFileTypeGIF];
    } else if ([uniformType isEqual:UTTypeJPEG]) {
        return [self dataUsingType:NSBitmapImageFileTypeJPEG];
    } else if ([uniformType isEqual:UTTypePNG]) {
        return [self dataUsingType:NSBitmapImageFileTypePNG];
    } else {
        return nil;
    }
}

@end
