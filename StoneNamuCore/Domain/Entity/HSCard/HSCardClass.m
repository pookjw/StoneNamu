//
//  HSCardClass.m
//  HSCardClass
//
//  Created by Jinwoo Kim on 7/28/21.
//

#import <StoneNamuCore/HSCardClass.h>
#import <StoneNamuCore/Identifier.h>

NSString * NSStringFromHSCardClass(HSCardClass class) {
    switch (class) {
        case HSCardClassNeutral:
            return @"neutral";
        case HSCardClassDeathKnight:
            return @"deathknight";
        case HSCardClassDemonHunter:
            return @"demonhunter";
        case HSCardClassDruid:
            return @"druid";
        case HSCardClassHunter:
            return @"hunter";
        case HSCardClassMage:
            return @"mage";
        case HSCardClassPaladin:
            return @"paladin";
        case HSCardClassPriest:
            return @"priest";
        case HSCardClassRogue:
            return @"rogue";
        case HSCardClassShaman:
            return @"shaman";
        case HSCardClassWarlock:
            return @"warlock";
        case HSCardClassWarrior:
            return @"warrior";
        default:
            return @"";
    }
}

HSCardClass HSCardClassFromNSString(NSString * key) {
    if ([key isEqualToString:@"neutral"]) {
        return HSCardClassNeutral;
    } else if ([key isEqualToString:@"deathknight"]) {
        return HSCardClassDeathKnight;
    } else if ([key isEqualToString:@"demonhunter"]) {
        return HSCardClassDemonHunter;
    } else if ([key isEqualToString:@"druid"]) {
        return HSCardClassDruid;
    } else if ([key isEqualToString:@"hunter"]) {
        return HSCardClassHunter;
    } else if ([key isEqualToString:@"mage"]) {
        return HSCardClassMage;
    } else if ([key isEqualToString:@"paladin"]) {
        return HSCardClassPaladin;
    } else if ([key isEqualToString:@"priest"]) {
        return HSCardClassPriest;
    } else if ([key isEqualToString:@"rogue"]) {
        return HSCardClassRogue;
    } else if ([key isEqualToString:@"shaman"]) {
        return HSCardClassShaman;
    } else if ([key isEqualToString:@"warlock"]) {
        return HSCardClassWarlock;
    } else if ([key isEqualToString:@"warrior"]) {
        return HSCardClassWarrior;
    } else {
        return HSCardClassNeutral;
    }
}

NSArray<NSString *> * hsCardClasses(void) {
    return @[
        NSStringFromHSCardClass(HSCardClassNeutral),
        NSStringFromHSCardClass(HSCardClassDeathKnight),
        NSStringFromHSCardClass(HSCardClassDemonHunter),
        NSStringFromHSCardClass(HSCardClassDruid),
        NSStringFromHSCardClass(HSCardClassHunter),
        NSStringFromHSCardClass(HSCardClassMage),
        NSStringFromHSCardClass(HSCardClassPaladin),
        NSStringFromHSCardClass(HSCardClassPriest),
        NSStringFromHSCardClass(HSCardClassRogue),
        NSStringFromHSCardClass(HSCardClassShaman),
        NSStringFromHSCardClass(HSCardClassWarlock),
        NSStringFromHSCardClass(HSCardClassWarrior)
    ];
}

NSArray<NSString *> * hsCardClassesForFormat(HSDeckFormat format) {
    if ([format isEqualToString:HSDeckFormatStandard]) {
        return @[
            NSStringFromHSCardClass(HSCardClassDemonHunter),
            NSStringFromHSCardClass(HSCardClassDruid),
            NSStringFromHSCardClass(HSCardClassHunter),
            NSStringFromHSCardClass(HSCardClassMage),
            NSStringFromHSCardClass(HSCardClassPaladin),
            NSStringFromHSCardClass(HSCardClassPriest),
            NSStringFromHSCardClass(HSCardClassRogue),
            NSStringFromHSCardClass(HSCardClassShaman),
            NSStringFromHSCardClass(HSCardClassWarlock),
            NSStringFromHSCardClass(HSCardClassWarrior)
        ];
    } else if ([format isEqualToString:HSDeckFormatWild]) {
        return @[
            NSStringFromHSCardClass(HSCardClassDemonHunter),
            NSStringFromHSCardClass(HSCardClassDruid),
            NSStringFromHSCardClass(HSCardClassHunter),
            NSStringFromHSCardClass(HSCardClassMage),
            NSStringFromHSCardClass(HSCardClassPaladin),
            NSStringFromHSCardClass(HSCardClassPriest),
            NSStringFromHSCardClass(HSCardClassRogue),
            NSStringFromHSCardClass(HSCardClassShaman),
            NSStringFromHSCardClass(HSCardClassWarlock),
            NSStringFromHSCardClass(HSCardClassWarrior)
        ];
    } else if ([format isEqualToString:HSDeckFormatClassic]) {
        return @[
            NSStringFromHSCardClass(HSCardClassDruid),
            NSStringFromHSCardClass(HSCardClassHunter),
            NSStringFromHSCardClass(HSCardClassMage),
            NSStringFromHSCardClass(HSCardClassPaladin),
            NSStringFromHSCardClass(HSCardClassPriest),
            NSStringFromHSCardClass(HSCardClassRogue),
            NSStringFromHSCardClass(HSCardClassShaman),
            NSStringFromHSCardClass(HSCardClassWarlock),
            NSStringFromHSCardClass(HSCardClassWarrior)
        ];
    } else {
        return @[];
    }
}

NSDictionary<NSString *, NSString *> * hsCardClassesWithLocalizable(void) {
    NSMutableDictionary<NSString *, NSString *> *dic = [@{} mutableCopy];
    
    [hsCardClasses() enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        dic[obj] = NSLocalizedStringFromTableInBundle(obj,
                                                      @"HSCardClass",
                                                      [NSBundle bundleWithIdentifier:IDENTIFIER],
                                                      @"");
    }];
    
    NSDictionary<NSString *, NSString *> *result = [[dic copy] autorelease];
    [dic release];
    
    return result;
}

NSDictionary<NSString *, NSString *> * hsCardClassesWithLocalizableForFormat(HSDeckFormat format) {
    NSMutableDictionary<NSString *, NSString *> *dic = [@{} mutableCopy];
    
    [hsCardClassesForFormat(format) enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        dic[obj] = NSLocalizedStringFromTableInBundle(obj,
                                                      @"HSCardClass",
                                                      [NSBundle bundleWithIdentifier:IDENTIFIER],
                                                      @"");
    }];
    
    NSDictionary<NSString *, NSString *> *result = [[dic copy] autorelease];
    [dic release];
    
    return result;
}
