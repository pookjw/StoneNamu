//
//  CardOptionsMenuItem.m
//  StoneNamuMac
//
//  Created by Jinwoo Kim on 10/31/21.
//

#import "CardOptionsMenuItem.h"

@implementation CardOptionsMenuItem

- (void)dealloc {
    [_key release];
    [super dealloc];
}

- (instancetype)initWithTitle:(NSString *)string action:(SEL)selector keyEquivalent:(NSString *)charCode key:(NSDictionary *)key {
    self = [self initWithTitle:string action:selector keyEquivalent:charCode];
    
    if (self) {
        [self->_key release];
        self->_key = [key copy];
    }
    
    return self;
}

- (id)copyWithZone:(nullable NSZone *)zone {
    id copy = [super copyWithZone:zone];
    
    if (copy) {
        CardOptionsMenuItem *_copy = (CardOptionsMenuItem *)copy;
        [_copy->_key release];
        _copy->_key = [self->_key copyWithZone:zone];
    }
    
    return copy;
}

@end
