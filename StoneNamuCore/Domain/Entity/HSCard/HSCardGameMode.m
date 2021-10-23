//
//  HSCardGameMode.m
//  HSCardGameMode
//
//  Created by Jinwoo Kim on 7/29/21.
//

#import "HSCardGameMode.h"
#import <StoneNamuCore/Identifier.h>

NSString * NSStringFromHSCardGameMode(HSCardGameMode gameMode) {
    switch (gameMode) {
        case HSCardGameModeConstructed:
            return @"constructed";
        case HSCardGameModeBattlegrounds:
            return @"battlegrounds";
        case HSCardGameModeDuels:
            return @"duels";
        case HSCardGameModeArena:
            return @"arena";
        case HSCardGameModeMercenaries:
            return @"mercenaries";
        default:
            return @"";
    }
}

HSCardGameMode HSCardGameModeFromNSString(NSString * key) {
    if ([key isEqualToString:@"constructed"]) {
        return HSCardGameModeConstructed;
    } else if ([key isEqualToString:@"battlegrounds"]) {
        return HSCardGameModeBattlegrounds;
    } else if ([key isEqualToString:@"duels"]) {
        return HSCardGameModeDuels;
    } else if ([key isEqualToString:@"arena"]) {
        return HSCardGameModeArena;
    } else if ([key isEqualToString:@"mercenaries"]) {
        return HSCardGameModeMercenaries;
    } else {
        return HSCardGameModeConstructed;
    }
}

NSArray<NSString *> *hsCardGameModes(void) {
    return @[
        NSStringFromHSCardGameMode(HSCardGameModeConstructed),
        NSStringFromHSCardGameMode(HSCardGameModeBattlegrounds),
        NSStringFromHSCardGameMode(HSCardGameModeDuels),
        NSStringFromHSCardGameMode(HSCardGameModeArena),
        NSStringFromHSCardGameMode(HSCardGameModeMercenaries)
    ];
}

NSDictionary<NSString *, NSString *> * hsCardGameModesWithLocalizable(void) {
    NSMutableDictionary<NSString *, NSString *> *dic = [@{} mutableCopy];
    
    [hsCardGameModes() enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        dic[obj] = NSLocalizedStringFromTableInBundle(obj,
                                                      @"HSCardGameMode",
                                                      [NSBundle bundleWithIdentifier:IDENTIFIER],
                                                      @"");
    }];
    
    NSDictionary<NSString *, NSString *> *result = [[dic copy] autorelease];
    [dic release];
    
    return result;
}
