//
//  BlizzardHSAPILocale.h
//  StoneNamuCore
//
//  Created by Jinwoo Kim on 7/17/21.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, BlizzardHSAPILocale) {
    BlizzardHSAPILocaleEnUS,
    BlizzardHSAPILocaleKoKR
};

NSString *NSStringFromLocale(BlizzardHSAPILocale);
