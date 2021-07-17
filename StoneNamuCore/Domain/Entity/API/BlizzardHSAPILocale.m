//
//  BlizzardHSAPILocale.m
//  StoneNamuCore
//
//  Created by Jinwoo Kim on 7/18/21.
//

#import "BlizzardHSAPILocale.h"

NSString *NSStringFromLocale(BlizzardHSAPILocale locale) {
    switch (locale) {
        case BlizzardHSAPILocaleEnUS:
            return @"en_US";
        case BlizzardHSAPILocaleKoKR:
            return @"ko_KR";
        default:
            return @"en_US";
    }
}
