//
//  CardBacksItemModel.m
//  StoneNamuWatch WatchKit Extension
//
//  Created by Jinwoo Kim on 3/6/22.
//

#import "CardBacksItemModel.h"

@implementation CardBacksItemModel

- (instancetype)initWithHSCardBack:(HSCardBack *)hsCardBack {
    self = [self init];
    
    if (self) {
        [self->_hsCardBack release];
        self->_hsCardBack = [hsCardBack copy];
    }
    
    return self;
}

- (void)dealloc {
    [_hsCardBack release];
    [super dealloc];
}

- (BOOL)isEqual:(id)object {
    if (![object isKindOfClass:[CardBacksItemModel class]]) {
        return NO;
    }
    
    CardBacksItemModel *toCompare = (CardBacksItemModel *)object;
    
    BOOL hsCardBack = compareNullableValues(self.hsCardBack, toCompare.hsCardBack, @selector(isEqual:));
    
    return hsCardBack;
}

- (NSUInteger)hash {
    return self.hsCardBack.hash;
}

@end
