//
//  HSCardClass.m
//  StoneNamuCore
//
//  Created by Jinwoo Kim on 2/5/22.
//

#import <StoneNamuCore/HSCardClass.h>

@implementation HSCardClass

- (void)dealloc {
    [_slug release];
    [_classId release];
    [_name release];
    [_heroCardId release];
    [_heroPowerCardId release];
    [_alternateHeroCardIds release];
    [super dealloc];
}

+ (HSCardClass *)hsCardClassFromDic:(NSDictionary *)dic error:(NSError * _Nullable *)error {
    HSCardClass *hsCardClass = [HSCardClass new];
    
    [hsCardClass->_slug release];
    hsCardClass->_slug = [dic[@"slug"] copy];
    
    [hsCardClass->_classId release];
    hsCardClass->_classId = [dic[@"id"] copy];
    
    [hsCardClass->_name release];
    hsCardClass->_name = [dic[@"name"] copy];
    
    [hsCardClass->_heroCardId release];
    hsCardClass->_heroCardId = [dic[@"cardId"] copy];
    
    [hsCardClass->_heroPowerCardId release];
    hsCardClass->_heroPowerCardId = [dic[@"heroPowerCardId"] copy];
    
    NSMutableSet<NSNumber *> *alternateHeroCardIds = [NSMutableSet<NSNumber *> new];
    [(NSArray<id> *)dic[@"alternateHeroCardIds"] enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:NSNumber.class]) {
            [alternateHeroCardIds addObject:obj];
        }
    }];
    [hsCardClass->_alternateHeroCardIds release];
    hsCardClass->_alternateHeroCardIds = [alternateHeroCardIds copy];
    [alternateHeroCardIds release];
    
    return [hsCardClass autorelease];
}

#pragma mark - NSCopying

- (nonnull id)copyWithZone:(nullable NSZone *)zone {
    id copy = [[self class] new];
    
    if (copy) {
        HSCardClass *_copy = (HSCardClass *)copy;
        
        [_copy->_slug release];
        _copy->_slug = [self.slug copyWithZone:zone];
        
        [_copy->_classId release];
        _copy->_classId = [self.classId copyWithZone:zone];
        
        [_copy->_name release];
        _copy->_name = [self.name copyWithZone:zone];
        
        [_copy->_heroCardId release];
        _copy->_heroCardId = [self.heroCardId copyWithZone:zone];
        
        [_copy->_heroPowerCardId release];
        _copy->_heroPowerCardId = [self.heroPowerCardId copyWithZone:zone];
        
        [_copy->_alternateHeroCardIds release];
        _copy->_alternateHeroCardIds = [self.alternateHeroCardIds copyWithZone:zone];
    }
    
    return copy;
}

@end
