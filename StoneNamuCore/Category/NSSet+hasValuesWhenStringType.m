//
//  NSSet+hasValuesWhenStringType.m
//  StoneNamuCore
//
//  Created by Jinwoo Kim on 2/5/22.
//

#import <StoneNamuCore/NSSet+hasValuesWhenStringType.h>

@implementation NSSet (hasValuesWhenStringType)

- (BOOL)hasValuesWhenStringType {
    if (self.count == 0) return NO;
    
    BOOL __block hasEmptyValue = YES;
    
    [self enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, BOOL * _Nonnull stop) {
        if (![obj isEqualToString:@""]) {
            hasEmptyValue = NO;
            *stop = YES;
        }
    }];
    
    return !hasEmptyValue;
}

@end
