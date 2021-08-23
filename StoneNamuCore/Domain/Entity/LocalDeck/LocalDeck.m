//
//  LocalDeck.m
//  LocalDeck
//
//  Created by Jinwoo Kim on 8/17/21.
//

#import "LocalDeck.h"
#import "HSCardHero.h"

@implementation LocalDeck

@dynamic cardsData;
@dynamic isWild;
@dynamic classId;
@dynamic deckCode;
@dynamic name;
@dynamic timestamp;

- (NSArray<NSNumber *> *)cards {
    if (self.cardsData == nil) {
        return @[];
    }
    
    NSError * _Nullable error = nil;
    
    NSArray<NSNumber *> *cards = [NSKeyedUnarchiver unarchivedObjectOfClass:[NSArray<NSNumber *> class] fromData:self.cardsData error:&error];
    
    if (error) {
        NSLog(@"%@", error.localizedDescription);
        return @[];
    }
    
    return cards;
}

- (void)setCards:(NSArray<NSNumber *> *)cards {
    NSError * _Nullable error = nil;
    NSArray<NSNumber *> *cardsCopy = [cards copy];
    
    NSData *cardsData = [NSKeyedArchiver archivedDataWithRootObject:cardsCopy requiringSecureCoding:YES error:&error];
    [cardsCopy release];
    
    if (error) {
        NSLog(@"%@", error.localizedDescription);
        return;
    }
    
    self.cardsData = cardsData;
}

- (void)setValuesAsHSDeck:(HSDeck *)hsDeck {
    NSMutableArray<NSNumber *> *cards = [@[] mutableCopy];
    [hsDeck.cards enumerateObjectsUsingBlock:^(HSCard * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [cards addObject:[NSNumber numberWithUnsignedInteger:obj.cardId]];
    }];
    self.cards = cards;
    [cards release];
    
    self.isWild = [NSNumber numberWithBool:[hsDeck.format isEqualToString:HSDeckFormatWild]];
    self.classId = [NSNumber numberWithUnsignedInteger:hsDeck.classId];
    self.deckCode = [[hsDeck.deckCode copy] autorelease];
    self.name = hsCardClassesWithLocalizable()[NSStringFromHSCardClass(hsDeck.classId)];
}

- (void)updateTimestamp {
    self.timestamp = [NSDate new];
}

@end
