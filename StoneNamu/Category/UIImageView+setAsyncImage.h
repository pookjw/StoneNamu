//
//  UIImageView+setAsyncImage.h
//  UIImageView+setAsyncImage
//
//  Created by Jinwoo Kim on 8/2/21.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void (^UIImageViewSetAsyncImageCompletion)(UIImage * _Nullable, NSError * _Nullable);

@interface UIImageView (setAsyncImage)
- (void)setAsyncImageWithURL:(NSURL * _Nullable)url indicator:(BOOL)indicator;
- (void)setAsyncImageWithURL:(NSURL * _Nullable)url indicator:(BOOL)indicator completion:(UIImageViewSetAsyncImageCompletion)completion;
@end

NS_ASSUME_NONNULL_END
