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
        self.raritySlugType = nil;
    }
    
    return self;
}

- (void)dealloc {
    [_hsCard release];
    [_raritySlugType release];
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
    
    BOOL type = (self.type == toCompare.type);
    BOOL hsCard = compareNullableValues(self.hsCard, toCompare.hsCard, @selector(isEqual:));
    BOOL graphManaCost = compareNullableValues(self.graphManaCost, toCompare.graphManaCost, @selector(isEqualToNumber:));
    
    return (type) && (hsCard) && (graphManaCost);
}

- (NSUInteger)hash {
    return self.type ^ self.hsCard.hash ^ self.graphManaCost.hash;
}

@end
