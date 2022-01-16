//
//  NSDictionary+combine.m
//  StoneNamuCore
//
//  Created by Jinwoo Kim on 1/9/22.
//

#import <StoneNamuCore/NSDictionary+combine.h>

@implementation NSDictionary (combine)

- (NSDictionary *)dictionaryByAddingKey:(id)key value:(id)value {
    NSMutableDictionary *mutable = [self mutableCopy];
    mutable[key] = value;
    NSDictionary *result = [mutable copy];
    [mutable release];
    return [result autorelease];
}

- (NSDictionary *)dictionaryByCombiningWithDictionary:(NSDictionary *)dictionary shouldOverride:(BOOL)shouldOverride {
    NSMutableDictionary *mutable = [self mutableCopy];
    
    [dictionary enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        if ((mutable[key] == nil) || (shouldOverride)) {
            mutable[key] = obj;
        }
    }];
    
    NSDictionary *result = [mutable copy];
    [mutable release];
    
    return [result autorelease];
}

@end
