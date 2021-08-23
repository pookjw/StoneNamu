//
//  NSMutableArray+removeSingle.m
//  NSMutableArray+removeSingle
//
//  Created by Jinwoo Kim on 8/24/21.
//

#import "NSMutableArray+removeSingle.h"

@implementation NSMutableArray (removeSingle)

- (void)removeSingleObject:(id)object {
    NSUInteger index = [self indexOfObject:object];
    [self removeObjectAtIndex:index];
}

@end
