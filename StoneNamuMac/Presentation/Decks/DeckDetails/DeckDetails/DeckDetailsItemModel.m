//
//  DeckDetailsItemModel.m
//  StoneNamuMac
//
//  Created by Jinwoo Kim on 12/12/21.
//

#import "DeckDetailsItemModel.h"

@implementation DeckDetailsItemModel

- (instancetype)initWithType:(DeckDetailsItemModelType)type {
    self = [self init];
    
    if (self) {
        self.hsCard = nil;
        self.hsCardCount = nil;
        self->_type = type;
    }
    
    return self;
}

- (void)dealloc {
    [_hsCard release];
    [_hsCardCount release];
    [super dealloc];
}

- (BOOL)isEqual:(id)object {
    DeckDetailsItemModel *toCompare = (DeckDetailsItemModel *)object;
    
    if (![toCompare isKindOfClass:[DeckDetailsItemModel class]]) {
        return NO;
    }
    
    return (self.type == toCompare.type) &&
    (compareNullableValues(self.hsCard, toCompare.hsCard, @selector(isEqual:))) &&
    (self.isLegendary == toCompare.isLegendary);
}

- (NSUInteger)hash {
    return self.type ^ self.hsCard.hash ^ (self.isLegendary);
}

@end
