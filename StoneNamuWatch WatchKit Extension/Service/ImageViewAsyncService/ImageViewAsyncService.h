//
//  ImageViewAsyncService.h
//  StoneNamuWatch WatchKit Extension
//
//  Created by Jinwoo Kim on 3/9/22.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void (^ImageViewAsyncServiceCompletion)(UIImage * _Nullable, NSError * _Nullable);

@interface ImageViewAsyncService : NSObject
- (void)setAsyncImageToImageView:(id)imageView withURL:(NSURL * _Nullable)url indicator:(BOOL)indicator;
- (void)setAsyncImageToImageView:(id)imageView withURL:(NSURL * _Nullable)url indicator:(BOOL)indicator completion:(ImageViewAsyncServiceCompletion)completion;
- (void)cancelAsyncImageOnImageView:(id)imageView;
- (void)clearSetAsyncImageContextsOnImageView:(id)imageView;
@end

NS_ASSUME_NONNULL_END
