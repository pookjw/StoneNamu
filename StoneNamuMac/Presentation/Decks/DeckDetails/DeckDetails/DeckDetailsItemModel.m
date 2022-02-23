//
//  DeckDetailsItemModel.m
//  StoneNamuMac
//
//  Created by Jinwoo Kim on 12/12/21.
//

#import "DeckDetailsItemModel.h"

@implementation DeckDetailsItemModel

- (instancetype)initWithHSCard:(HSCard *)hsCard hsCardCount:(NSNumber *)hsCardCount raritySlugType:(HSCardRaritySlugType)raritySlugType {
    self = [self init];
    
    if (self) {
        [self->_hsCard release];
        self->_hsCard = [hsCard copy];
        
        self.hsCardCount = hsCardCount;
        
        [self->_raritySlugType release];
        self->_raritySlugType = [raritySlugType copy];
    }
    
    return self;
}

- (void)dealloc {
    [_hsCard release];
    [_hsCardCount release];
    [_raritySlugType release];
    [super dealloc];
}

- (BOOL)isEqual:(id)object {
    DeckDetailsItemModel *toCompare = (DeckDetailsItemModel *)object;
    
    if (![toCompare isKindOfClass:[DeckDetailsItemModel class]]) {
        return NO;
    }
    
    return compareNullableValues(self.hsCard, toCompare.hsCard, @selector(isEqual:));
}

- (NSUInteger)hash {
    return self.hsCard.hash;
}

@end
