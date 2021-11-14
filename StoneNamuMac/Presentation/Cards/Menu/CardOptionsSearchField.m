//
//  CardOptionsSearchField.m
//  StoneNamuMac
//
//  Created by Jinwoo Kim on 11/1/21.
//

#import "CardOptionsSearchField.h"

@implementation CardOptionsSearchField

- (instancetype)initWithKey:(NSDictionary *)key {
    self = [self init];
    
    if (self) {
        [self->_key release];
        self->_key = [key copy];
    }
    
    return self;
}

- (void)dealloc {
    [_key release];
    [super dealloc];
}

@end
