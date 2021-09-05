//
//  UIImage+imageWithGrayScale.h
//  UIImage+imageWithGrayScale
//
//  Created by Jinwoo Kim on 9/5/21.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIImage (imageWithGrayScale)
@property BOOL isGrayScaleApplied;
- (UIImage *)imageWithGrayScale;
@property UIImage * _Nullable imageBeforeGrayScale;
@end

NS_ASSUME_NONNULL_END
