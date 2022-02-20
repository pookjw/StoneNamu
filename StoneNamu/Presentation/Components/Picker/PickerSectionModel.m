//
//  PickerSectionModel.m
//  StoneNamu
//
//  Created by Jinwoo Kim on 2/19/22.
//

#import "PickerSectionModel.h"

@implementation PickerSectionModel

- (instancetype)initWithType:(NSUInteger)type title:(NSString *)title {
    self = [self init];
    
    if (self) {
        self->_type = type;
        
        [self->_title release];
        self->_title = [title copy];
    }
    
    return self;
}

- (void)dealloc {
    [_title release];
    [super dealloc];
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

- (id)copyWithZone:(NSZone *)zone {
    id copy = [[self class] new];
    
    if (copy) {
        PickerSectionModel *_copy = (PickerSectionModel *)copy;
        
        _copy->_type = self.type;
        
        [_copy->_title release];
        _copy->_title = [self.title copyWithZone:zone];
    }
    
    return copy;
}

@end
