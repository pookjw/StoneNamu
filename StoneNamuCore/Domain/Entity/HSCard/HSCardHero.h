//
//  HSCardHero.h
//  HSCardHero
//
//  Created by Jinwoo Kim on 8/17/21.
//

#import <Foundation/Foundation.h>
#import "HSCardClass.h"

typedef NS_ENUM(NSUInteger, HSCardHero) {
    HSCardHeroDemonHunter = 56550,
    HSCardHeroDruid = 274,
    HSCardHeroHunter = 31,
    HSCardHeroMage = 637,
    HSCardHeroPaladin = 671,
    HSCardHeroPriest = 813,
    HSCardHeroRogue = 930,
    HSCardHeroShaman = 1066,
    HSCardHeroWarlock = 893,
    HSCardHeroWarrior = 7
};

HSCardHero HSCardHeroFromHSCardClass(HSCardClass);
HSCardClass HSCardClassFromHSCardHero(HSCardHero);
