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

- (BOOL)isEqual:(id)object {
    DeckDetailsItemModel *toCompare = (DeckDetailsItemModel *)object;
    
    if (![toCompare isKindOfClass:[DeckDetailsItemModel class]]) {
        return NO;
    }
    
    return (self.type == toCompare.type) &&
    (((self.hsCard == nil) && (toCompare.hsCard == nil)) || ([self.hsCard isEqual:toCompare.hsCard])) &&
    (((self.graphManaCost == nil) && (toCompare.graphManaCost == nil)) || ([self.graphManaCost isEqualToNumber:toCompare.graphManaCost]));
}

- (NSUInteger)hash {
    return self.type ^ self.hsCard.hash ^ self.graphManaCost.hash;
}

@end
