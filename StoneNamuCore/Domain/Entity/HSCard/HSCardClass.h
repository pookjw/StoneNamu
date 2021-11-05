//
//  HSCardClass.h
//  StoneNamuCore
//
//  Created by Jinwoo Kim on 7/18/21.
//

#import <Foundation/Foundation.h>
#import <StoneNamuCore/HSDeckFormat.h>

typedef NS_ENUM(NSUInteger, HSCardClass) {
    HSCardClassNeutral = 12,
    HSCardClassDeathKnight = 1,
    HSCardClassDemonHunter = 14,
    HSCardClassDruid = 2,
    HSCardClassHunter = 3,
    HSCardClassMage = 4,
    HSCardClassPaladin = 5,
    HSCardClassPriest = 6,
    HSCardClassRogue = 7,
    HSCardClassShaman = 8,
    HSCardClassWarlock = 9,
    HSCardClassWarrior = 10,
};

NSString * NSStringFromHSCardClass(HSCardClass);
HSCardClass HSCardClassFromNSString(NSString *);

NSArray<NSString *> * hsCardClasses(void);
NSArray<NSString *> * hsCardClassesForFormat(HSDeckFormat);

NSString * localizableFromHSCardClass(HSCardClass);
NSDictionary<NSString *, NSString *> * localizablesWithHSCardClass(void);
NSDictionary<NSString *, NSString *> * localizablesWithHSCardClasseForFormat(HSDeckFormat);
