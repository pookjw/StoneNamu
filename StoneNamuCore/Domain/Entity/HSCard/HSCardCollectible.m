//
//  HSCardCollectible.m
//  HSCardCollectible
//
//  Created by Jinwoo Kim on 7/28/21.
//

#import <StoneNamuCore/HSCardCollectible.h>

NSString * NSStringFromHSCardCollectible(HSCardCollectible collectible) {
    switch (collectible) {
        case HSCardCollectibleYES:
            return @"1";
        case HSCardCollectibleNO:
            return @"0";
        default:
            return @"1";
    }
}

HSCardCollectible HSCardCollectibleFromNSString(NSString * key) {
    if ([key isEqualToString:@"1"]) {
        return HSCardCollectibleYES;
    } else if ([key isEqualToString:@"0"]) {
        return HSCardCollectibleNO;
    } else {
        return HSCardCollectibleYES;
    }
}

NSArray<NSString *> *hsCardCollectibles(void) {
    return @[
        NSStringFromHSCardCollectible(HSCardCollectibleYES),
        NSStringFromHSCardCollectible(HSCardCollectibleNO)
    ];
}
