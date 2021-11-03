//
//  HSCardSpellSchool.m
//  StoneNamuCore
//
//  Created by Jinwoo Kim on 11/4/21.
//

#import <StoneNamuCore/HSCardSpellSchool.h>
#import <StoneNamuCore/Identifier.h>

NSString * NSStringFromHSCardSpellSchool(HSCardSpellSchool type) {
    switch (type) {
        case HSCardSpellSchoolArcane:
            return @"arcane";
        case HSCardSpellSchoolFire:
            return @"fire";
        case HSCardSpellSchoolFrost:
            return @"frost";
        case HSCardSpellSchoolNature:
            return @"nature";
        case HSCardSpellSchoolHoly:
            return @"holy";
        case HSCardSpellSchoolShadow:
            return @"shadow";
        case HSCardSpellSchoolFel:
            return @"fel";
        default:
            return @"";
    }
}

HSCardSpellSchool HSCardSpellSchoolFromNSString(NSString * key) {
    if ([key isEqualToString:@"arcane"]) {
        return HSCardSpellSchoolArcane;
    } else if ([key isEqualToString:@"fire"]) {
        return HSCardSpellSchoolFire;
    } else if ([key isEqualToString:@"frost"]) {
        return HSCardSpellSchoolFrost;
    } else if ([key isEqualToString:@"nature"]) {
        return HSCardSpellSchoolNature;
    } else if ([key isEqualToString:@"holy"]) {
        return HSCardSpellSchoolHoly;
    } else if ([key isEqualToString:@"shadow"]) {
        return HSCardSpellSchoolShadow;
    } else if ([key isEqualToString:@"fel"]) {
        return HSCardSpellSchoolFel;
    } else {
        return 0;
    }
}

NSArray<NSString *> *hsCardSpellSchools(void) {
    return @[
        NSStringFromHSCardSpellSchool(HSCardSpellSchoolArcane),
        NSStringFromHSCardSpellSchool(HSCardSpellSchoolFire),
        NSStringFromHSCardSpellSchool(HSCardSpellSchoolFrost),
        NSStringFromHSCardSpellSchool(HSCardSpellSchoolNature),
        NSStringFromHSCardSpellSchool(HSCardSpellSchoolHoly),
        NSStringFromHSCardSpellSchool(HSCardSpellSchoolShadow),
        NSStringFromHSCardSpellSchool(HSCardSpellSchoolFel)
    ];
}

NSDictionary<NSString *, NSString *> * hsCardSpellSchoolsWithLocalizable(void) {
    NSMutableDictionary<NSString *, NSString *> *dic = [@{} mutableCopy];
    
    [hsCardSpellSchools() enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        dic[obj] = NSLocalizedStringFromTableInBundle(obj,
                                                      @"HSCardSpellSchool",
                                                      [NSBundle bundleWithIdentifier:IDENTIFIER],
                                                      @"");
    }];
    
    NSDictionary<NSString *, NSString *> *result = [[dic copy] autorelease];
    [dic release];
    
    return result;
}
