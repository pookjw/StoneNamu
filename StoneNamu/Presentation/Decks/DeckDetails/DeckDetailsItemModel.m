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
        self.hsCardCount = 0;
        self->_type = type;
        self.manaDictionary = nil;
    }
    
    return self;
}

- (void)dealloc {
    [_hsCard release];
    [_manaDictionary release];
    [super dealloc];
}

- (id)copyWithZone:(NSZone *)zone {
    id copy = [[self class] new];
    
    if (copy) {
        DeckDetailsItemModel *_copy = (DeckDetailsItemModel *)copy;
        [_copy->_hsCard release];
        _copy->_hsCard = [self.hsCard copyWithZone:zone];
        _copy->_hsCardCount = self.hsCardCount;
        _copy->_type = self.type;
        [_copy->_manaDictionary release];
        _copy->_manaDictionary = [self.manaDictionary copyWithZone:zone];
    }
    
    return copy;
}

- (BOOL)isEqual:(id)object {
    DeckDetailsItemModel *toCompare = (DeckDetailsItemModel *)object;
    
    if (![toCompare isKindOfClass:[DeckDetailsItemModel class]]) {
        return NO;
    }
    
    return ([self.hsCard isEqual:toCompare.hsCard] || ((self.hsCard == nil) && (toCompare.hsCard == nil))) &&
    (self.type == toCompare.type) &&
    ([self.manaDictionary isEqualToDictionary:toCompare.manaDictionary] || ((self.manaDictionary == nil) && (toCompare.manaDictionary == nil)));
}

- (NSUInteger)hash {
    return self.hsCard.hash ^ self.type ^ self.manaDictionary.hash;
}

@end
