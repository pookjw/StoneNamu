//
//  CardOptionsTextField.m
//  StoneNamuMac
//
//  Created by Jinwoo Kim on 11/1/21.
//

#import "CardOptionsTextField.h"

@implementation CardOptionsTextField

- (instancetype)initWithKey:(NSDictionary *)key {
    self = [self init];
    
    if (self) {
        self->_key = [key copy];
    }
    
    return self;
}

- (void)dealloc {
    [_key release];
    [super dealloc];
}

@end
