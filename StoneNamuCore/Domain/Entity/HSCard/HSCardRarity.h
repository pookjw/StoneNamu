//
//  HSCardRarity.h
//  StoneNamuCore
//
//  Created by Jinwoo Kim on 7/18/21.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, HSCardRarity) {
    HSCardRarityNull = 0,
    HSCardRarityFree = 2,
    HSCardRarityCommon = 1,
    HSCardRarityRare = 3,
    HSCardRarityEpic = 4,
    HSCardRarityLegendary = 5
};

NSString * NSStringFromHSCardRarity(HSCardRarity);
HSCardRarity HSCardRarityFromNSString(NSString *);

NSArray<NSString *> *hsCardRarities(void);
