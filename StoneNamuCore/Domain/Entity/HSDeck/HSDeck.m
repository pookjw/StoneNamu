//
//  HSDeck.m
//  HSDeck
//
//  Created by Jinwoo Kim on 8/17/21.
//

#import "HSDeck.h"
#import "StoneNamuCoreErrors.h"

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

- (id)copyWithZone:(NSZone *)zone {
    id copy = [[self class] new];
    
    if (copy) {
        HSDeck *_copy = (HSDeck *)copy;
        _copy->_deckCode = [self.deckCode copyWithZone:zone];
        _copy->_format = [self.format copyWithZone:zone];
        _copy->_classId = self.classId;
        _copy->_cards = [self.cards copyWithZone:zone];
    }
    
    return copy;
}

+ (HSDeck * _Nullable)hsDeckFromDic:(NSDictionary *)dic error:(NSError ** _Nullable)error {
    HSDeck *hsDeck = [HSDeck new];
    
    if (dic[@"deckCode"] == nil) {
        *error = InvalidHSDeckError();
        return nil;
    }
    
    hsDeck->_deckCode = [dic[@"deckCode"] copy];
    hsDeck->_format = [dic[@"format"] copy];
    
    NSNumber *classId = dic[@"hero"][@"classId"];
    hsDeck->_classId = [classId unsignedIntegerValue];
    hsDeck->_cards = [[HSCard hsCardsFromDic:dic] copy];
    
    return [hsDeck autorelease];
}

@end
