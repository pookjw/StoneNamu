//
//  LocalDeck.m
//  LocalDeck
//
//  Created by Jinwoo Kim on 8/17/21.
//

#import <StoneNamuCore/LocalDeck.h>
#import <StoneNamuCore/HSCardHero.h>

@implementation LocalDeck

@dynamic hsCardsData;
@dynamic format;
@dynamic classId;
@dynamic deckCode;
@dynamic name;
@dynamic timestamp;

- (NSArray<HSCard *> *)hsCards {
    if (self.hsCardsData == nil) {
        return @[];
    }
    
    NSError * _Nullable error = nil;
    
    NSArray<HSCard *> *cards = [NSKeyedUnarchiver unarchivedObjectOfClasses:HSCard.unarchvingClasses fromData:self.hsCardsData error:&error];
    
    if (error) {
        NSLog(@"%@", error.localizedDescription);
        return @[];
    }
    
    return cards;
}

- (void)setHsCards:(NSArray<NSNumber *> *)hsCards {
    NSError * _Nullable error = nil;
    NSArray<NSNumber *> *hsCardsCopy = [hsCards copy];
    
    NSData *hsCardsData = [NSKeyedArchiver archivedDataWithRootObject:hsCardsCopy requiringSecureCoding:YES error:&error];
    [hsCardsCopy release];
    
    if (error) {
        NSLog(@"%@", error.localizedDescription);
        return;
    }
    
    self.hsCardsData = hsCardsData;
}

- (NSArray<NSNumber *> *)hsCardIds {
    NSMutableArray<NSNumber *> *mutable = [@[] mutableCopy];
    
    for (HSCard *hsCard in self.hsCards) {
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
        self.hsCards = hsDeck.cards;
    } else {
        NSLog(@"card in HSDeck is empty!");
    }
    
    self.format = hsDeck.format;
    self.classId = [NSNumber numberWithUnsignedInteger:hsDeck.classId];
    self.deckCode = [[hsDeck.deckCode copy] autorelease];
    
    if (self.name == nil) {
        self.name = hsCardClassesWithLocalizable()[NSStringFromHSCardClass(hsDeck.classId)];
    }
}

- (void)updateTimestamp {
    self.timestamp = [[NSDate new] autorelease];
}

@end
