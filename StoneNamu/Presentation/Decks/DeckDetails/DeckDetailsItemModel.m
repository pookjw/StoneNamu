//
//  DeckDetailsItemModel.m
//  DeckDetailsItemModel
//
//  Created by Jinwoo Kim on 8/20/21.
//

#import "DeckDetailsItemModel.h"

@implementation DeckDetailsItemModel

- (instancetype)initWithType:(DeckDetailsItemModelType)type {
    self = [self init];
    
    if (self) {
        self.hsCard = nil;
        self.hsCardCount = nil;
        self->_type = type;
        self.graphManaCost = nil;
        self.graphPercentage = nil;
        self.graphCount = nil;
    }
    
    return self;
}

- (void)dealloc {
    [_hsCard release];
    [_hsCardCount release];
    [_graphManaCost release];
    [_graphPercentage release];
    [_graphCount release];
    [super dealloc];
}

- (id)copyWithZone:(NSZone *)zone {
    id copy = [[self class] new];
    
    if (copy) {
        DeckDetailsItemModel *_copy = (DeckDetailsItemModel *)copy;
        [_copy->_hsCard release];
        _copy->_hsCard = [self.hsCard copyWithZone:zone];
        [_copy->_hsCardCount release];
        [_copy->_hsCardCount copyWithZone:zone];
        _copy->_type = self.type;
        [_copy->_graphManaCost release];
        _copy->_graphManaCost = [self.graphManaCost copyWithZone:zone];
        [_copy->_graphPercentage release];
        _copy->_graphPercentage = [self.graphPercentage copyWithZone:zone];
        [_copy->_graphCount release];
        _copy->_graphCount = [self.graphCount copyWithZone:zone];
    }
    
    return copy;
}

- (BOOL)isEqual:(id)object {
    DeckDetailsItemModel *toCompare = (DeckDetailsItemModel *)object;
    
    if (![toCompare isKindOfClass:[DeckDetailsItemModel class]]) {
        return NO;
    }
    
    return (self.type == toCompare.type) &&
    ([self.hsCard isEqual:toCompare.hsCard] || ((self.hsCard == nil) && (toCompare.hsCard == nil))) &&
    ([self.graphManaCost isEqualToNumber:toCompare.graphManaCost] || ((self.graphManaCost == nil) && (toCompare.graphManaCost == nil)));
}

- (NSUInteger)hash {
    return self.type ^ self.hsCard.hash ^ self.graphManaCost.hash;
}

@end
