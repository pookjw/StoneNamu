//
//  Prefs.m
//  Prefs
//
//  Created by Jinwoo Kim on 8/10/21.
//

#import <StoneNamuCore/Prefs.h>
#import <StoneNamuCore/BlizzardAPIRegionHost.h>
#import <StoneNamuCore/BlizzardHSAPILocale.h>
#import <StoneNamuCore/BlizzardHSAPIKeys.h>

@implementation Prefs

@dynamic locale;
@dynamic apiRegionHost;

+ (NSString *)alternativeLocale {
    NSString *language = NSLocale.preferredLanguages[0];
    NSString *localeIdentifier = NSLocale.currentLocale.localeIdentifier;

    if ([language containsString:@"en"]) {
        return BlizzardHSAPILocaleEnUS;
    } else if ([language containsString:@"fr"]) {
        return BlizzardHSAPILocaleFrFR;
    } else if ([language containsString:@"de"]) {
        return BlizzardHSAPILocaleDeDE;
    } else if ([language containsString:@"it"]) {
        return BlizzardHSAPILocaleItIT;
    } else if ([language containsString:@"ja"]) {
        return BlizzardHSAPILocaleJaJP;
    } else if ([language containsString:@"ko"]) {
        return BlizzardHSAPILocaleKoKR;
    } else if ([language containsString:@"pl"]) {
        return BlizzardHSAPILocalePlPL;
    } else if ([language containsString:@"ru"]) {
        return BlizzardHSAPILocaleRuRU;
    } else if ([localeIdentifier containsString:@"zh_CN"]) {
        return BlizzardHSAPILocaleZhCN;
    } else if ([language containsString:@"es"]) {
        return BlizzardHSAPILocaleKoKR;
    } else if ([localeIdentifier containsString:@"zh_TW"]) {
        return BlizzardHSAPILocaleZhTW;
    } else {
        return BlizzardHSAPILocaleEnUS;
    }
}

+ (NSString *)alternativeAPIRegionHost {
    NSLocale *locale = NSLocale.currentLocale;
    NSString * _Nullable countryCode = locale.countryCode;
    
    if ([countryCode isEqualToString:@"US"]) {
        return NSStringForAPIFromRegionHost(BlizzardAPIRegionHostUS);
    } else if ([countryCode isEqualToString:@"EU"]) {
        return NSStringForAPIFromRegionHost(BlizzardAPIRegionHostEU);
    } else if ([countryCode isEqualToString:@"KR"]) {
        return NSStringForAPIFromRegionHost(BlizzardAPIRegionHostKR);
    } else if ([countryCode isEqualToString:@"TW"]) {
        return NSStringForAPIFromRegionHost(BlizzardAPIRegionHostTW);
    } else if ([countryCode isEqualToString:@"CN"]) {
        return NSStringForAPIFromRegionHost(BlizzardAPIRegionHostCN);
    } else {
        return NSStringForAPIFromRegionHost(BlizzardAPIRegionHostUS);
    }
}

- (NSDictionary *)addLocalKeyIfNeedToOptions:(NSDictionary * _Nullable)options {
    NSString *locale;
    
    if (self.locale) {
        locale = self.locale;
    } else {
        locale = [self class].alternativeLocale;
    }
    
    if (options == nil) {
        return @{BlizzardHSAPIOptionTypeLocale: locale};
    } else if ([options.allKeys containsObject:BlizzardHSAPIOptionTypeLocale]) {
        return options;
    } else {
        NSMutableDictionary *mutableOptions = [options mutableCopy];
        mutableOptions[BlizzardHSAPIOptionTypeLocale] = locale;
        NSDictionary *result = [mutableOptions copy];
        [mutableOptions release];
        return [result autorelease];
    }
}

@end
