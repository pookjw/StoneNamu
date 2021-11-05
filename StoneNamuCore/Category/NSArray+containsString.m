//
//  NSArray+containsString.m
//  StoneNamuCore
//
//  Created by Jinwoo Kim on 10/27/21.
//

#import <StoneNamuCore/NSArray+containsString.h>

@implementation NSArray (containsString)

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

@end
