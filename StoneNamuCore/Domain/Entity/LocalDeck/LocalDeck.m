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
@dynamic format;
@dynamic classId;
@dynamic deckCode;
@dynamic name;
@dynamic timestamp;

- (NSArray<HSCard *> *)cards {
    if (self.cardsData == nil) {
        return @[];
    }
    
    NSError * _Nullable error = nil;
    
    NSArray<HSCard *> *cards = [NSKeyedUnarchiver unarchivedObjectOfClasses:HSCard.unarchvingClasses fromData:self.cardsData error:&error];
    
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

- (NSArray<NSNumber *> *)cardIds {
    NSMutableArray<NSNumber *> *mutable = [@[] mutableCopy];
    
    for (HSCard *hsCard in self.cards) {
        @autoreleasepool {
            [mutable addObject:[NSNumber numberWithUnsignedInteger:hsCard.cardId]];
        }
    }
    
    NSArray<NSNumber *> *result = [mutable copy];
    [mutable release];
    
    return [result autorelease];
}

- (void)setValuesAsHSDeck:(HSDeck *)hsDeck {
    if (hsDeck.cards.count > 0) {
        self.cards = hsDeck.cards;
    } else {
        NSLog(@"card in HSDeck is empty!");
    }
    
    self.format = hsDeck.format;
    self.classId = [NSNumber numberWithUnsignedInteger:hsDeck.classId];
    self.deckCode = [[hsDeck.deckCode copy] autorelease];
    self.name = hsCardClassesWithLocalizable()[NSStringFromHSCardClass(hsDeck.classId)];
}

- (void)updateTimestamp {
    self.timestamp = [[NSDate new] autorelease];
}

@end
