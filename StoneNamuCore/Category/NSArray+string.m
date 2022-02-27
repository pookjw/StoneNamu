//
//  NSArray+string.m
//  StoneNamuCore
//
//  Created by Jinwoo Kim on 10/27/21.
//

#import <StoneNamuCore/NSArray+string.h>

@implementation NSArray (string)

- (BOOL)containsString:(NSString *)string {
    BOOL __block result = NO;
    
    [self enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (![obj isKindOfClass:[NSString class]]) {
            return;
        }
        if ([obj isEqualToString:string]) {
            result = YES;
            *stop = YES;
        }
    }];
    
    return result;
}

- (NSUInteger)indexOfString:(NSString *)string {
    NSInteger __block index = 0;
    
    [self enumerateObjectsUsingBlock:^(NSString *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isEqualToString:string]) {
            index = idx;
            *stop = YES;
        }
    }];
    
    return index;
}

@end
