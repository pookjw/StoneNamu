//
//  CardDetailsChildrenContentCollectionViewItemItemModel.m
//  StoneNamuMac
//
//  Created by Jinwoo Kim on 11/22/21.
//

#import "CardDetailsChildrenContentCollectionViewItemItemModel.h"

@implementation CardDetailsChildrenContentCollectionViewItemItemModel

- (instancetype)initWithHSCard:(HSCard *)hsCard {
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
    if (![object isKindOfClass:[CardDetailsChildrenContentCollectionViewItemItemModel class]]) {
        return NO;
    }
    
    CardDetailsChildrenContentCollectionViewItemItemModel *toCompare = (CardDetailsChildrenContentCollectionViewItemItemModel *)object;
    
    return [self.hsCard isEqual:toCompare.hsCard];
}

- (NSUInteger)hash {
    return self.hsCard.hash;
}

@end
