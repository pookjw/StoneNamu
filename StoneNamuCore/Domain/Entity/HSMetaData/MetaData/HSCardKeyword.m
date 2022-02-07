//
//  HSCardKeyword.m
//  StoneNamuCore
//
//  Created by Jinwoo Kim on 2/5/22.
//

#import <StoneNamuCore/HSCardKeyword.h>

@implementation HSCardKeyword

- (void)dealloc {
    [_keywordId release];
    [_slug release];
    [_name release];
    [_refText release];
    [_text release];
    [_gameModes release];
    [super dealloc];
}

+ (HSCardKeyword *)hsCardKeywordFromDic:(NSDictionary *)dic error:(NSError * _Nullable *)error {
    HSCardKeyword *hsCardKeyword = [HSCardKeyword new];
    
    [hsCardKeyword->_keywordId release];
    hsCardKeyword->_keywordId = [dic[@"id"] copy];
    
    [hsCardKeyword->_slug release];
    hsCardKeyword->_slug = [dic[@"slug"] copy];
    
    [hsCardKeyword->_name release];
    hsCardKeyword->_name = [dic[@"name"] copy];
    
    [hsCardKeyword->_refText release];
    hsCardKeyword->_refText = [dic[@"refText"] copy];
    
    [hsCardKeyword->_text release];
    hsCardKeyword->_text = [dic[@"text"] copy];
    
    NSMutableSet<NSNumber *> *gameModes = [NSMutableSet<NSNumber *> new];
    [(NSArray<id> *)dic[@"gameModes"] enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:NSNumber.class]) {
            [gameModes addObject:obj];
        }
    }];
    [hsCardKeyword->_gameModes release];
    hsCardKeyword->_gameModes = [gameModes copy];
    [gameModes release];
    
    return [hsCardKeyword autorelease];
}

#pragma mark - NSCopying

- (nonnull id)copyWithZone:(nullable NSZone *)zone {
    id copy = [[self class] new];
    
    if (copy) {
        HSCardKeyword *_copy = (HSCardKeyword *)copy;
        
        [_copy->_keywordId release];
        _copy->_keywordId = [self.keywordId copyWithZone:zone];
        
        [_copy->_slug release];
        _copy->_slug = [self.slug copyWithZone:zone];
        
        [_copy->_name release];
        _copy->_name = [self.name copyWithZone:zone];
        
        [_copy->_refText release];
        _copy->_refText = [self.refText copyWithZone:zone];
        
        [_copy->_text release];
        _copy->_text = [self.text copyWithZone:zone];
        
        [_copy->_gameModes release];
        _copy->_gameModes = [self.gameModes copyWithZone:zone];
    }
    
    return copy;
}

@end
