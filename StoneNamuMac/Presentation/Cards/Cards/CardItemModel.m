//
//  CardItemModel.m
//  CardItemModel
//
//  Created by Jinwoo Kim on 9/26/21.
//

#import "CardItemModel.h"

@implementation CardItemModel

- (instancetype)initWithHSCard:(HSCard *)hsCard hsCardGameModeSlugType:(HSCardGameModeSlugType)hsCardGameModeSlugType {
    self = [self init];
    
    if (self) {
        [self->_hsCard release];
        self->_hsCard = [hsCard copy];
        
        [self->_hsCardGameModeSlugType release];
        self->_hsCardGameModeSlugType = [hsCardGameModeSlugType copy];
    }
    
    return self;
}

- (void)dealloc {
    [_hsCard release];
    [_hsCardGameModeSlugType release];
    [super dealloc];
}

- (BOOL)isEqual:(id)object {
    if (![object isKindOfClass:[CardItemModel class]]) {
        return NO;
    }
    
    CardItemModel *toCompare = (CardItemModel *)object;
    
    BOOL hsCard = compareNullableValues(self.hsCard, toCompare.hsCard, @selector(isEqual:));
    BOOL hsCardGameModeSlugType = compareNullableValues(self.hsCardGameModeSlugType, toCompare.hsCardGameModeSlugType, @selector(isEqualToString:));
    
    return hsCard && hsCardGameModeSlugType;
}

- (NSUInteger)hash {
    return self.hsCard.hash ^ self.hsCardGameModeSlugType.hash;
}

@end
