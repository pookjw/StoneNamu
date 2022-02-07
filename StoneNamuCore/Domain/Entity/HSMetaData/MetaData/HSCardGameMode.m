//
//  HSCardGameMode.m
//  StoneNamuCore
//
//  Created by Jinwoo Kim on 2/5/22.
//

#import <StoneNamuCore/HSCardGameMode.h>

@implementation HSCardGameMode

- (void)dealloc {
    [_slug release];
    [_gameModeId release];
    [_name release];
    [super dealloc];
}

+ (HSCardGameMode *)hsCardGameModeFromDic:(NSDictionary *)dic error:(NSError * _Nullable *)error {
    HSCardGameMode *hsCardGameMode = [HSCardGameMode new];
    
    [hsCardGameMode->_slug release];
    hsCardGameMode->_slug = [dic[@"slug"] copy];
    
    [hsCardGameMode->_gameModeId release];
    hsCardGameMode->_gameModeId = [dic[@"id"] copy];
    
    [hsCardGameMode->_name release];
    hsCardGameMode->_name = [dic[@"name"] copy];
    
    return [hsCardGameMode autorelease];
}

#pragma mark - NSCopying

- (nonnull id)copyWithZone:(nullable NSZone *)zone {
    id copy = [[self class] new];
    
    if (copy) {
        HSCardGameMode *_copy = (HSCardGameMode *)copy;
        
        [_copy->_slug release];
        _copy->_slug = [self.slug copyWithZone:zone];
        
        [_copy->_gameModeId release];
        _copy->_gameModeId = [self.gameModeId copyWithZone:zone];
        
        [_copy->_name release];
        _copy->_name = [self.name copyWithZone:zone];
    }
    
    return copy;
}

@end
