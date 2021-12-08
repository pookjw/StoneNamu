//
//  DeckAddCardItemModel.m
//  StoneNamuMac
//
//  Created by Jinwoo Kim on 12/8/21.
//

#import "DeckAddCardItemModel.h"

@implementation DeckAddCardItemModel

- (instancetype)initWithCard:(HSCard *)hsCard {
    self = [self init];
    
    if (self) {
        [self->_hsCard release];
        self->_hsCard = [hsCard copy];
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
