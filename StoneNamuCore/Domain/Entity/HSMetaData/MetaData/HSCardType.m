//
//  HSCardType.m
//  StoneNamuCore
//
//  Created by Jinwoo Kim on 2/5/22.
//

#import <StoneNamuCore/HSCardType.h>

@implementation HSCardType

- (void)dealloc {
    [_slug release];
    [_typeId release];
    [_name release];
    [_gameModes release];
    [super dealloc];
}

+ (HSCardType *)hsCardTypeFromDic:(NSDictionary *)dic error:(NSError * _Nullable *)error {
    HSCardType *hsCardType = [HSCardType new];
    
    [hsCardType->_slug release];
    hsCardType->_slug = [dic[@"slug"] copy];
    
    [hsCardType->_typeId release];
    hsCardType->_typeId = [dic[@"id"] copy];
    
    [hsCardType->_name release];
    hsCardType->_name = [dic[@"name"] copy];
    
    NSMutableSet<NSNumber *> *gameModes = [NSMutableSet<NSNumber *> new];
    [(NSArray<id> *)dic[@"gameModes"] enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:NSNumber.class]) {
            [gameModes addObject:obj];
        }
    }];
    [hsCardType->_gameModes release];
    hsCardType->_gameModes = [gameModes copy];
    [gameModes release];
    
    return [hsCardType autorelease];
}

#pragma mark - NSCopying

- (nonnull id)copyWithZone:(nullable NSZone *)zone {
    id copy = [[self class] new];
    
    if (copy) {
        HSCardType *_copy = (HSCardType *)copy;
        
        [_copy->_slug release];
        _copy->_slug = [self.slug copyWithZone:zone];
        
        [_copy->_typeId release];
        _copy->_typeId = [self.typeId copyWithZone:zone];
        
        [_copy->_name release];
        _copy->_name = [self.name copyWithZone:zone];
        
        [_copy->_gameModes release];
        _copy->_gameModes = [self.gameModes copyWithZone:zone];
    }
    
    return copy;
}

@end
