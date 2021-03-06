//
//  CardSectionModel.m
//  StoneNamu
//
//  Created by Jinwoo Kim on 7/24/21.
//

#import "CardSectionModel.h"

@implementation CardSectionModel

- (instancetype)initWithType:(CardSectionModelType)type {
    self = [self init];
    
    if (self) {
        self->_type = type;
    }
    
    return self;
}

- (BOOL)isEqual:(id)object {
    if (![object isKindOfClass:[CardSectionModel class]]) {
        return NO;
    }
    
    CardSectionModel *toCompare = (CardSectionModel *)object;
    
    return self.type == toCompare.type;
}

- (NSUInteger)hash {
    return self.type;
}

@end
