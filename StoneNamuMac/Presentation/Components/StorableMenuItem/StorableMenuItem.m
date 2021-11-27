//
//  StorableMenuItem.m
//  StoneNamuMac
//
//  Created by Jinwoo Kim on 10/31/21.
//

#import "StorableMenuItem.h"

@implementation StorableMenuItem

- (void)dealloc {
    [_userInfo release];
    [super dealloc];
}

- (instancetype)initWithTitle:(NSString *)string action:(SEL)selector keyEquivalent:(NSString *)charCode userInfo:(NSDictionary *)userInfo {
    self = [self initWithTitle:string action:selector keyEquivalent:charCode];
    
    if (self) {
        [self->_userInfo release];
        self->_userInfo = [userInfo copy];
    }
    
    return self;
}

- (id)copyWithZone:(nullable NSZone *)zone {
    id copy = [super copyWithZone:zone];
    
    if (copy) {
        StorableMenuItem *_copy = (StorableMenuItem *)copy;
        [_copy->_userInfo release];
        _copy->_userInfo = [self->_userInfo copyWithZone:zone];
    }
    
    return copy;
}

@end
