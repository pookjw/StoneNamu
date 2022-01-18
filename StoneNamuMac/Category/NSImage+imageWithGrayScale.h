//
//  NSImage+imageWithGrayScale.h
//  StoneNamuMac
//
//  Created by Jinwoo Kim on 1/19/22.
//

#import <Cocoa/Cocoa.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSImage (imageWithGrayScale)
@property (readonly) BOOL isGrayScaleApplied;
@property NSImage * _Nullable imageBeforeGrayScale;
- (NSImage *)imageWithGrayScale;
@end

NS_ASSUME_NONNULL_END
