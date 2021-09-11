//
//  NSSemaphoreCondition.m
//  NSSemaphoreCondition
//
//  Created by Jinwoo Kim on 8/16/21.
//

#import "NSSemaphoreCondition.h"

@implementation NSSemaphoreCondition

- (instancetype)initWithValue:(NSInteger)value {
    self = [self init];
    
    if (self) {
        self->_value = value;
    }
    
    return self;
}

- (void)signal {
    self->_value += 1;
    [super signal];
}

- (void)wait {
    self->_value -= 1;
    
    while (self->_value != 0) {
        [super wait];
    }
}

@end
