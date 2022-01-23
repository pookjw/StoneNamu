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
    // sometimes it releases unexpectedly
    NSData * _Nullable hsCardsData = [self.hsCardsData retain];
    
    if (hsCardsData == nil) {
        [hsCardsData release];
        return @[];
    }
    
    NSError * _Nullable error = nil;
    
    NSArray<HSCard *> *cards = [NSKeyedUnarchiver unarchivedObjectOfClasses:HSCard.unarchvingClasses fromData:hsCardsData error:&error];
    [hsCardsData release];
    
    if (error) {
        NSLog(@"%@", error.localizedDescription);
        return @[];
    }
    
    return cards;
}

- (void)setHsCards:(NSArray<HSCard *> *)hsCards {
    NSError * _Nullable error = nil;
    
    NSData *hsCardsData = [NSKeyedArchiver archivedDataWithRootObject:hsCards requiringSecureCoding:YES error:&error];
    
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
}

- (void)updateTimestamp {
    self.timestamp = [[NSDate new] autorelease];
}

@end
