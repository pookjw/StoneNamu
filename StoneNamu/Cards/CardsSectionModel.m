//
//  CardsSectionModel.m
//  StoneNamu
//
//  Created by Jinwoo Kim on 7/24/21.
//

#import "CardsSectionModel.h"

@implementation CardsSectionModel

- (instancetype)initWithType:(CardsSectionModelType)type {
    self = [self init];
    
    if (self) {
        _type = type;
    }
    
    return self;
}

- (BOOL)isEqual:(id)object {
    if (![object isKindOfClass:[CardsSectionModel class]]) {
        return NO;
    }
    
    CardsSectionModel *toCompare = (CardsSectionModel *)object;
    
    return self.type == toCompare.type;
}

@end
