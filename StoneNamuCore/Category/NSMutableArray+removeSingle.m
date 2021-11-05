//
//  NSMutableArray+removeSingle.m
//  NSMutableArray+removeSingle
//
//  Created by Jinwoo Kim on 8/24/21.
//

#import <StoneNamuCore/NSMutableArray+removeSingle.h>

@implementation NSMutableArray (removeSingle)

- (void)removeSingleObject:(id)object {
    NSUInteger index = [self indexOfObject:object];
    [self removeObjectAtIndex:index];
}

- (void)removeSingleString:(NSString *)string {
    NSInteger __block index = -1;
    
    [self enumerateObjectsUsingBlock:^(NSString *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isEqualToString:string]) {
            index = idx;
            *stop = YES;
        }
    }];
    
    if (index == -1) return;
    
    [self removeObjectAtIndex:index];
}

@end
