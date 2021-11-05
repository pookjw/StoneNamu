//
//  HSCardSpellSchool.h
//  StoneNamu
//
//  Created by Jinwoo Kim on 11/4/21.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, HSCardSpellSchool) {
    HSCardSpellSchoolArcane = 1,
    HSCardSpellSchoolFire = 2,
    HSCardSpellSchoolFrost = 3,
    HSCardSpellSchoolNature = 4,
    HSCardSpellSchoolHoly = 5,
    HSCardSpellSchoolShadow = 6,
    HSCardSpellSchoolFel = 7
};

NSString * NSStringFromHSCardSpellSchool(HSCardSpellSchool);
HSCardSpellSchool HSCardSpellSchoolFromNSString(NSString *);

NSArray<NSString *> *hsCardSpellSchools(void);

NSString * localizableFromHSCardSpellSchool(HSCardSpellSchool);
NSDictionary<NSString *, NSString *> * localizablesWithHSCardSpellSchool(void);
