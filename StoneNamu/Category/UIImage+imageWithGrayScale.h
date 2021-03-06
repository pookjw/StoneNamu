//
//  UIImage+imageWithGrayScale.h
//  UIImage+imageWithGrayScale
//
//  Created by Jinwoo Kim on 9/5/21.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIImage (imageWithGrayScale)
@property (readonly) BOOL isGrayScaleApplied;
@property UIImage * _Nullable imageBeforeGrayScale;
- (UIImage *)imageWithGrayScale;
@end

NS_ASSUME_NONNULL_END
