//
//  BlizzardHSAPILocale.m
//  BlizzardHSAPILocale
//
//  Created by Jinwoo Kim on 8/14/21.
//

#import "BlizzardHSAPILocale.h"
#import <StoneNamuCore/Identifier.h>

NSArray<NSString *> *blizzardHSAPILocales(void) {
    return @[
        BlizzardHSAPILocaleEnUS,
        BlizzardHSAPILocaleFrFR,
        BlizzardHSAPILocaleDeDE,
        BlizzardHSAPILocaleItIT,
        BlizzardHSAPILocaleJaJP,
        BlizzardHSAPILocaleKoKR,
        BlizzardHSAPILocalePlPL,
        BlizzardHSAPILocaleRuRU,
        BlizzardHSAPILocaleZhCN,
        BlizzardHSAPILocaleEsES,
        BlizzardHSAPILocaleZhTW
    ];
}

NSDictionary<NSString *, NSString *> *blizzardHSAPILocalesWithLocalizable(void) {
    NSMutableDictionary<NSString *, NSString *> *dic = [@{} mutableCopy];
    
    [blizzardHSAPILocales() enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        dic[obj] = NSLocalizedStringFromTableInBundle(obj,
                                                      @"BlizzardHSAPILocale",
                                                      [NSBundle bundleWithIdentifier:IDENTIFIER],
                                                      @"");
    }];
    
    NSDictionary<NSString *, NSString *> *result = [[dic copy] autorelease];
    [dic release];
    
    return result;
}
