//
//  ResourcesService.m
//  StoneNamuResources
//
//  Created by Jinwoo Kim on 11/12/21.
//

#import <StoneNamuResources/ResourcesService.h>
#import <StoneNamuResources/Identifier.h>

@implementation ResourcesService

#if TARGET_OS_IPHONE
+ (UIImage * _Nullable)imageForKey:(ImageKey)imageKey {
    return [UIImage imageNamed:imageKey inBundle:[NSBundle bundleWithIdentifier:Identifier] withConfiguration:nil];
}
#endif

#if TARGET_OS_OSX
+ (NSImage * _Nullable)imageForKey:(ImageKey)imageKey {
    return [[NSBundle bundleWithIdentifier:Identifier] imageForResource:imageKey];
}
#endif

+ (NSString *)localizaedStringForKey:(LocalizableKey)localizableKey {
    return NSLocalizedStringFromTableInBundle(localizableKey,
                                              @"Localizable",
                                              [NSBundle bundleWithIdentifier:Identifier],
                                              @"");
}

@end
