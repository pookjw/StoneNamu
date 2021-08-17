//
//  HSCardType.h
//  HSCardType
//
//  Created by Jinwoo Kim on 7/28/21.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, HSCardType) {
    HSCardTypeMinion = 4,
    HSCardTypeSpell = 5,
    HSCardTypeWeapon = 7,
    HSCardTypeHero = 3,
    HSCardTypeHeroPower = 10
};

NSString * NSStringFromHSCardType(HSCardType);
HSCardType HSCardTypeFromNSString(NSString *);

NSArray<NSString *> *hsCardTypesCollectibles(void);
NSDictionary<NSString *, NSString *> * hsCardTypesWithLocalizable(void);
