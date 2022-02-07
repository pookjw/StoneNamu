//
//  HSCardRarity.m
//  StoneNamuCore
//
//  Created by Jinwoo Kim on 2/5/22.
//

#import <StoneNamuCore/HSCardRarity.h>

@implementation HSCardRarity

- (void)dealloc {
    [_slug release];
    [_rarityId release];
    [_craftingCost release];
    [_dustValue release];
    [_name release];
    [super dealloc];
}

+ (HSCardRarity *)hsCardRarityFromDic:(NSDictionary *)dic error:(NSError * _Nullable *)error {
    HSCardRarity *hsCardRarity = [HSCardRarity new];
    
    [hsCardRarity->_slug release];
    hsCardRarity->_slug = [dic[@"slug"] copy];
    
    [hsCardRarity->_rarityId release];
    hsCardRarity->_rarityId = [dic[@"id"] copy];
    
    NSMutableSet<NSNumber *> *craftingCost = [NSMutableSet<NSNumber *> new];
    [(NSArray<id> *)dic[@"craftingCost"] enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:NSNumber.class]) {
            [craftingCost addObject:obj];
        }
    }];
    [hsCardRarity->_craftingCost release];
    hsCardRarity->_craftingCost = [craftingCost copy];
    [craftingCost release];
    
    NSMutableSet<NSNumber *> *dustValue = [NSMutableSet<NSNumber *> new];
    [(NSArray<id> *)dic[@"dustValue"] enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:NSNumber.class]) {
            [dustValue addObject:obj];
        }
    }];
    [hsCardRarity->_dustValue release];
    hsCardRarity->_dustValue = [dustValue copy];
    [dustValue release];
    
    [hsCardRarity->_name release];
    hsCardRarity->_name = [dic[@"name"] copy];
    
    return [hsCardRarity autorelease];
}

#pragma mark - NSCopying

- (nonnull id)copyWithZone:(nullable NSZone *)zone {
    id copy = [[self class] new];
    
    if (copy) {
        HSCardRarity *_copy = (HSCardRarity *)copy;
        
        [_copy->_slug release];
        _copy->_slug = [self.slug copyWithZone:zone];
        
        [_copy->_rarityId release];
        _copy->_rarityId = [self.rarityId copyWithZone:zone];
        
        [_copy->_craftingCost release];
        _copy->_craftingCost = [self.craftingCost copyWithZone:zone];
        
        [_copy->_dustValue release];
        _copy->_dustValue = [self.dustValue copyWithZone:zone];
        
        [_copy->_name release];
        _copy->_name = [self.name copyWithZone:zone];
    }
    
    return copy;
}

@end
