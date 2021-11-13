//
//  HSDeckFormat.m
//  HSDeckFormat
//
//  Created by Jinwoo Kim on 8/29/21.
//

#import <StoneNamuCore/HSDeckFormat.h>

NSArray<NSString *> * hsDeckFormats(void) {
    return @[
        HSDeckFormatStandard,
        HSDeckFormatWild,
        HSDeckFormatClassic
    ];
}
