//
//  DeckAddCardItemModel.m
//  StoneNamuMac
//
//  Created by Jinwoo Kim on 12/8/21.
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
    
    return [self.hsCard isEqual:toCompare.hsCard];
}

- (NSUInteger)hash {
    return self.hsCard.hash;
}

@end
