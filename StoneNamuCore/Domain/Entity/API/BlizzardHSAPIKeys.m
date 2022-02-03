//
//  BlizzardHSAPIKeys.m
//  BlizzardHSAPIKeys
//
//  Created by Jinwoo Kim on 9/1/21.
//

#import <StoneNamuCore/BlizzardHSAPIKeys.h>
#import <StoneNamuCore/HSCardSet.h>
#import <StoneNamuCore/HSCardCollectible.h>
#import <StoneNamuCore/HSCardGameMode.h>
#import <StoneNamuCore/HSCardSort.h>

NSDictionary<BlizzardHSAPIOptionType, NSSet<NSString *> *> *BlizzardHSAPIDefaultOptions(void) {
    return @{
        BlizzardHSAPIOptionTypeCollectible: [NSSet setWithObject:NSStringFromHSCardCollectible(HSCardCollectibleYES)],
        BlizzardHSAPIOptionTypeGameMode: [NSSet setWithObject:NSStringFromHSCardGameMode(HSCardGameModeConstructed)],
        BlizzardHSAPIOptionTypeSort: [NSSet setWithArray:@[NSStringFromHSCardSort(HSCardSortManaCostAsc), NSStringFromHSCardSort(HSCardSortNameAsc)]]
    };
}

NSDictionary<BlizzardHSAPIOptionType, NSSet<NSString *> *> *BlizzardHSAPIDefaultOptionsUsingLocalDeck(LocalDeck * localDeck) {
    NSMutableDictionary<BlizzardHSAPIOptionType, NSSet<NSString *> *> *finalOptions = [BlizzardHSAPIDefaultOptions() mutableCopy];
    finalOptions[BlizzardHSAPIOptionTypeClass] = [NSSet setWithObject:NSStringFromHSCardClass(localDeck.classId.unsignedIntegerValue)];
   
    HSCardSet cardSet;
    if ([localDeck.format isEqualToString:HSDeckFormatStandard]) {
        cardSet = HSCardSetStandardCards;
    } else if ([localDeck.format isEqualToString:HSDeckFormatWild]) {
        cardSet = HSCardSetWildCards;
    } else if ([localDeck.format isEqualToString:HSDeckFormatClassic]) {
        cardSet = HSCardSetClassicCards;
    } else {
        cardSet = HSCardSetWildCards;
    }
    finalOptions[BlizzardHSAPIOptionTypeSet] = [NSSet setWithObject:NSStringFromHSCardSet(cardSet)];
    
    return [finalOptions autorelease];
}
