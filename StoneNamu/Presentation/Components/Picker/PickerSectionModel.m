//
//  PickerSectionModel.m
//  StoneNamu
//
//  Created by Jinwoo Kim on 2/19/22.
//

#import "PickerSectionModel.h"

@implementation PickerSectionModel

- (instancetype)initWithType:(PickerSectionModelType)type {
    self = [self init];
    
    if (self) {
        self->_type = type;
    }
    
    return self;
}

- (BOOL)isEqual:(id)object {
    PickerSectionModel *toCompare = (PickerSectionModel *)object;
    
    if (![toCompare isKindOfClass:[PickerSectionModel class]]) {
        return NO;
    }
    
    return (self.type == toCompare.type);
}

- (NSUInteger)hash {
    return self.type;
}

- (NSComparisonResult)compare:(PickerSectionModel *)other {
    if (self.type < other.type) {
        return NSOrderedAscending;
    } else if (self.type > other.type) {
        return NSOrderedDescending;
    } else {
        return NSOrderedSame;
    }
}

@end
