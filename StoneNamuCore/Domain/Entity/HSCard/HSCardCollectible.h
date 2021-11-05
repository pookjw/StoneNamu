//
//  HSCardCollectible.h
//  HSCardCollectible
//
//  Created by Jinwoo Kim on 7/28/21.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, HSCardCollectible) {
    HSCardCollectibleYES = 1,
    HSCardCollectibleNO = 0
};

NSString * NSStringFromHSCardCollectible(HSCardCollectible);
HSCardCollectible HSCardCollectibleFromNSString(NSString *);

NSArray<NSString *> *hsCardCollectibles(void);
NSString * localizableFromHSCardCollectible(HSCardCollectible);
NSDictionary<NSString *, NSString *> * localizablesWithHSCardCollectible(void);
