//
//  NSImageView+setAsyncImage.h
//  StoneNamuMac
//
//  Created by Jinwoo Kim on 10/25/21.
//

#import <Cocoa/Cocoa.h>

NS_ASSUME_NONNULL_BEGIN

typedef void (^NSImageViewSetAsyncImageCompletion)(NSImage * _Nullable, NSError * _Nullable);

@interface NSImageView (setAsyncImage)
- (void)setAsyncImageWithURL:(NSURL * _Nullable)url indicator:(BOOL)indicator;
- (void)setAsyncImageWithURL:(NSURL * _Nullable)url indicator:(BOOL)indicator completion:(NSImageViewSetAsyncImageCompletion)completion;
@end

NS_ASSUME_NONNULL_END
