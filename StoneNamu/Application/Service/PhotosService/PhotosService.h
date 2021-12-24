//
//  PhotosService.h
//  PhotosService
//
//  Created by Jinwoo Kim on 8/16/21.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void (^PhotosServiceSaveImageCompletion)(BOOL success, NSError * _Nullable error);

@interface PhotosService : NSObject
@property (class, readonly, nonatomic) PhotosService *sharedInstance;
+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;
- (void)saveImage:(UIImage *)image fromViewController:(UIViewController *)viewController completionHandler:(PhotosServiceSaveImageCompletion)completionHandler;
- (void)saveImageURL:(NSURL *)url fromViewController:(UIViewController *)viewController completionHandler:(PhotosServiceSaveImageCompletion)completionHandler;
@end

NS_ASSUME_NONNULL_END
