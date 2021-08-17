//
//  HSCardMinionType.h
//  HSCardMinionType
//
//  Created by Jinwoo Kim on 7/28/21.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, HSCardMinionType) {
    HSCardMinionTypeBeast = 20,
    HSCardMinionTypeDemon = 15,
    HSCardMinionTypeDragon = 24,
    HSCardMinionTypeElemental = 18,
    HSCardMinionTypeMech = 17,
    HSCardMinionTypeMurloc = 14,
    HSCardMinionTypePirate = 23,
    HSCardMinionTypeQuilboar = 43,
    HSCardMinionTypeTotem = 26,
    HSCardMinionTypeNone = 0
};

NSString * NSStringFromHSCardMinionType(HSCardMinionType);
HSCardMinionType HSCardMinionTypeFromNSString(NSString *);

NSArray<NSString *> *hsCardMinionTypes(void);
NSDictionary<NSString *, NSString *> * hsCardMinionTypesWithLocalizable(void);
