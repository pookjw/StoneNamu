//
//  CardDetailsSectionModel.m
//  CardDetailsSectionModel
//
//  Created by Jinwoo Kim on 8/4/21.
//

#import "CardDetailsSectionModel.h"

@implementation CardDetailsSectionModel

- (instancetype)initWithType:(CardDetailsSectionModelType)type {
    self = [self init];
    
    if (self) {
        _type = type;
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

@end
