//
//  HSCardSpellSchool.m
//  StoneNamuCore
//
//  Created by Jinwoo Kim on 2/5/22.
//

#import <StoneNamuCore/HSCardSpellSchool.h>

@implementation HSCardSpellSchool

- (void)dealloc {
    [_slug release];
    [_spellSchoolId release];
    [_name release];
    [super dealloc];
}

+ (HSCardSpellSchool *)hsCardSpellSchoolFromDic:(NSDictionary *)dic error:(NSError * _Nullable *)error {
    HSCardSpellSchool *hsCardSpellSchool = [HSCardSpellSchool new];
    
    [hsCardSpellSchool->_slug release];
    hsCardSpellSchool->_slug = [dic[@"slug"] copy];
    
    [hsCardSpellSchool->_spellSchoolId release];
    hsCardSpellSchool->_spellSchoolId = [dic[@"id"] copy];
    
    [hsCardSpellSchool->_name release];
    hsCardSpellSchool->_name = [dic[@"name"] copy];
    
    return [hsCardSpellSchool autorelease];
}

#pragma mark - NSCopying

- (nonnull id)copyWithZone:(nullable NSZone *)zone {
    id copy = [[self class] new];
    
    if (copy) {
        HSCardSpellSchool *_copy = (HSCardSpellSchool *)copy;
        
        [_copy->_slug release];
        _copy->_slug = [self.slug copyWithZone:zone];
        
        [_copy->_spellSchoolId release];
        _copy->_spellSchoolId = [self.spellSchoolId copyWithZone:zone];
        
        [_copy->_name release];
        _copy->_name = [self.name copyWithZone:zone];
    }
    
    return copy;
}

@end
