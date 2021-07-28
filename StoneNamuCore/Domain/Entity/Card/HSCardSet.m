//
//  HSCardSet.m
//  HSCardSet
//
//  Created by Jinwoo Kim on 7/25/21.
//

#import "HSCardSet.h"

NSString * NSStringFromHSCardSet(HSCardSet set) {
    switch (set) {
        case HSCardSetLegacy:
            return @"legacy";
        case HSCardSetNaxxramas:
            return @"naxxramas";
        case HSCardSetGoblinsVsGnomes:
            return @"goblins-vs-gnomes";
        case HSCardSetBlackRockMountain:
            return @"blackrock-mountain";
        case HSCardSetTheGrandTournament:
            return @"the-grand-tournament";
        case HSCardSetLeagueOfExplorers:
            return @"league-of-explorers";
        case HSCardSetWhispersOfTheOldGods:
            return @"whispers-of-the-old-gods";
        case HSCardSetOneNightInKarazhan:
            return @"one-night-in-karazhan";
        case HSCardSetMeanStreetOfGadgetzan:
            return @"mean-streets-of-gadgetzan";
        case HSCardSetJourneyToUngoro:
            return @"journey-to-ungoro";
        case HSCardSetKnightsOfTheFrozenThrone:
            return @"knights-of-the-frozen-throne";
        case HSCardSetKoboldsAndCatacombs:
            return @"kobolds-and-catacombs";
        case HSCardSetTheWitchwood:
            return @"the-witchwood";
        case HSCardSetTheBoomsdayProject:
            return @"the-boomsday-project";
        case HSCardSetRastakhansRumble:
            return @"rastakhans-rumble";
        case HSCardSetRiseOfShadows:
            return @"rise-of-shadows";
        case HSCardSetSaviorsOfUldum:
            return @"saviors-of-uldum";
        case HSCardSetDescentOfDragons:
            return @"descent-of-dragons";
        case HSCardSetGalakrondsAwakening:
            return @"galakronds-awakening";
        case HSCardSetDemonHunderInitiate:
            return @"demonhunter-initiate";
        case HSCardSetCore:
            return @"core";
        case HSCardSetAshesOfOutland:
            return @"ashes-of-outland";
        case HSCardSetScholomanceAcademy:
            return @"scholomance-academy";
        case HSCardSetMadnessAtTheDarkmoonFaire:
            return @"madness-at-the-darkmoon-faire";
        case HSCardSetForgedInTheBarrens:
            return @"forged-in-the-barrens";
        case HSCardSetUnitedInStormWind:
            return @"united-in-stormwind";
        case HSCardSetClassicCards:
            return @"classic-cards";
        case HSCardSetWildCards:
            return @"wild";
        case HSCardSetStandardCards:
            return @"standard";
        default:
            return @"";
    }
}

HSCardSet HSCardSetFromNSString(NSString * key) {
    if ([key isEqualToString:@"legacy"]) {
        return HSCardSetLegacy;
    } else if ([key isEqualToString:@"naxxramas"]) {
        return HSCardSetNaxxramas;
    } else if ([key isEqualToString:@"goblins-vs-gnomes"]) {
        return HSCardSetGoblinsVsGnomes;
    } else if ([key isEqualToString:@"blackrock-mountain"]) {
        return HSCardSetBlackRockMountain;
    } else if ([key isEqualToString:@"the-grand-tournament"]) {
        return HSCardSetTheGrandTournament;
    } else if ([key isEqualToString:@"league-of-explorers"]) {
        return HSCardSetLeagueOfExplorers;
    } else if ([key isEqualToString:@"whispers-of-the-old-gods"]) {
        return HSCardSetWhispersOfTheOldGods;
    } else if ([key isEqualToString:@"one-night-in-karazhan"]) {
        return HSCardSetOneNightInKarazhan;
    } else if ([key isEqualToString:@"mean-streets-of-gadgetzan"]) {
        return HSCardSetMeanStreetOfGadgetzan;
    } else if ([key isEqualToString:@"journey-to-ungoro"]) {
        return HSCardSetJourneyToUngoro;
    } else if ([key isEqualToString:@"knights-of-the-frozen-throne"]) {
        return HSCardSetKnightsOfTheFrozenThrone;
    } else if ([key isEqualToString:@"kobolds-and-catacombs"]) {
        return HSCardSetKoboldsAndCatacombs;
    } else if ([key isEqualToString:@"the-witchwood"]) {
        return HSCardSetTheWitchwood;
    } else if ([key isEqualToString:@"the-boomsday-project"]) {
        return HSCardSetTheBoomsdayProject;
    } else if ([key isEqualToString:@"rastakhans-rumble"]) {
        return HSCardSetRastakhansRumble;
    } else if ([key isEqualToString:@"rise-of-shadows"]) {
        return HSCardSetRiseOfShadows;
    } else if ([key isEqualToString:@"saviors-of-uldum"]) {
        return HSCardSetSaviorsOfUldum;
    } else if ([key isEqualToString:@"descent-of-dragons"]) {
        return HSCardSetDescentOfDragons;
    } else if ([key isEqualToString:@"galakronds-awakening"]) {
        return HSCardSetGalakrondsAwakening;
    } else if ([key isEqualToString:@"demonhunter-initiate"]) {
        return HSCardSetDemonHunderInitiate;
    } else if ([key isEqualToString:@"core"]) {
        return HSCardSetCore;
    } else if ([key isEqualToString:@"ashes-of-outland"]) {
        return HSCardSetAshesOfOutland;
    } else if ([key isEqualToString:@"scholomance-academy"]) {
        return HSCardSetScholomanceAcademy;
    } else if ([key isEqualToString:@"madness-at-the-darkmoon-faire"]) {
        return HSCardSetMadnessAtTheDarkmoonFaire;
    } else if ([key isEqualToString:@"forged-in-the-barrens"]) {
        return HSCardSetForgedInTheBarrens;
    } else if ([key isEqualToString:@"united-in-stormwind"]) {
        return HSCardSetUnitedInStormWind;
    } else if ([key isEqualToString:@"classic-cards"]) {
        return HSCardSetClassicCards;
    } else if ([key isEqualToString:@"wild"]) {
        return HSCardSetWildCards;
    } else if ([key isEqualToString:@"standard"]) {
        return HSCardSetStandardCards;
    } else {
        return HSCardSetLegacy;
    }
}

