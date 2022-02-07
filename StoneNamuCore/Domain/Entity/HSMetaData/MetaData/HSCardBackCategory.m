//
//  HSCardBackCategory.m
//  StoneNamuCore
//
//  Created by Jinwoo Kim on 2/5/22.
//

#import <StoneNamuCore/HSCardBackCategory.h>

@implementation HSCardBackCategory

- (void)dealloc {
    [_slug release];
    [_cardBackCategoryId release];
    [_name release];
    [super dealloc];
}

+ (HSCardBackCategory *)hsCardBackCategoryFromDic:(NSDictionary *)dic error:(NSError * _Nullable *)error {
    HSCardBackCategory *hsCardBackCategory = [HSCardBackCategory new];
    
    [hsCardBackCategory->_slug release];
    hsCardBackCategory->_slug = [dic[@"slug"] copy];
    
    [hsCardBackCategory->_cardBackCategoryId release];
    hsCardBackCategory->_cardBackCategoryId = [dic[@"id"] copy];
    
    [hsCardBackCategory->_name release];
    hsCardBackCategory->_name = [dic[@"name"] copy];
    
    return [hsCardBackCategory autorelease];
}

#pragma mark - NSCopying

- (nonnull id)copyWithZone:(nullable NSZone *)zone {
    id copy = [[self class] new];
    
    if (copy) {
        HSCardBackCategory *_copy = (HSCardBackCategory *)copy;
        
        [_copy->_slug release];
        _copy->_slug = [self.slug copyWithZone:zone];
        
        [_copy->_cardBackCategoryId release];
        _copy->_cardBackCategoryId = [self.cardBackCategoryId copyWithZone:zone];
        
        [_copy->_name release];
        _copy->_name = [self.name copyWithZone:zone];
    }
    
    return copy;
}

@end
