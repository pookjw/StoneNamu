//
//  HSCardSetGroups.m
//  StoneNamuCore
//
//  Created by Jinwoo Kim on 2/5/22.
//

#import <StoneNamuCore/HSCardSetGroups.h>

@implementation HSCardSetGroups

- (void)dealloc {
    [_slug release];
    [_year release];
    [_svg release];
    [_cardSets release];
    [_name release];
    [_standard release];
    [_icon release];
    [super dealloc];
}

+ (HSCardSetGroups *)hsCardSetGroupsFromDic:(NSDictionary *)dic error:(NSError * _Nullable *)error {
    HSCardSetGroups *hsCardSetGroups = [HSCardSetGroups new];
    
    [hsCardSetGroups->_slug release];
    hsCardSetGroups->_slug = [dic[@"slug"] copy];
    
    [hsCardSetGroups->_year release];
    hsCardSetGroups->_year = [dic[@"year"] copy];
    
    [hsCardSetGroups->_svg release];
    hsCardSetGroups->_svg = [dic[@"svg"] copy];
    
    NSMutableSet<NSString *> *cardSets = [NSMutableSet<NSString *> new];
    [(NSArray<id> *)dic[@"cardSets"] enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:NSString.class]) {
            [cardSets addObject:obj];
        }
    }];
    [hsCardSetGroups->_cardSets release];
    hsCardSetGroups->_cardSets = [cardSets copy];
    [cardSets release];
    
    [hsCardSetGroups->_name release];
    hsCardSetGroups->_name = [dic[@"name"] copy];
    
    [hsCardSetGroups->_standard release];
    hsCardSetGroups->_standard = [dic[@"standard"] copy];
    
    [hsCardSetGroups->_icon release];
    hsCardSetGroups->_icon = [dic[@"icon"] copy];
    
    return [hsCardSetGroups autorelease];
}

#pragma mark - NSCopying

- (nonnull id)copyWithZone:(nullable NSZone *)zone {
    id copy = [[self class] new];
    
    if (copy) {
        HSCardSetGroups *_copy = (HSCardSetGroups *)copy;
        
        [_copy->_slug release];
        _copy->_slug = [self.slug copyWithZone:zone];
        
        [_copy->_year release];
        _copy->_year = [self.year copyWithZone:zone];
        
        [_copy->_svg release];
        _copy->_svg = [self.svg copyWithZone:zone];
        
        [_copy->_cardSets release];
        _copy->_cardSets = [self.cardSets copyWithZone:zone];
        
        [_copy->_name release];
        _copy->_name = [self.name copyWithZone:zone];
        
        [_copy->_standard release];
        _copy->_standard = [self.standard copyWithZone:zone];
        
        [_copy->_icon release];
        _copy->_icon = [self.icon copyWithZone:zone];
    }
    
    return copy;
}

@end
