//
//  PrefsCardsMenuItem.m
//  StoneNamuMac
//
//  Created by Jinwoo Kim on 11/15/21.
//

#import "PrefsCardsMenuItem.h"

@implementation PrefsCardsMenuItem

- (instancetype)initWithKey:(NSString * _Nullable)key {
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

- (id)copyWithZone:(NSZone *)zone {
    id copy = [super copyWithZone:zone];
    
    if (copy) {
        PrefsCardsMenuItem *_copy = (PrefsCardsMenuItem *)copy;
        [_copy->_key release];
        _copy->_key = [self->_key copyWithZone:zone];
    }
    
    return copy;
}

@end
