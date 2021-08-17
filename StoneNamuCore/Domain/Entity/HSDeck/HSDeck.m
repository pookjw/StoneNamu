//
//  HSDeck.m
//  HSDeck
//
//  Created by Jinwoo Kim on 8/17/21.
//

#import "HSDeck.h"

@implementation HSDeck

- (void)dealloc {
    [_deckCode release];
    [_format release];
    [_cards release];
    [super dealloc];
}

- (BOOL)isEqual:(id)object {
    HSDeck *toCompare = (HSDeck *)object;
    
    if (![toCompare isKindOfClass:[HSDeck class]]) {
        return NO;
    }
    
    return [self.deckCode isEqualToString:toCompare.deckCode];
}

+ (HSDeck * _Nullable)hsDeckFromDic:(NSDictionary *)dic {
    HSDeck *hsDeck = [HSDeck new];
    
    hsDeck->_deckCode = [dic[@"deckCode"] copy];
    hsDeck->_format = [dic[@"format"] copy];
    
    NSNumber *classId = dic[@"hero"][@"classId"];
    hsDeck->_classId = [classId unsignedIntegerValue];
    hsDeck->_cards = [[HSCard hsCardsFromDic:dic] copy];
    
    return [hsDeck autorelease];
}

@end
