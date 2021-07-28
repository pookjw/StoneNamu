//
//  HSCardSet.h
//  HSCardSet
//
//  Created by Jinwoo Kim on 7/25/21.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, HSCardSet) {
    HSCardSetLegacy = 9000,
    HSCardSetNaxxramas = 12,
    HSCardSetGoblinsVsGnomes = 13,
    HSCardSetBlackRockMountain = 14,
    HSCardSetTheGrandTournament = 15,
    HSCardSetLeagueOfExplorers = 20,
    HSCardSetWhispersOfTheOldGods = 21,
    HSCardSetOneNightInKarazhan = 23,
    HSCardSetMeanStreetOfGadgetzan = 25,
    HSCardSetJourneyToUngoro = 157,
    HSCardSetKnightsOfTheFrozenThrone = 1001,
    HSCardSetKoboldsAndCatacombs = 1004,
    HSCardSetTheWitchwood = 1125,
    HSCardSetTheBoomsdayProject = 1127,
    HSCardSetRastakhansRumble = 1129,
    HSCardSetRiseOfShadows = 1130,
    HSCardSetSaviorsOfUldum = 1158,
    HSCardSetDescentOfDragons = 1347,
    HSCardSetGalakrondsAwakening = 1403,
    HSCardSetDemonHunderInitiate = 1463,
    HSCardSetCore = 1637,
    HSCardSetAshesOfOutland = 1414,
    HSCardSetScholomanceAcademy = 1443,
    HSCardSetMadnessAtTheDarkmoonFaire = 1466,
    HSCardSetForgedInTheBarrens = 1525,
    HSCardSetUnitedInStormWind = 1578,
    HSCardSetClassicCards = 1646,
    HSCardSetWildCards = 9001,
    HSCardSetStandardCards = 9002
};

NSString * NSStringFromHSCardSet(HSCardSet);
HSCardSet HSCardSetFromNSString(NSString *);

NSArray<NSString *> * hsCardSets(void);
NSDictionary<NSString *, NSString *> * hsCardSetsWithLocalizable(void);

/*
 legacy
 naxxramas : 12
 goblins-vs-gnomes : 13
 blackrock-mountain : 14
 the-grand-tournament : 15
 league-of-explorers : 20
 whispers-of-the-old-gods : 21
 one-night-in-karazhan : 23
 mean-streets-of-gadgetzan : 25
 journey-to-ungoro : 27
 knights-of-the-frozen-throne : 1001
 kobolds-and-catacombs : 1004
 the-witchwood : 1125
 the-boomsday-project : 1127
 rastakhans-rumble : 1129
 rise-of-shadows : 1130
 saviors-of-uldum : 1158
 descent-of-dragons : 1347
 galakronds-awakening : 1403
 demonhunter-initiate : 1463
 core : 1637
 ashes-of-outland : 1414
 scholomance-academy : 1443
 madness-at-the-darkmoon-faire : 1466
 forged-in-the-barrens : 1525
 united-in-stormwind : 1578
 classic-cards : 1646
 wild
 standard
 */

/*
 gameModes
 duels
 arena
 */
