//
//  HSCardKeyword.m
//  HSCardKeyword
//
//  Created by Jinwoo Kim on 7/29/21.
//

#import "HSCardKeyword.h"
#import <StoneNamuCore/Identifier.h>

NSString * NSStringFromHSCardKeyword(HSCardKeyword keyword) {
    switch (keyword) {
        case HSCardKeywordAdapt:
            return @"adapt";
        case HSCardKeywordBattlecry:
            return @"battlecry";
        case HSCardKeywordCharge:
            return @"charge";
        case HSCardKeywordCombo:
            return @"combo";
        case HSCardKeywordCorrupt:
            return @"corrupt";
        case HSCardKeywordCounter:
            return @"counter";
        case HSCardKeywordDeathrattle:
            return @"deathrattle";
        case HSCardKeywordDiscover:
            return @"discover";
        case HSCardKeywordDivineShield:
            return @"divine-shield";
        case HSCardKeywordEcho:
            return @"echo";
        case HSCardKeywordFreeze:
            return @"freeze";
        case HSCardKeywordFrenzy:
            return @"frenzy";
        case HSCardKeywordImmune:
            return @"immune";
        case HSCardKeywordInspire:
            return @"inspire";
        case HSCardKeywordInvoke:
            return @"empower";
        case HSCardKeywordLackey:
            return @"evilzug";
        case HSCardKeywordLifesteal:
            return @"lifesteal";
        case HSCardKeywordMagnetic:
            return @"modular";
        case HSCardKeywordMegaWindfury:
            return @"mega-windfury";
        case HSCardKeywordNatureSpellDamage:
            return @"spellpowernature";
        case HSCardKeywordOutcast:
            return @"outcast";
        case HSCardKeywordOverkill:
            return @"overkill";
        case HSCardKeywordOverload:
            return @"overload";
        case HSCardKeywordPoisonous:
            return @"poisonous";
        case HSCardKeywordQuest:
            return @"quest";
        case HSCardKeywordQuestline:
            return @"questline";
        case HSCardKeywordReborn:
            return @"reborn";
        case HSCardKeywordRecruit:
            return @"recruit";
        case HSCardKeywordRush:
            return @"rush";
        case HSCardKeywordSecret:
            return @"secret";
        case HSCardKeywordSidequest:
            return @"sidequest";
        case HSCardKeywordSilence:
            return @"silence";
        case HSCardKeywordSpareParts:
            return @"spare-part";
        case HSCardKeywordSpellDamage:
            return @"spellpower";
        case HSCardKeywordSpellburst:
            return @"spellburst";
        case HSCardKeywordStartOfGame:
            return @"startofgamekeyword";
        case HSCardKeywordStealth:
            return @"stealth";
        case HSCardKeywordTaunt:
            return @"taunt";
        case HSCardKeywordTradeable:
            return @"trade";
        case HSCardKeywordTwinspell:
            return @"twinspell";
        case HSCardKeywordWindfury:
            return @"windfury";
        default:
            return @"";
    }
}

HSCardKeyword HSCardKeywordFromNSString(NSString * key) {
    if ([key isEqual:@"adapt"]) {
        return HSCardKeywordAdapt;
    } else if ([key isEqual:@"battlecry"]) {
        return HSCardKeywordBattlecry;
    } else if ([key isEqual:@"charge"]) {
        return HSCardKeywordCharge;
    } else if ([key isEqual:@"combo"]) {
        return HSCardKeywordCombo;
    } else if ([key isEqual:@"corrupt"]) {
        return HSCardKeywordCorrupt;
    } else if ([key isEqual:@"counter"]) {
        return HSCardKeywordCounter;
    } else if ([key isEqual:@"deathrattle"]) {
        return HSCardKeywordDeathrattle;
    } else if ([key isEqual:@"discover"]) {
        return HSCardKeywordDiscover;
    } else if ([key isEqual:@"divine-shield"]) {
        return HSCardKeywordDivineShield;
    } else if ([key isEqual:@"echo"]) {
        return HSCardKeywordEcho;
    } else if ([key isEqual:@"freeze"]) {
        return HSCardKeywordFreeze;
    } else if ([key isEqual:@"frenzy"]) {
        return HSCardKeywordFrenzy;
    } else if ([key isEqual:@"immune"]) {
        return HSCardKeywordImmune;
    } else if ([key isEqual:@"inspire"]) {
        return HSCardKeywordInspire;
    } else if ([key isEqual:@"empower"]) {
        return HSCardKeywordInvoke;
    } else if ([key isEqual:@"evilzug"]) {
        return HSCardKeywordLackey;
    } else if ([key isEqual:@"lifesteal"]) {
        return HSCardKeywordLifesteal;
    } else if ([key isEqual:@"modular"]) {
        return HSCardKeywordMagnetic;
    } else if ([key isEqual:@"mega-windfury"]) {
        return HSCardKeywordMegaWindfury;
    } else if ([key isEqual:@"spellpowernature"]) {
        return HSCardKeywordNatureSpellDamage;
    } else if ([key isEqual:@"outcast"]) {
        return HSCardKeywordOutcast;
    } else if ([key isEqual:@"overkill"]) {
        return HSCardKeywordOverkill;
    } else if ([key isEqual:@"overload"]) {
        return HSCardKeywordOverload;
    } else if ([key isEqual:@"poisonous"]) {
        return HSCardKeywordPoisonous;
    } else if ([key isEqual:@"quest"]) {
        return HSCardKeywordQuest;
    } else if ([key isEqual:@"questline"]) {
        return HSCardKeywordQuestline;
    } else if ([key isEqual:@"reborn"]) {
        return HSCardKeywordReborn;
    } else if ([key isEqual:@"recruit"]) {
        return HSCardKeywordRecruit;
    } else if ([key isEqual:@"rush"]) {
        return HSCardKeywordRush;
    } else if ([key isEqual:@"secret"]) {
        return HSCardKeywordSecret;
    } else if ([key isEqual:@"sidequest"]) {
        return HSCardKeywordSidequest;
    } else if ([key isEqual:@"silence"]) {
        return HSCardKeywordSilence;
    } else if ([key isEqual:@"spare-part"]) {
        return HSCardKeywordSpareParts;
    } else if ([key isEqual:@"spellpower"]) {
        return HSCardKeywordSpellDamage;
    } else if ([key isEqual:@"spellburst"]) {
        return HSCardKeywordSpellburst;
    } else if ([key isEqual:@"startofgamekeyword"]) {
        return HSCardKeywordStartOfGame;
    } else if ([key isEqual:@"stealth"]) {
        return HSCardKeywordStealth;
    } else if ([key isEqual:@"taunt"]) {
        return HSCardKeywordTaunt;
    } else if ([key isEqual:@"trade"]) {
        return HSCardKeywordTradeable;
    } else if ([key isEqual:@"twinspell"]) {
        return HSCardKeywordTwinspell;
    } else if ([key isEqual:@"windfury"]) {
        return HSCardKeywordWindfury;
    } else {
        return 0;
    }
}

