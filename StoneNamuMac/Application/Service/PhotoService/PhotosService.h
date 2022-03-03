//
//  PhotosService.h
//  StoneNamuMac
//
//  Created by Jinwoo Kim on 12/25/21.
//

#import <Cocoa/Cocoa.h>
#import <StoneNamuCore/StoneNamuCore.h>

NS_ASSUME_NONNULL_BEGIN

typedef void (^PhotosServiceCompletion)(BOOL success, NSError * _Nullable error);

@interface PhotosService : NSObject
+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithImages:(NSDictionary<NSString *, NSImage *> *)images;
- (instancetype)initWithURLs:(NSDictionary<NSString *, NSURL *> *)urls;
- (instancetype)initWithHSCards:(NSSet<HSCard *> *)hsCards hsGameModeSlugType:(HSCardGameModeSlugType)hsCardGameModeSlugType isGold:(BOOL)isGold;
- (instancetype)initWithHSCards:(NSSet<HSCard *> *)hsCards hsGameModeSlugTypes:(NSDictionary<HSCard *, HSCardGameModeSlugType> *)hsCardGameModeSlugTypes isGolds:(NSDictionary<HSCard *, NSNumber *> *)isGolds;
- (void)beginSheetModalForWindow:(NSWindow * _Nullable)window completion:(PhotosServiceCompletion)completion;
- (void)beginSharingServiceOfView:(NSView *)view;
@end

NS_ASSUME_NONNULL_END
