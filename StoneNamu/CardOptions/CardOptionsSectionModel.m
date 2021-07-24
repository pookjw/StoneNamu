//
//  CardOptionsSectionModel.m
//  StoneNamu
//
//  Created by Jinwoo Kim on 7/24/21.
//

#import "CardOptionsSectionModel.h"

@implementation CardOptionsSectionModel

- (instancetype)initWithType:(CardOptionsSectionModelType)type {
    self = [self init];
    
    if (self) {
        _type = type;
    }
    
    return self;
}

- (BOOL)isEqual:(id)object {
    if (![object isKindOfClass:[CardOptionsSectionModel class]]) {
        return NO;
    }
    
    CardOptionsSectionModel *toCompare = (CardOptionsSectionModel *)object;
    
    return self.type == toCompare.type;
}

@end
