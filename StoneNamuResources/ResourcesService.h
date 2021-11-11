//
//  ResourcesService.h
//  StoneNamuResources
//
//  Created by Jinwoo Kim on 11/12/21.
//

#import <TargetConditionals.h>
#if TARGET_OS_IPHONE
#import <UIKit/UIKit.h>
#elif TARGET_OS_OSX
#import <Cocoa/Cocoa.h>
#endif
#import <StoneNamuResources/ImageKey.h>
#import <StoneNamuResources/LocalizableKey.h>

NS_ASSUME_NONNULL_BEGIN

@interface ResourcesService : NSObject
#if TARGET_OS_IPHONE
+ (UIImage * _Nullable)imageForKey:(ImageKey)imageKey;
#elif TARGET_OS_OSX
+ (NSImage * _Nullable)imageForKey:(ImageKey)imageKey;
#endif
+ (NSString *)localizaedStringForKey:(LocalizableKey)localizableKey;
@end

NS_ASSUME_NONNULL_END
