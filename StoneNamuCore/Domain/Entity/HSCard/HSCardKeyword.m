//
//  HSCardKeyword.m
//  HSCardKeyword
//
//  Created by Jinwoo Kim on 7/29/21.
//

#import <StoneNamuCore/HSCardKeyword.h>
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
    if ([key isEqualToString:@"adapt"]) {
        return HSCardKeywordAdapt;
    } else if ([key isEqualToString:@"battlecry"]) {
        return HSCardKeywordBattlecry;
    } else if ([key isEqualToString:@"charge"]) {
        return HSCardKeywordCharge;
    } else if ([key isEqualToString:@"combo"]) {
        return HSCardKeywordCombo;
    } else if ([key isEqualToString:@"corrupt"]) {
        return HSCardKeywordCorrupt;
    } else if ([key isEqualToString:@"counter"]) {
        return HSCardKeywordCounter;
    } else if ([key isEqualToString:@"deathrattle"]) {
        return HSCardKeywordDeathrattle;
    } else if ([key isEqualToString:@"discover"]) {
        return HSCardKeywordDiscover;
    } else if ([key isEqualToString:@"divine-shield"]) {
        return HSCardKeywordDivineShield;
    } else if ([key isEqualToString:@"echo"]) {
        return HSCardKeywordEcho;
    } else if ([key isEqualToString:@"freeze"]) {
        return HSCardKeywordFreeze;
    } else if ([key isEqualToString:@"frenzy"]) {
        return HSCardKeywordFrenzy;
    } else if ([key isEqualToString:@"immune"]) {
        return HSCardKeywordImmune;
    } else if ([key isEqualToString:@"inspire"]) {
        return HSCardKeywordInspire;
    } else if ([key isEqualToString:@"empower"]) {
        return HSCardKeywordInvoke;
    } else if ([key isEqualToString:@"evilzug"]) {
        return HSCardKeywordLackey;
    } else if ([key isEqualToString:@"lifesteal"]) {
        return HSCardKeywordLifesteal;
    } else if ([key isEqualToString:@"modular"]) {
        return HSCardKeywordMagnetic;
    } else if ([key isEqualToString:@"mega-windfury"]) {
        return HSCardKeywordMegaWindfury;
    } else if ([key isEqualToString:@"spellpowernature"]) {
        return HSCardKeywordNatureSpellDamage;
    } else if ([key isEqualToString:@"outcast"]) {
        return HSCardKeywordOutcast;
    } else if ([key isEqualToString:@"overkill"]) {
        return HSCardKeywordOverkill;
    } else if ([key isEqualToString:@"overload"]) {
        return HSCardKeywordOverload;
    } else if ([key isEqualToString:@"poisonous"]) {
        return HSCardKeywordPoisonous;
    } else if ([key isEqualToString:@"quest"]) {
        return HSCardKeywordQuest;
    } else if ([key isEqualToString:@"questline"]) {
        return HSCardKeywordQuestline;
    } else if ([key isEqualToString:@"reborn"]) {
        return HSCardKeywordReborn;
    } else if ([key isEqualToString:@"recruit"]) {
        return HSCardKeywordRecruit;
    } else if ([key isEqualToString:@"rush"]) {
        return HSCardKeywordRush;
    } else if ([key isEqualToString:@"secret"]) {
        return HSCardKeywordSecret;
    } else if ([key isEqualToString:@"sidequest"]) {
        return HSCardKeywordSidequest;
    } else if ([key isEqualToString:@"silence"]) {
        return HSCardKeywordSilence;
    } else if ([key isEqualToString:@"spare-part"]) {
        return HSCardKeywordSpareParts;
    } else if ([key isEqualToString:@"spellpower"]) {
        return HSCardKeywordSpellDamage;
    } else if ([key isEqualToString:@"spellburst"]) {
        return HSCardKeywordSpellburst;
    } else if ([key isEqualToString:@"startofgamekeyword"]) {
        return HSCardKeywordStartOfGame;
    } else if ([key isEqualToString:@"stealth"]) {
        return HSCardKeywordStealth;
    } else if ([key isEqualToString:@"taunt"]) {
        return HSCardKeywordTaunt;
    } else if ([key isEqualToString:@"trade"]) {
        return HSCardKeywordTradeable;
    } else if ([key isEqualToString:@"twinspell"]) {
        return HSCardKeywordTwinspell;
    } else if ([key isEqualToString:@"windfury"]) {
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
