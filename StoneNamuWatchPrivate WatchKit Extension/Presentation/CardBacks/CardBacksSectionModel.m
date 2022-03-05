//
//  CardBacksSectionModel.m
//  StoneNamuWatch WatchKit Extension
//
//  Created by Jinwoo Kim on 3/6/22.
//

#import "CardBacksSectionModel.h"

@implementation CardBacksSectionModel

- (instancetype)initWithType:(CardBacksSectionModelType)type {
    self = [self init];
    
    if (self) {
        self->_type = type;
    }
    
    return self;
}

- (BOOL)isEqual:(id)object {
    if (![object isKindOfClass:[CardBacksSectionModel class]]) {
        return NO;
    }
    
    CardBacksSectionModel *toCompare = (CardBacksSectionModel *)object;
    
    return self.type == toCompare.type;
}

- (NSUInteger)hash {
    return self.type;
}

@end
