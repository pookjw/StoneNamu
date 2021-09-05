//
//  DeckAddCardItemModel.m
//  StoneNamu
//
//  Created by Jinwoo Kim on 7/24/21.
//

#import "DeckAddCardItemModel.h"

@implementation DeckAddCardItemModel

- (instancetype)initWithCard:(HSCard *)card count:(NSUInteger)count {
    self = [self init];
    
    if (self) {
        self->_card = [card copy];
        self.count = count;
    }
    
    return self;
}

- (void)dealloc {
    [_card release];
    [super dealloc];
}

- (BOOL)isEqual:(id)object {
    if (![object isKindOfClass:[DeckAddCardItemModel class]]) {
        return NO;
    }
    
    DeckAddCardItemModel *toCompare = (DeckAddCardItemModel *)object;
    
    return ([self.card isEqual:toCompare.card]);
}

- (NSUInteger)hash {
    return self.card.hash;
}

@end
