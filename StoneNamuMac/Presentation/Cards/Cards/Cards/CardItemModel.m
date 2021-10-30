//
//  CardItemModel.m
//  CardItemModel
//
//  Created by Jinwoo Kim on 9/26/21.
//

#import "CardItemModel.h"

@implementation CardItemModel

- (instancetype)initWithCard:(HSCard *)hsCard {
    self = [self init];
    
    if (self) {
        self->_hsCard = [hsCard copy];
    }
    
    return self;
}

- (void)dealloc {
    [_hsCard release];
    [super dealloc];
}

- (BOOL)isEqual:(id)object {
    if (![object isKindOfClass:[CardItemModel class]]) {
        return NO;
    }
    
    CardItemModel *toCompare = (CardItemModel *)object;
    
    return [self.hsCard isEqual:toCompare.hsCard];
}

- (NSUInteger)hash {
    return self.hsCard.hash;
}

@end
