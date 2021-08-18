//
//  CardItemModel.m
//  StoneNamu
//
//  Created by Jinwoo Kim on 7/24/21.
//

#import "CardItemModel.h"

@implementation CardItemModel

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
    if (![object isKindOfClass:[CardItemModel class]]) {
        return NO;
    }
    
    CardItemModel *toCompare = (CardItemModel *)object;
    
    return [self.card isEqual:toCompare.card];
}

- (NSUInteger)hash {
    return self.card.hash;
}

@end
