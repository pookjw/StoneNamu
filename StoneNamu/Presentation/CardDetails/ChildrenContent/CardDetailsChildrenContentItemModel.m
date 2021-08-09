//
//  CardDetailsChildrenContentItemModel.m
//  CardDetailsChildrenContentItemModel
//
//  Created by Jinwoo Kim on 8/9/21.
//

#import "CardDetailsChildrenContentItemModel.h"

@implementation CardDetailsChildrenContentItemModel

- (instancetype)initWithHSCard:(HSCard *)hsCard {
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
    if (![object isKindOfClass:[CardDetailsChildrenContentItemModel class]]) {
        return NO;
    }
    
    CardDetailsChildrenContentItemModel *toCompare = (CardDetailsChildrenContentItemModel *)object;
    
    return self.hsCard == toCompare.hsCard;
}

@end
