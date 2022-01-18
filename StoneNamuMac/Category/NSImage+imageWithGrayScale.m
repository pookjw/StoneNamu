//
//  NSImage+imageWithGrayScale.m
//  StoneNamuMac
//
//  Created by Jinwoo Kim on 1/19/22.
//

#import "NSImage+imageWithGrayScale.h"
#import <objc/runtime.h>
#import <CoreImage/CoreImage.h>

static NSString * const NSImageGrayScaleCategoryIsGrayScaleApplied = @"NSImageGrayScaleCategoryIsGrayScaleApplied";
static NSString * const NSImageGrayScaleCategoryImageBeforeGrayScale = @"NSImageGrayScaleCategoryImageBeforeGrayScale";

@implementation NSImage (imageWithGrayScale)

- (void)dealloc {
    objc_removeAssociatedObjects(self);
    [super dealloc];
}

- (BOOL)isGrayScaleApplied {
    NSNumber *value = objc_getAssociatedObject(self, &NSImageGrayScaleCategoryIsGrayScaleApplied);
    
    if (value == NULL) {
        return NO;
    }
    
    return value.boolValue;
}

- (void)setIsGrayScaleApplied:(BOOL)isGrayScaleApplied {
    objc_setAssociatedObject(self, &NSImageGrayScaleCategoryIsGrayScaleApplied, [NSNumber numberWithBool:isGrayScaleApplied], OBJC_ASSOCIATION_RETAIN);
}

- (NSImage * _Nullable)imageBeforeGrayScale {
    NSImage *imageBeforeGrayScale = objc_getAssociatedObject(self, &NSImageGrayScaleCategoryImageBeforeGrayScale);
    
    if (imageBeforeGrayScale == NULL) {
        return nil;
    }
    
    return imageBeforeGrayScale;
}

- (void)setImageBeforeGrayScale:(NSImage *)imageBeforeGrayScale {
    objc_setAssociatedObject(self, &NSImageGrayScaleCategoryImageBeforeGrayScale, imageBeforeGrayScale, OBJC_ASSOCIATION_RETAIN);
}

- (NSImage *)imageWithGrayScale {
    // https://stackoverflow.com/a/36874348
    
    if (self.isGrayScaleApplied) return self;
    
    NSData *data = self.TIFFRepresentation;
    NSBitmapImageRep *bitmapImageRep = [NSBitmapImageRep imageRepWithData:data];
    CIImage *ciImage= [[CIImage alloc] initWithBitmapImageRep:bitmapImageRep];
    CIImage *grayscale = [ciImage imageByApplyingFilter:@"CIColorControls"
                                    withInputParameters:@{kCIInputSaturationKey : @0.0}];
    [ciImage release];
    
    NSCIImageRep *ciImageRep = [NSCIImageRep imageRepWithCIImage:grayscale];
    NSImage *newImage = [[NSImage alloc] initWithSize:bitmapImageRep.size];
    [newImage addRepresentation:ciImageRep];
    
    newImage.isGrayScaleApplied = YES;
    newImage.imageBeforeGrayScale = self;
    
    // Return the new grayscale image
    return [newImage autorelease];
}

@end
