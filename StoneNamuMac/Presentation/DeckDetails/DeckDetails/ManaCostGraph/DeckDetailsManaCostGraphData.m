//
//  DeckDetailsManaCostGraphData.m
//  StoneNamuMac
//
//  Created by Jinwoo Kim on 12/16/21.
//

#import "DeckDetailsManaCostGraphData.h"

@implementation DeckDetailsManaCostGraphData

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
    DeckDetailsManaCostGraphData *toCompare = (DeckDetailsManaCostGraphData *)object;
    
    if (![toCompare isKindOfClass:[DeckDetailsManaCostGraphData class]]) {
        return NO;
    }
    
    return (self.manaCost == toCompare.manaCost) &&
    (self.percentage == toCompare.percentage) &&
    (self.count == toCompare.count);
}

#pragma mark - NSCopying

- (id)copyWithZone:(NSZone *)zone {
    id copy = [[self class] new];
    
    if (copy) {
        DeckDetailsManaCostGraphData *_copy = (DeckDetailsManaCostGraphData *)copy;
        _copy->_manaCost = self->_manaCost;
        _copy->_percentage = self->_percentage;
        _copy->_count = self->_count;
    }
    
    return copy;
}

@end