NSArray<NSString *> * hsCardSets() {
    return @[
        NSStringFromHSCardSet(HSCardSetLegacy),
        NSStringFromHSCardSet(HSCardSetNaxxramas),
        NSStringFromHSCardSet(HSCardSetNaxxramas),
        NSStringFromHSCardSet(HSCardSetBlackRockMountain),
        NSStringFromHSCardSet(HSCardSetTheGrandTournament),
        NSStringFromHSCardSet(HSCardSetLeagueOfExplorers),
        NSStringFromHSCardSet(HSCardSetWhispersOfTheOldGods),
        NSStringFromHSCardSet(HSCardSetOneNightInKarazhan),
        NSStringFromHSCardSet(HSCardSetMeanStreetOfGadgetzan),
        NSStringFromHSCardSet(HSCardSetJourneyToUngoro),
        NSStringFromHSCardSet(HSCardSetKnightsOfTheFrozenThrone),
        NSStringFromHSCardSet(HSCardSetKoboldsAndCatacombs),
        NSStringFromHSCardSet(HSCardSetTheWitchwood),
        NSStringFromHSCardSet(HSCardSetTheBoomsdayProject),
        NSStringFromHSCardSet(HSCardSetRastakhansRumble),
        NSStringFromHSCardSet(HSCardSetRiseOfShadows),
        NSStringFromHSCardSet(HSCardSetSaviorsOfUldum),
        NSStringFromHSCardSet(HSCardSetDescentOfDragons),
        NSStringFromHSCardSet(HSCardSetGalakrondsAwakening),
        NSStringFromHSCardSet(HSCardSetDemonHunderInitiate),
        NSStringFromHSCardSet(HSCardSetCore),
        NSStringFromHSCardSet(HSCardSetAshesOfOutland),
        NSStringFromHSCardSet(HSCardSetScholomanceAcademy),
        NSStringFromHSCardSet(HSCardSetMadnessAtTheDarkmoonFaire),
        NSStringFromHSCardSet(HSCardSetForgedInTheBarrens),
        NSStringFromHSCardSet(HSCardSetUnitedInStormWind),
        NSStringFromHSCardSet(HSCardSetClassicCards),
        NSStringFromHSCardSet(HSCardSetWildCards),
        NSStringFromHSCardSet(HSCardSetStandardCards)
    ];
}

NSDictionary<NSString *, NSString *> * hsCardSetsWithLocalizable() {
    NSMutableDictionary<NSString *, NSString *> *dic = [@{} mutableCopy];
    
    [hsCardSets() enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        dic[obj] = NSLocalizedStringFromTableInBundle(obj,
                                                      @"HSCardSet",
                                                      [NSBundle bundleWithIdentifier:@"com.pookjw.StoneNamuCore"],
                                                      @"");
    }];
    
    NSDictionary<NSString *, NSString *> *result = [[dic copy] autorelease];
    [dic release];
    
    return result;;
}
