//
//  MainListSectionModel.m
//  StoneNamuMac
//
//  Created by Jinwoo Kim on 11/16/21.
//

#import "MainListSectionModel.h"

@implementation MainListSectionModel

- (instancetype)initWithType:(MainListSectionModelType)type {
    self = [self init];
    
    if (self) {
        self->_type = type;
    }
    
    return self;
}

- (BOOL)isEqual:(id)object {
    if (![object isKindOfClass:[MainListSectionModel class]]) {
        return NO;
    }
    
    MainListSectionModel *toCompare = (MainListSectionModel *)object;
    
    return self.type == toCompare.type;
}

- (NSUInteger)hash {
    return self.type;
}

@end
