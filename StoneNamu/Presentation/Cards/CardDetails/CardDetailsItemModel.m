//
//  CardDetailsItemModel.m
//  CardDetailsItemModel
//
//  Created by Jinwoo Kim on 8/4/21.
//

#import "CardDetailsItemModel.h"
#import <StoneNamuResources/StoneNamuResources.h>

@implementation CardDetailsItemModel

- (instancetype)initWithPrimaryText:(NSString *)primaryText secondaryText:(NSString *)secondaryText {
    self = [self init];
    
    if (self) {
        self->_type = CardDetailsItemModelTypeInfo;
        
        [self->_primaryText release];
        self->_primaryText = [primaryText copy];
        
        [self->_secondaryText release];
        self->_secondaryText = [secondaryText copy];
    }
    
    return self;
}
- (instancetype)initWithChildHSCard:(HSCard *)childHSCard {
    self = [self init];
    
    if (self) {
        self->_type = CardDetailsItemModelTypeChild;
        
        [self->_childHSCard release];
        self->_childHSCard = [childHSCard copy];
    }
    
    return self;
}

- (void)dealloc {
    [_primaryText release];
    [_secondaryText release];
    [_childHSCard release];
    [super dealloc];
}

- (BOOL)isEqual:(id)object {
    if (![object isKindOfClass:[CardDetailsItemModel class]]) {
        return NO;
    }
    
    CardDetailsItemModel *toCompare = (CardDetailsItemModel *)object;
    
    BOOL type = (self.type == toCompare.type);
    BOOL childHSCard = compareNullableValues(self.childHSCard, toCompare.childHSCard, @selector(isEqual:));
    
    return (type) && (childHSCard);
}

- (NSUInteger)hash {
    return self.type ^ self.childHSCard.hash;
}

@end
