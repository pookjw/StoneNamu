//
//  HSCardMinionType.m
//  StoneNamuCore
//
//  Created by Jinwoo Kim on 2/5/22.
//

#import <StoneNamuCore/HSCardMinionType.h>

@implementation HSCardMinionType

- (void)dealloc {
    [_slug release];
    [_minionTypeId release];
    [_name release];
    [_gameModes release];
    [super dealloc];
}

+ (HSCardMinionType *)hsCardMinionTypeFromDic:(NSDictionary *)dic error:(NSError * _Nullable *)error {
    HSCardMinionType *hsCardMinionType = [HSCardMinionType new];
    
    [hsCardMinionType->_slug release];
    hsCardMinionType->_slug = [dic[@"slug"] copy];
    
    [hsCardMinionType->_minionTypeId release];
    hsCardMinionType->_minionTypeId = [dic[@"id"] copy];
    
    [hsCardMinionType->_name release];
    hsCardMinionType->_name = [dic[@"name"] copy];
    
    NSMutableSet<NSNumber *> *gameModes = [NSMutableSet<NSNumber *> new];
    [(NSArray<id> *)dic[@"gameModes"] enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:NSNumber.class]) {
            [gameModes addObject:obj];
        }
    }];
    [hsCardMinionType->_gameModes release];
    hsCardMinionType->_gameModes = [gameModes copy];
    [gameModes release];
    
    return [hsCardMinionType autorelease];
}

#pragma mark - NSCopying

- (nonnull id)copyWithZone:(nullable NSZone *)zone {
    id copy = [[self class] new];
    
    if (copy) {
        HSCardMinionType *_copy = (HSCardMinionType *)copy;
        
        [_copy->_slug release];
        _copy->_slug = [self.slug copyWithZone:zone];
        
        [_copy->_minionTypeId release];
        _copy->_minionTypeId = [self.minionTypeId copyWithZone:zone];
        
        [_copy->_name release];
        _copy->_name = [self.name copyWithZone:zone];
        
        [_copy->_gameModes release];
        _copy->_gameModes = [self.gameModes copyWithZone:zone];
    }
    
    return copy;
}

@end
