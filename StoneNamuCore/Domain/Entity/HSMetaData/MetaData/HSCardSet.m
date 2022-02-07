//
//  HSCardSet.m
//  StoneNamuCore
//
//  Created by Jinwoo Kim on 2/5/22.
//

#import <StoneNamuCore/HSCardSet.h>

@implementation HSCardSet

- (void)dealloc {
    [_setId release];
    [_name release];
    [_slug release];
    [_type release];
    [_aliasSetIds release];
    [_collectibleCount release];
    [_collectibleRevealedCount release];
    [_nonCollectibleCount release];
    [_nonCollectibleRevealedCount release];
    [super dealloc];
}

+ (HSCardSet *)hsCardSetFromDic:(NSDictionary *)dic error:(NSError * _Nullable *)error {
    HSCardSet *hsCardSet = [HSCardSet new];
    
    [hsCardSet->_setId release];
    hsCardSet->_setId = [dic[@"id"] copy];
    
    [hsCardSet->_name release];
    hsCardSet->_name = [dic[@"name"] copy];
    
    [hsCardSet->_slug release];
    hsCardSet->_slug = [dic[@"slug"] copy];
    
    [hsCardSet->_type release];
    hsCardSet->_type = [dic[@"type"] copy];
    
    NSMutableSet<NSNumber *> *aliasSetIds = [NSMutableSet<NSNumber *> new];
    [(NSArray<id> *)dic[@"aliasSetIds"] enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:NSNumber.class]) {
            [aliasSetIds addObject:obj];
        }
    }];
    [hsCardSet->_aliasSetIds release];
    hsCardSet->_aliasSetIds = [aliasSetIds copy];
    [aliasSetIds release];
    
    [hsCardSet->_collectibleCount release];
    hsCardSet->_collectibleCount = [dic[@"collectibleCount"] copy];
    
    [hsCardSet->_collectibleRevealedCount release];
    hsCardSet->_collectibleRevealedCount = [dic[@"collectibleRevealedCount"] copy];
    
    [hsCardSet->_nonCollectibleCount release];
    hsCardSet->_nonCollectibleCount = [dic[@"nonCollectibleCount"] copy];
    
    [hsCardSet->_nonCollectibleRevealedCount release];
    hsCardSet->_nonCollectibleRevealedCount = [dic[@"nonCollectibleRevealedCount"] copy];
    
    return [hsCardSet autorelease];
}

#pragma mark - NSCopying

- (nonnull id)copyWithZone:(nullable NSZone *)zone {
    id copy = [[self class] new];
    
    if (copy) {
        HSCardSet *_copy = (HSCardSet *)copy;
        
        [_copy->_setId release];
        _copy->_setId = [self.setId copyWithZone:zone];

        [_copy->_name release];
        _copy->_name = [self.name copyWithZone:zone];
        
        [_copy->_slug release];
        _copy->_slug = [self.slug copyWithZone:zone];
        
        [_copy->_type release];
        _copy->_type = [self.type copyWithZone:zone];
        
        [_copy->_aliasSetIds release];
        _copy->_aliasSetIds = [self.aliasSetIds copyWithZone:zone];
        
        [_copy->_collectibleCount release];
        _copy->_collectibleCount = [self.collectibleCount copyWithZone:zone];
        
        [_copy->_collectibleRevealedCount release];
        _copy->_collectibleRevealedCount = [self.collectibleRevealedCount copyWithZone:zone];
        
        [_copy->_nonCollectibleCount release];
        _copy->_nonCollectibleCount = [self.nonCollectibleCount copyWithZone:zone];
        
        [_copy->_nonCollectibleRevealedCount release];
        _copy->_nonCollectibleRevealedCount = [self.nonCollectibleRevealedCount copyWithZone:zone];
    }
    
    return copy;
}

@end
