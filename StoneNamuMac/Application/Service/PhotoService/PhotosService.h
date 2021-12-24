//
//  PhotosService.h
//  StoneNamuMac
//
//  Created by Jinwoo Kim on 12/25/21.
//

#import <Cocoa/Cocoa.h>

NS_ASSUME_NONNULL_BEGIN

typedef void (^PhotosServiceSaveImageCompletion)(BOOL success, NSError * _Nullable error);

@interface PhotosService : NSObject
+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithImages:(NSDictionary<NSString *, NSImage *> *)images;
- (instancetype)initWithURLs:(NSDictionary<NSString *, NSURL *> *)urls;
- (void)beginSheetModalForWindow:(NSWindow * _Nullable)window completion:(PhotosServiceSaveImageCompletion)completion;
@end

NS_ASSUME_NONNULL_END
