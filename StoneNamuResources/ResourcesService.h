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
#import <StoneNamuResources/FontKey.h>
#import <StoneNamuCore/StoneNamuCore.h>

NS_ASSUME_NONNULL_BEGIN

@interface ResourcesService : NSObject
+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;

#if TARGET_OS_IPHONE
+ (UIImage * _Nullable)imageForKey:(ImageKey)imageKey;
#elif TARGET_OS_OSX
+ (NSImage * _Nullable)imageForKey:(ImageKey)imageKey;
#endif

#if TARGET_OS_IPHONE
+ (UIImage * _Nullable)imageForBlizzardHSAPIOptionType:(BlizzardHSAPIOptionType)optionType fill:(BOOL)fill;
+ (UIImage * _Nullable)imageForDeckFormat:(HSDeckFormat)deckFormat;
+ (UIImage * _Nullable)portraitImageForHSCardClassSlugType:(HSCardClassSlugType)hsCardClassSlugType;
#elif TARGET_OS_OSX
+ (NSImage * _Nullable)imageForBlizzardHSAPIOptionType:(BlizzardHSAPIOptionType)optionType fill:(BOOL)fill;
+ (NSImage * _Nullable)imageForDeckFormat:(HSDeckFormat)deckFormat;
+ (NSImage * _Nullable)portraitImageForHSCardClassSlugType:(HSCardClassSlugType)hsCardClassSlugType;
#endif

+ (NSString *)localizationForKey:(LocalizableKey)localizableKey;

+ (NSString *)localizationForBlizzardAPIRegionHost:(BlizzardAPIRegionHost)region;
+ (NSDictionary<NSString *, NSString *> *)localizationsWithBlizzardAPIRegionHostForAPI;

+ (NSString *)localizationForBlizzardHSAPILocale:(BlizzardHSAPILocale)locale;
+ (NSDictionary<NSString *, NSString *> *)localizationsWithBlizzardHSAPILocale;

+ (NSString *)localizationForBlizzardHSAPIOptionType:(BlizzardHSAPIOptionType)optionType;

+ (NSString *)localizationForHSCardCollectible:(HSCardCollectible)collectible;
+ (NSDictionary<NSString *, NSString *> *)localizationsForHSCardCollectible;

+ (NSString *)localizationForHSCardSort:(HSCardSort)hsCardSort;
+ (NSDictionary<NSString *, NSString *> *)localizationsForHSCardSort;
+ (NSDictionary<NSString *, NSString *> *)localizationsForHSCardSortWithHSCardGameModeSlugType:(HSCardGameModeSlugType)hsCardGameModeSlugType;

+ (NSString *)localizationForHSDeckFormat:(HSDeckFormat)hsDeckFormat;
+ (NSDictionary<NSString *, NSString *> *)localizationsForHSDeckFormat;

+ (NSString *)localizationForHSDeck:(HSDeck *)hsDeck title:(NSString *)title className:(NSString *)className;

#if TARGET_OS_IPHONE
+ (UIFont * _Nullable)fontForKey:(FontKey)fontKey size:(CGFloat)size;
#elif TARGET_OS_OSX
+ (NSFont * _Nullable)fontForKey:(FontKey)fontKey size:(CGFloat)size;
#endif
@end

NS_ASSUME_NONNULL_END
