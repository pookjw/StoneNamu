//
//  UIImage+imageWithGrayScale.m
//  UIImage+imageWithGrayScale
//
//  Created by Jinwoo Kim on 9/5/21.
//

#import "UIImage+imageWithGrayScale.h"
#import <objc/runtime.h>

static NSString * const UIImageGrayScaleCategoryIsGrayScaleApplied = @"UIImageGrayScaleCategoryIsGrayScaleApplied";
static NSString * const UIImageGrayScaleCategoryImageBeforeGrayScale = @"UIImageGrayScaleCategoryImageBeforeGrayScale";

@implementation UIImage (imageWithGrayScale)

- (void)dealloc {
    objc_removeAssociatedObjects(self);
    [super dealloc];
}

- (BOOL)isGrayScaleApplied {
    NSNumber *value = objc_getAssociatedObject(self, &UIImageGrayScaleCategoryIsGrayScaleApplied);
    return value.boolValue;
}

- (void)setIsGrayScaleApplied:(BOOL)isGrayScaleApplied {
    objc_setAssociatedObject(self, &UIImageGrayScaleCategoryIsGrayScaleApplied, [NSNumber numberWithBool:isGrayScaleApplied], OBJC_ASSOCIATION_RETAIN);
}

- (UIImage * _Nullable)imageBeforeGrayScale {
    return objc_getAssociatedObject(self, &UIImageGrayScaleCategoryImageBeforeGrayScale);
}

- (void)setImageBeforeGrayScale:(UIImage *)imageBeforeGrayScale {
    objc_setAssociatedObject(self, &UIImageGrayScaleCategoryImageBeforeGrayScale, imageBeforeGrayScale, OBJC_ASSOCIATION_RETAIN);
}

- (UIImage *)imageWithGrayScale {
    // https://stackoverflow.com/a/36874348
    
    if (self.isGrayScaleApplied) return self;
    
    CIImage *ciImage = [[CIImage alloc] initWithImage:self];
    CIImage *grayscale = [ciImage imageByApplyingFilter:@"CIColorControls"
                                    withInputParameters:@{kCIInputSaturationKey : @0.0}];
    [ciImage release];
    UIImage *newImage = [UIImage imageWithCIImage:grayscale];
    newImage.isGrayScaleApplied = YES;
    newImage.imageBeforeGrayScale = self;
    
    // Return the new grayscale image
    return newImage;
}

@end
