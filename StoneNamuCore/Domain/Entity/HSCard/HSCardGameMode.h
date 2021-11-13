//
//  HSCardGameMode.h
//  HSCardGameMode
//
//  Created by Jinwoo Kim on 7/29/21.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, HSCardGameMode) {
    HSCardGameModeConstructed,
    HSCardGameModeBattlegrounds,
    HSCardGameModeDuels,
    HSCardGameModeArena,
    HSCardGameModeMercenaries
};

NSString * NSStringFromHSCardGameMode(HSCardGameMode);
HSCardGameMode HSCardGameModeFromNSString(NSString *);

NSArray<NSString *> *hsCardGameModes(void);
