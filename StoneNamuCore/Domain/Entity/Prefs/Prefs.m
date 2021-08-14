//
//  Prefs.m
//  Prefs
//
//  Created by Jinwoo Kim on 8/10/21.
//

#import "Prefs.h"
#import "BlizzardAPIRegionHost.h"
#import "BlizzardHSAPILocale.h"

@implementation Prefs

@dynamic locale;
@dynamic apiRegionHost;

+ (NSString *)alternativeLocale {
    NSLocale *locale = NSLocale.currentLocale;
    NSString *language = locale.languageCode;
    NSString *localeIdentifier = locale.localeIdentifier;

    if ([language isEqualToString:@"en"]) {
        return BlizzardHSAPILocaleEnUS;
    } else if ([language isEqualToString:@"fr"]) {
        return BlizzardHSAPILocaleFrFR;
    } else if ([language isEqualToString:@"de"]) {
        return BlizzardHSAPILocaleDeDE;
    } else if ([language isEqualToString:@"it"]) {
        return BlizzardHSAPILocaleItIT;
    } else if ([language isEqualToString:@"ja"]) {
        return BlizzardHSAPILocaleJaJP;
    } else if ([language isEqualToString:@"ko"]) {
        return BlizzardHSAPILocaleKoKR;
    } else if ([language isEqualToString:@"pl"]) {
        return BlizzardHSAPILocalePlPL;
    } else if ([language isEqualToString:@"ru"]) {
        return BlizzardHSAPILocaleRuRU;
    } else if ([localeIdentifier isEqualToString:@"zh_CN"]) {
        return BlizzardHSAPILocaleZhCN;
    } else if ([language isEqualToString:@"es"]) {
        return BlizzardHSAPILocaleKoKR;
    } else if ([localeIdentifier isEqualToString:@"zh_TW"]) {
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

@end
