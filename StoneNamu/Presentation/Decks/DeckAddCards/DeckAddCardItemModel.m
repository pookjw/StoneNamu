//
//  DeckAddCardItemModel.m
//  StoneNamu
//
//  Created by Jinwoo Kim on 7/24/21.
//

#import "DeckAddCardItemModel.h"

@implementation DeckAddCardItemModel

- (instancetype)initWithHSCard:(HSCard *)hsCard count:(NSUInteger)count isLegendary:(BOOL)isLegendary {
    self = [self init];
    
    if (self) {
        [self->_hsCard release];
        self->_hsCard = [hsCard copy];
        
        self.count = count;
        
        self->_isLegendary = isLegendary;
    }
    
    return self;
}

- (void)dealloc {
    [_hsCard release];
    [super dealloc];
}

- (BOOL)isEqual:(id)object {
    if (![object isKindOfClass:[DeckAddCardItemModel class]]) {
        return NO;
    }
    
    DeckAddCardItemModel *toCompare = (DeckAddCardItemModel *)object;
    
    BOOL hsCard = compareNullableValues(self.hsCard, toCompare.hsCard, @selector(isEqual:));
    
    return hsCard;
}

- (NSUInteger)hash {
    return self.hsCard.hash;
}

@end
