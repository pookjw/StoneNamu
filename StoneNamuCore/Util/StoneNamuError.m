//
//  StoneNamuError.m
//  StoneNamuCore
//
//  Created by Jinwoo Kim on 11/19/21.
//

#import <StoneNamuCore/StoneNamuError.h>
#import <StoneNamuCore/Identifier.h>

@implementation StoneNamuError

- (instancetype)initWithErrorType:(StoneNamuErrorType)type {
    self = [self initWithDomain:[NSString stringWithFormat:@"%@.%@", IDENTIFIER, type]
                           code:100
                       userInfo:nil];
    
    if (self) {
        [self->_type release];
        self->_type = [type copy];
    }
    
    return self;
}

+ (instancetype)errorWithErrorType:(StoneNamuErrorType)type {
    id object = [self errorWithDomain:[NSString stringWithFormat:@"%@.%@", IDENTIFIER, type]
                                 code:100
                             userInfo:nil];
    
    if (object) {
        StoneNamuError *_object = (StoneNamuError *)object;
        [_object->_type release];
        _object->_type = [type copy];
    }
    
    return object;
}

- (void)dealloc {
    [_type release];
    [super dealloc];
}

- (id)copyWithZone:(NSZone *)zone {
    id copy = [super copyWithZone:zone];
    
    if (copy) {
        StoneNamuError *_copy = (StoneNamuError *)copy;
        [_copy->_type release];
        _copy->_type = [self.type copyWithZone:zone];
    }
    
    return copy;
}

@end
