//
//  HSCardType.m
//  HSCardType
//
//  Created by Jinwoo Kim on 7/28/21.
//

#import <StoneNamuCore/HSCardType.h>
#import <StoneNamuCore/Identifier.h>

NSString * NSStringFromHSCardType(HSCardType type) {
    switch (type) {
        case HSCardTypeMinion:
            return @"minion";
        case HSCardTypeSpell:
            return @"spell";
        case HSCardTypeWeapon:
            return @"weapon";
        case HSCardTypeHero:
            return @"hero";
        case HSCardTypeHeroPower:
            return @"hero-power"; // this keyword is not for Blizzard Official API
        default:
            return @"";
    }
}

HSCardType HSCardTypeFromNSString(NSString * key) {
    if ([key isEqualToString:@"minion"]) {
        return HSCardTypeMinion;
    } else if ([key isEqualToString:@"spell"]) {
        return HSCardTypeSpell;
    } else if ([key isEqualToString:@"weapon"]) {
        return HSCardTypeWeapon;
    } else if ([key isEqualToString:@"hero"]) {
        return HSCardTypeHero;
    } else if ([key isEqualToString:@"hero-power"]) {
        return HSCardTypeHeroPower;
    } else {
        return HSCardTypeMinion;
    }
}

NSArray<NSString *> *hsCardTypes(void) {
    return @[
        NSStringFromHSCardType(HSCardTypeMinion),
        NSStringFromHSCardType(HSCardTypeSpell),
        NSStringFromHSCardType(HSCardTypeWeapon),
        NSStringFromHSCardType(HSCardTypeHero),
        NSStringFromHSCardType(HSCardTypeHeroPower)
    ];
}

NSString * localizableFromHSCardType(HSCardType key) {
    return NSLocalizedStringFromTableInBundle(NSStringFromHSCardType(key),
                                              @"HSCardType",
                                              [NSBundle bundleWithIdentifier:IDENTIFIER],
                                              @"");
}

NSDictionary<NSString *, NSString *> * localizableWithHSCardType(void) {
    NSMutableDictionary<NSString *, NSString *> *dic = [@{} mutableCopy];
    
    [hsCardTypes() enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        dic[obj] = localizableFromHSCardType(HSCardTypeFromNSString(obj));
    }];
    
    NSDictionary<NSString *, NSString *> *result = [[dic copy] autorelease];
    [dic release];
    
    return result;
}
