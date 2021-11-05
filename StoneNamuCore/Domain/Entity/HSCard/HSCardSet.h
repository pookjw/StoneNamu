//
//  HSCardSet.h
//  HSCardSet
//
//  Created by Jinwoo Kim on 7/25/21.
//

#import <Foundation/Foundation.h>
#import <StoneNamuCore/HSDeckFormat.h>

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
    HSCardSetJourneyToUngoro = 27,
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
NSString * localizableFromHSCardSet(HSCardSet);
NSDictionary<NSString *, NSString *> * localizablesWithHSCardSet(void);

NSArray<NSString *> *hsCardSetsFromHSDeckFormat(HSDeckFormat);
NSDictionary<NSString *, NSString *> * localizablesWithHSCardSetFromHSDeckFormat(HSDeckFormat);
