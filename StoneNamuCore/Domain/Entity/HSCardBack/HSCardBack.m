//
//  HSCardBack.m
//  StoneNamuCore
//
//  Created by Jinwoo Kim on 3/5/22.
//

#import <StoneNamuCore/HSCardBack.h>

@implementation HSCardBack

- (void)dealloc {
    [_text release];
    [_name release];
    [_image release];
    [_slug release];
    [super dealloc];
}

+ (HSCardBack *)hsCardBackFromDic:(NSDictionary *)dic error:(NSError * _Nullable *)error {
    HSCardBack *hsCardBack = [HSCardBack new];
    
    hsCardBack->_cardBackId = [(NSNumber *)dic[@"id"] unsignedIntegerValue];
    
    hsCardBack->_sortCategory = [(NSNumber *)dic[@"sortCategory"] unsignedIntegerValue];
    
    [hsCardBack->_text release];
    hsCardBack->_text = [dic[@"text"] copy];
    
    [hsCardBack->_name release];
    hsCardBack->_name = [dic[@"name"] copy];
    
    [hsCardBack->_image release];
    hsCardBack->_image = [[NSURL URLWithString:dic[@"image"]] copy];
    
    [hsCardBack->_slug release];
    hsCardBack->_slug = [dic[@"slug"] copy];
    
    return [hsCardBack autorelease];
}

+ (NSArray<HSCardBack *> *)hsCardBacksFromDic:(NSDictionary *)dic error:(NSError * _Nullable *)error {
    NSMutableArray<HSCardBack *> *hsCardBacks = [NSMutableArray<HSCardBack *> new];
    
    [(NSArray<NSDictionary *> *)dic[@"cardBacks"] enumerateObjectsUsingBlock:^(NSDictionary * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        HSCardBack *hsCardBack = [HSCardBack hsCardBackFromDic:obj error:nil];
        if (hsCardBack) {
            [hsCardBacks addObject:hsCardBack];
        }
    }];
    
    return [hsCardBacks autorelease];
}

- (BOOL)isEqual:(id)object {
    if (![object isKindOfClass:[HSCardBack class]]) {
        return NO;
    }
    
    HSCardBack *toCompare = (HSCardBack *)object;
    
    return (self.cardBackId == toCompare.cardBackId) && ([self.slug isEqualToString:toCompare.slug]);
}

- (NSUInteger)hash {
    return self.cardBackId ^ self.slug.hash;
}

#pragma mark - NSCopying

- (id)copyWithZone:(NSZone *)zone {
    id copy = [[self class] new];
    
    if (copy) {
        HSCardBack *_copy = (HSCardBack *)copy;
        
        _copy->_cardBackId = self.cardBackId;
        _copy->_sortCategory = self.sortCategory;
        
        [_copy->_text release];
        _copy->_text = [self.text copyWithZone:zone];
        
        [_copy->_name release];
        _copy->_name = [self.name copyWithZone:zone];
        
        [_copy->_image release];
        _copy->_image = [self.image copyWithZone:zone];
        
        [_copy->_slug release];
        _copy->_slug = [self.slug copyWithZone:zone];
    }
    
    return copy;
}

@end
