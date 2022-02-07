//
//  HSCardMercenaryRole.m
//  StoneNamuCore
//
//  Created by Jinwoo Kim on 2/5/22.
//

#import <StoneNamuCore/HSCardMercenaryRole.h>

@implementation HSCardMercenaryRole

- (void)dealloc {
    [_slug release];
    [_mercenaryRoleId release];
    [_name release];
    [super dealloc];
}

+ (HSCardMercenaryRole *)hsCardMercenaryRoleFromDic:(NSDictionary *)dic error:(NSError * _Nullable *)error {
    HSCardMercenaryRole *hsCardMercenaryRole = [HSCardMercenaryRole new];
    
    [hsCardMercenaryRole->_slug release];
    hsCardMercenaryRole->_slug = [dic[@"slug"] copy];
    
    [hsCardMercenaryRole->_mercenaryRoleId release];
    hsCardMercenaryRole->_mercenaryRoleId = [dic[@"id"] copy];
    
    [hsCardMercenaryRole->_name release];
    hsCardMercenaryRole->_name = [dic[@"name"] copy];
    
    return [hsCardMercenaryRole autorelease];
}

#pragma mark - NSCopying

- (nonnull id)copyWithZone:(nullable NSZone *)zone {
    id copy = [[self class] new];
    
    if (copy) {
        HSCardMercenaryRole *_copy = (HSCardMercenaryRole *)copy;
        
        [_copy->_slug release];
        _copy->_slug = [self.slug copyWithZone:zone];
        
        [_copy->_mercenaryRoleId release];
        _copy->_mercenaryRoleId = [self.mercenaryRoleId copyWithZone:zone];
        
        [_copy->_name release];
        _copy->_name = [self.name copyWithZone:zone];
    }
    
    return copy;
}

@end
