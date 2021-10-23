//
//  HSDeckFormat.m
//  HSDeckFormat
//
//  Created by Jinwoo Kim on 8/29/21.
//

#import "HSDeckFormat.h"
#import <StoneNamuCore/Identifier.h>

NSArray<NSString *> * hsDeckFormats(void) {
    return @[
        HSDeckFormatStandard,
        HSDeckFormatWild,
        HSDeckFormatClassic
    ];
}
NSDictionary<NSString *, NSString *> * hsDeckFormatsWithLocalizable(void) {
    NSMutableDictionary<NSString *, NSString *> *dic = [@{} mutableCopy];
    
    [hsDeckFormats() enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        dic[obj] = NSLocalizedStringFromTableInBundle(obj,
                                                      @"HSDeckFormat",
                                                      [NSBundle bundleWithIdentifier:IDENTIFIER],
                                                      @"");
    }];
    
    NSDictionary<NSString *, NSString *> *result = [[dic copy] autorelease];
    [dic release];
    
    return result;
}
