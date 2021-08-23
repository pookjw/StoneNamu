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
    }
    
    return self;
}

- (void)dealloc {
    [_hsCard release];
    [super dealloc];
}

- (id)copyWithZone:(NSZone *)zone {
    id copy = [[self class] new];
    
    if (copy) {
        DeckDetailsItemModel *_copy = (DeckDetailsItemModel *)copy;
        _copy->_hsCard = [self.hsCard copyWithZone:zone];
        _copy->_hsCardCount = self.hsCardCount;
        _copy->_type = self.type;
    }
    
    return copy;
}

- (BOOL)isEqual:(id)object {
    DeckDetailsItemModel *toCompare = (DeckDetailsItemModel *)object;
    
    if (![toCompare isKindOfClass:[DeckDetailsItemModel class]]) {
        return NO;
    }
    
    return ([self.hsCard isEqual:toCompare.hsCard]) && (self.hsCardCount == toCompare.hsCardCount);
}

- (NSUInteger)hash {
    return self.type ^ self.hsCard.hash ^ self.hsCardCount;
}

@end
