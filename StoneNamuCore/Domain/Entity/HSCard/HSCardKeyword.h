//
//  HSCardKeyword.h
//  HSCardKeywords
//
//  Created by Jinwoo Kim on 7/28/21.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, HSCardKeyword) {
    HSCardKeywordAdapt = 34,
    HSCardKeywordBattlecry = 8,
    HSCardKeywordCharge = 4,
    HSCardKeywordCombo = 13,
    HSCardKeywordCorrupt = 91,
    HSCardKeywordCounter = 16,
    HSCardKeywordDeathrattle = 12,
    HSCardKeywordDiscover = 21,
    HSCardKeywordDivineShield = 3, // divine-shield
    HSCardKeywordEcho = 52,
    HSCardKeywordFreeze = 10,
    HSCardKeywordFrenzy = 99,
    HSCardKeywordImmune = 17,
    HSCardKeywordInspire = 20,
    HSCardKeywordInvoke = 79, // empower
    HSCardKeywordLackey = 71, // evilzug
    HSCardKeywordLifesteal = 38,
    HSCardKeywordMagnetic = 66, // modular
    HSCardKeywordMegaWindfury = 77, // mega-windfury
    HSCardKeywordNatureSpellDamage = 104, // spellpowernature
    HSCardKeywordOutcast = 86,
    HSCardKeywordOverkill = 61,
    HSCardKeywordOverload = 14,
    HSCardKeywordPoisonous = 32,
    HSCardKeywordQuest = 31,
    HSCardKeywordQuestline = 96,
    HSCardKeywordReborn = 78,
    HSCardKeywordRecruit = 39,
    HSCardKeywordRush = 53,
    HSCardKeywordSecret = 5,
    HSCardKeywordSidequest = 89,
    HSCardKeywordSilence = 15,
    HSCardKeywordSpareParts = 19, // spare-part
    HSCardKeywordSpellDamage = 2, // spellpower
    HSCardKeywordSpellburst = 88, // spellburst
    HSCardKeywordStartOfGame = 64, // startofgamekeyword
    HSCardKeywordStealth = 6,
    HSCardKeywordTaunt = 1,
    HSCardKeywordTradeable = 97, // trade
    HSCardKeywordTwinspell = 76,
    HSCardKeywordWindfury = 11
};

NSString * NSStringFromHSCardKeyword(HSCardKeyword);
HSCardKeyword HSCardKeywordFromNSString(NSString *);

NSArray<NSString *> *hsCardKeywords(void);
NSDictionary<NSString *, NSString *> * hsCardKeywordsWithLocalizable(void);
