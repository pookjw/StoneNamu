//
//  CardOptionSectionModel.m
//  StoneNamu
//
//  Created by Jinwoo Kim on 7/24/21.
//

#import "CardOptionSectionModel.h"

@implementation CardOptionSectionModel

- (instancetype)initWithType:(CardOptionSectionModelType)type {
    self = [self init];
    
    if (self) {
        _type = type;
    }
    
    return self;
}

- (BOOL)isEqual:(id)object {
    if (![object isKindOfClass:[CardOptionSectionModel class]]) {
        return NO;
    }
    
    CardOptionSectionModel *toCompare = (CardOptionSectionModel *)object;
    
    return self.type == toCompare.type;
}

@end
