//
//  LocalDeck.m
//  LocalDeck
//
//  Created by Jinwoo Kim on 8/17/21.
//

#import "LocalDeck.h"

@implementation LocalDeck

@dynamic cardsData;
@dynamic isWild;
@dynamic classId;
@dynamic deckCode;
@dynamic name;

- (NSArray<NSNumber *> * _Nullable)cards {
    if (self.cardsData == nil) {
        return nil;
    }
    
    NSError * _Nullable error = nil;
    
    NSArray<NSNumber *> *cards = [NSKeyedUnarchiver unarchivedObjectOfClass:[NSArray<NSNumber *> class] fromData:self.cardsData error:&error];
    
    if (error) {
        NSLog(@"%@", error.localizedDescription);
        return nil;
    }
    
    return cards;
}

- (void)setCards:(NSArray<NSNumber *> * _Nullable)cards {
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

@end
