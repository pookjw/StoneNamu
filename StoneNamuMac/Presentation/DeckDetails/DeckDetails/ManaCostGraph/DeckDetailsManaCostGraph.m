//
//  DeckDetailsManaCostGraph.m
//  StoneNamuMac
//
//  Created by Jinwoo Kim on 12/16/21.
//

#import "DeckDetailsManaCostGraph.h"

@implementation DeckDetailsManaCostGraph

- (instancetype)initWithManaCost:(NSUInteger)manaCost percentage:(float)percentage count:(NSUInteger)count {
    self = [self init];
    
    if (self) {
        self->_manaCost = manaCost;
        self->_percentage = percentage;
        self->_count = count;
    }
    
    return self;
}

- (BOOL)isEqual:(id)object {
    DeckDetailsManaCostGraph *toCompare = (DeckDetailsManaCostGraph *)object;
    
    if (![toCompare isKindOfClass:[DeckDetailsManaCostGraph class]]) {
        return NO;
    }
    
    return (self.manaCost == toCompare.manaCost) &&
    (self.percentage == toCompare.percentage) &&
    (self.count == toCompare.count);
}

@end
