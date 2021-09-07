//
//  HSDeck.m
//  HSDeck
//
//  Created by Jinwoo Kim on 8/17/21.
//

#import "HSDeck.h"
#import "StoneNamuCoreErrors.h"
#import "NSArray+countOfObject.h"

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

+ (HSDeck * _Nullable)hsDeckFromDic:(NSDictionary *)dic error:(NSError ** _Nullable)error {
    HSDeck *hsDeck = [HSDeck new];
    
    if (dic[@"deckCode"] == nil) {
        if (error) {
            *error = InvalidHSDeckError();
        }
        [hsDeck release];
        return nil;
    }
    
    hsDeck->_deckCode = [dic[@"deckCode"] copy];
    hsDeck->_format = [dic[@"format"] copy];
    
    NSNumber *classId = dic[@"hero"][@"classId"];
    hsDeck->_classId = [classId unsignedIntegerValue];
    hsDeck->_cards = [[HSCard hsCardsFromDic:dic] copy];
    
    return [hsDeck autorelease];
}

- (NSString *)localizedDeckCodeWithTitle:(NSString *)title {
    NSMutableString *result = [@"" mutableCopy];
    NSString *classTitle = NSLocalizedStringFromTableInBundle(@"CLASS",
                                                               @"HSDeck",
                                                               [NSBundle bundleWithIdentifier:@"com.pookjw.StoneNamuCore"],
                                                               @"");
    NSString *formatTitle = NSLocalizedStringFromTableInBundle(@"FORMAT",
                                                               @"HSDeck",
                                                               [NSBundle bundleWithIdentifier:@"com.pookjw.StoneNamuCore"],
                                                               @"");
    NSString *footer1Title = NSLocalizedStringFromTableInBundle(@"FOOTER_1",
                                                               @"HSDeck",
                                                               [NSBundle bundleWithIdentifier:@"com.pookjw.StoneNamuCore"],
                                                               @"");
    NSString *footer2Title = NSLocalizedStringFromTableInBundle(@"FOOTER_2",
                                                               @"HSDeck",
                                                               [NSBundle bundleWithIdentifier:@"com.pookjw.StoneNamuCore"],
                                                               @"");
    
    NSString *className = hsCardClassesWithLocalizable()[NSStringFromHSCardClass(self.classId)];
    NSString *formatName = hsDeckFormatsWithLocalizable()[self.format];
    
    [result appendFormat:@"### %@\n", title];
    [result appendFormat:@"# %@: %@\n", classTitle, className];
    [result appendFormat:@"# %@: %@\n", formatTitle, formatName];
    [result appendString:@"#\n"];
    
    //
    
    NSArray<HSCard *> *sortedCards = [self.cards sortedArrayUsingComparator:^NSComparisonResult(HSCard * _Nonnull obj1, HSCard * _Nonnull obj2) {
        return [obj1 compare:obj2];
    }];
    NSMutableArray<HSCard *> *addedCards = [@[] mutableCopy];
    
    [sortedCards enumerateObjectsUsingBlock:^(HSCard * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([addedCards containsObject:obj]) {
            return;
        }
        
        NSUInteger count = [sortedCards countOfObject:obj];
        NSUInteger cost = obj.manaCost;
        NSString *name = obj.name;
        [result appendFormat:@"# %lux (%lu) %@\n", count, cost, name];
        [addedCards addObject:obj];
    }];
    
    [addedCards release];
    
    //
    
    [result appendString:@"#\n"];
    [result appendFormat:@"%@\n", self.deckCode];
    [result appendString:@"#\n"];
    [result appendFormat:@"# %@\n", footer1Title];
    [result appendFormat:@"# %@", footer2Title];
    
    //
    
    return [result autorelease];
}

#pragma mark - NSCopying

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

@end
