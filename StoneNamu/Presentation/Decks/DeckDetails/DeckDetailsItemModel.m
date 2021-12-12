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
        self.cardManaCost = nil;
        self.percentage = nil;
        self.cardCount = nil;
    }
    
    return self;
}

- (void)dealloc {
    [_hsCard release];
    [_hsCardCount release];
    [_cardManaCost release];
    [_percentage release];
    [_cardCount release];
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
        [_copy->_cardManaCost release];
        _copy->_cardManaCost = [self.cardManaCost copyWithZone:zone];
        [_copy->_percentage release];
        _copy->_percentage = [self.percentage copyWithZone:zone];
        [_copy->_cardCount release];
        _copy->_cardCount = [self.cardCount copyWithZone:zone];
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
    ([self.cardManaCost isEqualToNumber:toCompare.cardManaCost] || ((self.cardManaCost == nil) && (toCompare.cardManaCost == nil)));
}

- (NSUInteger)hash {
    return self.type ^ self.hsCard.hash ^ self.cardManaCost.hash;
}

@end
