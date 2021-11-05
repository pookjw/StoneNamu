//
//  HSCardRarity.m
//  HSCardRarity
//
//  Created by Jinwoo Kim on 7/28/21.
//

#import <StoneNamuCore/HSCardRarity.h>
#import <StoneNamuCore/Identifier.h>

NSString * NSStringFromHSCardRarity(HSCardRarity rarity) {
    switch (rarity) {
        case HSCardRarityFree:
            return @"free";
        case HSCardRarityCommon:
            return @"common";
        case HSCardRarityRare:
            return @"rare";
        case HSCardRarityEpic:
            return @"epic";
        case HSCardRarityLegendary:
            return @"legendary";
        default:
            return @"";
    }
}

HSCardRarity HSCardRarityFromNSString(NSString * key) {
    if ([key isEqualToString:@"free"]) {
        return HSCardRarityFree;
    } else if ([key isEqualToString:@"common"]) {
        return HSCardRarityCommon;
    } else if ([key isEqualToString:@"rare"]) {
        return HSCardRarityRare;
    } else if ([key isEqualToString:@"epic"]) {
        return HSCardRarityEpic;
    } else if ([key isEqualToString:@"legendary"]) {
        return HSCardRarityLegendary;
    } else {
        return HSCardRarityNull;
    }
}

NSArray<NSString *> *hsCardRarities(void) {
    return @[
        NSStringFromHSCardRarity(HSCardRarityNull),
        NSStringFromHSCardRarity(HSCardRarityFree),
        NSStringFromHSCardRarity(HSCardRarityCommon),
        NSStringFromHSCardRarity(HSCardRarityRare),
        NSStringFromHSCardRarity(HSCardRarityEpic),
        NSStringFromHSCardRarity(HSCardRarityLegendary)
    ];
}

NSString * localizableFromHSCardRarity(HSCardRarity key) {
    return NSLocalizedStringFromTableInBundle(NSStringFromHSCardRarity(key),
                                              @"HSCardRarity",
                                              [NSBundle bundleWithIdentifier:IDENTIFIER],
                                              @"");;
}

NSDictionary<NSString *, NSString *> * localizablesWithHSCardRarity(void) {
    NSMutableDictionary<NSString *, NSString *> *dic = [@{} mutableCopy];
    
    [hsCardRarities() enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        dic[obj] = localizableFromHSCardRarity(HSCardRarityFromNSString(obj));
    }];
    
    NSDictionary<NSString *, NSString *> *result = [[dic copy] autorelease];
    [dic release];
    
    return result;
}
