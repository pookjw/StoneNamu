//
//  UIImageView+setAsyncImage.h
//  UIImageView+setAsyncImage
//
//  Created by Jinwoo Kim on 8/2/21.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIImageView (setAsyncImage)
- (void)setAsyncImageWithURL:(NSURL * _Nullable)url indicator:(BOOL)indicator;
@end

NS_ASSUME_NONNULL_END
