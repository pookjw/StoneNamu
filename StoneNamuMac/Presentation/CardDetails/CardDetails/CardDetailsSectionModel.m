//
//  CardDetailsSectionModel.m
//  StoneNamuMac
//
//  Created by Jinwoo Kim on 11/22/21.
//

#import "CardDetailsSectionModel.h"

@implementation CardDetailsSectionModel

- (instancetype)initWithType:(CardDetailsSectionModelType)type {
    self = [self init];
    
    if (self) {
        self->_type = type;
    }
    
    return self;
}

- (BOOL)isEqual:(id)object {
    if (![object isKindOfClass:[CardDetailsSectionModel class]]) {
        return NO;
    }
    
    CardDetailsSectionModel *toCompare = (CardDetailsSectionModel *)object;
    
    return self.type == toCompare.type;
}

- (NSUInteger)hash {
    return self.type;
}

@end
