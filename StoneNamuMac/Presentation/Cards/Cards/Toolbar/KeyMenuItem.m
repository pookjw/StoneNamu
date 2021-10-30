//
//  KeyMenuItem.m
//  StoneNamuMac
//
//  Created by Jinwoo Kim on 10/31/21.
//

#import "KeyMenuItem.h"

@implementation KeyMenuItem

- (void)dealloc {
    [_key dealloc];
    [super dealloc];
}

- (instancetype)initWithTitle:(NSString *)string action:(SEL)selector keyEquivalent:(NSString *)charCode key:(NSDictionary *)key {
    self = [self initWithTitle:string action:selector keyEquivalent:charCode];
    
    if (self) {
        self->_key = [key copy];
    }
    
    return self;
}

@end
