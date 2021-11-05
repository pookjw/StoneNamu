//
//  HSCardHero.m
//  HSCardHero
//
//  Created by Jinwoo Kim on 8/17/21.
//

#import <StoneNamuCore/HSCardHero.h>

HSCardHero HSCardHeroFromHSCardClass(HSCardClass key) {
    switch (key) {
        case HSCardClassDemonHunter:
            return HSCardHeroDemonHunter;
        case HSCardClassDruid:
            return HSCardHeroDruid;
        case HSCardClassHunter:
            return HSCardHeroHunter;
        case HSCardClassMage:
            return HSCardHeroMage;
        case HSCardClassPaladin:
            return HSCardHeroPaladin;
        case HSCardClassPriest:
            return HSCardHeroPriest;
        case HSCardClassRogue:
            return HSCardHeroRogue;
        case HSCardClassShaman:
            return HSCardHeroShaman;
        case HSCardClassWarlock:
            return HSCardHeroWarlock;
        case HSCardClassWarrior:
            return HSCardHeroWarrior;
        default:
            NSLog(@"Invalid class key!");
            return 0;
    }
}

HSCardClass HSCardClassFromHSCardHero(HSCardHero key) {
    switch (key) {
        case HSCardHeroDemonHunter:
            return HSCardClassDemonHunter;
        case HSCardHeroDruid:
            return HSCardClassDruid;
        case HSCardHeroHunter:
            return HSCardClassHunter;
        case HSCardHeroMage:
            return HSCardClassMage;
        case HSCardHeroPaladin:
            return HSCardClassPaladin;
        case HSCardHeroPriest:
            return HSCardClassPriest;
        case HSCardHeroRogue:
            return HSCardClassRogue;
        case HSCardHeroShaman:
            return HSCardClassShaman;
        case HSCardHeroWarlock:
            return HSCardClassWarlock;
        case HSCardHeroWarrior:
            return HSCardClassWarrior;
        default:
            NSLog(@"Invalid hero key!");
            return 0;
    }
}

NSArray<NSNumber *> * hsCardHeroes(void) {
    return @[
        [NSNumber numberWithUnsignedInteger:HSCardHeroDemonHunter],
        [NSNumber numberWithUnsignedInteger:HSCardHeroDruid],
        [NSNumber numberWithUnsignedInteger:HSCardHeroHunter],
        [NSNumber numberWithUnsignedInteger:HSCardHeroMage],
        [NSNumber numberWithUnsignedInteger:HSCardHeroPaladin],
        [NSNumber numberWithUnsignedInteger:HSCardHeroPriest],
        [NSNumber numberWithUnsignedInteger:HSCardHeroRogue],
        [NSNumber numberWithUnsignedInteger:HSCardHeroShaman],
        [NSNumber numberWithUnsignedInteger:HSCardHeroWarlock],
        [NSNumber numberWithUnsignedInteger:HSCardHeroWarrior]
    ];
}
