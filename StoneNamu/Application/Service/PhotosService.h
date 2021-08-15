//
//  PhotosService.h
//  PhotosService
//
//  Created by Jinwoo Kim on 8/16/21.
//

#import <UIKit/UIKit.h>
#import <Photos/Photos.h>

NS_ASSUME_NONNULL_BEGIN

@interface PhotosService : NSObject
@property (class, readonly, nonatomic) PhotosService *sharedInstance;
- (void)saveImage:(UIImage *)image fromViewController:(UIViewController *)viewController completionHandler:(void (^)(BOOL success, NSError *error))completionHandler;
- (void)saveImageURL:(NSURL *)url fromViewController:(UIViewController *)viewController completionHandler:(void (^)(BOOL success, NSError *error))completionHandler;
@end

NS_ASSUME_NONNULL_END
