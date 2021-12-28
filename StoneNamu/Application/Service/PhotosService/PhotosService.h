//
//  PhotosService.h
//  PhotosService
//
//  Created by Jinwoo Kim on 8/16/21.
//

#import <UIKit/UIKit.h>
#import <StoneNamuCore/StoneNamuCore.h>

NS_ASSUME_NONNULL_BEGIN

typedef void (^PhotosServiceCompletion)(BOOL success, NSError * _Nullable error);

@interface PhotosService : NSObject
+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithImages:(NSDictionary<NSString *, UIImage *> *)images;
- (instancetype)initWithURLs:(NSDictionary<NSString *, NSURL *> *)urls;
- (instancetype)initWithHSCards:(NSSet<HSCard *> *)hsCards;
- (void)beginSavingFromViewController:(UIViewController *)viewController completion:(PhotosServiceCompletion)completion;
- (void)beginSharingFromViewController:(UIViewController *)viewController completion:(PhotosServiceCompletion)completion;
@end

NS_ASSUME_NONNULL_END