NSArray<NSString *> *hsCardKeywords(void) {
    return @[
        NSStringFromHSCardKeyword(HSCardKeywordAdapt),
        NSStringFromHSCardKeyword(HSCardKeywordBattlecry),
        NSStringFromHSCardKeyword(HSCardKeywordCharge),
        NSStringFromHSCardKeyword(HSCardKeywordCombo),
        NSStringFromHSCardKeyword(HSCardKeywordCorrupt),
        NSStringFromHSCardKeyword(HSCardKeywordCounter),
        NSStringFromHSCardKeyword(HSCardKeywordDeathrattle),
        NSStringFromHSCardKeyword(HSCardKeywordDiscover),
        NSStringFromHSCardKeyword(HSCardKeywordDivineShield),
        NSStringFromHSCardKeyword(HSCardKeywordEcho),
        NSStringFromHSCardKeyword(HSCardKeywordFreeze),
        NSStringFromHSCardKeyword(HSCardKeywordFrenzy),
        NSStringFromHSCardKeyword(HSCardKeywordImmune),
        NSStringFromHSCardKeyword(HSCardKeywordInspire),
        NSStringFromHSCardKeyword(HSCardKeywordInvoke),
        NSStringFromHSCardKeyword(HSCardKeywordLackey),
        NSStringFromHSCardKeyword(HSCardKeywordLifesteal),
        NSStringFromHSCardKeyword(HSCardKeywordMagnetic),
        NSStringFromHSCardKeyword(HSCardKeywordMegaWindfury),
        NSStringFromHSCardKeyword(HSCardKeywordNatureSpellDamage),
        NSStringFromHSCardKeyword(HSCardKeywordOutcast),
        NSStringFromHSCardKeyword(HSCardKeywordOverkill),
        NSStringFromHSCardKeyword(HSCardKeywordOverload),
        NSStringFromHSCardKeyword(HSCardKeywordPoisonous),
        NSStringFromHSCardKeyword(HSCardKeywordQuest),
        NSStringFromHSCardKeyword(HSCardKeywordQuestline),
        NSStringFromHSCardKeyword(HSCardKeywordReborn),
        NSStringFromHSCardKeyword(HSCardKeywordRecruit),
        NSStringFromHSCardKeyword(HSCardKeywordRush),
        NSStringFromHSCardKeyword(HSCardKeywordSecret),
        NSStringFromHSCardKeyword(HSCardKeywordSidequest),
        NSStringFromHSCardKeyword(HSCardKeywordSilence),
        NSStringFromHSCardKeyword(HSCardKeywordSpareParts),
        NSStringFromHSCardKeyword(HSCardKeywordSpellDamage),
        NSStringFromHSCardKeyword(HSCardKeywordSpellburst),
        NSStringFromHSCardKeyword(HSCardKeywordStartOfGame),
        NSStringFromHSCardKeyword(HSCardKeywordStealth),
        NSStringFromHSCardKeyword(HSCardKeywordTaunt),
        NSStringFromHSCardKeyword(HSCardKeywordTradeable),
        NSStringFromHSCardKeyword(HSCardKeywordTwinspell),
        NSStringFromHSCardKeyword(HSCardKeywordWindfury)
    ];
}

NSDictionary<NSString *, NSString *> * hsCardKeywordsWithLocalizable(void) {
    NSMutableDictionary<NSString *, NSString *> *dic = [@{} mutableCopy];
    
    [hsCardKeywords() enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        dic[obj] = NSLocalizedStringFromTableInBundle(obj,
                                                      @"HSCardKeyword",
                                                      [NSBundle bundleWithIdentifier:IDENTIFIER],
                                                      @"");
    }];
    
    NSDictionary<NSString *, NSString *> *result = [[dic copy] autorelease];
    [dic release];
    
    return result;
}
