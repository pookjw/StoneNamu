//
//  HSCardSet.m
//  HSCardSet
//
//  Created by Jinwoo Kim on 7/25/21.
//

#import "HSCardSet.h"
#import <StoneNamuCore/Identifier.h>

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
            return @"legacy";
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

NSArray<NSNumber *> * hsCardSets() {
    return @[
        [NSNumber numberWithUnsignedInteger:HSCardSetLegacy],
        [NSNumber numberWithUnsignedInteger:HSCardSetNaxxramas],
        [NSNumber numberWithUnsignedInteger:HSCardSetGoblinsVsGnomes],
        [NSNumber numberWithUnsignedInteger:HSCardSetBlackRockMountain],
        [NSNumber numberWithUnsignedInteger:HSCardSetTheGrandTournament],
        [NSNumber numberWithUnsignedInteger:HSCardSetLeagueOfExplorers],
        [NSNumber numberWithUnsignedInteger:HSCardSetWhispersOfTheOldGods],
        [NSNumber numberWithUnsignedInteger:HSCardSetOneNightInKarazhan],
        [NSNumber numberWithUnsignedInteger:HSCardSetMeanStreetOfGadgetzan],
        [NSNumber numberWithUnsignedInteger:HSCardSetJourneyToUngoro],
        [NSNumber numberWithUnsignedInteger:HSCardSetKnightsOfTheFrozenThrone],
        [NSNumber numberWithUnsignedInteger:HSCardSetKoboldsAndCatacombs],
        [NSNumber numberWithUnsignedInteger:HSCardSetTheWitchwood],
        [NSNumber numberWithUnsignedInteger:HSCardSetTheBoomsdayProject],
        [NSNumber numberWithUnsignedInteger:HSCardSetRastakhansRumble],
        [NSNumber numberWithUnsignedInteger:HSCardSetRiseOfShadows],
        [NSNumber numberWithUnsignedInteger:HSCardSetSaviorsOfUldum],
        [NSNumber numberWithUnsignedInteger:HSCardSetDescentOfDragons],
        [NSNumber numberWithUnsignedInteger:HSCardSetGalakrondsAwakening],
        [NSNumber numberWithUnsignedInteger:HSCardSetDemonHunderInitiate],
        [NSNumber numberWithUnsignedInteger:HSCardSetCore],
        [NSNumber numberWithUnsignedInteger:HSCardSetAshesOfOutland],
        [NSNumber numberWithUnsignedInteger:HSCardSetScholomanceAcademy],
        [NSNumber numberWithUnsignedInteger:HSCardSetMadnessAtTheDarkmoonFaire],
        [NSNumber numberWithUnsignedInteger:HSCardSetForgedInTheBarrens],
        [NSNumber numberWithUnsignedInteger:HSCardSetUnitedInStormWind],
        [NSNumber numberWithUnsignedInteger:HSCardSetClassicCards],
        [NSNumber numberWithUnsignedInteger:HSCardSetWildCards],
        [NSNumber numberWithUnsignedInteger:HSCardSetStandardCards]
    ];
}

NSDictionary<NSString *, NSString *> * hsCardSetsWithLocalizable() {
    NSMutableDictionary<NSString *, NSString *> *dic = [@{} mutableCopy];
    
    [hsCardSets() enumerateObjectsUsingBlock:^(NSNumber * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSString *key = NSStringFromHSCardSet(obj.unsignedIntegerValue);
        dic[key] = NSLocalizedStringFromTableInBundle(key,
                                                      @"HSCardSet",
                                                      [NSBundle bundleWithIdentifier:IDENTIFIER],
                                                      @"");
    }];
    
    NSDictionary<NSString *, NSString *> *result = [[dic copy] autorelease];
    [dic release];
    
    return result;
}

