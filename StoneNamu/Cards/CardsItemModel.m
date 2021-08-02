//
//  CardsItemModel.m
//  StoneNamu
//
//  Created by Jinwoo Kim on 7/24/21.
//

#import "CardsItemModel.h"

@implementation CardsItemModel

- (instancetype)initWithCard:(HSCard *)card {
    self = [self init];
    
    if (self) {
        _card = [card copy];
    }
    
    return self;
}

- (void)dealloc {
    [_card release];
    [super dealloc];
}

- (BOOL)isEqual:(id)object {
    if (![object isKindOfClass:[CardsItemModel class]]) {
        return NO;
    }
    
    CardsItemModel *toCompare = (CardsItemModel *)object;
    
    return self.card == toCompare.card;
}

@end