NSArray<NSNumber *> *hsCardSetsFromHSDeckFormat(HSDeckFormat deckFormat) {
    if ([deckFormat isEqualToString:HSDeckFormatStandard]) {
        return @[
            [NSNumber numberWithUnsignedInteger:HSCardSetCore],
            [NSNumber numberWithUnsignedInteger:HSCardSetAshesOfOutland],
            [NSNumber numberWithUnsignedInteger:HSCardSetScholomanceAcademy],
            [NSNumber numberWithUnsignedInteger:HSCardSetMadnessAtTheDarkmoonFaire],
            [NSNumber numberWithUnsignedInteger:HSCardSetForgedInTheBarrens],
            [NSNumber numberWithUnsignedInteger:HSCardSetUnitedInStormWind],
            [NSNumber numberWithUnsignedInteger:HSCardSetStandardCards]
        ];
    } else if ([deckFormat isEqualToString:HSDeckFormatWild]) {
        return @[
            [NSNumber numberWithUnsignedInteger:HSCardSetLegacy],
            [NSNumber numberWithUnsignedInteger:HSCardSetNaxxramas],
            [NSNumber numberWithUnsignedInteger:HSCardSetGoblinsVsGnomes],
            [NSNumber numberWithUnsignedInteger:HSCardSetBlackRockMountain],
            [NSNumber numberWithUnsignedInteger:HSCardSetTheGrandTournament],
            [NSNumber numberWithUnsignedInteger:HSCardSetLeagueOfExplorers],
            [NSNumber numberWithUnsignedInteger:HSCardSetWhispersOfTheOldGods],
            [NSNumber numberWithUnsignedInteger:HSCardSetOneNightInKarazhan],
            [NSNumber numberWithUnsignedInteger:HSCardSetMeanStreetOfGadgetzan],
            [NSNumber numberWithUnsignedInteger:HSCardSetJourneyToUngoro],
            [NSNumber numberWithUnsignedInteger:HSCardSetKnightsOfTheFrozenThrone],
            [NSNumber numberWithUnsignedInteger:HSCardSetKoboldsAndCatacombs],
            [NSNumber numberWithUnsignedInteger:HSCardSetTheWitchwood],
            [NSNumber numberWithUnsignedInteger:HSCardSetTheBoomsdayProject],
            [NSNumber numberWithUnsignedInteger:HSCardSetRastakhansRumble],
            [NSNumber numberWithUnsignedInteger:HSCardSetRiseOfShadows],
            [NSNumber numberWithUnsignedInteger:HSCardSetSaviorsOfUldum],
            [NSNumber numberWithUnsignedInteger:HSCardSetDescentOfDragons],
            [NSNumber numberWithUnsignedInteger:HSCardSetGalakrondsAwakening],
            [NSNumber numberWithUnsignedInteger:HSCardSetDemonHunderInitiate],
            [NSNumber numberWithUnsignedInteger:HSCardSetCore],
            [NSNumber numberWithUnsignedInteger:HSCardSetAshesOfOutland],
            [NSNumber numberWithUnsignedInteger:HSCardSetScholomanceAcademy],
            [NSNumber numberWithUnsignedInteger:HSCardSetMadnessAtTheDarkmoonFaire],
            [NSNumber numberWithUnsignedInteger:HSCardSetForgedInTheBarrens],
            [NSNumber numberWithUnsignedInteger:HSCardSetUnitedInStormWind],
            [NSNumber numberWithUnsignedInteger:HSCardSetWildCards],
            [NSNumber numberWithUnsignedInteger:HSCardSetStandardCards]
        ];
    } else if ([deckFormat isEqualToString:HSDeckFormatClassic]) {
        return @[
            [NSNumber numberWithUnsignedInteger:HSCardSetClassicCards]
        ];
    } else {
        return @[];
    }
}

NSDictionary<NSString *, NSString *> * hsCardSetsWithLocalizableFromHSDeckFormat(HSDeckFormat deckFormat) {
    NSMutableDictionary<NSString *, NSString *> *dic = [@{} mutableCopy];
    
    [hsCardSetsFromHSDeckFormat(deckFormat) enumerateObjectsUsingBlock:^(NSNumber * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSString *key = NSStringFromHSCardSet(obj.unsignedIntegerValue);
        dic[key] = NSLocalizedStringFromTableInBundle(key,
                                                      @"HSCardSet",
                                                      [NSBundle bundleWithIdentifier:IDENTIFIER],
                                                      @"");
    }];
    
    NSDictionary<NSString *, NSString *> *result = [[dic copy] autorelease];
    [dic release];
    
    return result;
}
